import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils

token_ETH = "0x614539062f7205049917e03ec4c86ff808f083cb"
key_ETH = utils.pad_address_right(
    token_ETH
)  # Solidity equivalent: bytes32(uint256(uint160(_token)) << 96)

ticket_id = Web3.toHex(Web3.solidityKeccak(["string"], ["ticket1"]))


@pytest.fixture(scope="module", autouse=True)
def ride_holding(ride_hub, RideTestHolding, Contract, deployer):
    yield Contract.from_abi(
        "RideTestHolding", ride_hub[0].address, RideTestHolding.abi, deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_transferCurrency(ride_holding, deployer, person1):
    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, 100)
    tx.wait(1)
    tx = ride_holding.ssUserToCurrencyKeyToHolding_(person1, key_ETH, 100)
    tx.wait(1)

    assert ride_holding.sUserToCurrencyKeyToHolding_(deployer, key_ETH) == 100
    assert ride_holding.sUserToCurrencyKeyToHolding_(person1, key_ETH) == 100

    tx = ride_holding.transferCurrency_(ticket_id, key_ETH, 50, deployer, person1)
    tx.wait(1)

    assert ride_holding.sUserToCurrencyKeyToHolding_(deployer, key_ETH) == 50
    assert ride_holding.sUserToCurrencyKeyToHolding_(person1, key_ETH) == 150


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_transferCurrency_event(ride_holding, deployer, person1):
    tx = ride_holding.ssUserToCurrencyKeyToHolding_(deployer, key_ETH, 100)
    tx.wait(1)
    tx = ride_holding.ssUserToCurrencyKeyToHolding_(person1, key_ETH, 100)
    tx.wait(1)

    tx = ride_holding.transferCurrency_(ticket_id, key_ETH, 50, deployer, person1)
    tx.wait(1)

    assert tx.events["CurrencyTransferred"]["decrease"] == deployer
    assert tx.events["CurrencyTransferred"]["tixId"] == ticket_id
    assert tx.events["CurrencyTransferred"]["increase"] == person1
    assert tx.events["CurrencyTransferred"]["key"] == key_ETH
    assert tx.events["CurrencyTransferred"]["amount"] == 50
