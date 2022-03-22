from ctypes import util
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
def ride_ticket(ride_hub, RideTestTicket, Contract, deployer):
    yield Contract.from_abi(
        "RideTestTicket", ride_hub[0].address, RideTestTicket.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_access_control(ride_hub, RideTestAccessControl, Contract, deployer):
    yield Contract.from_abi(
        "RideTestAccessControl",
        ride_hub[0].address,
        RideTestAccessControl.abi,
        deployer,
    )


ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))


def setup_ticket_details(ride_ticket, deployer, person1):
    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 10, key_MYR, key_ETH, 3, 2, True
    )
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_2(ticket_id, 12345)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToDriverEnd_(ticket_id, person1, True)
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssUserToTixId_(person1, ticket_id)
    tx.wait(1)


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_setForceEndDelay(ride_ticket, ride_access_control, deployer):
    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_ticket.setForceEndDelay(12345)
    tx.wait(1)

    assert ride_ticket.sForceEndDelay(deployer.address) == 12345


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setForceEndDelay_event(ride_ticket, ride_access_control, deployer):
    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_ticket.setForceEndDelay(12345)
    tx.wait(1)

    assert tx.events["ForceEndDelaySet"]["sender"] == deployer
    assert tx.events["ForceEndDelaySet"]["newDelayPeriod"] == 12345


def test_getUserToTixId(ride_ticket, deployer, person1):
    setup_ticket_details(ride_ticket, deployer, person1)

    assert ride_ticket.getUserToTixId(deployer) == ticket_id
    assert ride_ticket.getUserToTixId(person1) == ticket_id


def test_getTixIdToTicket(ride_ticket, deployer, person1):
    setup_ticket_details(ride_ticket, deployer, person1)

    assert ride_ticket.getTixIdToTicket(ticket_id)[0] == deployer
    assert ride_ticket.getTixIdToTicket(ticket_id)[1] == person1
    assert ride_ticket.getTixIdToTicket(ticket_id)[2] == 10
    assert ride_ticket.getTixIdToTicket(ticket_id)[3] == key_MYR
    assert ride_ticket.getTixIdToTicket(ticket_id)[4] == key_ETH
    assert ride_ticket.getTixIdToTicket(ticket_id)[5] == 3
    assert ride_ticket.getTixIdToTicket(ticket_id)[6] == 2
    assert ride_ticket.getTixIdToTicket(ticket_id)[7] == True
    assert ride_ticket.getTixIdToTicket(ticket_id)[8] == 12345


def test_getTixIdToDriverEnd(ride_ticket, deployer, person1):
    setup_ticket_details(ride_ticket, deployer, person1)

    assert ride_ticket.getTixIdToDriverEnd(ticket_id)[0] == person1
    assert ride_ticket.getTixIdToDriverEnd(ticket_id)[1] == True


def test_getForceEndDelay(ride_ticket, ride_access_control, deployer):
    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_ticket.setForceEndDelay(12345)
    tx.wait(1)

    assert ride_ticket.getForceEndDelay(deployer.address) == 12345
