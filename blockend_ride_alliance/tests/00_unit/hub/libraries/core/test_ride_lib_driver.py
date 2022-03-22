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


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_requireDrvMatchTixDrv_revert(ride_driver, person1):
    with brownie.reverts("RideLibDriver: Driver not match ticket driver"):
        ride_driver.requireDrvMatchTixDrv_(person1)


def test_requireDrvMatchTixDrv_pass(ride_driver, ride_ticket, deployer, person1):
    ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))

    tx = ride_ticket.ssUserToTixId_(deployer, ticket_id)
    tx.wait(1)

    tx = ride_ticket.ssTixIdToTicket_(
        ticket_id, deployer, person1, 1, key_MYR, key_ETH, 5, 10, False
    )
    tx.wait(1)

    assert ride_driver.requireDrvMatchTixDrv_(person1, {"from": deployer})


def test_requireIsDriver_revert(ride_driver):
    with brownie.reverts("RideLibDriver: Caller not driver"):
        ride_driver.requireIsDriver_()


def test_requireIsDriver_pass(ride_driver, ride_driver_details, deployer):
    tx = ride_driver_details.ssDriverToDriverDetails_(
        deployer, 2, "test123", deployer.address, 9, 8, 7, 6, 5, 4
    )
    tx.wait(1)

    assert ride_driver.requireIsDriver_()


def test_requireNotDriver_revert(ride_driver, ride_driver_details, deployer):
    tx = ride_driver_details.ssDriverToDriverDetails_(
        deployer, 2, "test123", deployer.address, 9, 8, 7, 6, 5, 4
    )
    tx.wait(1)

    with brownie.reverts("RideLibDriver: Caller is driver"):
        ride_driver.requireNotDriver_()


def test_requireNotDriver_pass(ride_driver):
    assert ride_driver.requireNotDriver_()
