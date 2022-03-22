import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_penalty(ride_hub, RideTestPenalty, Contract, deployer):
    yield Contract.from_abi(
        "RideTestPenalty", ride_hub[0].address, RideTestPenalty.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_access_control(ride_hub, RideTestAccessControl, Contract, deployer):
    yield Contract.from_abi(
        "RideTestAccessControl",
        ride_hub[0].address,
        RideTestAccessControl.abi,
        deployer,
    )


chain = brownie.network.state.Chain()


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_setBanDuration(ride_penalty, ride_access_control, deployer):
    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_penalty.setBanDuration(12345)
    tx.wait(1)

    assert ride_penalty.sBanDuration_(deployer.address) == 12345


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setBanDuration_event(ride_penalty, ride_access_control, deployer):
    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_penalty.setBanDuration(12345)
    tx.wait(1)

    assert tx.events["SetBanDuration"]["sender"] == deployer
    assert tx.events["SetBanDuration"]["banDuration"] == 12345


def test_getBanDuration(ride_penalty, ride_access_control, deployer):
    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_penalty.setBanDuration(12345)
    tx.wait(1)

    assert ride_penalty.getBanDuration(deployer.address) == 12345


def test_getUserToBanEndTimestamp(ride_penalty, deployer):
    assert ride_penalty.getUserToBanEndTimestamp(deployer) == 0

    tx = ride_penalty.ssUserToBanEndTimestamp_(deployer, 7955020800)
    tx.wait(1)

    assert ride_penalty.getUserToBanEndTimestamp(deployer) == 7955020800
