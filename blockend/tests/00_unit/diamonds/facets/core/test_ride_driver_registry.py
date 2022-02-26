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


@pytest.fixture(scope="module", autouse=True)
def ride_badge(ride_hub, RideTestBadge, Contract, deployer):
    yield Contract.from_abi(
        "RideTestBadge", ride_hub[0].address, RideTestBadge.abi, deployer
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_approveApplicant_revert(ride_driver_registry, ride_badge, deployer, person1):
    tx = ride_badge.ssDriverToDriverReputation_(
        person1, 2, "test123", 5, 6, 7, 8, 9, 3, {"from": deployer}
    )
    tx.wait(1)

    with brownie.reverts("RideDriverRegistry: URI already set"):
        ride_driver_registry.approveApplicant(person1, "test456", {"from": deployer})


def test_approveApplicant(ride_driver_registry, ride_badge, person1):
    assert ride_badge.sDriverToDriverReputation_(person1)[1] == ""

    tx = ride_driver_registry.approveApplicant(person1, "test456")
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(person1)[1] == "test456"


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_approveApplicant_event(ride_driver_registry, person1):
    tx = ride_driver_registry.approveApplicant(person1, "test456")
    tx.wait(1)

    assert tx.events["ApplicantApproved"]["applicant"] == person1


def test_registerAsDriver_require_1_revert(ride_driver_registry):
    with brownie.reverts("RideDriverRegistry: URI not set in background check"):
        ride_driver_registry.registerAsDriver(789)


def test_registerAsDriver(ride_driver_registry, ride_badge, deployer):
    tx = ride_driver_registry.approveApplicant(deployer, "test456")
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(deployer)[0] == 0
    assert ride_badge.sDriverToDriverReputation_(deployer)[2] == 0

    tx = ride_driver_registry.registerAsDriver(789)
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(deployer)[0] == 1
    assert ride_badge.sDriverToDriverReputation_(deployer)[2] == 789


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_registerAsDriver_event(ride_driver_registry, deployer):
    tx = ride_driver_registry.approveApplicant(deployer, "test456")
    tx.wait(1)

    tx = ride_driver_registry.registerAsDriver(789)
    tx.wait(1)

    assert tx.events["RegisteredAsDriver"]["sender"] == deployer


def test_updateMaxMetresPerTrip(ride_driver_registry, ride_badge, deployer):
    test_registerAsDriver(ride_driver_registry, ride_badge, deployer)

    assert ride_badge.sDriverToDriverReputation_(deployer)[2] == 789

    tx = ride_driver_registry.updateMaxMetresPerTrip(888)
    tx.wait(1)

    assert ride_badge.sDriverToDriverReputation_(deployer)[2] == 888


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_updateMaxMetresPerTrip_event(ride_driver_registry, ride_badge, deployer):
    test_registerAsDriver(ride_driver_registry, ride_badge, deployer)

    tx = ride_driver_registry.updateMaxMetresPerTrip(888)
    tx.wait(1)

    assert tx.events["MaxMetresUpdated"]["sender"] == deployer
    assert tx.events["MaxMetresUpdated"]["metres"] == 888
