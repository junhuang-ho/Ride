import pytest
import math
import brownie
from web3 import Web3
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_alliance_forger(
    ride_alliance_factory, RideTestAllianceForger, Contract, deployer
):
    yield Contract.from_abi(
        "RideTestAllianceForger",
        ride_alliance_factory.address,
        RideTestAllianceForger.abi,
        deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass
