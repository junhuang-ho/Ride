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

token_BTC = "0xc116851f0F506a4A1f304f8587ed4357F17643c5"
key_BTC = utils.pad_address_right(
    token_BTC
)  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

price_feed_ETH = "0xc116851f0F506a4A1f304f8587ed4357F17643c5"

ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))


@pytest.fixture(scope="module", autouse=True)
def ride_driver(ride_hub, RideTestDriver, Contract, deployer):
    yield Contract.from_abi(
        "RideTestDriver", ride_hub[0].address, RideTestDriver.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_driver_details(ride_hub, RideTestDriverDetails, Contract, deployer):
    contract_ride_driver_details = Contract.from_abi(
        "RideTestDriverDetails",
        ride_hub[0].address,
        RideTestDriverDetails.abi,
        deployer,
    )
    yield contract_ride_driver_details


@pytest.fixture(scope="module", autouse=True)
def ride_ticket(ride_hub, RideTestTicket, Contract, deployer):
    yield Contract.from_abi(
        "RideTestTicket", ride_hub[0].address, RideTestTicket.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_exchange(ride_hub, RideTestExchange, Contract, deployer):
    yield Contract.from_abi(
        "RideTestExchange", ride_hub[0].address, RideTestExchange.abi, deployer
    )


@pytest.fixture(scope="module", autouse=True)
def ride_holding(ride_hub, RideTestHolding, Contract, deployer):
    yield Contract.from_abi(
        "RideTestHolding", ride_hub[0].address, RideTestHolding.abi, deployer
    )


def setup_acceptTicket(ride_driver, ride_driver_details, ride_exchange, deployer):
    tx = ride_driver_details.ssDriverToDriverDetails_(
        deployer, 2, "test123", deployer.address, 9, 8, 7, 6, 5, 4
    )
    tx.wait(1)

    assert ride_driver.requireIsDriver_()

    tx = ride_exchange.ssXToYToXPerYAddedPriceFeed_(key_MYR, key_ETH, price_feed_ETH)
    tx.wait(1)

    assert ride_exchange.sXToYToXAddedPerYPriceFeed_(key_MYR, key_ETH) == price_feed_ETH


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_acceptTicket_require_1_revert(
    ride_driver, ride_driver_details, ride_exchange, deployer
):
    setup_acceptTicket(ride_driver, ride_driver_details, ride_exchange, deployer)

    with brownie.reverts("RideDriver: Ticket not exists"):
        ride_driver.acceptTicket(key_MYR, key_ETH, ticket_id)


def test_acceptTicket_require_2_revert(
    ride_driver, ride_driver_details, ride_exchange, ride_ticket, deployer, person1
):
    setup_acceptTicket(ride_driver, ride_driver_details, ride_exchange, deployer)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, utils.ZERO_ADDRESS, 1, key_EUR, token_ETH, 5, 10, False,
    )
    tx.wait(1)

    with brownie.reverts("RideDriver: Local currency key not match"):
        ride_driver.acceptTicket(key_MYR, key_ETH, ticket_id)


def test_acceptTicket_require_3_revert(
    ride_driver, ride_driver_details, ride_exchange, ride_ticket, deployer, person1
):
    setup_acceptTicket(ride_driver, ride_driver_details, ride_exchange, deployer)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, utils.ZERO_ADDRESS, 1, key_MYR, key_BTC, 5, 10, False,
    )
    tx.wait(1)

    with brownie.reverts("RideDriver: Payment currency key not match"):
        ride_driver.acceptTicket(key_MYR, key_ETH, ticket_id)


def test_acceptTicket_require_4_revert(
    ride_driver, ride_driver_details, ride_exchange, ride_ticket, deployer, person1
):
    setup_acceptTicket(ride_driver, ride_driver_details, ride_exchange, deployer)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, utils.ZERO_ADDRESS, 1, key_MYR, key_ETH, 5, 10, False,
    )
    tx.wait(1)

    with brownie.reverts("RideDriver: Driver's holding < cancellationFee or fare"):
        ride_driver.acceptTicket(key_MYR, key_ETH, ticket_id)


def test_acceptTicket_require_5_revert(
    ride_driver,
    ride_driver_details,
    ride_exchange,
    ride_ticket,
    ride_holding,
    deployer,
    person1,
):
    setup_acceptTicket(ride_driver, ride_driver_details, ride_exchange, deployer)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, utils.ZERO_ADDRESS, 100, key_MYR, key_ETH, 5, 10, False,
    )
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, 100)
    tx.wait(1)

    with brownie.reverts("RideDriver: Trip too long"):
        ride_driver.acceptTicket(key_MYR, key_ETH, ticket_id)


