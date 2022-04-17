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


def test_requireCurrencySupported_revert(ride_currency_registry):
    with brownie.reverts("RideLibCurrencyRegistry: Currency not supported"):
        ride_currency_registry.requireCurrencySupported_(key_MYR)


def test_requireCurrencySupported_pass(ride_currency_registry, deployer):
    tx = ride_currency_registry.ssCurrencyKeyToSupported_(
        key_MYR, True, {"from": deployer}
    )
    tx.wait(1)

    assert ride_currency_registry.requireCurrencySupported_(key_MYR)


def test_requireIsCrypto_revert(ride_currency_registry):
    with brownie.reverts("RideLibCurrencyRegistry: Not crypto"):
        ride_currency_registry.requireIsCrypto_(key_ETH)


def test_requireIsCrypto_pass(ride_currency_registry, deployer):
    tx = ride_currency_registry.ssCurrencyKeyToCrypto_(
        key_ETH, True, {"from": deployer}
    )
    tx.wait(1)

    assert ride_currency_registry.requireIsCrypto_(key_ETH)


def test_register(ride_currency_registry, deployer):
    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)

    tx = ride_currency_registry.register_(key_MYR, {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)


def test_encode_code(ride_currency_registry):
    assert ride_currency_registry.encode_code_("MYR") == key_MYR


def test_encode_token(ride_currency_registry):
    assert ride_currency_registry.encode_token_(token_ETH) == key_ETH


def test_registerFiat_revert(ride_currency_registry, deployer):
    with brownie.reverts("RideLibCurrencyRegistry: Empty code string"):
        ride_currency_registry.registerFiat_("", {"from": deployer})


def test_registerFiat(ride_currency_registry, deployer):
    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)

    tx = ride_currency_registry.registerFiat_("MYR", {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)


def test_registerCrypto_revert(ride_currency_registry, deployer):
    with brownie.reverts("RideLibCurrencyRegistry: Zero token address"):
        ride_currency_registry.registerCrypto_(utils.ZERO_ADDRESS, {"from": deployer})


def test_registerCrypto(ride_currency_registry, deployer):
    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)

    tx = ride_currency_registry.registerCrypto_(token_ETH, {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)


def test_removeCurrency_fiat(ride_currency_registry, deployer):
    tx = ride_currency_registry.registerFiat_("MYR", {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)

    tx = ride_currency_registry.removeCurrency_(key_MYR, {"from": deployer})
    tx.wait(1)

    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_MYR)


def test_removeCurrency_crypto(ride_currency_registry, deployer):
    tx = ride_currency_registry.registerCrypto_(token_ETH, {"from": deployer})
    tx.wait(1)

    assert ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)
    assert ride_currency_registry.sCurrencyKeyToCrypto_(key_ETH)

    tx = ride_currency_registry.removeCurrency_(key_ETH, {"from": deployer})
    tx.wait(1)

    assert not ride_currency_registry.sCurrencyKeyToSupported_(key_ETH)
    assert not ride_currency_registry.sCurrencyKeyToCrypto_(key_ETH)
