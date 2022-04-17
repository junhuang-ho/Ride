import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils
import scripts.post_deployment_setup as pds
import scripts.execution_patterns as ep
import scripts.hive_utils as hu
import test_hive_setup as ths


chain = brownie.network.state.Chain()

#######################################################
##### ------------------------------------------- #####
##### ----- set location details in bytes32 ----- #####
##### ------------------------------------------- #####
#######################################################

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

############################################
##### -------------------------------- #####
##### ----- requesters & runners ----- #####
##### -------------------------------- #####
############################################


@pytest.fixture(scope="module", autouse=True)
def requester1(person5):
    yield person5


@pytest.fixture(scope="module", autouse=True)
def requester2(person6):
    yield person6


@pytest.fixture(scope="module", autouse=True)
def runners(
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
    ths.new_runner_joins(
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
        [person4, person7],
    )
    yield [person4, person7]


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


# @pytest.mark.skip(reason="tmp")
def test_deposit(
    ride_WETH9,
    ride_hub,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requester1)
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requester2)
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, runners[0])


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
the address of package that the runners[0] should pick up, this 
package address would be set by the requester. In ride-sharing, 
this would be the passenger's address. However, it could be a 
"friend" address where someone "calls a cab" for him/her.
It also allows the smart contract to be applied to food delivery
or any delivery in general, where the package address is the
address of the supplier where the item needs to be picked up from.

