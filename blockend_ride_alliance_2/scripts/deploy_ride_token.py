from brownie import network, config
import brownie
import scripts.utils as utils


def main(deployer):
    ride_token = brownie.Ride.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    return ride_token
