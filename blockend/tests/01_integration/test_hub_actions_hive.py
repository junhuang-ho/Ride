import pytest
import brownie
import scripts.utils as utils
import scripts.post_deployment_setup as pds
import scripts.execution_patterns as ep
import scripts.hive_utils as hu


@pytest.fixture(scope="module", autouse=True)
def role_hive(ride_access_control):
    yield ride_access_control.getRole("HIVE_ROLE")


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_approveApplicant(
    sample_hive,
    ride_runner_registry,
    ride_hub,
    ride_token,
    ride_runner_detail,
    ride_access_control,
    deployer,
    person1,
    person2,
    person3,
    ride_multi_sigs,
):
    hive_governance_token, hive_timelock, hive_governor = sample_hive

    uri = "new tuker"
    with brownie.reverts():
        ride_runner_registry.approveApplicant(person1, uri, {"from": person1})

    hu.get_voting_power(
        ride_token, hive_governance_token, ride_multi_sigs, [person2, person3]
    )

    assert ride_runner_detail.getRunnerToRunnerDetail(person1)[1] == ""
    assert (
        ride_runner_detail.getRunnerToRunnerDetail(person1)[2] != hive_timelock.address
    )

    args = (
        person1,
        uri,
    )
    encoded_function = ride_runner_registry.approveApplicant.encode_input(*args)
    ep.governance_process(
        [encoded_function],
        [ride_hub[0].address],
        hive_governor,
        ride_access_control,
        deployer,
        deployer,
        {person2: 1, person3: 1},
        deployer,
    )

    assert ride_runner_detail.getRunnerToRunnerDetail(person1)[1] != ""
    assert (
        ride_runner_detail.getRunnerToRunnerDetail(person1)[2] == hive_timelock.address
    )

