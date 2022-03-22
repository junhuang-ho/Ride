import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils
import scripts.experimental.deploy_diamond as dd


@pytest.fixture(scope="module", autouse=True)
def diamond():
    yield dd.main()


# @pytest.fixture(scope="module", autouse=True)
# def bucket(diamond, Bucket, deployer):
#     yield brownie.Contract.from_abi(
#         "Bucket", diamond.address, Bucket.abi, deployer,
#     )


# @pytest.fixture(scope="module", autouse=True)
# def boxers(diamond, Boxers, deployer):
#     yield brownie.Contract.from_abi(
#         "Boxers", diamond.address, Boxers.abi, deployer,
#     )


def bucket(diamond):
    deployer = utils.get_account(index=0)
    return brownie.Contract.from_abi(
        "Bucket", diamond.address, brownie.Bucket.abi, deployer,
    )


def boxers(diamond):
    deployer = utils.get_account(index=0)
    return brownie.Contract.from_abi(
        "Boxers", diamond.address, brownie.Boxers.abi, deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_event(diamond, Bucket, Boxers, deployer, person1):

    # bucket = brownie.Contract.from_abi("Bucket", diamond.address, Bucket.abi, deployer,)

    tx = bucket(diamond).storeBucket(77, {"from": deployer})
    tx.wait(1)

    print(tx.info())

    # boxers = brownie.Contract.from_abi("Boxers", diamond.address, Boxers.abi, deployer,)

    # tx = bucket.storeBucket(77, {"from": deployer})
    # tx.wait(1)

    # print(tx.info())

    # tx = boxers.store2(69, {"from": deployer})
    # tx.wait(1)

    # print(tx.info())

    tx = boxers(diamond).store2(69, {"from": deployer})
    tx.wait(1)

    print(tx.info())

    tx = boxers(diamond).store2(88, {"from": person1})
    tx.wait(1)

    print(tx.info())
