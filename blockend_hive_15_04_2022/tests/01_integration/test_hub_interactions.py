import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils
import scripts.post_deployment_setup as pds
import scripts.execution_patterns as ep
import scripts.hive_utils as hu

chain = brownie.network.state.Chain()

location_package = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["package location"]).hex()]
    )
)

location_destination = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"],
        ["0x" + eth_abi.encode_abi(["string"], ["destination location"]).hex()],
    )
)
#####################################
##### ------------------------- #####
##### ----- hive creation ----- #####
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

    # 2 # give initial hive representatives voting power
    hu.get_voting_power(
        ride_token, hive_governance_token, ride_multi_sigs, [person2, person3]
    )

    # 3 # one representative registering self as runner
    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[0] == 0
    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[3] == 0

    max_metres_per_trip = 555
    tx = ride_runner_registry.registerAsRunner(max_metres_per_trip, {"from": person2})
    tx.wait(1)

    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[0] != 0
    assert ride_runner_detail.getRunnerToRunnerDetail(person2)[3] == max_metres_per_trip


#########################################################
##### --------------------------------------------- #####
##### ---------- hive setting their fees ---------- #####
##### --------------------------------------------- #####
#########################################################


def test_hive_fees(
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
        deployer,
        {person2: 1, person3: 1},
        deployer,
    )

    assert ride_fee.getCancellationFee(hive_timelock.address, key_USD) == "5 ether"
    assert ride_fee.getBaseFee(hive_timelock.address, key_USD) == "3 ether"
    assert ride_fee.getCostPerMinute(hive_timelock.address, key_USD) == "0.0008 ether"
    assert ride_fee.getCostPerMetre(hive_timelock.address, key_USD) == "0.0005 ether"


#########################################################
##### --------------------------------------------- #####
##### ----- joining a hive to become a runner ----- #####
##### --------------------------------------------- #####
#########################################################


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
):
    # 0 # setup
    _, hive_timelock, hive_governor = sample_hive

    test_hive_fees(
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

    # 1 # vote if new user should join as runner (success)
    assert ride_runner_detail.getRunnerToRunnerDetail(person4)[1] == ""
    assert (
        ride_runner_detail.getRunnerToRunnerDetail(person4)[2] != hive_timelock.address
    )

    uri = "new runner docs"
    args = (
        person4,
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

    assert ride_runner_detail.getRunnerToRunnerDetail(person4)[1] != ""
    assert (
        ride_runner_detail.getRunnerToRunnerDetail(person4)[2] == hive_timelock.address
    )

    # 2 # complete runner registration
    assert ride_runner_detail.getRunnerToRunnerDetail(person4)[0] == 0
    assert ride_runner_detail.getRunnerToRunnerDetail(person4)[3] == 0

    max_metres_per_trip = 565
    tx = ride_runner_registry.registerAsRunner(max_metres_per_trip, {"from": person4})
    tx.wait(1)

    assert ride_runner_detail.getRunnerToRunnerDetail(person4)[0] != 0
    assert ride_runner_detail.getRunnerToRunnerDetail(person4)[3] == max_metres_per_trip


############################################
##### -------------------------------- #####
##### ----- requestors & runners ----- #####
##### -------------------------------- #####
############################################


@pytest.fixture(scope="module", autouse=True)
def requestor1(person5):
    yield person5


@pytest.fixture(scope="module", autouse=True)
def requestor2(person6):
    yield person6


@pytest.fixture(scope="module", autouse=True)
def runner1(person4):
    yield person4


###########################################
##### ------------------------------- #####
##### ----------- deposit ----------- #####
##### ------------------------------- #####
###########################################


def deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, person):
    amount = "100 ether"

    # 1 # --> convert ETH to wETH by sending ether to wETH contract (unique to this wETH contract)
    assert ride_WETH9.balanceOf(person) == 0

    tx = person.transfer(ride_WETH9.address, amount)
    tx.wait(1)

    assert ride_WETH9.balanceOf(person) == amount

    # 2 # --> approve RideHub contract to be able to handle user's wETH
    # NOTE: if in token contract, increaseAllowance/decreaseAllowance is available instead, use it!!
    # otherwise use approve, but keep best practice: https://ethereum.org/en/developers/tutorials/erc20-annotated-code/#allowance-functions
    assert ride_WETH9.allowance(person, ride_hub[0].address) == 0

    tx = ride_WETH9.approve(ride_hub[0].address, amount, {"from": person})
    tx.wait(1)

    assert ride_WETH9.allowance(person, ride_hub[0].address) == amount

    # 3 # --> user deposit wETH from wallet to RideHub contract
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)

    assert ride_holding.getHolding(person, key_wETH) == 0

    tx = ride_holding.depositTokens(key_wETH, amount, {"from": person})
    tx.wait(1)

    assert ride_holding.getHolding(person, key_wETH) == amount


