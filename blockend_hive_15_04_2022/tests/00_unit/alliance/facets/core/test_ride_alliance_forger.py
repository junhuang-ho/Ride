import pytest
import math
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils

count = 69
name = "Test"
symbol = "T"

salt = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"],
        [
            "0x"
            + eth_abi.encode_abi(
                ["int", "string", "string"], [count, name, symbol]
            ).hex(),
        ],
    )
)  # Solidity equivalent: keccak256(abi.encode(x,y,z))

alliance_key = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"],
        ["0x" + eth_abi.encode_abi(["string", "string"], [name, symbol]).hex()],
    )
)


@pytest.fixture(scope="module", autouse=True)
def ride_alliance_forger(
    ride_alliance_factory, RideTestAllianceForger, Contract, deployer
):
    yield Contract.from_abi(
        "RideTestAllianceForger",
        ride_alliance_factory.address,
        RideTestAllianceForger.abi,
        deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_getCount(ride_alliance_forger):
    tx = ride_alliance_forger.ssCount_(count)
    tx.wait(1)

    assert ride_alliance_forger.getCount() == count


def test_getAllianceKey(ride_alliance_forger):
    assert ride_alliance_forger.getAllianceKey(name, symbol) == alliance_key


def test_getSalt(ride_alliance_forger):
    tx = ride_alliance_forger.ssCount_(count)
    tx.wait(1)

    assert ride_alliance_forger.getSalt(name, symbol) == salt


def test_forge_revert(ride_alliance_forger, ride_token, ride_hub, person2):
    tx = ride_alliance_forger.ssAllianceKeyToAlliance_(alliance_key, person2.address)
    tx.wait(1)

    with brownie.reverts("RideAllianceForger: alliance exists!"):
        ride_alliance_forger.forge(
            ride_token, name, symbol, 1, ride_hub[0].address, 5, 5, 0, 4
        )


def test_forge(ride_alliance_forger, ride_token, ride_hub):
    assert ride_alliance_forger.sCount_() == 0
    assert (
        ride_alliance_forger.sAllianceKeyToAlliance_(alliance_key) == utils.ZERO_ADDRESS
    )
    assert (
        ride_alliance_forger.sAllianceKeyToAllianceTimelock_(alliance_key)
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_alliance_forger.sAllianceKeyToAllianceGovernor_(alliance_key)
        == utils.ZERO_ADDRESS
    )

    tx = ride_alliance_forger.forge(
        ride_token, name, symbol, 1, ride_hub[0].address, 5, 5, 0, 4
    )
    tx.wait(1)

    assert ride_alliance_forger.sCount_() == 1
    assert (
        ride_alliance_forger.sAllianceKeyToAlliance_(alliance_key) != utils.ZERO_ADDRESS
    )
    assert (
        ride_alliance_forger.sAllianceKeyToAllianceTimelock_(alliance_key)
        != utils.ZERO_ADDRESS
    )
    assert (
        ride_alliance_forger.sAllianceKeyToAllianceGovernor_(alliance_key)
        != utils.ZERO_ADDRESS
    )


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_forge(ride_alliance_forger, ride_token, ride_hub, deployer):
    tx = ride_alliance_forger.forge(
        ride_token, name, symbol, 1, ride_hub[0].address, 5, 5, 0, 4
    )
    tx.wait(1)

    assert tx.events["AllianceForged"]["sender"] == deployer
    assert tx.events["AllianceForged"]["allianceKey"] == alliance_key
    assert tx.events["AllianceForged"]["alliance"] == ride_alliance_forger.getAlliance(
        alliance_key
    )
    assert tx.events["AllianceForged"][
        "timelock"
    ] == ride_alliance_forger.getAllianceTimelock(alliance_key)
    assert tx.events["AllianceForged"][
        "governor"
    ] == ride_alliance_forger.getAllianceGovernor(alliance_key)


def test_getAlliance(ride_alliance_forger, ride_token, ride_hub):
    tx = ride_alliance_forger.forge(
        ride_token, name, symbol, 1, ride_hub[0].address, 5, 5, 0, 4
    )
    tx.wait(1)

    assert ride_alliance_forger.sAllianceKeyToAlliance_(
        alliance_key
    ) == ride_alliance_forger.getAlliance(alliance_key)


def test_getAllianceTimelock(ride_alliance_forger, ride_token, ride_hub):
    tx = ride_alliance_forger.forge(
        ride_token, name, symbol, 1, ride_hub[0].address, 5, 5, 0, 4
    )
    tx.wait(1)

    assert ride_alliance_forger.sAllianceKeyToAllianceTimelock_(
        alliance_key
    ) == ride_alliance_forger.getAllianceTimelock(alliance_key)


def test_getAllianceGovernor(ride_alliance_forger, ride_token, ride_hub):
    tx = ride_alliance_forger.forge(
        ride_token, name, symbol, 1, ride_hub[0].address, 5, 5, 0, 4
    )
    tx.wait(1)

    assert ride_alliance_forger.sAllianceKeyToAllianceGovernor_(
        alliance_key
    ) == ride_alliance_forger.getAllianceGovernor(alliance_key)


def test_governor_name(
    ride_token, ride_hub, ride_alliance_forger, RideAllianceGovernor, deployer
):
    tx = ride_alliance_forger.forge(
        ride_token, name, symbol, 1, ride_hub[0].address, 5, 5, 0, 4
    )
    tx.wait(1)

    ride_alliance_governor = brownie.Contract.from_abi(
        "RideAllianceGovernor",
        ride_alliance_forger.getAllianceGovernor(alliance_key),
        RideAllianceGovernor.abi,
        deployer,
    )

    assert ride_alliance_governor.name() == name + "Governor"
