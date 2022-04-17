import pytest
import brownie
import scripts.utils as utils
import scripts.post_deployment_setup as pds
import scripts.execution_patterns as ep
import scripts.hive_utils as hu

"""
When launching Ride in a new region, a Hive (DAO) must first be setup in that location (Hive per state/country)
"""


chain = brownie.network.state.Chain()


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


#####################################
##### ------------------------- #####
##### ----- Hive Creation ----- #####
##### ------------------------- #####
#####################################


def test_hive_creation(
    sample_hive,
    ride_token,
    ride_runner_detail,
    ride_runner_registry,
    ride_multi_sigs,
    person2,
    person3,
):
    # 1 # hive creation
    hive_governance_token, _, _ = sample_hive

    # 2 # give initial hive administrators voting power
    hu.get_voting_power(
        ride_token, hive_governance_token, ride_multi_sigs, [person2, person3]
    )

    # 3 # one administrator registering self as runner (optional)
    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[0] == 0
    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[3] == 0

    max_metres_per_trip = 555
    tx = ride_runner_registry.registerAsRunner(max_metres_per_trip, {"from": person2})
    tx.wait(1)

    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[0] != 0
    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[3] == max_metres_per_trip


###################################################
##### --------------------------------------- #####
##### ---------- Hive Setting Fees ---------- #####
##### --------------------------------------- #####
###################################################


def test_hive_set_fees(
    sample_hive,
    ride_token,
    ride_hub,
    ride_runner_detail,
    ride_runner_registry,
    ride_fee,
    ride_currency_registry,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
):
    # 0 # setup
    _, hive_timelock, hive_governor = sample_hive

    test_hive_creation(
        sample_hive,
        ride_token,
        ride_runner_detail,
        ride_runner_registry,
        ride_multi_sigs,
        person2,
        person3,
    )

    key_USD = ride_currency_registry.getKeyFiat("USD")

    assert ride_fee.getCancellationFee(hive_timelock.address, key_USD) == 0
    assert ride_fee.getBaseFee(hive_timelock.address, key_USD) == 0
    assert ride_fee.getCostPerMinute(hive_timelock.address, key_USD) == 0
    assert ride_fee.getCostPerMetre(hive_timelock.address, key_USD) == 0

    args = (
        key_USD,
        "5 ether",
    )
    encoded_function1 = ride_fee.setCancellationFee.encode_input(*args)

    args = (
        key_USD,
        "3 ether",
    )
    encoded_function2 = ride_fee.setBaseFee.encode_input(*args)

    args = (
        key_USD,
        "0.0008 ether",
    )
    encoded_function3 = ride_fee.setCostPerMinute.encode_input(*args)

    args = (
        key_USD,
        "0.0005 ether",
    )
    encoded_function4 = ride_fee.setCostPerMetre.encode_input(*args)

    ep.governance_process(
        [encoded_function1, encoded_function2, encoded_function3, encoded_function4],
        [
            ride_hub[0].address,
            ride_hub[0].address,
            ride_hub[0].address,
            ride_hub[0].address,
        ],
        hive_governor,
        ride_access_control,
        deployer,
        person3,
        {person2: 1, person3: 1},
        deployer,
    )

    assert ride_fee.getCancellationFee(hive_timelock.address, key_USD) == "5 ether"
    assert ride_fee.getBaseFee(hive_timelock.address, key_USD) == "3 ether"
    assert ride_fee.getCostPerMinute(hive_timelock.address, key_USD) == "0.0008 ether"
    assert ride_fee.getCostPerMetre(hive_timelock.address, key_USD) == "0.0005 ether"


#######################################################################
##### ----------------------------------------------------------- #####
##### ---------- Hive Setting Minimum Dispute Duration ---------- #####
##### ----------------------------------------------------------- #####
#######################################################################


def test_hive_set_min_dispute_duration(
    sample_hive,
    ride_token,
    ride_hub,
    ride_runner_detail,
    ride_runner_registry,
    ride_job_board,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
):
    # 0 # setup
    _, hive_timelock, hive_governor = sample_hive

    test_hive_creation(
        sample_hive,
        ride_token,
        ride_runner_detail,
        ride_runner_registry,
        ride_multi_sigs,
        person2,
        person3,
    )

    min_dispute_duration = ride_job_board.getMinDisputeDuration()
    assert min_dispute_duration > 0
    assert ride_job_board.getHiveToDisputeDuration(hive_timelock.address) == 0

    # 1 # will revert if duration value is less than minimum
    with brownie.reverts("TimelockController: underlying transaction reverted"):
        # due to: LibJobBoard: duration less than minimum duration
        duration = min_dispute_duration - 1
        args = (duration,)
        encoded_function1 = ride_job_board.setHiveToDisputeDuration.encode_input(*args)

        ep.governance_process(
            [encoded_function1,],
            [ride_hub[0].address,],
            hive_governor,
            ride_access_control,
            deployer,
            person3,
            {person2: 1, person3: 1},
            deployer,
        )

    # 2 # set duration for this Hive
    duration = min_dispute_duration + 1
    args = (duration,)
    encoded_function1 = ride_job_board.setHiveToDisputeDuration.encode_input(*args)

    ep.governance_process(
        [encoded_function1,],
        [ride_hub[0].address,],
        hive_governor,
        ride_access_control,
        deployer,
        person3,
        {person2: 1, person3: 1},
        deployer,
    )

    assert ride_job_board.getHiveToDisputeDuration(hive_timelock.address) == duration


