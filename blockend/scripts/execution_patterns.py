import brownie
from brownie import network
from web3 import Web3
import scripts.utils as utils

chain = brownie.network.state.Chain()


def execute_multisig_decision(tx_index, multi_sig, target, encoding, proposer, members):
    assert isinstance(members, list)

    description = "testing 123"
    value = 0

    assert multi_sig.isMember(proposer)

    tx = multi_sig.submitTransaction(
        target, value, encoding, description, {"from": proposer}
    )
    tx.wait(1)

    # TODO: usually get tx_index from submitTransaction event, event not working for now

    for member in members:
        assert multi_sig.isMember(member)
        tx = multi_sig.confirmTransaction(tx_index, {"from": member})
        tx.wait(1)

    tx = multi_sig.executeTransaction(tx_index, {"from": proposer})
    tx.wait(1)


def governance_process(
    encoded_functions,
    target_contracts,
    governor,
    access_control,
    anyone,
    anyone_with_minimum_votes,
    voters,
    revert_account,
):
    assert isinstance(encoded_functions, list)
    assert isinstance(target_contracts, list)
    assert isinstance(voters, dict)

    # 2 # --> propose, pass encoded function
    targets = target_contracts
    values = [0] * len(encoded_functions)
    calldatas = encoded_functions
    description = "test 123"
    description_hash = Web3.keccak(text=description).hex()
    tx = governor.propose(
        targets, values, calldatas, description, {"from": anyone_with_minimum_votes}
    )

    # 3 # --> wait for voting delay to pass
    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        for _ in range(governor.votingDelay()):  # move blocks
            with brownie.reverts():
                access_control.grantRole(
                    access_control.getDefaultAdminRole(),
                    revert_account,
                    {"from": revert_account},
                )

    tx.wait(1 + governor.votingDelay())

    # 4 # --> get proposal ID, usually from event, but can get from proposal hash reconstruction

    try:
        # event
        proposal_id = tx.events["ProposalCreated"]["proposalId"]
    except:
        # reconstruction
        proposal_id = governor.hashProposal(
            targets, values, calldatas, description_hash
        )

    assert governor.proposalSnapshot(proposal_id) == tx.block_number + 1
    assert governor.proposalEta(proposal_id) == 0
    # assert utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Pending"

    if not (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        tx.wait(5)

    # 5 # --> voting period
    # - `support=bravo` refers to the vote options 0 = Against, 1 = For, 2 = Abstain, as in `GovernorBravo`.
    # - `quorum=bravo` means that only For votes are counted towards quorum.
    # - `quorum=for,abstain` means that both For and Abstain votes are counted towards quorum.
    print("This Governor's counting mode:", governor.COUNTING_MODE())

    for voter, vote in voters.items():
        assert not governor.hasVoted(proposal_id, voter)

        tx = governor.castVoteWithReason(
            proposal_id, vote, "I like voting", {"from": voter}
        )  # or castVote or castVoteBySig
        tx.wait(1)

        assert governor.hasVoted(proposal_id, voter)

    # active once voting begins
    assert utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Active"

    # 6 # --> wait for voting period to pass
    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        for _ in range(governor.votingPeriod()):  # move blocks
            with brownie.reverts():
                access_control.grantRole(
                    access_control.getDefaultAdminRole(),
                    revert_account,
                    {"from": revert_account},
                )

    tx.wait(1 + governor.votingPeriod())

    # # 7 # --> once deadline reached, no more votes can be cast
    # assert governor.proposalDeadline(proposal_id) == brownie.web3.eth.block_number - 1

    # with brownie.reverts("Governor: vote not currently active"):
    #     governor.castVote(proposal_id, 1)

    if utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Succeeded":
        print("Proposal Succeeded")

        # 8 # --> queue the proposal
        tx = governor.queue(
            targets, values, calldatas, description_hash, {"from": anyone}
        )
        tx.wait(1)

        assert utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Queued"

        assert governor.proposalEta(proposal_id) == tx.timestamp + 1

        if (
            network.show_active() in utils.ENV_LOCAL_BLOCKS
            or network.show_active() in utils.ENV_LOCAL_FORKS
        ):
            chain.sleep(10)  # fast-forward time so that proposal is ready for execution
        else:
            tx.wait(10)

        # 9 # --> execute proposal
        tx = governor.execute(
            targets, values, calldatas, description_hash, {"from": anyone}
        )
        tx.wait(1)

        assert utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Executed"

        assert governor.proposalEta(proposal_id) == 0
    elif utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Expired":
        print("Proposal Expired")
        # 8 # --> possibly move to fallback
        pass
    else:
        assert (
            False
        ), f"something wrong with governance process, {utils.PROPOSAL_STATE[governor.state(proposal_id)]}"

    return proposal_id, tx


def governance_process_with_fallback(
    encoded_functions,
    target_contracts,
    governor,
    access_control,
    anyone,
    anyone_with_minimum_votes,
    voters,
    revert_account,
    multi_sig_tx_index,
    multi_sig,
    multi_sig_target_contract,
    multi_sig_encoded_function,
    multi_sig_proposer,
    multi_sig_members,
):
    proposal_id = governance_process(
        encoded_functions,
        target_contracts,
        governor,
        access_control,
        anyone,
        anyone_with_minimum_votes,
        voters,
        revert_account,
    )

    if utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Expired":
        execute_multisig_decision(
            multi_sig_tx_index,
            multi_sig,
            multi_sig_target_contract,
            multi_sig_encoded_function,
            multi_sig_proposer,
            multi_sig_members,
        )
    else:
        print("something wrong with governance process with fallback")


def governance_execute_only(
    encoded_functions,
    target_contracts,
    governor,
    access_control,
    anyone,
    anyone_with_minimum_votes,
    voters,
    revert_account,
):
    assert isinstance(encoded_functions, list)
    assert isinstance(target_contracts, list)
    assert isinstance(voters, dict)

    # 2 # --> propose, pass encoded function
    targets = target_contracts
    values = [0] * len(encoded_functions)
    calldatas = encoded_functions
    description = "test 123"
    description_hash = Web3.keccak(text=description).hex()
    # tx = governor.propose(
    #     targets, values, calldatas, description, {"from": anyone_with_minimum_votes}
    # )

    proposal_id = governor.hashProposal(targets, values, calldatas, description_hash)

    assert utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Queued"

    tx = governor.execute(
        targets, values, calldatas, description_hash, {"from": anyone}
    )
    tx.wait(1)

    assert utils.PROPOSAL_STATE[governor.state(proposal_id)] == "Executed"
