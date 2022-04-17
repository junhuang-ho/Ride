import pytest
import math
import brownie
from web3 import Web3
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_alliance_printer_timelock(
    ride_alliance_factory, RideTestAlliancePrinterTimelock, Contract, deployer
):
    yield Contract.from_abi(
        "RideTestAlliancePrinterTimelock",
        ride_alliance_factory.address,
        RideTestAlliancePrinterTimelock.abi,
        deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


@pytest.mark.skip(reason="TODO: refer to test_ride_alliance_forger.py")
def test_():
    pass
