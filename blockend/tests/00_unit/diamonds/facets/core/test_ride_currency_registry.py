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

token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
key_ETH = utils.pad_address_right(
    token_ETH
)  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

fee_cancellation = 5
fee_base = 3
fee_cost_per_minute = 4
fee_cost_per_metre_list = [1, 2, 3, 4, 5, 6]


@pytest.fixture(scope="module", autouse=True)
def ride_currency_registry(ride_hub, RideTestCurrencyRegistry, Contract, deployer):
    yield Contract.from_abi(
        "RideTestCurrencyRegistry",
        ride_hub[0].address,
        RideTestCurrencyRegistry.abi,
        deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_registerFiat_revert(ride_currency_registry, deployer):
    with brownie.reverts("RideLibCurrencyRegistry: Empty code string"):
        ride_currency_registry.registerFiat("", {"from": deployer})


def test_registerFiat(ride_currency_registry, deployer):
    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)

    tx = ride_currency_registry.registerFiat("MYR", {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)


def test_registerCrypto_revert(ride_currency_registry, deployer):
    with brownie.reverts("RideLibCurrencyRegistry: Zero token address"):
        ride_currency_registry.registerCrypto(utils.ZERO_ADDRESS, {"from": deployer})


def test_registerCrypto(ride_currency_registry, deployer):
    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)

    tx = ride_currency_registry.registerCrypto(token_ETH, {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)


def test_getKeyFiat(ride_currency_registry, deployer):
    tx = ride_currency_registry.registerFiat("MYR", {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.getKeyFiat("MYR") == key_MYR


def test_getKeyCrypto(ride_currency_registry, deployer):
    tx = ride_currency_registry.registerCrypto(token_ETH, {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.getKeyCrypto(token_ETH) == key_ETH


def test_removeCurrency_fiat(ride_currency_registry, deployer):
    tx = ride_currency_registry.registerFiat_("MYR", {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)

    tx = ride_currency_registry.removeCurrency(key_MYR, {"from": deployer})
    tx.wait(1)

    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)


def test_removeCurrency_crypto(ride_currency_registry, deployer):
    tx = ride_currency_registry.registerCrypto_(token_ETH, {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)
    assert ride_currency_registry.sCurrencyKeyToCrypto_(key_ETH)

    tx = ride_currency_registry.removeCurrency(key_ETH, {"from": deployer})
    tx.wait(1)

    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)
    assert not ride_currency_registry.sCurrencyKeyToCrypto_(key_ETH)


@pytest.fixture(scope="module", autouse=True)
def ride_fee(ride_hub, RideTestFee, Contract, deployer):
    yield Contract.from_abi(
        "RideTestFee", ride_hub[0].address, RideTestFee.abi, deployer,
    )


def test_setupFiatWithFee(ride_currency_registry, ride_fee):
    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)
    assert ride_fee.sCurrencyKeyToCancellationFee_(key_MYR) == 0
    assert ride_fee.sCurrencyKeyToBaseFee_(key_MYR) == 0
    assert ride_fee.sCurrencyKeyToCostPerMinute_(key_MYR) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 0) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 1) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 2) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 3) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 4) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 5) == 0

    tx = ride_currency_registry.setupFiatWithFee(
        "MYR", fee_cancellation, fee_base, fee_cost_per_minute, fee_cost_per_metre_list,
    )
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)
    assert ride_fee.sCurrencyKeyToCancellationFee_(key_MYR) == fee_cancellation
    assert ride_fee.sCurrencyKeyToBaseFee_(key_MYR) == fee_base
    assert ride_fee.sCurrencyKeyToCostPerMinute_(key_MYR) == fee_cost_per_minute
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 0)
        == fee_cost_per_metre_list[0]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 1)
        == fee_cost_per_metre_list[1]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 2)
        == fee_cost_per_metre_list[2]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 3)
        == fee_cost_per_metre_list[3]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 4)
        == fee_cost_per_metre_list[4]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 5)
        == fee_cost_per_metre_list[5]
    )


def setupCryptoWithFee(ride_currency_registry, ride_fee):
    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)
    assert ride_fee.sCurrencyKeyToCancellationFee_(key_ETH) == 0
    assert ride_fee.sCurrencyKeyToBaseFee_(key_ETH) == 0
    assert ride_fee.sCurrencyKeyToCostPerMinute_(key_ETH) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 0) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 1) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 2) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 3) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 4) == 0
    assert ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 5) == 0

    tx = ride_currency_registry.setupFiatWithFee(
        token_ETH,
        fee_cancellation,
        fee_base,
        fee_cost_per_minute,
        fee_cost_per_metre_list,
    )
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)
    assert ride_fee.sCurrencyKeyToCancellationFee_(key_ETH) == fee_cancellation
    assert ride_fee.sCurrencyKeyToBaseFee_(key_ETH) == fee_base
    assert ride_fee.sCurrencyKeyToCostPerMinute_(key_ETH) == fee_cost_per_minute
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 0)
        == fee_cost_per_metre_list[0]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 1)
        == fee_cost_per_metre_list[1]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 2)
        == fee_cost_per_metre_list[2]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 3)
        == fee_cost_per_metre_list[3]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_ETH, 4)
        == fee_cost_per_metre_list[4]
    )
    assert (
        ride_fee.sCurrencyKeyToBadgeToCostPerMetre_(key_MYR, 5)
        == fee_cost_per_metre_list[5]
    )

