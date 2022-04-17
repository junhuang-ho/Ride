import brownie
from brownie import network, config

import scripts.utils as utils


def main(rating_min, rating_max, deployer):
    ride_hub_cut = brownie.RideCut.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    ride_hub = brownie.RideHub.deploy(
        deployer.address,
        ride_hub_cut.address,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        facets = [
            "RideLoupe",
            "RideTestAccessControl",
            "RideTestAllyGovernanceTokenPrinter",
            "RideTestAllyTimelockPrinter",
            "RideTestAllyGovernorPrinter",
            "RideTestAllianceForger",
            "RideTestCurrencyRegistry",
            "RideTestExchange",
            "RideTestFee",
            "RideTestHolding",
            "RideTestPenalty",
            "RideTestRater",
            "RideTestTicket",
            "RideTestDriverRegistry",
            "RideTestDriverDetails",
            "RideTestDriver",
            "RideTestPassenger",
        ]
    else:
        facets = [
            "RideLoupe",
            "RideAccessControl",
            "RideAllyGovernanceTokenPrinter",
            "RideAllyTimelockPrinter",
            "RideAllyGovernorPrinter",
            "RideAllianceForger",
            "RideCurrencyRegistry",
            "RideExchange",
            "RideFee",
            "RideHolding",
            "RidePenalty",
            "RideRater",
            "RideTicket",
            "RideDriverRegistry",
            "RideDriverDetails",
            "RideDriver",
            "RidePassenger",
        ]

    facets_to_cut = utils.diamond_bulk_deploy(facets, deployer)

    ride_hub_initializer0 = brownie.RideHubInitializer0.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        contract_WETH9 = brownie.WETH9.deploy(
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )
        contract_mock_V3_aggregator = brownie.MockV3Aggregator.deploy(
            18,
            "2 ether",
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )
        tokens = [contract_WETH9.address]
        price_feeds = [contract_mock_V3_aggregator.address]
    else:
        tokens = []
        price_feeds = []
        mappings = config["networks"][network.show_active()]["mapping"]
        for key, value in config["networks"][network.show_active()].items():
            if "token" in key and key in mappings.keys():
                tokens.append(value)
                price_feeds.append(
                    config["networks"][network.show_active()][mappings[key]]
                )
            else:
                pass

    initial_params = [
        rating_min,
        rating_max,
        tokens,
        price_feeds,
    ]

    encoded_function_data = ride_hub_initializer0.init.encode_input(*initial_params)

    contract_ride_hub_cut = brownie.Contract.from_abi(
        "RideCut", ride_hub.address, brownie.RideCut.abi,
    )

    print("💎 Cutting RideHub 💎")
    tx = contract_ride_hub_cut.rideCut(
        facets_to_cut,
        ride_hub_initializer0.address,
        encoded_function_data,
        {"from": deployer},
    )
    tx.wait(1)

    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        return ride_hub, tokens
    else:
        return ride_hub, None
