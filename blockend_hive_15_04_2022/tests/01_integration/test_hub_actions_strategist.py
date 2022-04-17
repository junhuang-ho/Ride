import pytest
import brownie
import scripts.utils as utils
import scripts.execution_patterns as ep
import scripts.hive_utils as hu


@pytest.fixture(scope="module", autouse=True)
def role_strategist(ride_access_control):
    yield ride_access_control.getRole("STRATEGIST_ROLE")


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_build(
    ride_hub,
    ride_token,
    ride_hive_factory,
    ride_runner_detail,
    deployer,
    person1,
    person2,
    person3,
    ride_multi_sigs,
):
    # 1 # address without role cannot execute

    with brownie.reverts():
        ride_hive_factory.build(
            ride_token,
            "TukTukers",
            "TT",
            1,
            1,
            10,
            0,
            4,
            [person2, person3],
            ["identity 1", "identidy 2"],
            {"from": deployer},
        )

    # 2 # execute

    hu.build_hive(
        ride_hub[0],
        ride_token,
        ride_hive_factory,
        ride_runner_detail,
        deployer,
        person1,
        person2,
        person3,
        ride_multi_sigs,
    )


# setRatingBounds
# setJobLifespan
# setMinDisputeDuration
# addXperYPriceFeed
# deriveXPerYPriceFeed
# removeAddedXPerYPriceFeed
# removeDerivedXPerYPriceFeed
# registerFiat
# registerCrypto
# removeCurrency
