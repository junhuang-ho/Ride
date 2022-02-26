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


def setup_currency_suppport(ride_currency_registry):
    tx = ride_currency_registry.ssCurrencyKeyToSupported_(key_MYR, True)
    tx.wait(1)


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_setCancellationFee(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    assert ride_fee.sCurrencyKeyToCancellationFee_(key_MYR) == 0

    tx = ride_fee.setCancellationFee(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.sCurrencyKeyToCancellationFee_(key_MYR) == 3


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setCancellationFee_event(ride_fee, ride_currency_registry, deployer):
    setup_currency_suppport(ride_currency_registry)

    tx = ride_fee.setCancellationFee(key_MYR, 3)
    tx.wait(1)

    assert tx.events["FeeSetCancellation"]["sender"] == deployer
    assert tx.events["FeeSetCancellation"]["fee"] == 3


def test_setBaseFee(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    assert ride_fee.sCurrencyKeyToBaseFee_(key_MYR) == 0

    tx = ride_fee.setBaseFee(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.sCurrencyKeyToBaseFee_(key_MYR) == 3


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setBaseFee_event(ride_fee, ride_currency_registry, deployer):
    setup_currency_suppport(ride_currency_registry)

    tx = ride_fee.setBaseFee(key_MYR, 3)
    tx.wait(1)

    assert tx.events["FeeSetBase"]["sender"] == deployer
    assert tx.events["FeeSetBase"]["fee"] == 3


def test_setCostPerMinute(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    assert ride_fee.sCurrencyKeyToCostPerMinute_(key_MYR) == 0

    tx = ride_fee.setCostPerMinute(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.sCurrencyKeyToCostPerMinute_(key_MYR) == 3


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setCostPerMinute_event(ride_fee, ride_currency_registry, deployer):
    setup_currency_suppport(ride_currency_registry)

    tx = ride_fee.setCostPerMinute(key_MYR, 3)
    tx.wait(1)

    assert tx.events["FeeSetCostPerMinute"]["sender"] == deployer
    assert tx.events["FeeSetCostPerMinute"]["fee"] == 3


def test_setCostPerMetre_revert(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    with brownie.reverts("RideLibFee: Input length must be equal RideBadge.Badges"):
        ride_fee.setCostPerMetre(key_MYR, [1, 2, 3, 4, 5])

    with brownie.reverts("RideLibFee: Input length must be equal RideBadge.Badges"):
        ride_fee.setCostPerMetre(key_MYR, [1, 2, 3, 4, 5, 6, 7])


def test_setCostPerMetre(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 0) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 1) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 2) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 3) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 4) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 5) == 0

    tx = ride_fee.setCostPerMetre(key_MYR, [1, 2, 3, 4, 5, 6])
    tx.wait(1)

    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 0) == 1
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 1) == 2
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 2) == 3
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 3) == 4
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 4) == 5
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 5) == 6


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setCostPerMetre_event(ride_fee, ride_currency_registry, deployer):
    setup_currency_suppport(ride_currency_registry)

    tx = ride_fee.setCostPerMetre(key_MYR, [1, 2, 3, 4, 5, 6])
    tx.wait(1)

    assert tx.events["FeeSetCostPerMetre"]["sender"] == deployer
    assert tx.events["FeeSetCostPerMetre"]["fee"] == [1, 2, 3, 4, 5, 6]


def test_getFare(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    base_fee = 1
    cost_per_minute = 2
    badges_cost_per_metres = [1, 2, 3, 4, 5, 6]
    minutes_taken = 2
    metres_travelled = 2
    fare = (
        base_fee
        + (cost_per_minute * minutes_taken)
        + (badges_cost_per_metres[1] * metres_travelled)
    )

    tx = ride_fee.setBaseFee(key_MYR, base_fee)
    tx.wait(1)

    tx = ride_fee.setCostPerMinute(key_MYR, cost_per_minute)
    tx.wait(1)

    tx = ride_fee.setCostPerMetre(key_MYR, badges_cost_per_metres)
    tx.wait(1)

    assert ride_fee.getFare_(key_MYR, 1, minutes_taken, metres_travelled) == fare


def test_getCancellationFee(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    tx = ride_fee.setCancellationFee(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.getCancellationFee_(key_MYR) == 3


def test_getBaseFee(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    tx = ride_fee.setBaseFee(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.getBaseFee(key_MYR) == 3


def test_getCostPerMinute(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    tx = ride_fee.setCostPerMinute(key_MYR, 3)
    tx.wait(1)

    assert ride_fee.getCostPerMinute(key_MYR) == 3


def test_getCostPerMetre(ride_fee, ride_currency_registry):
    setup_currency_suppport(ride_currency_registry)

    tx = ride_fee.setCostPerMetre(key_MYR, [1, 2, 3, 4, 5, 6])
    tx.wait(1)

    assert ride_fee.getCostPerMetre(key_MYR, 0) == 1
    assert ride_fee.getCostPerMetre(key_MYR, 1) == 2
    assert ride_fee.getCostPerMetre(key_MYR, 2) == 3
    assert ride_fee.getCostPerMetre(key_MYR, 3) == 4
    assert ride_fee.getCostPerMetre(key_MYR, 4) == 5
    assert ride_fee.getCostPerMetre(key_MYR, 5) == 6
