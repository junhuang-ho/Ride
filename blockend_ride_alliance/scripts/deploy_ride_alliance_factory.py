from brownie import network, config
import brownie
import scripts.utils as utils


def main(deployer):
    ride_alliance_cut = brownie.RideAllianceCut.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    ride_alliance_factory = brownie.RideAllianceFactory.deploy(
        deployer.address,
        ride_alliance_cut.address,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        facets = [
            "RideAllianceLoupe",
            "RideTestAllianceAccessControl",
            "RideTestAlliancePrinter",
            "RideTestAlliancePrinterTimelock",
            "RideTestAlliancePrinterGovernor",
            "RideTestAllianceForger",
        ]
    else:
        facets = [
            "RideAllianceLoupe",
            "RideAllianceAccessControl",
            "RideAlliancePrinter",
            "RideAlliancePrinterTimelock",
            "RideAlliancePrinterGovernor",
            "RideAllianceForger",
        ]

    facets_to_cut = utils.diamond_bulk_deploy(facets, deployer)

    contract_ride_alliance_cut = brownie.Contract.from_abi(
        "RideAllianceCut", ride_alliance_factory.address, brownie.RideAllianceCut.abi,
    )

    print("💎 Cutting RideAllianceFactory 💎")
    tx = contract_ride_alliance_cut.rideCut(
        facets_to_cut, utils.ZERO_ADDRESS, utils.ZERO_CALLDATAS, {"from": deployer},
    )
    tx.wait(1)

    return ride_alliance_factory
