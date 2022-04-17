import brownie
import scripts.utils as utils


def main():
    deployer = utils.get_account(index=0)

    # deployed_box = brownie.Box0.deploy({"from": deployer}, publish_source=False)

    contract_box = brownie.Contract.from_abi(
        "Box0",
        "0xd0029bFE4c8E0b0891417b935Fd1a8510F79fEb9",
        brownie.Box0.abi,
        deployer,
    )

    # value = contract_box

