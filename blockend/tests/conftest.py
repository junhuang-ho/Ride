import pytest
import brownie
import scripts.utils as utils
import scripts.deploy_ride_multi_sigs as deploy_ride_multi_sigs
import scripts.deploy_ride_token as deploy_ride_token
import scripts.deploy_ride_governance as deploy_ride_governance
import scripts.deploy_ride_hub as deploy_ride_hub
import scripts.post_deployment_setup as pds
import scripts.hive_utils as hu


@pytest.fixture(scope="module")
def deployer():
    yield utils.get_account(index=0)


@pytest.fixture(scope="module")
def person1():
    yield utils.get_account(index=1)


@pytest.fixture(scope="module")
def person2():
    yield utils.get_account(index=2)


@pytest.fixture(scope="module")
def person3():
    yield utils.get_account(index=3)


@pytest.fixture(scope="module")
def person4():
    yield utils.get_account(index=4)


@pytest.fixture(scope="module")
def person5():
    yield utils.get_account(index=5)


@pytest.fixture(scope="module")
def person6():
    yield utils.get_account(index=6)


@pytest.fixture(scope="module")
def person7():
    yield utils.get_account(index=7)


@pytest.fixture(scope="module", autouse=True)
def ride_multi_sigs(deployer, person1):
    members = [deployer, person1]
    confirmations_required = 1
    yield deploy_ride_multi_sigs.main(members, confirmations_required, deployer)


@pytest.fixture(scope="module", autouse=True)
def ride_token(ride_multi_sigs, deployer):
    ride_token = deploy_ride_token.main(deployer)
    pds.setup_main_token(ride_token, ride_multi_sigs[0], deployer)
    yield ride_token


@pytest.fixture(scope="module", autouse=True)
def ride_governance(ride_token, ride_multi_sigs, deployer):
    min_delay = 1
    voting_delay = 1
    voting_period = 10
    proposal_threshold = 0
    quorum_percentage = 4

    ride_governance, ride_timelock, ride_governor = deploy_ride_governance.main(
        ride_token,
        min_delay,
        voting_delay,
        voting_period,
        proposal_threshold,
        quorum_percentage,
        deployer,
    )

    pds.setup_governance_roles(
        ride_timelock, ride_governor, deployer, ride_multi_sigs[2]
    )

    yield ride_governance, ride_timelock, ride_governor


#####


@pytest.fixture(scope="module", autouse=True)
def ride_hub(ride_multi_sigs, ride_token, AccessControl, Contract, deployer):
    # for hive_creation_count value, refer HiveFactory.sol contract,
    # if LibHiveFactory._requireCorrectOrder(int) set correctly in activateHive function,
    # then value == int
    hive_creation_count = 4
    job_lifespan = 86400
    min_dispute_duration = 60
    rating_min = 1
    rating_max = 5

    ride_hub, tokens = deploy_ride_hub.main(
        ride_token,
        hive_creation_count,
        job_lifespan,
        min_dispute_duration,
        rating_min,
        rating_max,
        deployer,
    )

    ride_access_control = Contract.from_abi(
        "AccessControl", ride_hub.address, AccessControl.abi, deployer,
    )

    pds.setup_hub_with_multi_sigs(
        ride_access_control,
        ride_multi_sigs[0],
        ride_multi_sigs[1],
        ride_multi_sigs[2],
        deployer,
    )

    yield ride_hub, tokens