2.
"""


def _setup(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_WETH9,
    requester1,
    requester2,
    runners,
):
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requester1)
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requester2)
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, runners[0])


# @pytest.mark.skip(reason="tmp")
def test_base_case(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # no dispute
    # # # no cancel
    # # # one to one
        # # # one runners[0] has one active job
        # # # one requester has one active job
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    # 1 # request runners[0]
    tx = utils.hub_requester(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requester1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requester's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requester1, key_wETH
    ) == holding_requester1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # runners[0] accepts job request
    tx = utils.hub_runner(ride_hub).acceptRequest(
        key_USD, key_wETH, job_ID, {"from": runners[0]},
    )
    tx.wait(1)

    # check # certain portion of runners[0]'s holdings locked up in vault
    assert utils.hub_holding(ride_hub).getHolding(
        runners[0], key_wETH
    ) == holding_runner1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
        value + cancellation_fee
    )

    # 3 # runners[0] reaches package location, collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 5 # runners[0] completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runners[0]},)
    tx.wait(1)

    # since not verified, countEnd + metresTravelled detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            1
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4] == 0
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 0

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runners[0], other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value
    )


# @pytest.mark.skip(reason="tmp")
def test_req_cancel_at_pending(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # no dispute
    # # # requester cancel at state == Pending
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    # 1 # request runners[0]
    tx = utils.hub_requester(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requester1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requester's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requester1, key_wETH
    ) == holding_requester1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # requester cancel
    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Pending"
    )

    tx = utils.hub_requester(ride_hub).cancelFromRequestor(
        job_ID, {"from": requester1},
    )
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # requester funds fully refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0


# @pytest.mark.skip(reason="tmp")
def test_req_cancel_at_accepted(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # no dispute
    # # # requester cancel at state == Accepted
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    # 1 # request runners[0]
    tx = utils.hub_requester(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requester1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requester's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requester1, key_wETH
    ) == holding_requester1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # runners[0] accepts job request
    tx = utils.hub_runner(ride_hub).acceptRequest(
        key_USD, key_wETH, job_ID, {"from": runners[0]},
    )
    tx.wait(1)

    # check # certain portion of runners[0]'s holdings locked up in vault
    assert utils.hub_holding(ride_hub).getHolding(
        runners[0], key_wETH
    ) == holding_runner1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
        value + cancellation_fee
    )

    # 3 # requester cancel
    tx = utils.hub_requester(ride_hub).cancelFromRequestor(
        job_ID, {"from": requester1},
    )
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # requester transfers cancellation fee to runners[0], other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


# @pytest.mark.skip(reason="tmp")
def test_run_cancel_at_accepted(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # no dispute
    # # # runners[0] cancel at state == Accepted
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    # 1 # request runners[0]
    tx = utils.hub_requester(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requester1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requester's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requester1, key_wETH
    ) == holding_requester1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # runners[0] accepts job request
    tx = utils.hub_runner(ride_hub).acceptRequest(
        key_USD, key_wETH, job_ID, {"from": runners[0]},
    )
    tx.wait(1)

    # check # certain portion of runners[0]'s holdings locked up in vault
    assert utils.hub_holding(ride_hub).getHolding(
        runners[0], key_wETH
    ) == holding_runner1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
        value + cancellation_fee
    )

    # 3 # runners[0] cancel
    tx = utils.hub_runner(ride_hub).cancelFromRunner(job_ID, {"from": runners[0]})
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # runners[0] transfer cancellation fee to requester, other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 + cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 - cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


def request_and_accept(
    ride_hub,
    package,
    key_USD,
    key_wETH,
    estimated_minutes,
    estimated_metres,
    hive_timelock,
    holding_requester1,
    holding_runner1,
    requester1,
    runners,
):
    # 1 # request runners[0]
    tx = utils.hub_requester(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requester1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requester's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requester1, key_wETH
    ) == holding_requester1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # runners[0] accepts job request
    tx = utils.hub_runner(ride_hub).acceptRequest(
        key_USD, key_wETH, job_ID, {"from": runners[0]},
    )
    tx.wait(1)

    # check # certain portion of runners[0]'s holdings locked up in vault
    assert utils.hub_holding(ride_hub).getHolding(
        runners[0], key_wETH
    ) == holding_runner1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
        value + cancellation_fee
    )

    return job_ID, value, cancellation_fee


# @pytest.mark.skip(reason="tmp")
def test_req_cancel_at_collected(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # no dispute
    # # # requester cancel at state == Collected
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location, collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # 4 # requester cancel
    tx = utils.hub_requester(ride_hub).cancelFromRequestor(
        job_ID, {"from": requester1},
    )
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # requester transfers cancellation fee to runners[0], other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


# @pytest.mark.skip(reason="tmp")
def test_run_cancel_at_collected(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # no dispute
    # # # requester cancel at state == Collected
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location, collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # 4 # runners[0] cancel
    tx = utils.hub_runner(ride_hub).cancelFromRunner(job_ID, {"from": runners[0]})
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # runners[0] transfer VALUE to requester, other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 + value
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 - value
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


# @pytest.mark.skip(reason="tmp")
def test_req_cancel_at_delivered(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # no dispute
    # # # requester cancel at state == Delivered
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location, collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # 5 # requester cancel
    tx = utils.hub_requester(ride_hub).cancelFromRequestor(
        job_ID, {"from": requester1},
    )
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # requester transfers VALUE to runners[0], other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


# @pytest.mark.skip(reason="tmp")
def test_dispute_at_collected_then_decision_reverted(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # dispute
    # # # no cancel
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location (or not), collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # 4 # requester dispute
    tx = utils.hub_requester(ride_hub).dispute(job_ID, True, {"from": requester1},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 5 # runners[0] cannot "click" deliverPackage
    with brownie.reverts("Runner: requestor dispute"):
        tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
        tx.wait(1)

    # 6 # requester decides to revert dispute decision
    tx = utils.hub_requester(ride_hub).dispute(job_ID, False, {"from": requester1},)
    tx.wait(1)

    # proceed as base case #

    # 7 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 8 # runners[0] completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runners[0]},)
    tx.wait(1)

    # since not verified, countEnd + metresTravelled detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            1
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4] == 0
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 0

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runners[0], other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value
    )


# @pytest.mark.skip(reason="tmp")
def test_dispute_at_collected_then_req_cancel(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # dispute
    # # # requester cancel at state == Collected
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location (or not), collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # requester dispute
    tx = utils.hub_requester(ride_hub).dispute(job_ID, True, {"from": requester1},)
    tx.wait(1)

    # 5 # runners[0] cannot "click" deliverPackage
    with brownie.reverts("Runner: requestor dispute"):
        tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
        tx.wait(1)

    # 6 # requester cancel
    tx = utils.hub_requester(ride_hub).cancelFromRequestor(
        job_ID, {"from": requester1},
    )
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # requester transfers cancellation fee to runners[0], other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


# @pytest.mark.skip(reason="tmp")
def test_dispute_at_collected_then_run_cancel(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # dispute
    # # # runners[0] cancel at state == Collected
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location (or not), collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # requester dispute
    tx = utils.hub_requester(ride_hub).dispute(job_ID, True, {"from": requester1},)
    tx.wait(1)

    # 5 # runners[0] cannot "click" deliverPackage
    with brownie.reverts("Runner: requestor dispute"):
        tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
        tx.wait(1)

    # 6 # runners[0] cancel
    tx = utils.hub_runner(ride_hub).cancelFromRunner(job_ID, {"from": runners[0]})
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # runners[0] transfer VALUE to requester, other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 + value
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 - value
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


# @pytest.mark.skip(reason="tmp")
def test_dispute_at_delivered_runner_no_accept_then_decision_reverted(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # dispute
    # # # no cancel
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location (or not), collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # 5 # requester dispute
    tx = utils.hub_requester(ride_hub).dispute(job_ID, True, {"from": requester1},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 6 # runners[0] cannot "click" completeJob IF not accept requester decision
    with brownie.reverts("Runner: not accept"):
        tx = utils.hub_runner(ride_hub).completeJob(
            job_ID, False, {"from": runners[0]},
        )
        tx.wait(1)

    # 7 # requester decides to revert dispute decision
    tx = utils.hub_requester(ride_hub).dispute(job_ID, False, {"from": requester1},)
    tx.wait(1)

    # proceed as base case #

    # 8 # runners[0] completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runners[0]},)
    tx.wait(1)

    # since not verified, countEnd + metresTravelled detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            1
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4] == 0
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 0

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runners[0], other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value
    )


# @pytest.mark.skip(reason="tmp")
def test_dispute_at_delivered_runner_accept(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # dispute
    # # # no cancel
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location (or not), collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # 5 # requester dispute
    tx = utils.hub_requester(ride_hub).dispute(job_ID, True, {"from": requester1},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 6 # runners[0] "click" completeJob as runners[0] accept requester decision
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runners[0]},)
    tx.wait(1)

    # since not verified, countEnd + metresTravelled detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            1
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4] == 0
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 0

    # check # since dispute and runners[0] accept, requester transfers cancellation fee, other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - cancellation_fee
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + cancellation_fee
    )


# @pytest.mark.skip(reason="tmp")
def test_dispute_at_delivered_runner_then_req_cancel(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # dispute
    # # # cancel
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location (or not), collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # 5 # requester dispute
    tx = utils.hub_requester(ride_hub).dispute(job_ID, True, {"from": requester1},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 6 # requester cancel
    tx = utils.hub_requester(ride_hub).cancelFromRequestor(
        job_ID, {"from": requester1},
    )
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # requester transfers cancellation fee to runners[0], other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + cancellation_fee
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


# verified


# @pytest.mark.skip(reason="tmp")
def test_verified_base_case(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # verification
    # # # no dispute
    # # # no cancel
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location, collect
    package_zero = requester1.address  # verify package address
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since verified, countStart detail of requester & runners[0] does increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 1
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 1

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 5 # runners[0] completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runners[0]},)
    tx.wait(1)

    # since verified, countEnd + metresTravelled detail of requester & runners[0] does increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            1
        ]
        == 1
    )
    assert (
        utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4]
        == estimated_metres
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 1

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runners[0], other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value
    )


# @pytest.mark.skip(reason="tmp")
def test_verified_req_cancel_at_collected(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # verification
    # # # no dispute
    # # # requester cancel at state == Collected
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location, collect
    package_zero = requester1.address  # verify package address
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # 4 # requester cancel
    tx = utils.hub_requester(ride_hub).cancelFromRequestor(
        job_ID, {"from": requester1},
    )
    tx.wait(1)

    assert (
        utils.PROPOSAL_STATE[
            utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[0]
        ]
        == "Cancelled"
    )

    # check # requester transfers VALUE to runners[0], other funds refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == 0

    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value
    )
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == 0


# @pytest.mark.skip(reason="tmp")
def test_init_not_verified_then_dispute_then_verify_then_revert_dispute(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # late verification after dispute
    # # # dispute
    # # # no cancel
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location (or not), collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # 4 # requester dispute
    tx = utils.hub_requester(ride_hub).dispute(job_ID, True, {"from": requester1},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 5 # runners[0] cannot "click" deliverPackage due to dispute
    with brownie.reverts("Runner: requestor dispute"):
        tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
        tx.wait(1)

    # 6 # runners[0] verifies package, click verify
    tx = utils.hub_runner(ride_hub).verify(
        job_ID, requester1.address, {"from": runners[0]},
    )
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 7 # requester decides to revert dispute decision
    tx = utils.hub_requester(ride_hub).dispute(job_ID, False, {"from": requester1},)
    tx.wait(1)

    # 8 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 9 # runners[0] completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runners[0]},)
    tx.wait(1)

    # since verified, countStart detail of requester & runners[0] does increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 1
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 1

    # since verified, countEnd + metresTravelled detail of requester & runners[0] does increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            1
        ]
        == 1
    )
    assert (
        utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4]
        == estimated_metres
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 1

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runners[0], other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value
    )


# @pytest.mark.skip(reason="tmp")
def test_no_dispute_verify_after_deliver_before_complete(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # late verification
    # # # no dispute
    # # # no cancel
    # # # one to one
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    job_ID, value, cancellation_fee = request_and_accept(
        ride_hub,
        package,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        hive_timelock,
        holding_requester1,
        holding_runner1,
        requester1,
        runners,
    )

    # # 1 # request runners[0]
    # tx = utils.hub_requester(ride_hub).requestRunner(
    #     hive_timelock.address,
    #     package,
    #     location_package,
    #     location_destination,
    #     key_USD,
    #     key_wETH,
    #     estimated_minutes,
    #     estimated_metres,
    #     {"from": requester1},
    # )
    # tx.wait(1)

    # job_ID = tx.events["RequestRunner"]["jobId"]

    # # check # certain portion of requester's holdings locked up in vault
    # value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    # cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
    #     10
    # ]  # (cancellation fee)
    # assert utils.hub_holding(ride_hub).getHolding(
    #     requester1, key_wETH
    # ) == holding_requester1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
    #     value + cancellation_fee
    # )

    # # 2 # runners[0] accepts job request
    # tx = utils.hub_runner(ride_hub).acceptRequest(
    #     key_USD, key_wETH, job_ID, {"from": runners[0]},
    # )
    # tx.wait(1)

    # # check # certain portion of runners[0]'s holdings locked up in vault
    # assert utils.hub_holding(ride_hub).getHolding(
    #     runners[0], key_wETH
    # ) == holding_runner1 - (value + cancellation_fee)
    # assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
    #     value + cancellation_fee
    # )

    # 3 # runners[0] reaches package location (or not), collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] verifies package, click verify
    tx = utils.hub_runner(ride_hub).verify(
        job_ID, requester1.address, {"from": runners[0]},
    )
    tx.wait(1)

    # 5 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 6 # runners[0] completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runners[0]},)
    tx.wait(1)

    # since verified, countStart detail of requester & runners[0] does increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 1
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 1

    # since verified, countEnd + metresTravelled detail of requester & runners[0] does increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            1
        ]
        == 1
    )
    assert (
        utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4]
        == estimated_metres
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 1

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runners[0], other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value
    )


# many requester to one runner


# @pytest.mark.skip(reason="tmp")
def test_base_case_many_req_one_run(
    sample_hive,
    ride_hub,
    ride_WETH9,
    ride_currency_registry,
    ride_holding,
    requester1,
    requester2,
    runners,
):
    """
    # # # no verification
    # # # no dispute
    # # # no cancel
    # # # many requester to one runner
    """
    _, hive_timelock, _ = sample_hive
    _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_WETH9,
        requester1,
        requester2,
        runners,
    )

    package = requester1
    key_USD = ride_currency_registry.getKeyFiat("USD")
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)
    estimated_minutes = 2
    estimated_metres = 100

    holding_requester1 = utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
    holding_runner1 = utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)

    assert holding_requester1 != 0
    assert holding_runner1 != 0

    # 1 # request runners[0]
    tx = utils.hub_requester(ride_hub).requestRunner(
        hive_timelock.address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requester1},
    )
    tx.wait(1)

    job_ID = tx.events["RequestRunner"]["jobId"]

    # check # certain portion of requester's holdings locked up in vault
    value = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requester1, key_wETH
    ) == holding_requester1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(requester1, key_wETH) == (
        value + cancellation_fee
    )

    # 2 # runners[0] accepts job request
    tx = utils.hub_runner(ride_hub).acceptRequest(
        key_USD, key_wETH, job_ID, {"from": runners[0]},
    )
    tx.wait(1)

    # check # certain portion of runners[0]'s holdings locked up in vault
    assert utils.hub_holding(ride_hub).getHolding(
        runners[0], key_wETH
    ) == holding_runner1 - (value + cancellation_fee)
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
        value + cancellation_fee
    )

    # # another job request
    package1 = requester2
    estimated_minutes1 = 3
    estimated_metres1 = 50

    holding_requester2 = utils.hub_holding(ride_hub).getHolding(requester2, key_wETH)
    tx1 = utils.hub_requester(ride_hub).requestRunner(
        hive_timelock.address,
        package1,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes1,
        estimated_metres1,
        {"from": requester2},
    )
    tx1.wait(1)

    job_ID_1 = tx1.events["RequestRunner"]["jobId"]

    # check # certain portion of requester's holdings locked up in vault
    value1 = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID_1)[9]  # (fare)
    cancellation_fee1 = utils.hub_job_board(ride_hub).getJobIdToJobDetail(job_ID_1)[
        10
    ]  # (cancellation fee)
    assert utils.hub_holding(ride_hub).getHolding(
        requester2, key_wETH
    ) == holding_requester2 - (value1 + cancellation_fee1)
    assert utils.hub_holding(ride_hub).getVault(requester2, key_wETH) == (
        value1 + cancellation_fee1
    )

    # # runners[0] accepts the new job request
    tx = utils.hub_runner(ride_hub).acceptRequest(
        key_USD, key_wETH, job_ID_1, {"from": runners[0]},
    )
    tx.wait(1)

    # check # certain portion of runners[0]'s holdings locked up in vault
    assert utils.hub_holding(ride_hub).getHolding(
        runners[0], key_wETH
    ) == holding_runner1 - (value + cancellation_fee) - (value1 + cancellation_fee1)
    assert utils.hub_holding(ride_hub).getVault(runners[0], key_wETH) == (
        value + cancellation_fee + (value1 + cancellation_fee1)
    )

    # 3 # runners[0] reaches package location, collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID, {"from": runners[0]},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 5 # runners[0] completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID, True, {"from": runners[0]},)
    tx.wait(1)

    # since not verified, countEnd + metresTravelled detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester1)[
            1
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4] == 0
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 0

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runners[0], other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester1, key_wETH)
        == holding_requester1 - value
    )
    assert utils.hub_holding(ride_hub).getHolding(
        runners[0], key_wETH
    ) == holding_runner1 + value - (value1 + cancellation_fee1)

    # # continue with second request

    # 3 # runners[0] reaches package location, collect
    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = utils.hub_runner(ride_hub).collectPackage(
        job_ID_1, package_zero, {"from": runners[0]},
    )
    tx.wait(1)

    # since not verified, countStart detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester2)[
            0
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[5] == 0

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 4 # runners[0] reaches destination, delivers package
    tx = utils.hub_runner(ride_hub).deliverPackage(job_ID_1, {"from": runners[0]},)
    tx.wait(1)

    # >> fast forward time >> to pass dispute duration
    chain.sleep(
        utils.hub_job_board(ride_hub).getMinDisputeDuration() + 1
    )  # TODO: change getMinDisputeDuration to getHiveToDisputeDuration (if have set)

    # 5 # runners[0] completes job, accepts outcome (whatever it may be)
    tx = utils.hub_runner(ride_hub).completeJob(job_ID_1, True, {"from": runners[0]},)
    tx.wait(1)

    # since not verified, countEnd + metresTravelled detail of requester & runners[0] does not increase
    assert (
        utils.hub_requester_detail(ride_hub).getRequestorToRequestorDetail(requester2)[
            1
        ]
        == 0
    )
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[4] == 0
    assert utils.hub_runner_detail(ride_hub).getRunnerToRunnerDetail(runners[0])[6] == 0

    # check # since no dispute/cancel, value (fare) is unlocked from vault to runners[0], other funds are refunded
    assert (
        utils.hub_holding(ride_hub).getHolding(requester2, key_wETH)
        == holding_requester2 - value1
    )
    assert (
        utils.hub_holding(ride_hub).getHolding(runners[0], key_wETH)
        == holding_runner1 + value + value1
    )


# # # TODO: many requester to one runner (all the many cases besides base)
# # # TODO: one requester to many runner (all the many cases + base)
# # # TODO: many requester to many runner (all the many cases + base)


##### ------                   ------ #####
##### ------        end        ------ #####
##### ------------------------------- #####
###########################################


###########################################
##### ------------------------------- #####
##### ----------- withdraw ---------- #####
##### ------------------------------- #####
###########################################


# @pytest.mark.skip(reason="tmp")
def test_withdraw(
    ride_hub, ride_currency_registry, ride_holding, ride_WETH9, requester1
):
    # 1 # --> setup
    deposit(ride_WETH9, ride_hub, ride_currency_registry, ride_holding, requester1)

    # 2 # --> withdraw from RideHub to wallet
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)

    assert ride_WETH9.balanceOf(requester1) == 0

    amount = ride_holding.getHolding(requester1, key_wETH)

    tx = ride_holding.withdrawTokens(key_wETH, amount, {"from": requester1})
    tx.wait(1)

    assert ride_holding.getHolding(requester1, key_wETH) == 0

    # 3 # --> check wallet

    assert ride_WETH9.balanceOf(requester1) == amount
