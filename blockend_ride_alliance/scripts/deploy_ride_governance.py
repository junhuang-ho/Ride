from brownie import network, config
import brownie
import scripts.utils as utils


def main(
    ride_token,
    min_delay,
    voting_delay,
    voting_period,
    proposal_threshold,
    quorum_percentage,
    deployer,
):
    ride_governance = brownie.RideGovernance.deploy(
        ride_token,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    ride_timelock = brownie.RideTimelock.deploy(
        min_delay,
        [],
        [],
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    ride_governor = brownie.RideGovernor.deploy(
        ride_governance.address,
        ride_timelock.address,
        voting_delay,
        voting_period,
        proposal_threshold,
        quorum_percentage,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    return ride_governance, ride_timelock, ride_governor