@pytest.fixture(scope="module", autouse=True)
def ride_currency_registry(ride_hub, CurrencyRegistry, Contract, deployer):
    yield Contract.from_abi(
        "CurrencyRegistry", ride_hub[0].address, CurrencyRegistry.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_exchange(ride_hub, Exchange, Contract, deployer):
    yield Contract.from_abi(
        "Exchange", ride_hub[0].address, Exchange.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_fee(ride_hub, Fee, Contract, deployer):
    yield Contract.from_abi(
        "Fee", ride_hub[0].address, Fee.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_runner(ride_hub, Runner, Contract, deployer):
    yield Contract.from_abi(
        "Runner", ride_hub[0].address, Runner.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_runner_detail(ride_hub, RunnerDetail, Contract, deployer):
    contract_runner_detail = Contract.from_abi(
        "RunnerDetail", ride_hub[0].address, RunnerDetail.abi, deployer
    )
    yield contract_runner_detail


@pytest.fixture(scope="module", autouse=True)
def ride_runner_registry(ride_hub, RunnerRegistry, Contract, deployer):
    yield Contract.from_abi(
        "RunnerRegistry", ride_hub[0].address, RunnerRegistry.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_requester(ride_hub, Requester, Contract, deployer):
    yield Contract.from_abi(
        "Requester", ride_hub[0].address, Requester.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_requester_detail(ride_hub, RequesterDetail, Contract, deployer):
    yield Contract.from_abi(
        "RequesterDetail", ride_hub[0].address, RequesterDetail.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_holding(ride_hub, Holding, Contract, deployer):
    yield Contract.from_abi(
        "Holding", ride_hub[0].address, Holding.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_penalty(ride_hub, Penalty, Contract, deployer):
    yield Contract.from_abi(
        "Penalty", ride_hub[0].address, Penalty.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_rater(ride_hub, Rater, Contract, deployer):
    yield Contract.from_abi(
        "Rater", ride_hub[0].address, Rater.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_job_board(ride_hub, JobBoard, Contract, deployer):
    yield Contract.from_abi(
        "JobBoard", ride_hub[0].address, JobBoard.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_access_control(ride_hub, AccessControl, Contract, deployer):
    yield Contract.from_abi(
        "AccessControl", ride_hub[0].address, AccessControl.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_cut(ride_hub, Cut, Contract, deployer):
    yield Contract.from_abi(
        "Cut", ride_hub[0].address, Cut.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_loupe(ride_hub, Loupe, Contract, deployer):
    yield Contract.from_abi(
        "Loupe", ride_hub[0].address, Loupe.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_hive_factory(ride_hub, HiveFactory, Contract, deployer):
    yield Contract.from_abi(
        "HiveFactory", ride_hub[0].address, HiveFactory.abi, deployer,
    )


##### hive


@pytest.fixture(scope="module", autouse=True)
def sample_hive(
    ride_hub,
    ride_token,
    ride_hive_factory,
    ride_runner_detail,
    ride_access_control,
    deployer,
    person1,
    person2,
    person3,
    ride_multi_sigs,
):
    name = "TukTukers"
    symbol = "TT"
    min_delay = 1
    voting_delay = 1
    voting_period = 5
    proposal_threshold = 50  # number of tokens
    quorum_percentage = 4

    yield hu.build_hive(
        ride_hub[0],
        ride_token,
        ride_hive_factory,
        ride_runner_detail,
        ride_access_control,
        deployer,
        person1,
        person2,
        person3,
        ride_multi_sigs,
        name,
        symbol,
        min_delay,
        voting_delay,
        voting_period,
        proposal_threshold,
        quorum_percentage,
    )


#####


@pytest.fixture(scope="module", autouse=True)
def ride_WETH9(ride_hub, WETH9, Contract, deployer):
    yield Contract.from_abi(
        "WETH9", ride_hub[1][0], WETH9.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def dWETH9(WETH9, deployer):
    yield WETH9.deploy(
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )


@pytest.fixture(scope="module", autouse=True)
def dMockV3Aggregator1(MockV3Aggregator, deployer):
    yield MockV3Aggregator.deploy(
        18,
        "2 ether",
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )


@pytest.fixture(scope="module", autouse=True)
def dMockV3Aggregator2(MockV3Aggregator, deployer):
    yield MockV3Aggregator.deploy(
        18,
        "3 ether",
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )


@pytest.fixture(scope="module", autouse=True)
def dBoxie(Boxie, deployer):
    yield Boxie.deploy(
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )


@pytest.fixture(scope="module", autouse=True)
def dBox(Box, deployer):
    yield Box.deploy(
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )


@pytest.fixture(scope="module", autouse=True)
def dBox3(Box3, deployer):
    yield Box3.deploy(
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )


@pytest.fixture(scope="module", autouse=True)
def dBox5(Box5, deployer):
    yield Box5.deploy(
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )


@pytest.fixture(scope="module", autouse=True)
def dBox6(Box6, deployer):
    yield Box6.deploy(
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )
