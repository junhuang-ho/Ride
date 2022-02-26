from brownie import network, config
import brownie
import scripts.utils as utils


def main(deployer):
    deployed_contract_ride_token = brownie.Ride.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    min_delay = 1
    deployed_contract_ride_timelock = brownie.RideTimelock.deploy(
        min_delay,
        [],
        [],
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        voting_delay = 1
        voting_period = 10
        proposal_threshold = 0
        quorum_percentage = 4
    else:
        voting_delay = 1
        voting_period = 200
        proposal_threshold = 0
        quorum_percentage = 4

    deployed_contract_ride_governor = brownie.RideGovernor.deploy(
        deployed_contract_ride_token.address,
        deployed_contract_ride_timelock.address,
        voting_delay,
        voting_period,
        proposal_threshold,
        quorum_percentage,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    assert deployed_contract_ride_governor.votingDelay() == voting_delay
    assert deployed_contract_ride_governor.votingPeriod() == voting_period
    assert deployed_contract_ride_governor.proposalThreshold() == proposal_threshold

    ###############################################################
    ##### --------------------------------------------------- #####
    ##### ----- timelock role granting - edit as needed ----- #####

    role_proposer = deployed_contract_ride_timelock.PROPOSER_ROLE()
    role_executor = deployed_contract_ride_timelock.EXECUTOR_ROLE()
    role_admin = deployed_contract_ride_timelock.TIMELOCK_ADMIN_ROLE()

    # check that 2 addresses owns the role_admin
    assert deployed_contract_ride_timelock.hasRole(
        role_admin, deployed_contract_ride_timelock.address
    )
    assert deployed_contract_ride_timelock.hasRole(role_admin, deployer)

    # set proposer role to governor (voters - those who hold token)
    tx = deployed_contract_ride_timelock.grantRole(
        role_proposer, deployed_contract_ride_governor.address, {"from": deployer}
    )
    tx.wait(1)

    # set executor role to zero address (anyone)
    tx = deployed_contract_ride_timelock.grantRole(
        role_executor, utils.ZERO_ADDRESS, {"from": deployer}
    )
    tx.wait(1)

    # deployer renounce control of timelock as no one should own the timelock contract, but the timelock itself
    tx = deployed_contract_ride_timelock.renounceRole(
        role_admin, deployer.address, {"from": deployer}
    )
    tx.wait(1)

    # check timelock admin roles
    assert deployed_contract_ride_timelock.hasRole(
        role_admin, deployed_contract_ride_timelock.address
    )
    assert not deployed_contract_ride_timelock.hasRole(role_admin, deployer)
    # with brownie.reverts():
    #     deployed_contract_ride_timelock.grantRole(
    #         role_admin, deployer.address, {"from": deployer}
    #     )
    # TODO: this reverts currently got error: https://github.com/eth-brownie/brownie/issues/1452

    ##### -----                                         ----- #####
    ##### --------------------------------------------------- #####
    ###############################################################

    print(f"Ride Token: {deployed_contract_ride_token.address}")
    print(f"RideTimelock: {deployed_contract_ride_timelock.address}")
    print(f"RideGobernor: {deployed_contract_ride_governor.address}")

    return (
        deployed_contract_ride_token,
        deployed_contract_ride_timelock,
        deployed_contract_ride_governor,
    )

