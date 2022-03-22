import brownie
import scripts.utils as utils
import scripts.execution_patterns as ep


def build_hive(
    ride_hub,
    ride_token,
    ride_hive_factory,
    ride_runner_detail,
    ride_access_control,
    deployer,
    person1,
    person2,
    person3,
    ride_multi_sigs,
    name,
    symbol,
    min_delay,
    voting_delay,
    voting_period,
    proposal_threshold,
    quorum_percentage,
):
    # 2 # execute

    members = [deployer, person1]

    args = (name, symbol)
    encoding = ride_hive_factory.initializeHiveGeneration.encode_input(*args)
    ep.execute_multisig_decision(
        0, ride_multi_sigs[2], ride_hub.address, encoding, deployer, members
    )

    args = (ride_token, name, symbol)
    encoding = ride_hive_factory.deployHiveGovernanceToken.encode_input(*args)
    ep.execute_multisig_decision(
        1, ride_multi_sigs[2], ride_hub.address, encoding, deployer, members
    )

    args = (min_delay, [], [])
    encoding = ride_hive_factory.deployHiveTimelock.encode_input(*args)
    ep.execute_multisig_decision(
        2, ride_multi_sigs[2], ride_hub.address, encoding, deployer, members
    )

    hive_key = ride_hive_factory.getHiveKey(name, symbol)

    address_hive_governance_token = ride_hive_factory.getHiveGovernanceToken(hive_key)
    contract_hive_governance_token = brownie.Contract.from_abi(
        "HiveGovernanceToken",
        address_hive_governance_token,
        brownie.HiveGovernanceToken.abi,
        deployer,
    )

    address_hive_timelock = ride_hive_factory.getHiveTimelock(hive_key)
    contract_hive_timelock = brownie.Contract.from_abi(
        "HiveTimelock", address_hive_timelock, brownie.HiveTimelock.abi, deployer,
    )

    args = (
        name,
        contract_hive_governance_token,
        contract_hive_timelock,
        ride_hub.address,
        voting_delay,
        voting_period,
        proposal_threshold,
        quorum_percentage,
    )
    encoding = ride_hive_factory.deployHiveGovernor.encode_input(*args)
    ep.execute_multisig_decision(
        3, ride_multi_sigs[2], ride_hub.address, encoding, deployer, members
    )

    address_hive_governor = ride_hive_factory.getHiveGovernor(hive_key)
    contract_hive_governor = brownie.Contract.from_abi(
        "HiveGovernor", address_hive_governor, brownie.HiveGovernor.abi, deployer,
    )

    args = (
        [person2, person3],
        ["identity 1", "identitiy 2"],
    )
    encoding = ride_hive_factory.activateHive.encode_input(*args)
    ep.execute_multisig_decision(
        4, ride_multi_sigs[2], ride_hub.address, encoding, deployer, members
    )

    assert address_hive_governance_token != utils.ZERO_ADDRESS
    assert address_hive_timelock != utils.ZERO_ADDRESS
    assert address_hive_governor != utils.ZERO_ADDRESS

    role_admin = contract_hive_timelock.TIMELOCK_ADMIN_ROLE()

    assert contract_hive_timelock.hasRole(role_admin, contract_hive_timelock.address)
    assert not contract_hive_timelock.hasRole(role_admin, deployer)
    assert not contract_hive_timelock.hasRole(
        role_admin, ride_hub.address
    )  # TODO: hub having admin role, would it be a problem?
    assert not contract_hive_timelock.hasRole(role_admin, ride_multi_sigs[2].address)

    assert ride_access_control.hasRole(
        ride_access_control.getRole("HIVE_ROLE"), contract_hive_timelock.address
    )

    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[1] != ""
    assert (
        ride_runner_detail.getRunnerToRunnerDetail(person2)[2] == address_hive_timelock
    )

    assert ride_runner_detail.getRunnerToRunnerDetail(person3)[1] != ""
    assert (
        ride_runner_detail.getRunnerToRunnerDetail(person3)[2] == address_hive_timelock
    )

    return (
        contract_hive_governance_token,
        contract_hive_timelock,
        contract_hive_governor,
    )


def get_voting_power(ride_token, hive_governance_token, ride_multi_sigs, voters):
    votes = "100 ether"
    for voter in voters:
        # 1 # --> mint some ride tokens
        tx = ride_token.mint(voter, votes, {"from": ride_multi_sigs[0]})
        tx.wait(1)

        assert ride_token.balanceOf(voter) == votes
        assert hive_governance_token.balanceOf(voter) == 0

        # 2 # --> swap ride tokens to governance token (for voting)
        tx = ride_token.approve(hive_governance_token.address, votes, {"from": voter})
        tx.wait(1)

        tx = hive_governance_token.depositFor(voter, votes, {"from": voter})
        tx.wait(1)

        assert ride_token.balanceOf(voter) == 0
        assert hive_governance_token.balanceOf(voter) == votes

        assert hive_governance_token.getVotes(voter) == 0

        # 3 # --> activate voting power (for self)
        tx = hive_governance_token.delegate(voter, {"from": voter})
        tx.wait(1)

        assert hive_governance_token.getVotes(voter) == votes
