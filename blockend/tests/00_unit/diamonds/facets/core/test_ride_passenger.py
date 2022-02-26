import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils


token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
chain = brownie.network.state.Chain()


@pytest.fixture(scope="module", autouse=True)
def ride_passenger(ride_hub, RideTestPassenger, Contract, deployer):
    yield Contract.from_abi(
        "RideTestPassenger", ride_hub[0].address, RideTestPassenger.abi, deployer,
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
def ride_fee(ride_hub, RideTestFee, Contract, deployer):
    yield Contract.from_abi(
        "RideTestFee", ride_hub[0].address, RideTestFee.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_exchange(ride_hub, RideTestExchange, Contract, deployer):
    yield Contract.from_abi(
        "RideTestExchange", ride_hub[0].address, RideTestExchange.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_holding(ride_hub, RideTestHolding, Contract, deployer):
    yield Contract.from_abi(
        "RideTestHolding", ride_hub[0].address, RideTestHolding.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_ticket(ride_hub, RideTestTicket, Contract, deployer):
    yield Contract.from_abi(
        "RideTestTicket", ride_hub[0].address, RideTestTicket.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_badge(ride_hub, RideTestBadge, Contract, deployer):
    yield Contract.from_abi(
        "RideTestBadge", ride_hub[0].address, RideTestBadge.abi, deployer
    )


def setup_currency_and_price_feed_support(
    ride_currency_registry, ride_exchange, dMockV3Aggregator1
):
    tx = ride_currency_registry.setupFiatWithFee(
        "EUR",
        "5 ether",
        "3 ether",
        "0.0001 ether",
        [
            "0.0010 ether",
            "0.0012 ether",
            "0.0014 ether",
            "0.0016 ether",
            "0.0017 ether",
            "0.0020 ether",
        ],
    )
    tx.wait(1)

    tx = ride_currency_registry.registerCrypto(token_ETH)
    tx.wait(1)

    key_ETH = ride_currency_registry.getKeyCrypto(token_ETH)
    key_EUR = ride_currency_registry.getKeyFiat("EUR")

    price_feed_ETH_EUR = dMockV3Aggregator1.address

    tx = ride_exchange.addXPerYPriceFeed(key_ETH, key_EUR, price_feed_ETH_EUR)
    tx.wait(1)

    return key_ETH, key_EUR


def setup_holding(ride_holding, key_ETH, deployer):
    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, "100 ether")
    tx.wait(1)


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_requestTicket_revert(
    ride_passenger,
    ride_currency_registry,
    ride_exchange,
    dMockV3Aggregator1,
    dMockV3Aggregator2,
):
    key_ETH, key_EUR = setup_currency_and_price_feed_support(
        ride_currency_registry, ride_exchange, dMockV3Aggregator1
    )

    with brownie.reverts(
        "RidePassenger: Passenger's holding < cancellationFee or fare"
    ):
        ride_passenger.requestTicket(key_ETH, key_EUR, 0, False, 5, 5)


def test_requestTicket(
    ride_passenger,
    ride_currency_registry,
    ride_exchange,
    ride_fee,
    ride_holding,
    ride_ticket,
    dMockV3Aggregator1,
    deployer,
):
    key_ETH, key_EUR = setup_currency_and_price_feed_support(
        ride_currency_registry, ride_exchange, dMockV3Aggregator1
    )
    setup_holding(ride_holding, key_ETH, deployer)

    assert ride_ticket.sUserToTixId_(deployer) == utils.ZERO_BYTES32

    tx = ride_passenger.requestTicket(key_EUR, key_ETH, 4, True, 5, 5)
    tx.wait(1)

    ticket_id = ride_ticket.sUserToTixId_(deployer)
    assert ticket_id != utils.ZERO_BYTES32

    price_feed = ride_exchange.getAddedXPerYInWei_(key_ETH, key_EUR) / (10 ** 18)

    fare = ride_fee.getFare(key_EUR, 4, 5, 5)

    assert ride_ticket.sTixIdToTicket_(ticket_id)[0] == deployer
    assert ride_ticket.sTixIdToTicket_(ticket_id)[1] == utils.ZERO_ADDRESS
    assert ride_ticket.sTixIdToTicket_(ticket_id)[2] == 4
    assert ride_ticket.sTixIdToTicket_(ticket_id)[3] == True
    assert ride_ticket.sTixIdToTicket_(ticket_id)[4] == 5
    assert ride_ticket.sTixIdToTicket_(ticket_id)[5] == key_EUR
    assert ride_ticket.sTixIdToTicket_(ticket_id)[6] == key_ETH
    assert ride_ticket.sTixIdToTicket_(ticket_id)[7] == (5 * (10 ** 18)) * price_feed
    assert ride_ticket.sTixIdToTicket_(ticket_id)[8] == fare * price_feed
    assert ride_ticket.sTixIdToTicket_(ticket_id)[9] == False
    assert ride_ticket.sTixIdToTicket_(ticket_id)[10] == 0

    return key_ETH, key_EUR, ticket_id


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_requestTicket_event(
    ride_passenger,
    ride_currency_registry,
    ride_exchange,
    ride_holding,
    ride_ticket,
    dMockV3Aggregator1,
    deployer,
):
    key_ETH, key_EUR = setup_currency_and_price_feed_support(
        ride_currency_registry, ride_exchange, dMockV3Aggregator1
    )
    setup_holding(ride_holding, key_ETH, deployer)

    ticket_id = ride_ticket.sUserToTixId_(deployer)

    tx = ride_passenger.requestTicket(key_EUR, key_ETH, 4, True, 5, 5)
    tx.wait(1)

    # print(tx.info())

    assert tx.events["RequestTicket"]["sender"] == deployer
    assert tx.events["RequestTicket"]["tixId"] == ticket_id
    assert (
        tx.events["RequestTicket"]["fare"] == ride_ticket.sTixIdToTicket_(ticket_id)[8]
    )


def test_cancelRequest_no_driver(
    ride_passenger,
    ride_currency_registry,
    ride_exchange,
    ride_fee,
    ride_holding,
    ride_ticket,
    dMockV3Aggregator1,
    deployer,
):
    key_ETH, _, _ = test_requestTicket(
        ride_passenger,
        ride_currency_registry,
        ride_exchange,
        ride_fee,
        ride_holding,
        ride_ticket,
        dMockV3Aggregator1,
        deployer,
    )

    holding_before = ride_holding.getHolding(deployer, key_ETH)

    tx = ride_passenger.cancelRequest()
    tx.wait(1)

    assert ride_holding.getHolding(deployer, key_ETH) == holding_before


def test_cancelRequest_driver(
    ride_passenger,
    ride_currency_registry,
    ride_exchange,
    ride_fee,
    ride_holding,
    ride_ticket,
    dMockV3Aggregator1,
    deployer,
    person1,
):
    key_ETH, key_EUR, ticket_id = test_requestTicket(
        ride_passenger,
        ride_currency_registry,
        ride_exchange,
        ride_fee,
        ride_holding,
        ride_ticket,
        dMockV3Aggregator1,
        deployer,
    )

    holding_before = ride_holding.getHolding(deployer, key_ETH)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, False
    )
    tx.wait(1)

    tx = ride_passenger.cancelRequest()
    tx.wait(1)

    assert ride_holding.getHolding(deployer, key_ETH) != holding_before


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_cancelRequest_event(
    ride_passenger,
    ride_currency_registry,
    ride_exchange,
    ride_fee,
    ride_holding,
    ride_ticket,
    dMockV3Aggregator1,
    deployer,
):
    _, _, ticket_id = test_requestTicket(
        ride_passenger,
        ride_currency_registry,
        ride_exchange,
        ride_fee,
        ride_holding,
        ride_ticket,
        dMockV3Aggregator1,
        deployer,
    )

    tx = ride_passenger.cancelRequest()
    tx.wait(1)

    assert tx.events["RequestCancelled"]["sender"] == deployer
    assert tx.events["RequestCancelled"]["tixId"] == ticket_id


def test_startTrip(ride_passenger, ride_ticket, ride_badge, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, False
    )
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(person1)[5] == 0
    assert ride_ticket.sTixIdToTicket_(ticket_id)[9] == False
    assert ride_ticket.sTixIdToTicket_(ticket_id)[10] == 0

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    tx = ride_passenger.startTrip(person1)
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(person1)[4] == 1
    assert ride_ticket.sTixIdToTicket_(ticket_id)[9] == True
    assert (
        ride_ticket.sTixIdToTicket_(ticket_id)[10]
        == chain[-1].timestamp + ride_ticket.sForceEndDelay()
    )


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_startTrip_event(ride_passenger, ride_ticket, ride_badge, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, False
    )
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    tx = ride_passenger.startTrip(person1)
    tx.wait(1)

    assert tx.events["TripStarted"]["passenger"] == deployer
    assert tx.events["TripStarted"]["tixId"] == ticket_id
    assert tx.events["TripStarted"]["driver"] == person1


def test_endTripPax_require_1_revert(ride_passenger, ride_ticket, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, True
    )
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    with brownie.reverts("RidePassenger: Driver must end trip"):
        ride_passenger.endTripPax(True, 3)


def test_endTripPax_require_2_revert(ride_passenger, ride_ticket, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, True
    )
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToDriverEnd_(ticket_id, person1, False)
    tx.wait(1)

    with brownie.reverts(
        "RidePassenger: Passenger must agree destination reached or not - indicated by driver"
    ):
        ride_passenger.endTripPax(False, 3)


def test_endTripPax_no_reached(
    ride_passenger, ride_ticket, ride_holding, ride_badge, deployer, person1
):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, True
    )
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToDriverEnd_(ticket_id, person1, False)
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, "100 ether")
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(person1)[3] == 0
    assert ride_badge.sDriverToDriverReputation_(person1)[5] == 0

    tx = ride_passenger.endTripPax(True, 3)
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(person1)[3] == 0
    assert ride_badge.sDriverToDriverReputation_(person1)[5] == 0


def test_endTripPax_reached(
    ride_passenger, ride_ticket, ride_holding, ride_badge, deployer, person1
):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, True
    )
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToDriverEnd_(ticket_id, person1, True)
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, "100 ether")
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(person1)[3] == 0
    assert ride_badge.sDriverToDriverReputation_(person1)[5] == 0

    tx = ride_passenger.endTripPax(True, 3)
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(person1)[3] == 5
    assert ride_badge.sDriverToDriverReputation_(person1)[5] == 1


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_endTripPax_event(ride_passenger, ride_ticket, ride_holding, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, True
    )
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToDriverEnd_(ticket_id, person1, True)
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, "100 ether")
    tx.wait(1)

    tx = ride_passenger.endTripPax(True, 3)
    tx.wait(1)

    assert tx.events["TripEndedPax"]["sender"] == deployer
    assert tx.events["TripEndedPax"]["tixId"] == ticket_id


def test_forceEndPax_revert(
    ride_passenger, ride_ticket, ride_holding, deployer, person1
):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, True
    )
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToDriverEnd_(ticket_id, person1, True)
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, "100 ether")
    tx.wait(1)

    with brownie.reverts("RidePassenger: Driver ended trip"):
        ride_passenger.forceEndPax()


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_forceEndPax_event(
    ride_passenger, ride_ticket, ride_holding, deployer, person1
):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))
    key_EUR = Web3.toHex(
        Web3.solidityKeccak(
            ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["EUR"]).hex()]
        )
    )  # Solidity equivalent: keccak256(abi.encode(_code))

    token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
    key_ETH = utils.pad_address_right(
        token_ETH
    )  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 4, True, 5, key_EUR, key_ETH, 5, 5, True
    )
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)
    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToDriverEnd_(ticket_id, utils.ZERO_ADDRESS, False)
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, "100 ether")
    tx.wait(1)

    tx = ride_passenger.forceEndPax()
    tx.wait(1)

    assert tx.events["ForceEndPax"]["sender"] == deployer
    assert tx.events["ForceEndPax"]["tixId"] == ticket_id
