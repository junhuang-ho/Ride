import pytest
import brownie
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_driver_registry(ride_hub, RideTestDriverRegistry, Contract, deployer):
    yield Contract.from_abi(
        "RideTestDriverRegistry",
        ride_hub[0].address,
        RideTestDriverRegistry.abi,
        deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_burnFirstDriverId_revert(ride_driver_registry):
    with brownie.reverts("RideLibDriverRegistry: Must be zero"):
        ride_driver_registry.burnFirstDriverId_()


@pytest.mark.skip(
    reason="TODO: test that _driverIdCounter value is 1 once deployed - integration test"
)
def test_burnFirstDriverId():
    # move to integration test
    pass


def test_mint(ride_driver_registry):
    assert ride_driver_registry.s_driverIdCounter_()[0] == 1

    tx = ride_driver_registry.mint_()
    tx.wait(1)

    assert ride_driver_registry.s_driverIdCounter_()[0] == 2
