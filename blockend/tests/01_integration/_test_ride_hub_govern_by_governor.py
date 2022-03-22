import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils

chain = brownie.network.state.Chain()


@pytest.fixture(scope="module", autouse=True)
def ride_token(ride_token, Ride, Contract, deployer):
    yield Contract.from_abi(
        "Ride", ride_token.address, Ride.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_governance_token(ride_governance, RideGovernance, Contract, deployer):
    yield Contract.from_abi(
        "RideGovernance", ride_governance[0].address, RideGovernance.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_timelock(ride_governance, RideTimelock, Contract, deployer):
    yield Contract.from_abi(
        "RideTimelock", ride_governance[1].address, RideTimelock.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_governor(ride_governance, RideGovernor, Contract, deployer):
    yield Contract.from_abi(
        "RideGovernor", ride_governance[2].address, RideGovernor.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def test_setup(ride_token, ride_timelock, ride_access_control, deployer, person1):
    # # 0 # --> setup governance roles
    # role_proposer = ride_timelock.PROPOSER_ROLE()
    # role_executor = ride_timelock.EXECUTOR_ROLE()
    # role_admin = ride_timelock.TIMELOCK_ADMIN_ROLE()

    # # check that 2 addresses owns the role_admin
    # assert ride_timelock.hasRole(role_admin, ride_timelock.address)
    # assert ride_timelock.hasRole(role_admin, deployer)

    # # set proposer role to governor (voters - those who hold token)
    # tx = ride_timelock.grantRole(
    #     role_proposer, ride_governor.address, {"from": deployer}
    # )
    # tx.wait(1)

    # # set executor role to zero address (anyone)
    # tx = ride_timelock.grantRole(role_executor, utils.ZERO_ADDRESS, {"from": deployer})
    # tx.wait(1)

    # # deployer renounce control of timelock as no one should own the timelock contract, but the timelock itself
    # tx = ride_timelock.renounceRole(role_admin, deployer.address, {"from": deployer})
    # tx.wait(1)

    # # check timelock admin roles
    # assert ride_timelock.hasRole(role_admin, ride_timelock.address)
    # assert not ride_timelock.hasRole(role_admin, deployer)
    #
    #
    #
    #
    # 1 # --> mint some tokens
    tx = ride_token.mint(person1, "100 ether", {"from": deployer})
    tx.wait(1)

    # 2 # --> transfer admin role of ride hub contract to timelock [WARNING]
    role_default_admin = ride_access_control.getDefaultAdminRole()
    role_maintainer = ride_access_control.getRole("MAINTAINER_ROLE")
    role_strategist = ride_access_control.getRole("STRATEGIST_ROLE")
    role_governor = ride_access_control.getRole("GOVERNOR_ROLE")
    role_reviewer = ride_access_control.getRole("REVIEWER_ROLE")

    assert not ride_access_control.hasRole(role_default_admin, ride_timelock.address)
    assert not ride_access_control.hasRole(role_maintainer, ride_timelock.address)
    assert not ride_access_control.hasRole(role_strategist, ride_timelock.address)
    # assert not ride_access_control.hasRole(role_governor, ride_timelock.address)
    assert not ride_access_control.hasRole(role_reviewer, ride_timelock.address)
    assert ride_access_control.hasRole(role_default_admin, deployer)
    assert ride_access_control.hasRole(role_maintainer, deployer)
    assert ride_access_control.hasRole(role_strategist, deployer)
    # assert ride_access_control.hasRole(role_governor, deployer)
    assert ride_access_control.hasRole(role_reviewer, deployer)

    tx = ride_access_control.grantRole(
        role_default_admin, ride_timelock.address, {"from": deployer}
    )
    tx.wait(1)
    tx = ride_access_control.grantRole(
        role_maintainer, ride_timelock.address, {"from": deployer}
    )
    tx.wait(1)
    tx = ride_access_control.grantRole(
        role_strategist, ride_timelock.address, {"from": deployer}
    )
    tx.wait(1)
    tx = ride_access_control.grantRole(
        role_governor, ride_timelock.address, {"from": deployer}
    )
    tx.wait(1)
    tx = ride_access_control.grantRole(
        role_reviewer, ride_timelock.address, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_access_control.renounceRole(role_default_admin, {"from": deployer})
    tx.wait(1)
    tx = ride_access_control.renounceRole(role_maintainer, {"from": deployer})
    tx.wait(1)
    tx = ride_access_control.renounceRole(role_strategist, {"from": deployer})
    tx.wait(1)
    tx = ride_access_control.renounceRole(role_governor, {"from": deployer})
    tx.wait(1)
    tx = ride_access_control.renounceRole(role_reviewer, {"from": deployer})
    tx.wait(1)

    assert ride_access_control.hasRole(role_default_admin, ride_timelock.address)
    assert ride_access_control.hasRole(role_maintainer, ride_timelock.address)
    assert ride_access_control.hasRole(role_strategist, ride_timelock.address)
    # assert ride_access_control.hasRole(role_governor, ride_timelock.address)
    assert ride_access_control.hasRole(role_reviewer, ride_timelock.address)
    assert not ride_access_control.hasRole(role_default_admin, deployer)
    assert not ride_access_control.hasRole(role_maintainer, deployer)
    assert not ride_access_control.hasRole(role_strategist, deployer)
    # assert not ride_access_control.hasRole(role_governor, deployer)
    assert not ride_access_control.hasRole(role_reviewer, deployer)
    with brownie.reverts():
        ride_access_control.grantRole(role_default_admin, deployer, {"from": deployer})

    # 3 # --> delegate (self) votes to be able to vote (activating votes to address)
    assert ride_token.getVotes(person1) == 0

    tx = ride_token.delegate(person1, {"from": person1})
    tx.wait(1)

    assert ride_token.getVotes(person1) == "100 ether"


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def governance_process(
    encoded_function,
    ride_hub,
    ride_governor,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    # 2 # --> propose, pass encoded function
    targets = [ride_hub[0].address]
    values = [0]
    calldatas = [encoded_function]
    description = "test 123"
    description_hash = Web3.keccak(text=description).hex()
    tx = ride_governor.propose(
        targets, values, calldatas, description, {"from": person2}
    )

    # 3 # --> wait for voting delay to pass
    for _ in range(ride_governor.votingDelay()):  # move blocks
        with brownie.reverts():
            ride_access_control.grantRole(
                ride_access_control.getDefaultAdminRole(), deployer, {"from": deployer}
            )

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
        proposal_id, 1, "I like voting", {"from": person1}
    )  # or castVote or castVoteBySig
    tx.wait(1)

    assert ride_governor.hasVoted(proposal_id, person1)

    # active once voting begins
    assert utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Active"

    # 6 # --> wait for voting period to pass
    for _ in range(ride_governor.votingPeriod()):  # move blocks
        with brownie.reverts():
            ride_access_control.grantRole(
                ride_access_control.getDefaultAdminRole(), deployer, {"from": deployer}
            )

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
    tx = ride_governor.execute(
        targets, values, calldatas, description_hash, {"from": person2}
    )
    tx.wait(1)

    assert utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Executed"

    assert ride_governor.proposalEta(proposal_id) == 0


def governance_process_multiple(
    encoded_functions,
    ride_hub,
    ride_governor,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    # 2 # --> propose, pass encoded function
    targets = [ride_hub[0].address] * len(encoded_functions)
    values = [0] * len(encoded_functions)
    calldatas = encoded_functions
    description = "test 123"
    description_hash = Web3.keccak(text=description).hex()
    tx = ride_governor.propose(
        targets, values, calldatas, description, {"from": person2}
    )

    # 3 # --> wait for voting delay to pass
    for _ in range(ride_governor.votingDelay()):  # move blocks
        with brownie.reverts():
            ride_access_control.grantRole(
                ride_access_control.getDefaultAdminRole(), deployer, {"from": deployer}
            )

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
        proposal_id, 1, "I like voting", {"from": person1}
    )  # or castVote or castVoteBySig
    tx.wait(1)

    assert ride_governor.hasVoted(proposal_id, person1)

    # active once voting begins
    assert utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Active"

    # 6 # --> wait for voting period to pass
    for _ in range(ride_governor.votingPeriod()):  # move blocks
        with brownie.reverts():
            ride_access_control.grantRole(
                ride_access_control.getDefaultAdminRole(), deployer, {"from": deployer}
            )

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
    tx = ride_governor.execute(
        targets, values, calldatas, description_hash, {"from": person2}
    )
    tx.wait(1)

    assert utils.PROPOSAL_STATE[ride_governor.state(proposal_id)] == "Executed"

    assert ride_governor.proposalEta(proposal_id) == 0


def test_RideAccessControl_grantRole(
    ride_hub, ride_governor, ride_access_control, deployer, person1, person2,
):
    role_default_admin = ride_access_control.getDefaultAdminRole()
    role_strategist = ride_access_control.getRole("STRATEGIST_ROLE")

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_access_control.grantRole(role_default_admin, person2, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (
        role_default_admin,
        person2,
    )
    encoded_function1 = ride_access_control.grantRole.encode_input(*args)

    args = (
        role_strategist,
        person2,
    )
    encoded_function2 = ride_access_control.grantRole.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert not ride_access_control.hasRole(role_default_admin, person2)
    assert not ride_access_control.hasRole(role_strategist, person2)

    # governance
    governance_process_multiple(
        [encoded_function1, encoded_function2],
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    assert ride_access_control.hasRole(role_default_admin, person2)
    assert ride_access_control.hasRole(role_strategist, person2)


def test_RideAccessControl_revokeRole(
    ride_hub, ride_governor, ride_access_control, deployer, person1, person2,
):
    test_RideAccessControl_grantRole(
        ride_hub, ride_governor, ride_access_control, deployer, person1, person2
    )

    role_default_admin = ride_access_control.getDefaultAdminRole()
    role_strategist = ride_access_control.getRole("STRATEGIST_ROLE")

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_access_control.revokeRole(role_default_admin, person2, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (
        role_default_admin,
        person2,
    )
    encoded_function1 = ride_access_control.revokeRole.encode_input(*args)

    args = (
        role_strategist,
        person2,
    )
    encoded_function2 = ride_access_control.revokeRole.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_access_control.hasRole(role_default_admin, person2)
    assert ride_access_control.hasRole(role_strategist, person2)

    # governance
    governance_process_multiple(
        [encoded_function1, encoded_function2],
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    assert not ride_access_control.hasRole(role_default_admin, person2)
    assert not ride_access_control.hasRole(role_strategist, person2)


def test_RideCurrencyRegistry_registerFiat(
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    fiat_code = "MYR"

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_currency_registry.registerFiat(fiat_code, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (fiat_code,)
    encoded_function = ride_currency_registry.registerFiat.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    with brownie.reverts("RideLibCurrencyRegistry: Currency not supported"):
        ride_currency_registry.getKeyFiat(fiat_code)

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after

    assert ride_currency_registry.getKeyFiat(fiat_code) == Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], [fiat_code]).hex()]
        )
    )


def test_RideCurrencyRegistry_registerCrypto(
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_token,
    deployer,
    person1,
    person2,
):
    token_address = ride_token.address

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_currency_registry.registerCrypto(token_address, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (token_address,)
    encoded_function = ride_currency_registry.registerCrypto.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    with brownie.reverts("RideLibCurrencyRegistry: Currency not supported"):
        ride_currency_registry.getKeyCrypto(token_address)

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after

    assert ride_currency_registry.getKeyCrypto(
        token_address
    ) == utils.pad_address_right(token_address)


def test_RideCurrencyRegistry_removeCurrency(
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_token,
    deployer,
    person1,
    person2,
):
    test_RideCurrencyRegistry_registerCrypto(
        ride_currency_registry,
        ride_hub,
        ride_governor,
        ride_access_control,
        ride_token,
        deployer,
        person1,
        person2,
    )

    key_currency = ride_currency_registry.getKeyCrypto(ride_token.address)

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_currency_registry.removeCurrency(key_currency, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (key_currency,)
    encoded_function = ride_currency_registry.removeCurrency.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_currency_registry.getKeyCrypto(
        ride_token.address
    ) == utils.pad_address_right(ride_token.address)

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    with brownie.reverts("RideLibCurrencyRegistry: Currency not supported"):
        ride_currency_registry.getKeyCrypto(ride_token.address)


def test_RideCurrencyRegistry_setupFiatWithFee(
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_fee,
    deployer,
    person1,
    person2,
):
    fiat_code = "MYR"
    fee_cancallation = 5
    fee_base = 3
    cost_per_minute = 2
    badges_cost_per_metre = [1, 2, 3, 4, 5, 6]

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_currency_registry.setupFiatWithFee(
            fiat_code,
            fee_cancallation,
            fee_base,
            cost_per_minute,
            badges_cost_per_metre,
            {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        fiat_code,
        fee_cancallation,
        fee_base,
        cost_per_minute,
        badges_cost_per_metre,
    )
    encoded_function = ride_currency_registry.setupFiatWithFee.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    key_code = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], [fiat_code]).hex()]
        )
    )
    with brownie.reverts("RideLibCurrencyRegistry: Currency not supported"):
        ride_currency_registry.getKeyFiat(fiat_code)
        # ride_fee.getCancellationFee(key_code) == 0
        # ride_fee.getBaseFee(key_code) == 0
        # ride_fee.getCostPerMinute(key_code) == 0
        # ride_fee.getCostPerMetre(key_code, 0) == 0
        # ride_fee.getCostPerMetre(key_code, 1) == 0
        # ride_fee.getCostPerMetre(key_code, 2) == 0
        # ride_fee.getCostPerMetre(key_code, 3) == 0
        # ride_fee.getCostPerMetre(key_code, 4) == 0
        # ride_fee.getCostPerMetre(key_code, 5) == 0

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after

    assert ride_currency_registry.getKeyFiat(fiat_code) == key_code
    assert ride_fee.getCancellationFee(key_code) == fee_cancallation
    assert ride_fee.getBaseFee(key_code) == fee_base
    assert ride_fee.getCostPerMinute(key_code) == cost_per_minute
    assert ride_fee.getCostPerMetre(key_code, 0) == badges_cost_per_metre[0]
    assert ride_fee.getCostPerMetre(key_code, 1) == badges_cost_per_metre[1]
    assert ride_fee.getCostPerMetre(key_code, 2) == badges_cost_per_metre[2]
    assert ride_fee.getCostPerMetre(key_code, 3) == badges_cost_per_metre[3]
    assert ride_fee.getCostPerMetre(key_code, 4) == badges_cost_per_metre[4]
    assert ride_fee.getCostPerMetre(key_code, 5) == badges_cost_per_metre[5]


def test_RideCurrencyRegistry_setupCryptoWithFee(
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_token,
    ride_fee,
    deployer,
    person1,
    person2,
):
    token_address = ride_token.address
    fee_cancallation = 5
    fee_base = 3
    cost_per_minute = 2
    badges_cost_per_metre = [1, 2, 3, 4, 5, 6]

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_currency_registry.setupCryptoWithFee(
            token_address,
            fee_cancallation,
            fee_base,
            cost_per_minute,
            badges_cost_per_metre,
            {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        token_address,
        fee_cancallation,
        fee_base,
        cost_per_minute,
        badges_cost_per_metre,
    )
    encoded_function = ride_currency_registry.setupCryptoWithFee.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    with brownie.reverts("RideLibCurrencyRegistry: Currency not supported"):
        ride_currency_registry.getKeyCrypto(token_address)

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    key_token = utils.pad_address_right(token_address)
    assert ride_currency_registry.getKeyCrypto(token_address) == key_token
    assert ride_fee.getCancellationFee(key_token) == fee_cancallation
    assert ride_fee.getBaseFee(key_token) == fee_base
    assert ride_fee.getCostPerMinute(key_token) == cost_per_minute
    assert ride_fee.getCostPerMetre(key_token, 0) == badges_cost_per_metre[0]
    assert ride_fee.getCostPerMetre(key_token, 1) == badges_cost_per_metre[1]
    assert ride_fee.getCostPerMetre(key_token, 2) == badges_cost_per_metre[2]
    assert ride_fee.getCostPerMetre(key_token, 3) == badges_cost_per_metre[3]
    assert ride_fee.getCostPerMetre(key_token, 4) == badges_cost_per_metre[4]
    assert ride_fee.getCostPerMetre(key_token, 5) == badges_cost_per_metre[5]


def test_RideExchange_addXPerYPriceFeed(
    ride_exchange,
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_token,
    dMockV3Aggregator1,
    deployer,
    person1,
    person2,
):
    test_RideCurrencyRegistry_registerFiat(
        ride_currency_registry,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    test_RideCurrencyRegistry_registerCrypto(
        ride_currency_registry,
        ride_hub,
        ride_governor,
        ride_access_control,
        ride_token,
        deployer,
        person1,
        person2,
    )

    key_code = ride_currency_registry.getKeyFiat("USD")
    key_token = ride_currency_registry.getKeyCrypto(ride_token.address)
    price_feed = dMockV3Aggregator1.address

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_exchange.addXPerYPriceFeed(
            key_code, key_token, price_feed, {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        key_code,
        key_token,
        price_feed,
    )
    encoded_function = ride_exchange.addXPerYPriceFeed.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    with brownie.reverts("RideLibExchange: Price feed not supported"):
        ride_exchange.getAddedXPerYPriceFeed(key_code, key_token)

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    assert ride_exchange.getAddedXPerYPriceFeed(key_code, key_token) == price_feed

    return key_code, key_token, price_feed


def test_RideExchange_deriveXPerYPriceFeed(
    ride_exchange,
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_token,
    ride_WETH9,
    dMockV3Aggregator2,
    deployer,
    person1,
    person2,
):
    key_code, key_token, _ = test_RideExchange_addXPerYPriceFeed(
        ride_exchange,
        ride_currency_registry,
        ride_hub,
        ride_governor,
        ride_access_control,
        ride_token,
        dMockV3Aggregator2,
        deployer,
        person1,
        person2,
    )

    key_wETH = utils.pad_address_right(ride_WETH9.address)
    # print("wETH-USD:", ride_exchange.getAddedXPerYPriceFeed(key_wETH, key_code))
    # print(
    #     "wETH-USD value:", ride_exchange.getAddedXPerYPriceFeedValue(key_wETH, key_code)
    # )
    # print("RIDE-USD:", ride_exchange.getAddedXPerYPriceFeed(key_token, key_code))
    # print(
    #     "RIDE-USD value:",
    #     ride_exchange.getAddedXPerYPriceFeedValue(key_token, key_code),
    # )

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_exchange.deriveXPerYPriceFeed(
            key_wETH, key_token, key_code, {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        key_wETH,
        key_token,
        key_code,
    )
    encoded_function = ride_exchange.deriveXPerYPriceFeed.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    with brownie.reverts("RideLibExchange: Derived price feed not supported"):
        ride_exchange.getDerivedXPerYPriceFeedDetails(key_wETH, key_token)

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    assert (
        ride_exchange.getDerivedXPerYPriceFeedDetails(key_wETH, key_token)[0]
        == key_code
    )
    assert ride_exchange.getDerivedXPerYPriceFeedDetails(key_wETH, key_token)[
        1
    ] == ride_exchange.getAddedXPerYPriceFeed(key_wETH, key_code)
    assert ride_exchange.getDerivedXPerYPriceFeedDetails(key_wETH, key_token)[
        2
    ] == ride_exchange.getAddedXPerYPriceFeed(key_token, key_code)
    assert ride_exchange.getDerivedXPerYPriceFeedDetails(key_wETH, key_token)[3] == True
    assert ride_exchange.getDerivedXPerYPriceFeedDetails(key_wETH, key_token)[4] == True

    return key_wETH, key_token, key_code


def test_RideExchange_removeAddedXPerYPriceFeed(
    ride_exchange,
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_token,
    dMockV3Aggregator1,
    deployer,
    person1,
    person2,
):
    key_code, key_token, price_feed = test_RideExchange_addXPerYPriceFeed(
        ride_exchange,
        ride_currency_registry,
        ride_hub,
        ride_governor,
        ride_access_control,
        ride_token,
        dMockV3Aggregator1,
        deployer,
        person1,
        person2,
    )

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_exchange.removeAddedXPerYPriceFeed(
            key_code, key_token, {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        key_code,
        key_token,
    )
    encoded_function = ride_exchange.removeAddedXPerYPriceFeed.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_exchange.getAddedXPerYPriceFeed(key_code, key_token) == price_feed

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    with brownie.reverts("RideLibExchange: Price feed not supported"):
        ride_exchange.getAddedXPerYPriceFeed(key_code, key_token)


def test_RideExchange_removeDerivedXPerYPriceFeed(
    ride_exchange,
    ride_currency_registry,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_token,
    ride_WETH9,
    dMockV3Aggregator2,
    deployer,
    person1,
    person2,
):
    key_nominator, key_denominator, key_shared = test_RideExchange_deriveXPerYPriceFeed(
        ride_exchange,
        ride_currency_registry,
        ride_hub,
        ride_governor,
        ride_access_control,
        ride_token,
        ride_WETH9,
        dMockV3Aggregator2,
        deployer,
        person1,
        person2,
    )

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_exchange.removeDerivedXPerYPriceFeed(
            key_nominator, key_denominator, {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        key_nominator,
        key_denominator,
    )
    encoded_function = ride_exchange.removeDerivedXPerYPriceFeed.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert (
        ride_exchange.getDerivedXPerYPriceFeedDetails(key_nominator, key_denominator)[0]
        == key_shared
    )
    assert (
        ride_exchange.getDerivedXPerYPriceFeedDetails(key_nominator, key_denominator)[3]
        == True
    )
    assert (
        ride_exchange.getDerivedXPerYPriceFeedDetails(key_nominator, key_denominator)[4]
        == True
    )

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    with brownie.reverts("RideLibExchange: Derived price feed not supported"):
        ride_exchange.getDerivedXPerYPriceFeedDetails(key_nominator, key_denominator)


def test_RideFee_setCancellationFee(
    ride_fee, ride_hub, ride_governor, ride_access_control, deployer, person1, person2,
):
    key_code = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["USD"]).hex()]
        )
    )
    fee = 5

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_fee.setCancellationFee(key_code, fee, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (
        key_code,
        fee,
    )
    encoded_function = ride_fee.setCancellationFee.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_fee.getCancellationFee(key_code) != fee

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after

    assert ride_fee.getCancellationFee(key_code) == fee


def test_RideFee_setBaseFee(
    ride_fee, ride_hub, ride_governor, ride_access_control, deployer, person1, person2,
):
    key_code = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["USD"]).hex()]
        )
    )
    fee = 5

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_fee.setBaseFee(key_code, fee, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (
        key_code,
        fee,
    )
    encoded_function = ride_fee.setBaseFee.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_fee.getBaseFee(key_code) != fee

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after

    assert ride_fee.getBaseFee(key_code) == fee


def test_RideFee_setCostPerMinute(
    ride_fee, ride_hub, ride_governor, ride_access_control, deployer, person1, person2,
):
    key_code = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["USD"]).hex()]
        )
    )
    fee = 5

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_fee.setCostPerMinute(key_code, fee, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (
        key_code,
        fee,
    )
    encoded_function = ride_fee.setCostPerMinute.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_fee.getCostPerMinute(key_code) != fee

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after

    assert ride_fee.getCostPerMinute(key_code) == fee


# def test_RideFee_setCostPerMetre(
#     ride_fee, ride_hub, ride_governor, ride_access_control, deployer, person1, person2,
# ):
#     key_code = Web3.toHex(
#         Web3.solidityKeccak(
#             ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["USD"]).hex()]
#         )
#     )
#     fee = [1, 2, 3, 4, 5, 6]

#     # 1 # --> revert as not contract owner
#     with brownie.reverts():
#         ride_fee.setCostPerMetre(key_code, fee, {"from": deployer})

#     # 2 # --> encode function to be executed
#     args = (
#         key_code,
#         fee,
#     )
#     encoded_function = ride_fee.setCostPerMetre.encode_input(*args)

#     # 3 # --> passs through governance process

#     # before
#     assert ride_fee.getCostPerMetre(key_code, 0) != fee[0]
#     assert ride_fee.getCostPerMetre(key_code, 1) != fee[1]
#     assert ride_fee.getCostPerMetre(key_code, 2) != fee[2]
#     assert ride_fee.getCostPerMetre(key_code, 3) != fee[3]
#     assert ride_fee.getCostPerMetre(key_code, 4) != fee[4]
#     assert ride_fee.getCostPerMetre(key_code, 5) != fee[5]

#     # governance
#     governance_process(
#         encoded_function,
#         ride_hub,
#         ride_governor,
#         ride_access_control,
#         deployer,
#         person1,
#         person2,
#     )

#     # after
#     assert ride_fee.getCostPerMetre(key_code, 0) == fee[0]
#     assert ride_fee.getCostPerMetre(key_code, 1) == fee[1]
#     assert ride_fee.getCostPerMetre(key_code, 2) == fee[2]
#     assert ride_fee.getCostPerMetre(key_code, 3) == fee[3]
#     assert ride_fee.getCostPerMetre(key_code, 4) == fee[4]
#     assert ride_fee.getCostPerMetre(key_code, 5) == fee[5]


def test_RidePenalty_setBanDuration(
    ride_penalty,
    ride_hub,
    ride_governor,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    ban_duration = 69

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_penalty.setBanDuration(ban_duration, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (ban_duration,)
    encoded_function = ride_penalty.setBanDuration.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_penalty.getBanDuration() != ban_duration

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after

    assert ride_penalty.getBanDuration() == ban_duration


def test_RideRater_setRatingBounds(
    ride_rater,
    ride_hub,
    ride_governor,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    rating_minimum = 2
    rating_maximum = 4

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_rater.setRatingBounds(rating_minimum, rating_maximum, {"from": deployer})

    # 2 # --> encode function to be executed
    args = (
        rating_minimum,
        rating_maximum,
    )
    encoded_function = ride_rater.setRatingBounds.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_rater.getRatingMin() != rating_minimum
    assert ride_rater.getRatingMax() != rating_maximum

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after

    assert ride_rater.getRatingMin() == rating_minimum
    assert ride_rater.getRatingMax() == rating_maximum


def test_RideCut_rideCut_add(
    ride_cut,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_loupe,
    dBox3,
    deployer,
    person1,
    person2,
):
    dBox3_selectors = utils.get_function_selectors(dBox3)
    facets_to_cut = [
        dBox3.address,
        utils.FACET_CUT_ACTIONS["Add"],
        dBox3_selectors,
    ]

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_cut.rideCut(
            [facets_to_cut],
            utils.ZERO_ADDRESS,
            utils.ZERO_CALLDATAS,
            {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        [facets_to_cut],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
    )
    encoded_function = ride_cut.rideCut.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert len(ride_loupe.facetFunctionSelectors(dBox3.address)) == 0

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    assert ride_loupe.facetFunctionSelectors(dBox3.address) == dBox3_selectors


def test_RideCut_rideCut_remove(
    ride_cut,
    ride_hub,
    ride_governor,
    ride_access_control,
    ride_loupe,
    dBox3,
    deployer,
    person1,
    person2,
):
    test_RideCut_rideCut_add(
        ride_cut,
        ride_hub,
        ride_governor,
        ride_access_control,
        ride_loupe,
        dBox3,
        deployer,
        person1,
        person2,
    )

    dBox3_selectors = utils.get_function_selectors(dBox3)
    facets_to_cut = [
        utils.ZERO_ADDRESS,
        utils.FACET_CUT_ACTIONS["Remove"],
        dBox3_selectors,
    ]

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_cut.rideCut(
            [facets_to_cut],
            utils.ZERO_ADDRESS,
            utils.ZERO_CALLDATAS,
            {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        [facets_to_cut],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
    )
    encoded_function = ride_cut.rideCut.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_loupe.facetFunctionSelectors(dBox3.address) == dBox3_selectors

    # governance
    governance_process(
        encoded_function,
        ride_hub,
        ride_governor,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    # after
    assert len(ride_loupe.facetFunctionSelectors(dBox3.address)) == 0

