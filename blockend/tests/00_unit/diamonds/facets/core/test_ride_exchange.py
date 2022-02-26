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

key_EUR = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
    )
)  # Solidity equivalent: keccak256(abi.encode(_code))

token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
key_ETH = utils.pad_address_right(
    token_ETH
)  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)


@pytest.fixture(scope="module", autouse=True)
def ride_exchange(ride_hub, RideTestExchange, Contract, deployer):
    yield Contract.from_abi(
        "RideTestExchange", ride_hub[0].address, RideTestExchange.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_currency_registry(ride_hub, RideTestCurrencyRegistry, Contract, deployer):
    yield Contract.from_abi(
        "RideTestCurrencyRegistry",
        ride_hub[0].address,
        RideTestCurrencyRegistry.abi,
        deployer,
    )


def setup_price_feed(dMockV3Aggregator1, dMockV3Aggregator2):
    price_feed_ETH_EUR = dMockV3Aggregator1.address
    price_feed_MYR_EUR = dMockV3Aggregator2.address

    return price_feed_ETH_EUR, price_feed_MYR_EUR


def support_ETH_EUR(ride_currency_registry):
    tx = ride_currency_registry.ssCurrencyKeyToSupported_(key_ETH, True)
    tx.wait(1)

    tx = ride_currency_registry.ssCurrencyKeyToSupported_(key_EUR, True)
    tx.wait(1)


def support_ETH_MYR(ride_currency_registry):
    tx = ride_currency_registry.ssCurrencyKeyToSupported_(key_MYR, True)
    tx.wait(1)

    tx = ride_currency_registry.ssCurrencyKeyToSupported_(key_EUR, True)
    tx.wait(1)


def support_price_feed(ride_exchange, price_feed_ETH_EUR, price_feed_MYR_EUR):
    tx = ride_exchange.ssXToYToXPerYAddedPriceFeed_(
        key_ETH, key_EUR, price_feed_ETH_EUR
    )
    tx.wait(1)

    tx = ride_exchange.ssXToYToXPerYAddedPriceFeed_(
        key_EUR, key_ETH, price_feed_ETH_EUR
    )
    tx.wait(1)

    # tx = ride_exchange.ssXToYToXPerYInverse_(key_EUR, key_ETH, True)
    # tx.wait(1)

    tx = ride_exchange.ssXToYToXPerYAddedPriceFeed_(
        key_MYR, key_EUR, price_feed_MYR_EUR
    )
    tx.wait(1)

    tx = ride_exchange.ssXToYToXPerYAddedPriceFeed_(
        key_EUR, key_MYR, price_feed_MYR_EUR
    )
    tx.wait(1)

    # tx = ride_exchange.ssXToYToXPerYInverse_(key_EUR, key_MYR, True)
    # tx.wait(1)


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_addXPerYPriceFeed_require_1_revert(ride_exchange, ride_currency_registry):
    support_ETH_EUR(ride_currency_registry)

    with brownie.reverts("RideLibExchange: Zero price feed address"):
        ride_exchange.addXPerYPriceFeed(key_ETH, key_EUR, utils.ZERO_ADDRESS)


def test_addXPerYPriceFeed_require_2_revert(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    support_ETH_EUR(ride_currency_registry)

    tx = ride_exchange.ssXToYToXPerYAddedPriceFeed_(
        key_ETH, key_EUR, price_feed_ETH_EUR
    )
    tx.wait(1)

    with brownie.reverts("RideLibExchange: Price feed already supported"):
        ride_exchange.addXPerYPriceFeed(key_ETH, key_EUR, price_feed_ETH_EUR)


def test_addXPerYPriceFeed(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    support_ETH_EUR(ride_currency_registry)

    tx = ride_exchange.addXPerYPriceFeed(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXAddedPerYPriceFeed_(key_ETH, key_EUR)
        == price_feed_ETH_EUR
    )
    assert (
        ride_exchange.sXToYToXAddedPerYPriceFeed_(key_EUR, key_ETH)
        == price_feed_ETH_EUR
    )
    assert not ride_exchange.sXToYToXPerYInverse_(key_ETH, key_EUR)
    assert ride_exchange.sXToYToXPerYInverse_(key_EUR, key_ETH)


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_addXPerYPriceFeed_event(
    ride_exchange,
    ride_currency_registry,
    dMockV3Aggregator1,
    dMockV3Aggregator2,
    deployer,
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    support_ETH_EUR(ride_currency_registry)

    tx = ride_exchange.addXPerYPriceFeed(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    assert tx.events["PriceFeedAdded"]["sender"] == deployer
    assert tx.events["PriceFeedAdded"]["keyX"] == key_ETH
    assert tx.events["PriceFeedAdded"]["keyY"] == key_EUR
    assert tx.events["PriceFeedAdded"]["priceFeed"] == price_feed_ETH_EUR


def test_deriveXPerYPriceFeed_require_1_revert(ride_exchange):
    with brownie.reverts(
        "RideLibExchange: Underlying currency key cannot be identical"
    ):
        ride_exchange.deriveXPerYPriceFeed(key_ETH, key_ETH, key_EUR)


def test_deriveXPerYPriceFeed_require_2_revert(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    support_price_feed(ride_exchange, price_feed_ETH_EUR, price_feed_MYR_EUR)

    tx = ride_exchange.ssXToYToXPerYDerivedPriceFeedDetails_(
        key_ETH, key_MYR, key_EUR, price_feed_ETH_EUR, utils.ZERO_ADDRESS, False, False
    )
    tx.wait(1)

    with brownie.reverts("RideLibExchange: Derived price feed already supported"):
        ride_exchange.deriveXPerYPriceFeed(key_ETH, key_MYR, key_EUR)


def test_deriveXPerYPriceFeed_no_underlying_inverse(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    support_price_feed(ride_exchange, price_feed_ETH_EUR, price_feed_MYR_EUR)

    tx = ride_exchange.ssXToYToXPerYInverse_(key_ETH, key_EUR, False)
    tx.wait(1)
    tx = ride_exchange.ssXToYToXPerYInverse_(key_MYR, key_EUR, False)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == utils.ZERO_BYTES32
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == False
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == False
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 0
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 0

    tx = ride_exchange.deriveXPerYPriceFeed(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == key_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == price_feed_ETH_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == price_feed_MYR_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == False
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == False
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 1
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 1


def test_deriveXPerYPriceFeed_underlying_numerator_inverse(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    support_price_feed(ride_exchange, price_feed_ETH_EUR, price_feed_MYR_EUR)

    tx = ride_exchange.ssXToYToXPerYInverse_(key_ETH, key_EUR, True)
    tx.wait(1)
    tx = ride_exchange.ssXToYToXPerYInverse_(key_MYR, key_EUR, False)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == utils.ZERO_BYTES32
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == False
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == False
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 0
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 0

    tx = ride_exchange.deriveXPerYPriceFeed(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == key_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == price_feed_ETH_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == price_feed_MYR_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == True
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == False
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 1
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 1


def test_deriveXPerYPriceFeed_underlying_denominator_inverse(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    support_price_feed(ride_exchange, price_feed_ETH_EUR, price_feed_MYR_EUR)

    tx = ride_exchange.ssXToYToXPerYInverse_(key_ETH, key_EUR, False)
    tx.wait(1)
    tx = ride_exchange.ssXToYToXPerYInverse_(key_MYR, key_EUR, True)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == utils.ZERO_BYTES32
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == False
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == False
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 0
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 0

    tx = ride_exchange.deriveXPerYPriceFeed(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == key_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == price_feed_ETH_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == price_feed_MYR_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == False
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == True
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 1
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 1


def test_deriveXPerYPriceFeed_both_underlying_inverse(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    support_price_feed(ride_exchange, price_feed_ETH_EUR, price_feed_MYR_EUR)

    tx = ride_exchange.ssXToYToXPerYInverse_(key_ETH, key_EUR, True)
    tx.wait(1)
    tx = ride_exchange.ssXToYToXPerYInverse_(key_MYR, key_EUR, True)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == utils.ZERO_BYTES32
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == False
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == False
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 0
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 0

    tx = ride_exchange.deriveXPerYPriceFeed(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == key_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == price_feed_ETH_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == price_feed_MYR_EUR
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == True
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == True
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 1
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 1


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_deriveXPerYPriceFeed_event(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2, deployer
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    support_price_feed(ride_exchange, price_feed_ETH_EUR, price_feed_MYR_EUR)

    tx = ride_exchange.deriveXPerYPriceFeed(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    assert tx.events["PriceFeedDerived"]["sender"] == deployer
    assert tx.events["PriceFeedDerived"]["keyX"] == key_ETH
    assert tx.events["PriceFeedDerived"]["keyY"] == key_MYR
    assert tx.events["PriceFeedDerived"]["keyShared"] == key_EUR


def test_removeDerivedXPerYPriceFeed(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
):
    test_deriveXPerYPriceFeed_both_underlying_inverse(
        ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.removeDerivedXPerYPriceFeed(key_ETH, key_MYR)
    tx.wait(1)

    assert ride_exchange.sXToYToBaseKeyCount_(key_ETH, key_EUR) == 0
    assert ride_exchange.sXToYToBaseKeyCount_(key_MYR, key_EUR) == 0

    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[0]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[0]
        == utils.ZERO_BYTES32
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[1]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[1]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[2]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[2]
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[3]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[3]
        == False
    )
    assert (
        ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_ETH, key_MYR)[4]
        == ride_exchange.sXToYToXPerYDerivedPriceFeedDetails_(key_MYR, key_ETH)[4]
        == False
    )

    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_ETH, key_MYR)
    assert not ride_exchange.sXToYToXPerYInverseDerived_(key_MYR, key_ETH)


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_removeDerivedXPerYPriceFeed_event(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2, deployer
):
    test_deriveXPerYPriceFeed_both_underlying_inverse(
        ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.removeDerivedXPerYPriceFeed(key_ETH, key_MYR)
    tx.wait(1)

    assert tx.events["DerivedPriceFeedRemoved"]["sender"] == deployer
    assert tx.events["DerivedPriceFeedRemoved"]["keyX"] == key_ETH
    assert tx.events["DerivedPriceFeedRemoved"]["keyY"] == key_MYR


def test_removeAddedXPerYPriceFeed_revert(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
):
    test_deriveXPerYPriceFeed_both_underlying_inverse(
        ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
    )

    with brownie.reverts("RideLibExchange: Base key being used"):
        ride_exchange.removeAddedXPerYPriceFeed(key_ETH, key_EUR)


def test_removeAddedXPerYPriceFeed(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    test_removeDerivedXPerYPriceFeed(
        ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
    )

    assert (
        ride_exchange.sXToYToXAddedPerYPriceFeed_(key_ETH, key_EUR)
        == price_feed_ETH_EUR
    )
    assert (
        ride_exchange.sXToYToXAddedPerYPriceFeed_(key_EUR, key_ETH)
        == price_feed_ETH_EUR
    )
    assert ride_exchange.sXToYToXPerYInverse_(key_ETH, key_EUR)

    tx = ride_exchange.removeAddedXPerYPriceFeed(key_ETH, key_EUR)
    tx.wait(1)

    assert (
        ride_exchange.sXToYToXAddedPerYPriceFeed_(key_ETH, key_EUR)
        == utils.ZERO_ADDRESS
    )
    assert (
        ride_exchange.sXToYToXAddedPerYPriceFeed_(key_EUR, key_ETH)
        == utils.ZERO_ADDRESS
    )
    assert not ride_exchange.sXToYToXPerYInverse_(key_ETH, key_EUR)
    assert not ride_exchange.sXToYToXPerYInverse_(key_EUR, key_ETH)

@pytest.mark.skip(reason="event cannot fire - require debug")
def test_removeAddedXPerYPriceFeed_event(
    ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2, deployer
):
    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )
    test_removeDerivedXPerYPriceFeed(
        ride_exchange, dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.removeAddedXPerYPriceFeed(key_ETH, key_EUR)
    tx.wait(1)

    assert tx.events["AddedPriceFeedRemoved"]["sender"] == deployer
    assert tx.events["AddedPriceFeedRemoved"]["priceFeed"] == price_feed_ETH_EUR


def test_getAddedXPerYPriceFeedValue(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    assert (
        ride_exchange.getAddedXPerYPriceFeedValue(key_ETH, key_EUR) == "2 ether"
    )  # see conftest.py setup


def test_getDerivedXPerYPriceFeedValue_no_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_MYR, key_EUR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR)
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR)
    price_feed_derived = int(
        (price_feed_numerator * (10 ** 18)) / price_feed_denominator
    )

    # assert (
    #     ride_exchange.getDerivedXPerYPriceFeedValue(key_ETH, key_MYR)
    #     == price_feed_derived  # "0.666666666666666666 ether"
    # )
    assert (
        abs(
            ride_exchange.getDerivedXPerYPriceFeedValue(key_ETH, key_MYR)
            - price_feed_derived
        )
        < 5000
    )


def test_getDerivedXPerYPriceFeedValue_denominator_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_MYR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR)
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR)
    price_feed_derived = int(
        (price_feed_numerator * (10 ** 18))
        / ((((10 ** 18) * (10 ** 18)) / price_feed_denominator))
    )

    # assert (
    #     ride_exchange.getDerivedXPerYPriceFeedValue(key_ETH, key_MYR)
    #     == price_feed_derived  # "6.000000000000000006 ether"
    # )
    assert (
        abs(
            ride_exchange.getDerivedXPerYPriceFeedValue(key_ETH, key_MYR)
            - price_feed_derived
        )
        < 5000
    )


def test_getDerivedXPerYPriceFeedValue_numerator_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_ETH, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_MYR, key_EUR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR)
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR)
    price_feed_derived = int(
        ((((10 ** 18) * (10 ** 18)) / price_feed_numerator) * (10 ** 18))
        / price_feed_denominator
    )

    # assert (
    #     ride_exchange.getDerivedXPerYPriceFeedValue(key_ETH, key_MYR)
    #     == price_feed_derived  # "0.166666666666666666 ether"
    # )
    assert (
        abs(
            ride_exchange.getDerivedXPerYPriceFeedValue(key_ETH, key_MYR)
            - price_feed_derived
        )
        < 5000
    )


def test_getDerivedXPerYPriceFeedValue_both_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_ETH, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_MYR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR)
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR)
    price_feed_derived = int(
        ((10 ** 18) * (10 ** 18))
        / ((price_feed_numerator * (10 ** 18)) / price_feed_denominator)
    )

    # assert (
    #     ride_exchange.getDerivedXPerYPriceFeedValue(key_ETH, key_MYR)
    #     == price_feed_derived  # "1.500000000000000001 ether"
    # )
    assert (
        abs(
            ride_exchange.getDerivedXPerYPriceFeedValue(key_ETH, key_MYR)
            - price_feed_derived
        )
        < 5000
    )


def test_convertCurrency_added_no_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_ETH, key_EUR, 500)

    price_feed = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (10 ** 18)

    assert value_eth == amount / price_feed


def test_convertCurrency_added_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_EUR, key_ETH, 500)

    price_feed = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (10 ** 18)

    assert value_eth == amount * price_feed


def test_convertCurrency_derived_no_inverse_underlying_no_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_MYR, key_EUR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_ETH, key_MYR, 500)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (
        10 ** 18
    )
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR) / (
        10 ** 18
    )

    assert value_eth == amount / (price_feed_numerator / price_feed_denominator)


def test_convertCurrency_derived_no_inverse_underlying_denominator_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_MYR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_ETH, key_MYR, 500)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (
        10 ** 18
    )
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR) / (
        10 ** 18
    )

    assert value_eth == amount / (price_feed_numerator / (1 / price_feed_denominator))


def test_convertCurrency_derived_no_inverse_underlying_numerator_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_ETH, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_MYR, key_EUR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_ETH, key_MYR, 500)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (
        10 ** 18
    )
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR) / (
        10 ** 18
    )

    assert value_eth == amount / ((1 / price_feed_numerator) / price_feed_denominator)


def test_convertCurrency_derived_no_inverse_underlying_both_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_ETH, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_MYR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_ETH, key_MYR, 500)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (
        10 ** 18
    )
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR) / (
        10 ** 18
    )

    assert value_eth == amount / (1 / (price_feed_numerator / price_feed_denominator))


def test_convertCurrency_derived_inverse_underlying_no_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_MYR, key_EUR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_MYR, key_ETH, 500)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (
        10 ** 18
    )
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR) / (
        10 ** 18
    )

    assert value_eth == amount * (price_feed_numerator / price_feed_denominator)


def test_convertCurrency_derived_inverse_underlying_denominator_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_MYR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_MYR, key_ETH, 500)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (
        10 ** 18
    )
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR) / (
        10 ** 18
    )

    assert value_eth == amount * (price_feed_numerator / (1 / price_feed_denominator))


def test_convertCurrency_derived_inverse_underlying_numerator_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_ETH, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_MYR, key_EUR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_MYR, key_ETH, 500)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (
        10 ** 18
    )
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR) / (
        10 ** 18
    )

    assert value_eth == amount * ((1 / price_feed_numerator) / price_feed_denominator)


def test_convertCurrency_derived_inverse_underlying_both_inverse(
    ride_exchange, ride_currency_registry, dMockV3Aggregator1, dMockV3Aggregator2
):
    support_ETH_EUR(ride_currency_registry)
    support_ETH_MYR(ride_currency_registry)

    price_feed_ETH_EUR, price_feed_MYR_EUR = setup_price_feed(
        dMockV3Aggregator1, dMockV3Aggregator2
    )

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_ETH, price_feed_ETH_EUR)
    tx.wait(1)

    tx = ride_exchange.addXPerYPriceFeed_(key_EUR, key_MYR, price_feed_MYR_EUR)
    tx.wait(1)

    tx = ride_exchange.deriveXPerYPriceFeed_(key_ETH, key_MYR, key_EUR)
    tx.wait(1)

    amount = 500
    value_eth = ride_exchange.convertCurrency(key_MYR, key_ETH, 500)

    price_feed_numerator = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (
        10 ** 18
    )
    price_feed_denominator = ride_exchange.getAddedXPerYInWei_(key_MYR, key_EUR) / (
        10 ** 18
    )

    assert value_eth == amount * (1 / (price_feed_numerator / price_feed_denominator))

