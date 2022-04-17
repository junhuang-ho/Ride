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
def ride_driver_details(ride_hub, RideTestDriverDetails, Contract, deployer):
    contract_ride_driver_details = Contract.from_abi(
        "RideTestDriverDetails",
        ride_hub[0].address,
        RideTestDriverDetails.abi,
        deployer,
    )
    yield contract_ride_driver_details


@pytest.fixture(scope="module", autouse=True)
def ride_access_control(ride_hub, RideTestAccessControl, Contract, deployer):
    yield Contract.from_abi(
        "RideTestAccessControl",
        ride_hub[0].address,
        RideTestAccessControl.abi,
        deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_approveNewAlly_require_1_revert(
    ride_driver_registry, ride_driver_details, deployer, person1
):
    tx = ride_driver_details.ssAllianceToDrivers_(deployer.address, [deployer])
    tx.wait(1)

    with brownie.reverts("RideDriverRegistry: First ally already set"):
        ride_driver_registry.approveNewAlly(person1, "testURI", deployer.address)


def test_approveNewAlly_require_2_revert(
    ride_driver_registry, ride_driver_details, deployer
):
    tx = ride_driver_details.ssDriverToDriverDetails_(
        deployer, 1, "dummy", deployer.address, 500, 5, 5, 4, 3, 3, {"from": deployer},
    )
    tx.wait(1)

    with brownie.reverts("RideDriverRegistry: URI already set"):
        ride_driver_registry.approveNewAlly(deployer, "testURI", deployer.address)


def test_approveNewAlly(ride_driver_registry, ride_driver_details, deployer, person1):
    assert ride_driver_details.sDriverToDriverDetails_(person1)[1] == ""
    assert ride_driver_details.sDriverToDriverDetails_(person1)[2] == utils.ZERO_ADDRESS
    assert len(ride_driver_details.sAllianceToDrivers_(deployer.address)) == 0

    tx = ride_driver_registry.approveNewAlly(person1, "testURI", deployer.address)
    tx.wait(1)

    assert ride_driver_details.sDriverToDriverDetails_(person1)[1] == "testURI"
    assert ride_driver_details.sDriverToDriverDetails_(person1)[2] == deployer.address
    assert len(ride_driver_details.sAllianceToDrivers_(deployer.address)) == 1
    assert ride_driver_details.sAllianceToDrivers_(deployer.address)[0] == person1


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_approveNewAlly_event(ride_driver_registry, deployer, person1):
    tx = ride_driver_registry.approveNewAlly(person1, "testURI", deployer.address)
    tx.wait(1)

    assert tx.events["ApplicantApproved"]["applicant"] == person1


def test_approveApplicant_require_1_revert(
    ride_driver_registry, ride_driver_details, ride_access_control, deployer, person1
):
    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    with brownie.reverts("RideDriverRegistry: Alliance not registered"):
        ride_driver_registry.approveApplicant(
            person1, "test456", deployer.address, {"from": deployer}
        )


def test_approveApplicant_require_2_revert(
    ride_driver_registry, ride_driver_details, ride_access_control, deployer, person1
):
    test_approveNewAlly(ride_driver_registry, ride_driver_details, deployer, person1)

    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    with brownie.reverts("RideDriverRegistry: URI already set"):
        ride_driver_registry.approveApplicant(
            person1, "test456", deployer.address, {"from": deployer}
        )


def test_approveApplicant(
    ride_driver_registry,
    ride_driver_details,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    test_approveNewAlly(ride_driver_registry, ride_driver_details, deployer, person1)

    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    assert ride_driver_details.sDriverToDriverDetails_(person2)[1] == ""
    assert ride_driver_details.sDriverToDriverDetails_(person2)[2] == utils.ZERO_ADDRESS

    tx = ride_driver_registry.approveApplicant(
        person2, "test456", deployer.address, {"from": deployer}
    )
    tx.wait(1)

    assert ride_driver_details.sDriverToDriverDetails_(person2)[1] == "test456"
    assert ride_driver_details.sDriverToDriverDetails_(person2)[2] == deployer.address


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_approveApplicant_event(
    ride_driver_registry,
    ride_driver_details,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    test_approveNewAlly(ride_driver_registry, ride_driver_details, deployer, person1)

    tx = ride_access_control.grantRole_(
        ride_access_control.getRole("ALLIANCE_ROLE"), deployer, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_driver_registry.approveApplicant(
        person2, "test456", deployer.address, {"from": deployer}
    )
    tx.wait(1)

    assert tx.events["ApplicantApproved"]["applicant"] == person2


def test_registerAsDriver_require_1_revert(ride_driver_registry):
    with brownie.reverts("RideDriverRegistry: URI not set in background check"):
        ride_driver_registry.registerAsDriver(789)


def test_registerAsDriver(
    ride_driver_registry,
    ride_driver_details,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    test_approveApplicant(
        ride_driver_registry,
        ride_driver_details,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    assert ride_driver_details.sDriverToDriverDetails_(person2)[0] == 0
    assert ride_driver_details.sDriverToDriverDetails_(person2)[3] == 0

    tx = ride_driver_registry.registerAsDriver(789, {"from": person2})
    tx.wait(1)

    assert ride_driver_details.sDriverToDriverDetails_(person2)[0] == 1
    assert ride_driver_details.sDriverToDriverDetails_(person2)[3] == 789


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_registerAsDriver_event(
    ride_driver_registry,
    ride_driver_details,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    test_approveApplicant(
        ride_driver_registry,
        ride_driver_details,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    assert ride_driver_details.sDriverToDriverDetails_(person2)[0] == 0
    assert ride_driver_details.sDriverToDriverDetails_(person2)[3] == 0

    tx = ride_driver_registry.registerAsDriver(789, {"from": person2})
    tx.wait(1)

    assert ride_driver_details.sDriverToDriverDetails_(person2)[0] == 1
    assert ride_driver_details.sDriverToDriverDetails_(person2)[3] == 789

    assert tx.events["RegisteredAsDriver"]["sender"] == person2


def test_updateMaxMetresPerTrip(
    ride_driver_registry,
    ride_driver_details,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    test_registerAsDriver(
        ride_driver_registry,
        ride_driver_details,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    assert ride_driver_details.sDriverToDriverDetails_(person2)[3] == 789

    tx = ride_driver_registry.updateMaxMetresPerTrip(888, {"from": person2})
    tx.wait(1)

    assert ride_driver_details.sDriverToDriverDetails_(person2)[3] == 888


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_updateMaxMetresPerTrip_event(
    ride_driver_registry,
    ride_driver_details,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    test_registerAsDriver(
        ride_driver_registry,
        ride_driver_details,
        ride_access_control,
        deployer,
        person1,
        person2,
    )

    tx = ride_driver_registry.updateMaxMetresPerTrip(888, {"from": person2})
    tx.wait(1)

    assert tx.events["MaxMetresUpdated"]["sender"] == person2
    assert tx.events["MaxMetresUpdated"]["metres"] == 888
