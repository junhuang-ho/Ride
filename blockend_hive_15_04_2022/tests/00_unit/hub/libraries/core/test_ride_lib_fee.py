import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils

key_MYR = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["MYR"]).hex()]
    )
)  # Solidity equivalent: keccak256(abi.encode(_code))


@pytest.fixture(scope="module", autouse=True)
def ride_fee(ride_hub, RideTestFee, Contract, deployer):
    yield Contract.from_abi(
        "RideTestFee", ride_hub[0].address, RideTestFee.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_currency_registry(ride_hub, RideTestCurrencyRegistry, Contract, deployer):
    yield Contract.from_abi(
        "RideTestCurrencyRegistry",
        ride_hub[0].address,
        RideTestCurrencyRegistry.abi,
        deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_access_control(ride_hub, RideTestAccessControl, Contract, deployer):
    yield Contract.from_abi(
        "RideTestAccessControl",
        ride_hub[0].address,
        RideTestAccessControl.abi,
        deployer,
    )


def setup_currency_suppport(ride_currency_registry, ride_access_control, deployer):
    tx = ride_currency_registry.ssCurrencyKeyToSupported_(key_MYR, True)
    tx.wait(1)

    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_setCancellationFee(
    ride_fee, ride_currency_registry, ride_access_control, deployer
):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    assert ride_fee.sCurrencyKeyToCancellationFee_(deployer, key_MYR) == 0

    tx = ride_fee.setCancellationFee_(key_MYR, 3, {"from": deployer})
    tx.wait(1)

    assert ride_fee.sCurrencyKeyToCancellationFee_(deployer, key_MYR) == 3


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setCancellationFee_event(
    ride_fee, ride_currency_registry, ride_access_control, deployer
):
    setup_currency_suppport(ride_currency_registry, ride_access_control)

    tx = ride_fee.setCancellationFee_(key_MYR, 3, {"from": deployer})
    tx.wait(1)

    assert tx.events["FeeSetCancellation"]["sender"] == deployer
    assert tx.events["FeeSetCancellation"]["fee"] == 3


def test_setBaseFee(ride_fee, ride_currency_registry, ride_access_control, deployer):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    assert ride_fee.sCurrencyKeyToBaseFee_(deployer, key_MYR) == 0

    tx = ride_fee.setBaseFee_(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.sCurrencyKeyToBaseFee_(deployer, key_MYR) == 3


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setBaseFee_event(
    ride_fee, ride_currency_registry, ride_access_control, deployer
):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    tx = ride_fee.setBaseFee_(key_MYR, 3)
    tx.wait(1)

    assert tx.events["FeeSetBase"]["sender"] == deployer
    assert tx.events["FeeSetBase"]["fee"] == 3


def test_setCostPerMinute(
    ride_fee, ride_currency_registry, ride_access_control, deployer
):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    assert ride_fee.sCurrencyKeyToCostPerMinute_(deployer, key_MYR) == 0

    tx = ride_fee.setCostPerMinute_(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.sCurrencyKeyToCostPerMinute_(deployer, key_MYR) == 3


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setCostPerMinute_event(
    ride_fee, ride_currency_registry, ride_access_control, deployer
):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    tx = ride_fee.setCostPerMinute_(key_MYR, 3)
    tx.wait(1)

    assert tx.events["FeeSetCostPerMinute"]["sender"] == deployer
    assert tx.events["FeeSetCostPerMinute"]["fee"] == 3


def test_setCostPerMetre(
    ride_fee, ride_currency_registry, ride_access_control, deployer
):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(deployer, key_MYR) == 0

    tx = ride_fee.setCostPerMetre_(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(deployer, key_MYR) == 3


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setCostPerMetre_event(
    ride_fee, ride_currency_registry, ride_access_control, deployer
):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    tx = ride_fee.setCostPerMetre_(key_MYR, 3)
    tx.wait(1)

    assert tx.events["FeeSetCostPerMetre"]["sender"] == deployer
    assert tx.events["FeeSetCostPerMetre"]["fee"] == 3


def test_getFare(ride_fee, ride_currency_registry, ride_access_control, deployer):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    base_fee = 1
    cost_per_minute = 2
    cost_per_metres = 2
    minutes_taken = 2
    metres_travelled = 2
    fare = (
        base_fee
        + (cost_per_minute * minutes_taken)
        + (cost_per_metres * metres_travelled)
    )

    tx = ride_fee.setBaseFee_(key_MYR, base_fee)
    tx.wait(1)

    tx = ride_fee.setCostPerMinute_(key_MYR, cost_per_minute)
    tx.wait(1)

    tx = ride_fee.setCostPerMetre_(key_MYR, cost_per_metres)
    tx.wait(1)

    assert ride_fee.getFare_(deployer, key_MYR, minutes_taken, metres_travelled) == fare


def test_getCancellationFee(
    ride_fee, ride_currency_registry, ride_access_control, deployer
):
    setup_currency_suppport(ride_currency_registry, ride_access_control, deployer)

    tx = ride_fee.setCancellationFee_(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.getCancellationFee_(deployer, key_MYR) == 3