def test_acceptTicket(
    ride_driver,
    ride_driver_details,
    ride_exchange,
    ride_ticket,
    ride_holding,
    deployer,
    person1,
):
    setup_acceptTicket(ride_driver, ride_driver_details, ride_exchange, deployer)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, utils.ZERO_ADDRESS, 5, key_MYR, key_ETH, 5, 10, False,
    )
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, 100)
    tx.wait(1)

    assert ride_ticket.sTixIdToTicket_(ticket_id)[1] == utils.ZERO_ADDRESS
    assert ride_ticket.sUserToTixId_(deployer) == utils.ZERO_BYTES32

    tx = ride_driver.acceptTicket(key_MYR, key_ETH, ticket_id)
    tx.wait(1)

    assert ride_ticket.sTixIdToTicket_(ticket_id)[1] == deployer
    assert ride_ticket.sUserToTixId_(deployer) == ticket_id


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_acceptTicket_event(
    ride_driver,
    ride_driver_details,
    ride_exchange,
    ride_ticket,
    ride_holding,
    deployer,
    person1,
):
    setup_acceptTicket(ride_driver, ride_driver_details, ride_exchange, deployer)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, utils.ZERO_ADDRESS, 5, key_MYR, key_ETH, 5, 10, False,
    )
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, 100)
    tx.wait(1)

    tx = ride_driver.acceptTicket(key_MYR, key_ETH, ticket_id)
    tx.wait(1)

    assert tx.events["AcceptedTicket"]["sender"] == deployer
    assert tx.events["AcceptedTicket"]["tixId"] == ticket_id


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_cancelPickUp_event(ride_driver, ride_ticket, ride_holding, deployer, person1):
    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, deployer, 2, key_MYR, key_ETH, 2, 2, False
    )
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, 100)
    tx.wait(1)

    tx = ride_driver.cancelPickUp()
    tx.wait(1)

    assert tx.events["DriverCancelled"]["sender"] == deployer
    assert tx.events["DriverCancelled"]["tixId"] == ticket_id


def test_endTripDrv_reached(ride_driver, ride_ticket, ride_holding, deployer, person1):
    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, deployer, 2, key_MYR, key_ETH, 2, 2, True
    )
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(person1, key_ETH, 100)
    tx.wait(1)

    assert ride_ticket.sTixIdToDriverEnd_(ticket_id)[0] == utils.ZERO_ADDRESS
    assert ride_ticket.sTixIdToDriverEnd_(ticket_id)[1] == False

    tx = ride_driver.endTripDrv(True)
    tx.wait(1)

    assert ride_ticket.sTixIdToDriverEnd_(ticket_id)[0] == deployer
    assert ride_ticket.sTixIdToDriverEnd_(ticket_id)[1] == True


def test_endTripDrv_not_reached(
    ride_driver, ride_ticket, ride_holding, deployer, person1
):
    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, deployer, 2, key_MYR, key_ETH, 2, 2, True
    )
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(person1, key_ETH, 100)
    tx.wait(1)

    assert ride_ticket.sTixIdToDriverEnd_(ticket_id)[0] == utils.ZERO_ADDRESS
    assert ride_ticket.sTixIdToDriverEnd_(ticket_id)[1] == False

    tx = ride_driver.endTripDrv(False)
    tx.wait(1)

    assert ride_ticket.sTixIdToDriverEnd_(ticket_id)[0] == deployer
    assert ride_ticket.sTixIdToDriverEnd_(ticket_id)[1] == False


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_endTripDrv_event(ride_driver, ride_ticket, ride_holding, deployer, person1):
    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, deployer, 2, key_MYR, key_ETH, 2, 2, True
    )
    tx.wait(1)

    tx = ride_holding.ssUserToCurrencyKeyToHolding_(person1, key_ETH, 100)
    tx.wait(1)

    tx = ride_driver.endTripDrv(False)
    tx.wait(1)

    assert tx.events["TripEndedDrv"]["sender"] == deployer
    assert tx.events["TripEndedDrv"]["tixId"] == ticket_id
    assert tx.events["TripEndedDrv"]["reached"] == False


def test_forceEndDrv_require_revert(ride_driver, ride_ticket, deployer, person1):
    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, deployer, 2, key_MYR, key_ETH, 2, 2, True
    )
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_2(ticket_id, 1645437890)
    tx.wait(1)

    with brownie.reverts("RideDriver: Driver must end trip"):
        ride_driver.forceEndDrv()


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_forceEndDrv_event(ride_driver, ride_ticket, deployer, person1):
    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, person1, deployer, 2, key_MYR, key_ETH, 2, 2, True
    )
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_2(ticket_id, 1645437890)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToDriverEnd_(ticket_id, deployer, True)
    tx.wait(1)

    tx = ride_driver.forceEndDrv()
    tx.wait(1)

    assert tx.events["ForceEndDrv"]["sender"] == deployer
    assert tx.events["ForceEndDrv"]["tixId"] == ticket_id
