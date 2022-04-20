from brownie import network, config
import brownie
import scripts.utils as utils
import scripts.deploy_ride_token as deploy_ride_token
import scripts.deploy_ride_hub as deploy_ride_hub
import scripts.execution_patterns as ep


def setup1(deployer):
    ride_token = deploy_ride_token.main(deployer)

    hive_creation_count = 4
    job_lifespan = 86400
    min_dispute_duration = 60
    rating_min = 1
    rating_max = 5
    ride_hub, _ = deploy_ride_hub.main(
        ride_token,
        hive_creation_count,
        job_lifespan,
        min_dispute_duration,
        rating_min,
        rating_max,
        deployer,
    )

    # 1 # build hive

    hive_factory = brownie.Contract.from_abi(
        "HiveFactory", ride_hub.address, brownie.HiveFactory.abi, deployer,
    )

    name = "RideDAO Malaysia"
    symbol = "RMYR"
    min_delay = 1
    proposers = []
    executors = []
    voting_delay = 1
    voting_period = 100
    proposal_threshold = 0
    quorum_percentage = 4

    tx = hive_factory.initializeHiveGeneration(name, symbol, {"from": deployer})
    tx.wait(1)

    assert tx.events["HiveCreationInitialized"]["orderCount"] == 1
    hive_key = tx.events["HiveCreationInitialized"]["hiveKey"]

    tx = hive_factory.deployHiveGovernanceToken(
        ride_token, name, symbol, {"from": deployer}
    )
    tx.wait(1)

    assert tx.events["HiveComponentDeployed"]["orderCount"] == 2
    hive_gov_token = tx.events["HiveComponentDeployed"]["component"]
    assert hive_gov_token == hive_factory.getHiveGovernanceToken(hive_key)

    tx = hive_factory.deployHiveTimelock(
        min_delay, proposers, executors, {"from": deployer}
    )
    tx.wait(1)

    assert tx.events["HiveComponentDeployed"]["orderCount"] == 3
    hive_timelock = tx.events["HiveComponentDeployed"]["component"]
    assert hive_timelock == hive_factory.getHiveTimelock(hive_key)

    tx = hive_factory.deployHiveGovernor(
        name,
        hive_gov_token,
        hive_timelock,
        ride_hub.address,
        voting_delay,
        voting_period,
        proposal_threshold,
        quorum_percentage,
        {"from": deployer},
    )
    tx.wait(1)

    assert tx.events["HiveComponentDeployed"]["orderCount"] == 4
    hive_gov = tx.events["HiveComponentDeployed"]["component"]
    assert hive_gov == hive_factory.getHiveGovernor(hive_key)

    tx = hive_factory.activateHive([deployer], ["test identity"], {"from": deployer})
    tx.wait(1)

    assert tx.events["HiveActivated"]["hiveCount"] == 1
    assert tx.events["HiveActivated"]["hiveKey"] == hive_key

    print("Deployed Hives")
    print("Gov Token:", hive_gov_token)
    print("Timelock:", hive_timelock)
    print("Governor:", hive_gov)

    return ride_token, ride_hub, hive_gov_token, hive_timelock, hive_gov


def setup2(
    deployer,
    ride_token,
    ride_hub,
    hive_gov_token,
    hive_timelock_address,
    hive_gov,
    ride_currency_registry,
    ride_fee,
    ride_access_control,
):
    # 2 # get hive voting power

    voter = deployer
    votes = "100 ether"
    # # --> mint some ride tokens
    tx = ride_token.mint(voter, votes, {"from": deployer})
    tx.wait(1)

    # assert ride_token.balanceOf(voter) == votes
    # assert hive_gov_token.balanceOf(voter) == 0

    # # --> swap ride tokens to governance token (for voting)
    tx = ride_token.approve(hive_gov_token.address, votes, {"from": voter})
    tx.wait(1)

    tx = hive_gov_token.depositFor(voter, votes, {"from": voter})
    tx.wait(1)

    # assert ride_token.balanceOf(voter) == 0
    # assert hive_gov_token.balanceOf(voter) == votes

    # assert hive_gov_token.getVotes(voter) == 0

    # # --> activate voting power (for self)
    tx = hive_gov_token.delegate(voter, {"from": voter})
    tx.wait(1)

    # assert hive_gov_token.getVotes(voter) == votes

    # 3 # hive setting fees

    key_USD = ride_currency_registry.getKeyFiat("USD")

    # assert ride_fee.getCancellationFee(hive_timelock_address, key_USD) == 0
    # assert ride_fee.getBaseFee(hive_timelock_address, key_USD) == 0
    # assert ride_fee.getCostPerMinute(hive_timelock_address, key_USD) == 0
    # assert ride_fee.getCostPerMetre(hive_timelock_address, key_USD) == 0

    fee_cancellation = "0.0015 ether"  # ~ $5 if ETH priced at $3000
    fee_base = "0.0010 ether"
    cost_per_minute = "0.000005 ether"
    cost_per_metre = "0.0008 ether"  # $2.51 per mile for random search on Uber: Central Park --> Brooklyn https://www.uber.com/global/en/price-estimate/

    args = (
        key_USD,
        fee_cancellation,
    )
    encoded_function1 = ride_fee.setCancellationFee.encode_input(*args)

    args = (
        key_USD,
        fee_base,
    )
    encoded_function2 = ride_fee.setBaseFee.encode_input(*args)

    args = (
        key_USD,
        cost_per_minute,
    )
    encoded_function3 = ride_fee.setCostPerMinute.encode_input(*args)

    args = (
        key_USD,
        cost_per_metre,
    )
    encoded_function4 = ride_fee.setCostPerMetre.encode_input(*args)

    ep.governance_process(
        [encoded_function1, encoded_function2, encoded_function3, encoded_function4],
        [ride_hub.address, ride_hub.address, ride_hub.address, ride_hub.address,],
        hive_gov,
        ride_access_control,
        deployer,
        deployer,
        {deployer: 1},
        deployer,
    )

    # ep.governance_execute_only(
    #     [encoded_function1, encoded_function2, encoded_function3, encoded_function4],
    #     [ride_hub.address, ride_hub.address, ride_hub.address, ride_hub.address,],
    #     hive_gov,
    #     ride_access_control,
    #     deployer,
    #     deployer,
    #     {deployer: 1},
    #     deployer,
    # )

    assert (
        ride_fee.getCancellationFee(hive_timelock_address, key_USD) == fee_cancellation
    )
    assert ride_fee.getBaseFee(hive_timelock_address, key_USD) == fee_base
    assert ride_fee.getCostPerMinute(hive_timelock_address, key_USD) == cost_per_minute
    assert ride_fee.getCostPerMetre(hive_timelock_address, key_USD) == cost_per_metre

    """
    ValueError: Execution reverted during call: 'execution reverted: Governor: vote not currently active'. 
    This transaction will likely revert. If you wish to broadcast, include `allow_revert:True` as a transaction 
    parameter.
    """


