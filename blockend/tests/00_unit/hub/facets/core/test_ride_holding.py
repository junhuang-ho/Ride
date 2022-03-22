import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_holding(ride_hub, RideTestHolding, Contract, deployer):
    yield Contract.from_abi(
        "RideTestHolding", ride_hub[0].address, RideTestHolding.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_currency_registry(ride_hub, RideTestCurrencyRegistry, Contract, deployer):
    yield Contract.from_abi(
        "RideTestCurrencyRegistry",
        ride_hub[0].address,
        RideTestCurrencyRegistry.abi,
        deployer,
    )


def setup_WETH(dWETH9):
    key_WETH = utils.pad_address_right(
        dWETH9.address
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    return key_WETH


def setup_currency_support(ride_currency_registry, key_WETH):
    tx = ride_currency_registry.ssCurrencyKeyToSupported_(key_WETH, True)
    tx.wait(1)

    tx = ride_currency_registry.ssCurrencyKeyToCrypto_(key_WETH, True)
    tx.wait(1)


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_depositTokens_revert(ride_holding, ride_currency_registry, dWETH9):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    with brownie.reverts("RideHolding: Zero amount"):
        ride_holding.depositTokens(key_WETH, 0)


def test_depositTokens_revert_if_token_not_approved(
    ride_holding, ride_currency_registry, dWETH9, deployer
):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    assert dWETH9.balanceOf(deployer) == 0

    tx = deployer.transfer(dWETH9.address, "1 ether")
    tx.wait(1)

    assert dWETH9.balanceOf(deployer) == "1 ether"

    with brownie.reverts():
        ride_holding.depositTokens(key_WETH, 100)


def test_depositTokens(ride_holding, ride_currency_registry, dWETH9, deployer):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    assert dWETH9.balanceOf(deployer) == 0

    tx = deployer.transfer(dWETH9.address, "1 ether")
    tx.wait(1)

    assert dWETH9.balanceOf(deployer) == "1 ether"

    assert dWETH9.allowance(deployer, ride_holding.address) == 0

    tx = dWETH9.approve(ride_holding.address, "1 ether")
    tx.wait(1)

    assert dWETH9.allowance(deployer, ride_holding.address) == "1 ether"

    assert ride_holding.sUserToCurrencyKeyToHolding_(deployer, key_WETH) == 0

    tx = ride_holding.depositTokens(key_WETH, "1 ether")
    tx.wait(1)

    assert ride_holding.sUserToCurrencyKeyToHolding_(deployer, key_WETH) == "1 ether"


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_depositTokens_event(ride_holding, ride_currency_registry, dWETH9, deployer):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    tx = deployer.transfer(dWETH9.address, "1 ether")
    tx.wait(1)

    tx = dWETH9.approve(ride_holding.address, "1 ether")
    tx.wait(1)

    tx = ride_holding.depositTokens(key_WETH, "1 ether")
    tx.wait(1)

    assert tx.events["TokensDeposited"]["sender"] == deployer
    assert tx.events["TokensDeposited"]["amount"] == "1 ether"


def test_depositTokensPermit_revert(ride_holding, ride_currency_registry, dWETH9):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    with brownie.reverts("RideHolding: Zero amount"):
        ride_holding.depositTokensPermit(
            key_WETH, 0, 123, 2, utils.ZERO_BYTES32, utils.ZERO_BYTES32
        )


@pytest.mark.skip(reason="require permit type token")
def test_depositTokensPermit():
    pass


@pytest.mark.skip(reason="require implement test_depositTokensPermit")
def test_depositTokensPermit_event():
    pass


def test_withdrawTokens_require_1_revert(ride_holding, ride_currency_registry, dWETH9):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    with brownie.reverts("RideHolding: Zero amount"):
        ride_holding.withdrawTokens(key_WETH, 0)


def test_withdrawTokens_require_2_revert(ride_holding, ride_currency_registry, dWETH9):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    with brownie.reverts("RideHolding: Insufficient holdings"):
        ride_holding.withdrawTokens(key_WETH, "1 ether")


def test_withdrawTokens(ride_holding, ride_currency_registry, dWETH9, deployer):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    test_depositTokens(ride_holding, ride_currency_registry, dWETH9, deployer)

    assert dWETH9.balanceOf(deployer) == 0

    tx = ride_holding.withdrawTokens(key_WETH, "1 ether")
    tx.wait(1)

    assert ride_holding.sUserToCurrencyKeyToHolding_(deployer, key_WETH) == 0
    assert dWETH9.balanceOf(deployer) == "1 ether"


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_withdrawTokens_event(ride_holding, ride_currency_registry, dWETH9, deployer):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    test_depositTokens(ride_holding, ride_currency_registry, dWETH9, deployer)

    tx = ride_holding.withdrawTokens(key_WETH, "1 ether")
    tx.wait(1)

    assert tx.events["TokensRemoved"]["sender"] == deployer
    assert tx.events["TokensRemoved"]["amount"] == "1 ether"


def test_getHolding(ride_holding, ride_currency_registry, dWETH9, deployer):
    key_WETH = setup_WETH(dWETH9)
    setup_currency_support(ride_currency_registry, key_WETH)

    test_depositTokens(ride_holding, ride_currency_registry, dWETH9, deployer)

    assert ride_holding.getHolding(deployer, key_WETH) == "1 ether"
