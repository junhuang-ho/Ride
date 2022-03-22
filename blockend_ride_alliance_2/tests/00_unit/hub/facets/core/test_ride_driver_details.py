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


def test_getDriverToDriverDetails(ride_driver_details, deployer):
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

    assert ride_driver_details.getDriverToDriverDetails(deployer)[0] == id
    assert ride_driver_details.getDriverToDriverDetails(deployer)[1] == uri
    assert ride_driver_details.getDriverToDriverDetails(deployer)[2] == alliance
    assert (
        ride_driver_details.getDriverToDriverDetails(deployer)[3] == max_metres_per_trip
    )
    assert ride_driver_details.getDriverToDriverDetails(deployer)[4] == metres_travelled
    assert ride_driver_details.getDriverToDriverDetails(deployer)[5] == count_start
    assert ride_driver_details.getDriverToDriverDetails(deployer)[6] == count_end
    assert ride_driver_details.getDriverToDriverDetails(deployer)[7] == total_rating
    assert ride_driver_details.getDriverToDriverDetails(deployer)[8] == count_rating


def test_calculateIndividualScore_when_countStart_zero(ride_driver_details, deployer):
    assert ride_driver_details.sDriverToDriverDetails_(deployer)[5] == 0  # countStart
    assert ride_driver_details.calculateIndividualScore(deployer) == 0


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

    assert ride_driver_details.calculateIndividualScore(deployer) == score


def test_calculateCollectiveScore(ride_driver_details, ride_rater, deployer, person1):
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

    tx = ride_rater.setRatingBounds_(min_rating, max_rating, {"from": deployer},)
    tx.wait(1)

    tx = ride_driver_details.ssAllianceToDrivers_(alliance, [deployer, person1])
    tx.wait(1)

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

    tx = ride_driver_details.ssDriverToDriverDetails_(
        person1,
        2,
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

    score = math.floor(
        ((metres_travelled * 2) * (count_end * 2) * (total_rating * 2))
        / ((count_start * 2) * (count_rating * 2) * (max_rating * 2))
    )

    assert ride_driver_details.calculateCollectiveScore(alliance) == score
