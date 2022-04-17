import pytest
import math
import brownie
import scripts.utils as utils


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
def ride_rater(ride_hub, RideTestRater, Contract, deployer):
    yield Contract.from_abi(
        "RideTestRater", ride_hub[0].address, RideTestRater.abi, deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_getDriverScoreDetails(ride_driver_details, ride_rater, deployer):
    id = 69
    uri = "testabc"
    alliance = deployer.address
    max_metres_per_trip = 501
    metres_travelled = 201
    count_start = 55
    count_end = 44
    total_rating = 113
    count_rating = 228

    tx = ride_driver_details.ssDriverToDriverDetails_(
        deployer,
        id,
        uri,
        alliance,
        max_metres_per_trip,
        metres_travelled,
        count_start,
        count_end,
        total_rating,
        count_rating,
        {"from": deployer},
    )
    tx.wait(1)

    (
        r_metres_travelled,
        r_count_start,
        r_count_end,
        r_total_rating,
        r_count_rating,
        r_max_rating,
    ) = ride_driver_details.getDriverScoreDetails_(deployer)

    assert r_metres_travelled == metres_travelled
    assert r_count_start == count_start
    assert r_count_end == count_end
    assert r_total_rating == total_rating
    assert r_count_rating == count_rating
    assert r_max_rating == ride_rater.sRatingMax_()


def test_calculateIndividualScore_when_countStart_zero(ride_driver_details, deployer):
    assert ride_driver_details.sDriverToDriverDetails_(deployer)[5] == 0  # countStart
    assert ride_driver_details.calculateIndividualScore_(deployer) == 0


def test_calculateIndividualScore(ride_driver_details, ride_rater, deployer):
    id = 1
    uri = "test123"
    alliance = deployer.address
    max_metres_per_trip = 500
    metres_travelled = 200
    count_start = 5
    count_end = 4
    total_rating = 13
    count_rating = count_start
    min_rating = 1
    max_rating = 5

    score = math.floor(
        (metres_travelled * count_end * total_rating)
        / (count_start * count_rating * max_rating)
    )

    tx = ride_driver_details.ssDriverToDriverDetails_(
        deployer,
        id,
        uri,
        alliance,
        max_metres_per_trip,
        metres_travelled,
        count_start,
        count_end,
        total_rating,
        count_rating,
        {"from": deployer},
    )
    tx.wait(1)

    tx = ride_rater.setRatingBounds_(min_rating, max_rating, {"from": deployer},)
    tx.wait(1)

    assert ride_driver_details.calculateIndividualScore_(deployer) == score