###############################################
##### ----------------------------------- #####
##### ---------- Hive Ban User ---------- #####
##### ----------------------------------- #####
###############################################


def test_hive_ban_user(
    sample_hive,
    ride_token,
    ride_hub,
    ride_runner_detail,
    ride_runner_registry,
    ride_penalty,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
    person1,
):
    # 0 # setup
    _, hive_timelock, hive_governor = sample_hive

    test_hive_creation(
        sample_hive,
        ride_token,
        ride_runner_detail,
        ride_runner_registry,
        ride_multi_sigs,
        person2,
        person3,
    )

    assert (
        ride_penalty.getUserToHiveToBanEndTimestamp(person1, hive_timelock.address) == 0
    )
    assert (
        ride_penalty.getUserToHiveToBanEndTimestamp(person2, hive_timelock.address) == 0
    )
    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[0] != 0  # is runner

    time_before = chain.time()

    # 1 # ban normal requester, and possible to ban runner as well
    duration = 99999
    args = (
        [person1, person2],
        [duration, duration],
    )
    encoded_function1 = ride_penalty.banUsers.encode_input(*args)

    _, tx = ep.governance_process(
        [encoded_function1,],
        [ride_hub[0].address,],
        hive_governor,
        ride_access_control,
        deployer,
        person3,
        {person2: 1, person3: 1},
        deployer,
    )

    assert (
        ride_penalty.getUserToHiveToBanEndTimestamp(person1, hive_timelock.address)
        > time_before
        + duration  # as more duration pass before ban end timestamp is set
    )
    assert (
        ride_penalty.getUserToHiveToBanEndTimestamp(person2, hive_timelock.address)
        > time_before
        + duration  # as more duration pass before ban end timestamp is set
    )


#################################################
##### ------------------------------------- #####
##### ----- some rando joins the Hive ----- #####
##### ------------------------------------- #####
#################################################


def new_runner_joins(
    sample_hive,
    ride_token,
    ride_hub,
    ride_runner_detail,
    ride_runner_registry,
    ride_fee,
    ride_currency_registry,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
    persons,
):
    # 0 # setup
    _, hive_timelock, hive_governor = sample_hive

    test_hive_set_fees(
        sample_hive,
        ride_token,
        ride_hub,
        ride_runner_detail,
        ride_runner_registry,
        ride_fee,
        ride_currency_registry,
        ride_access_control,
        ride_multi_sigs,
        deployer,
        person2,
        person3,
    )

    for person in persons:
        # 1 # vote if new user should join as runner (success)
        assert ride_runner_detail.getRunnerToRunnerDetail(person)[1] == ""
        assert (
            ride_runner_detail.getRunnerToRunnerDetail(person)[2]
            != hive_timelock.address
        )

        uri = "new runner docs"
        args = (
            person,
            uri,
        )
        encoded_function = ride_runner_registry.approveApplicant.encode_input(*args)
        ep.governance_process(
            [encoded_function],
            [ride_hub[0].address],
            hive_governor,
            ride_access_control,
            deployer,
            person3,
            {person2: 1, person3: 1},
            deployer,
        )

        assert ride_runner_detail.getRunnerToRunnerDetail(person)[1] != ""
        assert (
            ride_runner_detail.getRunnerToRunnerDetail(person)[2]
            == hive_timelock.address
        )

        # 2 # complete runner registration
        assert ride_runner_detail.getRunnerToRunnerDetail(person)[0] == 0
        assert ride_runner_detail.getRunnerToRunnerDetail(person)[3] == 0

        max_metres_per_trip = 565
        tx = ride_runner_registry.registerAsRunner(
            max_metres_per_trip, {"from": person}
        )
        tx.wait(1)

        assert ride_runner_detail.getRunnerToRunnerDetail(person)[0] != 0
        assert (
            ride_runner_detail.getRunnerToRunnerDetail(person)[3] == max_metres_per_trip
        )


def test_new_runner_joins(
    sample_hive,
    ride_token,
    ride_hub,
    ride_runner_detail,
    ride_runner_registry,
    ride_fee,
    ride_currency_registry,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
    person4,
    person7,
):
    new_runner_joins(
        sample_hive,
        ride_token,
        ride_hub,
        ride_runner_detail,
        ride_runner_registry,
        ride_fee,
        ride_currency_registry,
        ride_access_control,
        ride_multi_sigs,
        deployer,
        person2,
        person3,
        [person4, person7,],
    )


###########################################
##### ------------------------------- #####
##### ----- reset URI of runner ----- #####
##### ------------------------------- #####
###########################################


def test_hive_reset_runner_URI(
    sample_hive,
    ride_token,
    ride_hub,
    ride_runner_detail,
    ride_runner_registry,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
):
    # 0 # setup
    _, hive_timelock, hive_governor = sample_hive

    test_hive_creation(
        sample_hive,
        ride_token,
        ride_runner_detail,
        ride_runner_registry,
        ride_multi_sigs,
        person2,
        person3,
    )

    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[1] != ""

    new_uri = "hello new"
    args = (
        person2,
        new_uri,
    )
    encoded_function1 = ride_runner_registry.resetURI.encode_input(*args)

    _, tx = ep.governance_process(
        [encoded_function1,],
        [ride_hub[0].address,],
        hive_governor,
        ride_access_control,
        deployer,
        person3,
        {person2: 1, person3: 1},
        deployer,
    )

    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[1] == new_uri
