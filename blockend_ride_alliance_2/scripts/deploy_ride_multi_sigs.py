from brownie import network, config
import brownie
import scripts.utils as utils


def main(members, confirmations_required, deployer):
    assert isinstance(members, list)

    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        ride_multisig_administration = brownie.RideTestMultiSignatureWallet.deploy(
            "Ride Administration Test",
            members,
            confirmations_required,
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )

        ride_multisig_maintainer = brownie.RideTestMultiSignatureWallet.deploy(
            "Ride Maintainer Test",
            members,
            confirmations_required,
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )

        ride_multisig_strategist = brownie.RideTestMultiSignatureWallet.deploy(
            "Ride Strategist Test",
            members,
            confirmations_required,
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )
    else:
        ride_multisig_administration = brownie.RideMultiSignatureWallet.deploy(
            "Ride Administration",
            members,
            confirmations_required,
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )

        ride_multisig_maintainer = brownie.RideMultiSignatureWallet.deploy(
            "Ride Maintainer",
            members,
            confirmations_required,
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )

        ride_multisig_strategist = brownie.RideMultiSignatureWallet.deploy(
            "Ride Strategist",
            members,
            confirmations_required,
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )

    return (
        ride_multisig_administration,
        ride_multisig_maintainer,
        ride_multisig_strategist,
    )