def test_deposit(
    ride_WETH9,
    ride_hub,
    ride_currency_registry,
    ride_holding,
    requestor1,
    requestor2,
    runner1,
):
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requestor1)
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requestor2)
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, runner1)


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


###########################################
##### ------------------------------- #####
##### ------ main interactions ------ #####
##### ------       start       ------ #####
##### ------                   ------ #####

""" general notes/concepts
1.
    The "package" param passed into requestRunner represents 
the address of package that the runner should pick up, this 
package address would be set by the requestor. In ride-sharing, 
this would be the passenger's address. However, it could be a 
"friend" address where someone "calls a cab" for him/her.
It also allows the smart contract to be applied to food delivery
or any delivery in general, where the package address is the
address of the supplier where the item needs to be picked up from.

2.
"""


def _setup(
    sample_hive,
    ride_token,
    ride_hub,
    ride_currency_registry,
    ride_runner_detail,
    ride_runner_registry,
    ride_holding,
    ride_fee,
    ride_access_control,
    ride_multi_sigs,
    ride_WETH9,
    deployer,
    person2,
    person3,
    person4,
    requestor1,
    requestor2,
    runner1,
):
    test_new_runner_joins(
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
    )
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requestor1)
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requestor2)
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, runner1)


def test_base_case(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_token,
    ride_runner_detail,
    ride_runner_registry,
    ride_holding,
    ride_fee,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
    person4,
    requestor1,
    requestor2,
    runner1,
):
    """
    # # # no verification
    # # # no dispute
    # # # no cancel
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        sample_hive,
        ride_token,
        ride_hub,
        ride_currency_registry,
        ride_runner_detail,
        ride_runner_registry,
        ride_holding,
        ride_fee,
        ride_access_control,
        ride_multi_sigs,
        ride_WETH9,
        deployer,
        person2,
        person3,
        person4,
        requestor1,
        requestor2,
        runner1,
    )

    package = requestor1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requestor1 = utils.hub_holding(ride_hub).getHolding(requestor1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runner1, key_wETH)

    assert holding_requestor1 != 0
    assert holding_runner1 != 0

    # 1 # request runner
    tx = utils.hub_requestor(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requestor1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requestor's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requestor1, key_wETH
    ) == holding_requestor1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requestor1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # runner accepts job request
    tx = utils.hub_runner(ride_hub).acceptRequest(
        key_USD, key_wETH, job_ID, {"from": runner1},
    )
    tx.wait(1)

    # check # certain portion of runner's holdings locked up in vault
    assert utils.hub_holding(ride_hub).getHolding(
        runner1, key_wETH
    ) == holding_runner1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(runner1, key_wETH) == (
        value + cancellation_fee
    )

    # 3 # runner reaches package location, collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runner1},
    )
    tx.wait(1)

    # since not verified, countStart detail of requestor & runner does not increase
    assert (
        utils.hub_requestor_detail(ride_hub).getRequestorToRequestorDetail(requestor1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runner1)[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runner reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runner1},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 5 # runner completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runner1},)
    tx.wait(1)

    # since not verified, countEnd + metresTravelled detail of requestor & runner does not increase
    assert (
        utils.hub_requestor_detail(ride_hub).getRequestorToRequestorDetail(requestor1)[
            1
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runner1)[4] == 0
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runner1)[6] == 0

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runner, other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requestor1, key_wETH)
        == holding_requestor1 - value
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runner1, key_wETH)
        == holding_runner1 + value
    )


def test_req_cancel_pending(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_token,
    ride_runner_detail,
    ride_runner_registry,
    ride_holding,
    ride_fee,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
    person4,
    requestor1,
    requestor2,
    runner1,
):
    """
    # # # no verification
    # # # no dispute
    # # # requestor cancel at state == Pending
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        sample_hive,
        ride_token,
        ride_hub,
        ride_currency_registry,
        ride_runner_detail,
        ride_runner_registry,
        ride_holding,
        ride_fee,
        ride_access_control,
        ride_multi_sigs,
        ride_WETH9,
        deployer,
        person2,
        person3,
        person4,
        requestor1,
        requestor2,
        runner1,
    )

    package = requestor1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requestor1 = utils.hub_holding(ride_hub).getHolding(requestor1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runner1, key_wETH)

    assert holding_requestor1 != 0
    assert holding_runner1 != 0

    # 1 # request runner
    tx = utils.hub_requestor(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requestor1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requestor's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requestor1, key_wETH
    ) == holding_requestor1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requestor1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # requestor cancel
    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Pending"
    )

    tx = utils.hub_requestor(ride_hub).cancelFromRequestor(
        job_ID, {"from": requestor1},
    )
    tx.wait(1)

    # check # requestor funds fully refunded
    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    assert (
        utils.hub_holding(ride_hub).getHolding(requestor1, key_wETH)
        == holding_requestor1
    )
    assert utils.hub_holding(ride_hub).getVault(requestor1, key_wETH) == 0