def main():
    deployer = utils.get_account()

    # # 1 # deployment stuff
    # (
    #     ride_token,
    #     ride_hub,
    #     hive_gov_token_address,
    #     hive_timelock_address,
    #     hive_gov_address,
    # ) = setup1(deployer)

    # use_token_address = ride_token.address
    use_token_address = "0x4f8DcD5081F80a3F2E2621117f630766f6a96A8e"

    ride_token = brownie.Contract.from_abi(
        "Ride", use_token_address, brownie.Ride.abi, deployer,
    )

    # 2 # simple setup stuff
    # use_hub_address = ride_hub.address
    use_hub_address = "0x17f4AA03Ce8Ee96fFcd86DC810D845E29c131F97"

    # use_gov_token_address = hive_gov_token_address
    # use_timelock_address = hive_timelock_address
    # use_gov_address = hive_gov_address
    use_gov_token_address = "0xE05e6F5EA4C47F306d01E2E622AB80B931E3a41e"
    use_timelock_address = "0x381b91252fb0E48F74Be49D193AF2bbb3505FE7b"
    use_gov_address = "0x8Ae41568C3bc6916566079Fc889f54bCf5F248EA"

    ride_hub = brownie.Contract.from_abi(
        "Hub", use_hub_address, brownie.Hub.abi, deployer,
    )

    ride_fee = brownie.Contract.from_abi(
        "Fee", use_hub_address, brownie.Fee.abi, deployer,
    )

    ride_currency_registry = brownie.Contract.from_abi(
        "CurrencyRegistry", use_hub_address, brownie.CurrencyRegistry.abi, deployer,
    )

    ride_access_control = brownie.Contract.from_abi(
        "AccessControl", use_hub_address, brownie.AccessControl.abi, deployer,
    )

    hive_gov_token = brownie.Contract.from_abi(
        "HiveGovernanceToken",
        use_gov_token_address,
        brownie.HiveGovernanceToken.abi,
        deployer,
    )

    hive_gov = brownie.Contract.from_abi(
        "HiveGovernor", use_gov_address, brownie.HiveGovernor.abi, deployer,
    )

    setup2(
        deployer,
        ride_token,
        ride_hub,
        hive_gov_token,
        use_timelock_address,
        hive_gov,
        ride_currency_registry,
        ride_fee,
        ride_access_control,
    )

    # 3 # transfer ownership stuff
    JR_address = "0xa30c9e33629228cc2728ed11b02115f4d14bd8ae"

    role_admin = ride_access_control.getDefaultAdminRole()
    role_maintainer = ride_access_control.getRole("MAINTAINER_ROLE")
    role_strategist = ride_access_control.getRole("STRATEGIST_ROLE")

    tx = ride_access_control.grantRole(role_admin, JR_address, {"from": deployer})
    tx.wait(1)
    tx = ride_access_control.grantRole(role_maintainer, JR_address, {"from": deployer})
    tx.wait(1)
    tx = ride_access_control.grantRole(role_strategist, JR_address, {"from": deployer})
    tx.wait(1)

    assert ride_token.owner() == deployer

    tx = ride_token.transferOwnership(JR_address, {"from": deployer})
    tx.wait(1)

    assert ride_token.owner() == JR_address

    pass
