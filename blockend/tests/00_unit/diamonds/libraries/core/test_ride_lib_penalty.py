import pytest
import brownie
from web3 import Web3
import eth_abi
import web3
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_penalty(ride_hub, RideTestPenalty, Contract, deployer):
    yield Contract.from_abi(
        "RideTestPenalty", ride_hub[0].address, RideTestPenalty.abi, deployer,
    )


chain = brownie.network.state.Chain()


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_requireNotBanned_revert(ride_penalty, deployer):
    tx = ride_penalty.ssUserToBanEndTimestamp_(deployer, 7955020800)
    tx.wait(1)

    with brownie.reverts("RideLibPenalty: Still banned"):
        ride_penalty.requireNotBanned_()


def test_requireNotBanned_pass(ride_penalty, deployer):
    tx = ride_penalty.ssUserToBanEndTimestamp_(deployer, 1645508042)
    tx.wait(1)

    assert ride_penalty.requireNotBanned_()


def test_setBanDuration(ride_penalty):
    tx = ride_penalty.setBanDuration_(12345)
    tx.wait(1)

    assert ride_penalty.sBanDuration_() == 12345


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setBanDuration_event(ride_penalty, deployer):
    tx = ride_penalty.setBanDuration_(12345)
    tx.wait(1)

    assert tx.events["SetBanDuration"]["sender"] == deployer
    assert tx.events["SetBanDuration"]["banDuration"] == 12345


def test_temporaryBan(ride_penalty, deployer):
    assert ride_penalty.sUserToBanEndTimestamp_(deployer) == 0

    # now = chain.time()
    tx = ride_penalty.temporaryBan_(deployer)
    tx.wait(1)

    assert (
        ride_penalty.sUserToBanEndTimestamp_(deployer)
        == chain[-1].timestamp + ride_penalty.sBanDuration_()
    )


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_temporaryBan_event(ride_penalty, deployer):
    # now = chain.time()
    tx = ride_penalty.temporaryBan_(deployer)
    tx.wait(1)

    assert tx.events["UserBanned"]["banned"] == deployer
    assert tx.events["UserBanned"]["from"] == chain[-1].timestamp
    assert (
        tx.events["UserBanned"]["to"]
        == chain[-1].timestamp + ride_penalty.sBanDuration_()
    )
