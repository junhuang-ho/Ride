import pytest
import brownie
import scripts.utils as utils
import scripts.deploy_ride_hub as deploy_ride_hub
import scripts.deploy_ride_token_and_governance as deploy_ride_token_and_governance


@pytest.fixture(scope="module")
def deployer():
    yield utils.get_account(index=0)


@pytest.fixture(scope="module")
def person1():
    yield utils.get_account(index=1)


@pytest.fixture(scope="module")
def person2():
    yield utils.get_account(index=2)


@pytest.fixture(scope="module", autouse=True)
def ride_hub(deployer):
    yield deploy_ride_hub.main(deployer)


@pytest.fixture(scope="module", autouse=True)
def ride_token_and_governance(deployer):
    yield deploy_ride_token_and_governance.main(deployer)


@pytest.fixture(scope="module", autouse=True)
def ride_badge(ride_hub, RideBadge, Contract, deployer):
    contract_ride_badge = Contract.from_abi(
        "RideBadge", ride_hub[0].address, RideBadge.abi, deployer
    )
    yield contract_ride_badge


@pytest.fixture(scope="module", autouse=True)
def ride_currency_registry(ride_hub, RideCurrencyRegistry, Contract, deployer):
    yield Contract.from_abi(
        "RideCurrencyRegistry", ride_hub[0].address, RideCurrencyRegistry.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_driver_registry(ride_hub, RideDriverRegistry, Contract, deployer):
    yield Contract.from_abi(
        "RideDriverRegistry", ride_hub[0].address, RideDriverRegistry.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_driver(ride_hub, RideDriver, Contract, deployer):
    yield Contract.from_abi(
        "RideDriver", ride_hub[0].address, RideDriver.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_exchange(ride_hub, RideExchange, Contract, deployer):
    yield Contract.from_abi(
        "RideExchange", ride_hub[0].address, RideExchange.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_fee(ride_hub, RideFee, Contract, deployer):
    yield Contract.from_abi(
        "RideFee", ride_hub[0].address, RideFee.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_holding(ride_hub, RideHolding, Contract, deployer):
    yield Contract.from_abi(
        "RideHolding", ride_hub[0].address, RideHolding.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_passenger(ride_hub, RidePassenger, Contract, deployer):
    yield Contract.from_abi(
        "RidePassenger", ride_hub[0].address, RidePassenger.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_penalty(ride_hub, RidePenalty, Contract, deployer):
    yield Contract.from_abi(
        "RidePenalty", ride_hub[0].address, RidePenalty.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_rater(ride_hub, RideRater, Contract, deployer):
    yield Contract.from_abi(
        "RideRater", ride_hub[0].address, RideRater.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_ticket(ride_hub, RideTicket, Contract, deployer):
    yield Contract.from_abi(
        "RideTicket", ride_hub[0].address, RideTicket.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_access_control(ride_hub, RideAccessControl, Contract, deployer):
    yield Contract.from_abi(
        "RideAccessControl", ride_hub[0].address, RideAccessControl.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_cut(ride_hub, RideCut, Contract, deployer):
    yield Contract.from_abi(
        "RideCut", ride_hub[0].address, RideCut.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_loupe(ride_hub, RideLoupe, Contract, deployer):
    yield Contract.from_abi(
        "RideLoupe", ride_hub[0].address, RideLoupe.abi, deployer,
    )


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