def test_req_cancel_accepted(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_token,
    ride_runner_detail,
    ride_runner_registry,
    ride_holding,
    ride_fee,
    ride_access_control,
    ride_multi_sigs,
    deployer,
    person2,
    person3,
    person4,
    requestor1,
    requestor2,
    runner1,
):
    """
    # # # no verification
    # # # no dispute
    # # # requestor cancel at state == Accepted
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        sample_hive,
        ride_token,
        ride_hub,
        ride_currency_registry,
        ride_runner_detail,
        ride_runner_registry,
        ride_holding,
        ride_fee,
        ride_access_control,
        ride_multi_sigs,
        ride_WETH9,
        deployer,
        person2,
        person3,
        person4,
        requestor1,
        requestor2,
        runner1,
    )

    package = requestor1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requestor1 = utils.hub_holding(ride_hub).getHolding(requestor1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runner1, key_wETH)

    assert holding_requestor1 != 0
    assert holding_runner1 != 0

    # 1 # request runner
    tx = utils.hub_requestor(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requestor1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requestor's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requestor1, key_wETH
    ) == holding_requestor1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requestor1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # runner accepts job request
    tx = utils.hub_runner(ride_hub).acceptRequest(
        key_USD, key_wETH, job_ID, {"from": runner1},
    )
    tx.wait(1)

    # check # certain portion of runner's holdings locked up in vault
    assert utils.hub_holding(ride_hub).getHolding(
        runner1, key_wETH
    ) == holding_runner1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(runner1, key_wETH) == (
        value + cancellation_fee
    )

    # 3 # requestor cancel
    tx = utils.hub_requestor(ride_hub).cancelFromRequestor(
        job_ID, {"from": requestor1},
    )
    tx.wait(1)

    # check # requestor transfers cancellation fee to runner, other fund refunded
    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    assert (
        utils.hub_holding(ride_hub).getHolding(requestor1, key_wETH)
        == holding_requestor1 - cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(requestor1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runner1, key_wETH)
        == holding_runner1 + cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(runner1, key_wETH) == 0


# # # TODO: runner cancel at Accepted
# # # TODO: requestor cancel at Collected
# # # TODO: runner cancel at Collected
# # # TODO: requestor cancel at Delivered
# # # TODO: requestor dispute at state == Collected + dispute decision reverted
# # # TODO: requestor dispute at state == Collected + requestor cancelled
# # # TODO: requestor dispute at state == Collected + runner cancelled
# # # TODO: requestor dispute at state == Delivered + dispute decision reverted
# # # TODO: requestor dispute at state == Delivered + requestor cancelled
# # # TODO: requestor dispute at state == Delivered + runner accepts and completes job
# # # TODO: package verified (at collectPackage) + base case [requestor & runner details updated]
# # # TODO: package verified (at collectPackage) + cancel at state == Collected [requestor lose value]
# # # TODO: package verified (at collectPackage) + requestor dispute at state == Collected + dispute decision reverted
# # # TODO: package verified (at collectPackage) + requestor dispute at state == Collected + requestor cancelled
# # # TODO: package verified (at collectPackage) + requestor dispute at state == Collected + runner cancelled
# # # TODO: package verified (outside collectPackage), test all many many cases related to this . . .

##### ------                   ------ #####
##### ------        end        ------ #####
##### ------------------------------- #####
###########################################


###########################################
##### ------------------------------- #####
##### ----------- withdraw ---------- #####
##### ------------------------------- #####
###########################################


def test_withdraw(
    ride_hub, ride_currency_registry, ride_holding, ride_WETH9, requestor1
):
    # 1 # --> setup
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requestor1)

    # 2 # --> withdraw from RideHub to wallet
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)

    assert ride_WETH9.balanceOf(requestor1) == 0

    amount = ride_holding.getHolding(requestor1, key_wETH)

    tx = ride_holding.withdrawTokens(key_wETH, amount, {"from": requestor1})
    tx.wait(1)

    assert ride_holding.getHolding(requestor1, key_wETH) == 0

    # 3 # --> check wallet

    assert ride_WETH9.balanceOf(requestor1) == amount
