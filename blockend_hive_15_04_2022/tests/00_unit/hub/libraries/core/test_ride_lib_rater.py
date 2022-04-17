import pytest
import brownie
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_rater(ride_hub, RideTestRater, Contract, deployer):
    yield Contract.from_abi(
        "RideTestRater", ride_hub[0].address, RideTestRater.abi, deployer,
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


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_setRatingBounds_require_1_revert(ride_rater):
    with brownie.reverts("RideLibRater: Cannot have zero rating bound"):
        ride_rater.setRatingBounds_(0, 4)


def test_setRatingBounds_require_2_revert(ride_rater):
    with brownie.reverts(
        "RideLibRater: Maximum rating must be more than minimum rating"
    ):
        ride_rater.setRatingBounds_(3, 2)


def test_setRatingBounds(ride_rater):
    assert ride_rater.sRatingMin_() == 1
    assert ride_rater.sRatingMax_() == 5

    tx = ride_rater.setRatingBounds_(2, 4)
    tx.wait(1)

    assert ride_rater.sRatingMin_() == 2
    assert ride_rater.sRatingMax_() == 4


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setRatingBounds_event(ride_rater, deployer):
    tx = ride_rater.setRatingBounds_(2, 4)
    tx.wait(1)

    assert tx.events["SetRatingBounds"]["sender"] == deployer
    assert tx.events["SetRatingBounds"]["min"] == 2
    assert tx.events["SetRatingBounds"]["max"] == 4


def test_giveRating_revert(ride_rater, person1):
    with brownie.reverts(
        "RideLibRater: Rating must be within min and max ratings (inclusive)"
    ):
        ride_rater.giveRating_(person1, 6)

    with brownie.reverts(
        "RideLibRater: Rating must be within min and max ratings (inclusive)"
    ):
        ride_rater.giveRating_(person1, 0)


def test_giveRating(ride_rater, ride_driver_details, person1):
    assert ride_driver_details.sDriverToDriverDetails_(person1)[7] == 0
    assert ride_driver_details.sDriverToDriverDetails_(person1)[8] == 0

    tx = ride_rater.giveRating_(person1, 3)
    tx.wait(1)

    assert ride_driver_details.sDriverToDriverDetails_(person1)[7] == 3
    assert ride_driver_details.sDriverToDriverDetails_(person1)[8] == 1
