import brownie
from brownie import network, config

import scripts.utils as utils


def main():
    deployer = utils.get_account(index=0)

    contract_cut = brownie.DCut.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    contract_diamond = brownie.Diamond.deploy(
        deployer.address,
        contract_cut.address,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    facets = [
        "DLoupe",
        "DAccessControl",
        "Boxers",
        "Bucket",
    ]

    facets_to_cut = utils.diamond_bulk_deploy(facets, deployer)

    contract_diamond_cut = brownie.Contract.from_abi(
        "DCut", contract_diamond.address, brownie.DCut.abi,
    )

    print("💎 Cutting Diamond 💎")
    tx = contract_diamond_cut.cut(
        facets_to_cut, utils.ZERO_ADDRESS, utils.ZERO_CALLDATAS, {"from": deployer},
    )
    tx.wait(1)

    return contract_diamond

    # bucket = brownie.Contract.from_abi(
    #     "Bucket", contract_diamond.address, brownie.Bucket.abi, deployer,
    # )

    # tx = bucket.storeBucket(77, {"from": deployer})
    # tx.wait(1)

    # print(tx.info())

    # boxers = brownie.Contract.from_abi(
    #     "Boxers", contract_diamond.address, brownie.Boxers.abi, deployer,
    # )

    # tx = boxers.store(69, {"from": deployer})
    # tx.wait(1)

    # print(tx.info())

