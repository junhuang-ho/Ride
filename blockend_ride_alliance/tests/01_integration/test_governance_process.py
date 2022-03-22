import pytest
import brownie
from web3 import Web3
import scripts.utils as utils

chain = brownie.network.state.Chain()


@pytest.fixture(scope="module", autouse=True)
def ride_token(ride_token_and_governance, Ride, Contract, deployer):
    yield Contract.from_abi(
        "Ride", ride_token_and_governance[0].address, Ride.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_timelock(ride_token_and_governance, RideTimelock, Contract, deployer):
    yield Contract.from_abi(
        "RideTimelock",
        ride_token_and_governance[1].address,
        RideTimelock.abi,
        deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_governor(ride_token_and_governance, RideGovernor, Contract, deployer):
    yield Contract.from_abi(
        "RideGovernor",
        ride_token_and_governance[2].address,
        RideGovernor.abi,
        deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def test_setup(ride_token, ride_timelock, dBox, deployer, person1):
    # 1 # --> mint some tokens
    tx = ride_token.mint(person1, "100 ether", {"from": deployer})
    tx.wait(1)

    # 2 # --> transfer ownership of test contract to timelock [WARNING]
    assert dBox.owner() == deployer

    tx = dBox.transferOwnership(ride_timelock.address, {"from": deployer})
    tx.wait(1)

    assert dBox.owner() == ride_timelock.address

    # 3 # --> delegate (self) votes to be able to vote (activating votes to address)
    assert ride_token.getVotes(person1) == 0

    tx = ride_token.delegate(person1, {"from": person1})
    tx.wait(1)

    assert ride_token.getVotes(person1) == "100 ether"


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_successful_proposal(ride_governor, dBox, person1, person2):
    # 1 # --> encode function to be execute
    value = 69
    args = (value,)
    encoded_function = dBox.store.encode_input(*args)

    # 2 # --> propose, pass encoded function
    targets = [dBox.address]
    values = [0]
    calldatas = [encoded_function]
    description = "Store value in box!"
    description_hash = Web3.keccak(text=description).hex()
    tx = ride_governor.propose(
        targets, values, calldatas, description, {"from": person2}
    )

    # 3 # --> wait for voting delay to pass
    for _ in range(ride_governor.votingDelay()):  # move blocks
        with brownie.reverts():
            dBox.store(1)

    tx.wait(1 + ride_governor.votingDelay())

    # 4 # --> get proposal ID, usually from event, but can get from proposal hash reconstruction

    try:
        # event
        proposal_id = tx.events["ProposalCreated"]["proposalId"]
    except:
        # reconstruction
        proposal_id = ride_governor.hashProposal(
            targets, values, calldatas, description_hash
        )

    assert ride_governor.proposalSnapshot(proposal_id) == tx.block_number + 1
    assert ride_governor.proposalEta(proposal_id) == 0
    assert utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Pending"

    # 5 # --> voting period
    # - `support=bravo` refers to the vote options 0 = Against, 1 = For, 2 = Abstain, as in `GovernorBravo`.
    # - `quorum=bravo` means that only For votes are counted towards quorum.
    # - `quorum=for,abstain` means that both For and Abstain votes are counted towards quorum.
    print("This Governor's counting mode:", ride_governor.COUNTING_MODE())

    assert not ride_governor.hasVoted(proposal_id, person1)

    tx = ride_governor.castVoteWithReason(
        proposal_id, 1, "I like the proposed value", {"from": person1}
    )  # or castVote or castVoteBySig
    tx.wait(1)

    assert ride_governor.hasVoted(proposal_id, person1)

    # active once voting begins
    assert utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Active"

    # 6 # --> wait for voting period to pass
    for _ in range(ride_governor.votingPeriod()):  # move blocks
        with brownie.reverts():
            dBox.store(1)

    # 7 # --> once deadline reached, no more votes can be cast
    assert (
        ride_governor.proposalDeadline(proposal_id) == brownie.web3.eth.block_number - 1
    )

    with brownie.reverts("Governor: vote not currently active"):
        ride_governor.castVote(proposal_id, 1)

    assert (
        utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Succeeded"
    )  # or Defeated

    # 8 # --> queue the proposal
    tx = ride_governor.queue(
        targets, values, calldatas, description_hash, {"from": person2}
    )
    tx.wait(1)

    assert utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Queued"

    assert ride_governor.proposalEta(proposal_id) == tx.timestamp + 1

    chain.sleep(10)  # fast-forward time so that proposal is ready for execution

    # 9 # --> execute proposal
    assert dBox.retrieve() == 0

    tx = ride_governor.execute(
        targets, values, calldatas, description_hash, {"from": person2}
    )
    tx.wait(1)

    assert utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Executed"

    assert dBox.retrieve() == value

    assert ride_governor.proposalEta(proposal_id) == 0
