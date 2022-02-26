import pytest
import math
import brownie
import scripts.utils as utils

badges = [10_000, 100_000, 500_000, 1_000_000, 2_000_000]


@pytest.fixture(scope="module", autouse=True)
def ride_badge(ride_hub, RideTestBadge, Contract, deployer):
    contract_ride_badge = Contract.from_abi(
        "RideTestBadge", ride_hub[0].address, RideTestBadge.abi, deployer
    )
    yield contract_ride_badge


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


@pytest.mark.parametrize(
    "badges",
    [
        [10_000, 100_000, 500_000, 1_000_000],
        [10_000, 100_000, 500_000, 1_000_000, 2_000_000, 3_000_000],
    ],
)
def test_setBadgesMaxScores_revert(ride_badge, deployer, badges):
    with brownie.reverts(
        "RideLibBadge: Input array length must be one less than RideBadge.Badges"
    ):
        ride_badge.setBadgesMaxScores(badges, {"from": deployer})


def test_setBadgesMaxScores(ride_badge, deployer):
    assert ride_badge.sBadgeToBadgeMaxScore_(0) != badges[0]
    assert ride_badge.sBadgeToBadgeMaxScore_(1) != badges[1]
    assert ride_badge.sBadgeToBadgeMaxScore_(2) != badges[2]
    assert ride_badge.sBadgeToBadgeMaxScore_(3) != badges[3]
    assert ride_badge.sBadgeToBadgeMaxScore_(4) != badges[4]

    tx = ride_badge.setBadgesMaxScores(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.sBadgeToBadgeMaxScore_(0) == badges[0]
    assert ride_badge.sBadgeToBadgeMaxScore_(1) == badges[1]
    assert ride_badge.sBadgeToBadgeMaxScore_(2) == badges[2]
    assert ride_badge.sBadgeToBadgeMaxScore_(3) == badges[3]
    assert ride_badge.sBadgeToBadgeMaxScore_(4) == badges[4]


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setBadgesMaxScores_event(ride_badge, deployer):
    tx = ride_badge.setBadgesMaxScores(badges, {"from": deployer})
    tx.wait(1)

    assert tx.events["SetBadgesMaxScores"]["sender"] == deployer
    assert tx.events["SetBadgesMaxScores"]["scores"] == badges


def test_getBadgeToBadgeMaxScore(ride_badge, deployer):
    tx = ride_badge.setBadgesMaxScores(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.getBadgeToBadgeMaxScore(0) == badges[0]
    assert ride_badge.getBadgeToBadgeMaxScore(1) == badges[1]
    assert ride_badge.getBadgeToBadgeMaxScore(2) == badges[2]
    assert ride_badge.getBadgeToBadgeMaxScore(3) == badges[3]
    assert ride_badge.getBadgeToBadgeMaxScore(4) == badges[4]


def test_getDriverToDriverReputation(ride_badge, deployer):
    id = 69
    uri = "testabc"
    max_metres_per_trip = 501
    metres_travelled = 201
    count_start = 55
    count_end = 44
    total_rating = 113
    count_rating = 228

    tx = ride_badge.ssDriverToDriverReputation_(
        deployer,
        id,
        uri,
        max_metres_per_trip,
        metres_travelled,
        count_start,
        count_end,
        total_rating,
        count_rating,
        {"from": deployer},
    )
    tx.wait(1)

    assert ride_badge.getDriverToDriverReputation(deployer)[0] == id
    assert ride_badge.getDriverToDriverReputation(deployer)[1] == uri
    assert ride_badge.getDriverToDriverReputation(deployer)[2] == max_metres_per_trip
    assert ride_badge.getDriverToDriverReputation(deployer)[3] == metres_travelled
    assert ride_badge.getDriverToDriverReputation(deployer)[4] == count_start
    assert ride_badge.getDriverToDriverReputation(deployer)[5] == count_end
    assert ride_badge.getDriverToDriverReputation(deployer)[6] == total_rating
    assert ride_badge.getDriverToDriverReputation(deployer)[7] == count_rating
