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
def ride_passenger(ride_hub, RideTestPassenger, Contract, deployer):
    yield Contract.from_abi(
        "RideTestPassenger", ride_hub[0].address, RideTestPassenger.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_ticket(ride_hub, RideTestTicket, Contract, deployer):
    yield Contract.from_abi(
        "RideTestTicket", ride_hub[0].address, RideTestTicket.abi, deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_requirePaxMatchTixPax_revert(ride_passenger, deployer):
    with brownie.reverts("RideLibPassenger: Passenger not match tix passenger"):
        ride_passenger.requirePaxMatchTixPax_()


def test_requirePaxMatchTixPax_pass(ride_passenger, ride_ticket, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 0, False, 1, key_MYR, key_ETH, 5, 10, True
    )
    tx.wait(1)

    assert ride_passenger.requirePaxMatchTixPax_({"from": deployer})


def test_requireTripNotStart_revert(ride_passenger, ride_ticket, deployer, person1):
    test_requirePaxMatchTixPax_pass(ride_passenger, ride_ticket, deployer, person1)

    with brownie.reverts("RideLibPassenger: Trip already started"):
        ride_passenger.requireTripNotStart_()


def test_requireTripNotStart_pass(ride_passenger, ride_ticket, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 0, False, 1, key_MYR, key_ETH, 5, 10, False
    )
    tx.wait(1)

    assert ride_passenger.requireTripNotStart_({"from": deployer})


def test_requireTripInProgress_revert(ride_passenger, ride_ticket, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 0, False, 1, key_MYR, key_ETH, 5, 10, False
    )
    tx.wait(1)

    with brownie.reverts("RideLibPassenger: Trip not started"):
        ride_passenger.requireTripInProgress_()


def test_requireTripInProgress_pass(ride_passenger, ride_ticket, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 0, False, 1, key_MYR, key_ETH, 5, 10, True
    )
    tx.wait(1)

    assert ride_passenger.requireTripInProgress_({"from": deployer})


def test_requireForceEndAllowed_revert(ride_passenger, ride_ticket, deployer):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_2(ticket_id, 7260796800)
    tx.wait(1)

    with brownie.reverts("RideLibPassenger: Too early"):
        ride_passenger.requireForceEndAllowed_()


def test_requireForceEndAllowed_pass(ride_passenger, ride_ticket, deployer):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_2(ticket_id, 1645500740)
    tx.wait(1)

    assert ride_passenger.requireForceEndAllowed_({"from": deployer})
