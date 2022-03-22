import pytest
import math
import brownie
from web3 import Web3
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_alliance_printer(
    ride_alliance_factory, RideTestAlliancePrinter, Contract, deployer
):
    yield Contract.from_abi(
        "RideTestAlliancePrinter",
        ride_alliance_factory.address,
        RideTestAlliancePrinter.abi,
        deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


@pytest.mark.skip(reason="TODO: refer to test_ride_alliance_forger.py")
def test_():
    pass
