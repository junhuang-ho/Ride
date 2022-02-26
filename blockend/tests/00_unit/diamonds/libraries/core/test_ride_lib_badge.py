import pytest
import math
import brownie
import scripts.utils as utils

badges = [10_000, 100_000, 500_000, 1_000_000, 2_000_000]


@pytest.fixture(scope="module", autouse=True)
def ride_badge(ride_hub, RideTestBadge, Contract, deployer):
    yield Contract.from_abi(
        "RideTestBadge", ride_hub[0].address, RideTestBadge.abi, deployer
    )


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
        ride_badge.setBadgesMaxScores_(badges, {"from": deployer})


def test_setBadgesMaxScores(ride_badge, deployer):
    assert ride_badge.sBadgeToBadgeMaxScore_(0) != badges[0]
    assert ride_badge.sBadgeToBadgeMaxScore_(1) != badges[1]
    assert ride_badge.sBadgeToBadgeMaxScore_(2) != badges[2]
    assert ride_badge.sBadgeToBadgeMaxScore_(3) != badges[3]
    assert ride_badge.sBadgeToBadgeMaxScore_(4) != badges[4]

    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.sBadgeToBadgeMaxScore_(0) == badges[0]
    assert ride_badge.sBadgeToBadgeMaxScore_(1) == badges[1]
    assert ride_badge.sBadgeToBadgeMaxScore_(2) == badges[2]
    assert ride_badge.sBadgeToBadgeMaxScore_(3) == badges[3]
    assert ride_badge.sBadgeToBadgeMaxScore_(4) == badges[4]


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setBadgesMaxScores_event(ride_badge, deployer):
    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert tx.events["SetBadgesMaxScores"]["sender"] == deployer
    assert tx.events["SetBadgesMaxScores"]["scores"] == badges


def test_getBadgesCount(ride_badge):
    assert ride_badge.getBadgesCount_() == len(badges) + 1


def test_getBadge(ride_badge, deployer):
    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.getBadge_(0) == 0
    assert ride_badge.getBadge_(10000) == 0
    assert ride_badge.getBadge_(10001) == 1
    assert ride_badge.getBadge_(100000) == 1
    assert ride_badge.getBadge_(100001) == 2
    assert ride_badge.getBadge_(500000) == 2
    assert ride_badge.getBadge_(500001) == 3
    assert ride_badge.getBadge_(1000000) == 3
    assert ride_badge.getBadge_(1000001) == 4
    assert ride_badge.getBadge_(2000000) == 4
    assert ride_badge.getBadge_(2000001) == 5
    assert ride_badge.getBadge_(9999999) == 5


@brownie.test.given(
    value=brownie.test.strategy("uint256", min_value=0, max_value=10000)
)
def test_getBadge_property(ride_badge, deployer, value):
    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.getBadge_(value) == 0


@brownie.test.given(
    value=brownie.test.strategy("uint256", min_value=10001, max_value=100000)
)
def test_getBadge_property(ride_badge, deployer, value):
    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.getBadge_(value) == 1


@brownie.test.given(
    value=brownie.test.strategy("uint256", min_value=100001, max_value=500000)
)
def test_getBadge_property(ride_badge, deployer, value):
    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.getBadge_(value) == 2


@brownie.test.given(
    value=brownie.test.strategy("uint256", min_value=500001, max_value=1000000)
)
def test_getBadge_property(ride_badge, deployer, value):
    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.getBadge_(value) == 3


@brownie.test.given(
    value=brownie.test.strategy("uint256", min_value=1000001, max_value=2000000)
)
def test_getBadge_property(ride_badge, deployer, value):
    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.getBadge_(value) == 4


@brownie.test.given(value=brownie.test.strategy("uint256", min_value=2000001))
def test_getBadge_property(ride_badge, deployer, value):
    tx = ride_badge.setBadgesMaxScores_(badges, {"from": deployer})
    tx.wait(1)

    assert ride_badge.getBadge_(value) == 5


def test_calculateScore_when_countStart_zero(ride_badge, deployer):
    assert ride_badge.sDriverToDriverReputation_(deployer)[5] == 0  # countStart
    assert ride_badge.calculateScore_() == 0


def test_calculateScore(ride_hub, ride_badge, deployer, Contract, RideTestRater):
    id = 1
    uri = "test123"
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

    contract_ride_rater = Contract.from_abi(
        "RideTestRater", ride_hub[0].address, RideTestRater.abi, deployer
    )
    tx = contract_ride_rater.setRatingBounds_(
        min_rating, max_rating, {"from": deployer},
    )
    tx.wait(1)

    assert ride_badge.calculateScore_() == score
