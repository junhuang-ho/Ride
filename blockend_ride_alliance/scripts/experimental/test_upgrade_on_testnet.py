import brownie
from brownie import network, config
import time

import scripts.utils as utils


def deploy_RideRaterV2(deployer):

    deployed_contract = brownie.RideRaterV2.deploy(
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )

    print("New Contract:", deployed_contract.address)

    sleep_for = 30
    print("Sleeping...", sleep_for)
    time.sleep(sleep_for)

    return deployed_contract


def cut(ride_hub_address, contract_fresh, selectors_to_remove, deployer):
    ride_cut = brownie.Contract.from_abi(
        "RideCut", ride_hub_address, brownie.RideCut.abi, deployer,
    )

    selectors = utils.get_function_selectors(contract_fresh)

    tx = ride_cut.rideCut(
        [
            [contract_fresh.address, utils.FACET_CUT_ACTIONS["Add"], selectors],
            [
                utils.ZERO_ADDRESS,
                utils.FACET_CUT_ACTIONS["Remove"],
                selectors_to_remove,
            ],
        ],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": deployer},
    )
    tx.wait(1)


def main():
    ride_hub_address = "0x438e38F151Bf97139510a5e5F2B208F65f3bFF64"

    deployer = utils.get_account(index=0)
    deployed_contract = deploy_RideRaterV2(deployer)

    selectors_to_remove = ["0xda4db64f"]
    cut(ride_hub_address, deployed_contract, selectors_to_remove, deployer)


# TODO: 1. do a "reverse" action
# TODO: 2. do this cut action with governance (require set role through upgrade)
