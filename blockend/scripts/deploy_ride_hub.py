import brownie
from brownie import network, config

import scripts.utils as utils


def main(deployer):
    deployed_contract_ride_cut = brownie.RideCut.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    deployed_contract_ride_hub = brownie.RideHub.deploy(
        deployer.address,
        deployed_contract_ride_cut.address,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    deployed_contract_ride_initializer0 = brownie.RideInitializer0.deploy(
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
            "RideTestBadge",
            "RideTestCurrencyRegistry",
            "RideTestFee",
            "RideTestExchange",
            "RideTestHolding",
            "RideTestPenalty",
            "RideTestTicket",
            "RideTestPassenger",
            "RideTestRater",
            "RideTestDriver",
            "RideTestDriverRegistry",
        ]
    else:
        facets = [
            "RideLoupe",
            "RideAccessControl",
            "RideBadge",
            "RideCurrencyRegistry",
            "RideFee",
            "RideExchange",
            "RideHolding",
            "RidePenalty",
            "RideTicket",
            "RidePassenger",
            "RideRater",
            "RideDriver",
            "RideDriverRegistry",
        ]

    facets_to_cut = []
    for facet in facets:
        deployed_contract = getattr(brownie, facet).deploy(
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )
        facets_to_cut.append(
            [
                deployed_contract.address,
                utils.FACET_CUT_ACTIONS["Add"],
                utils.get_function_selectors(deployed_contract),
            ]
        )

    # set init params

    # note:
    # some perspective for badgesMaxScore
    # say 1 day work 10 hours and can travel 50_000 metres per hour (Subang to KL)
    # In 1 day, distance = 500_000 metres
    # In 1 year, distance = 180_000_000 metres
    # In 5 years, distance = 900_000_000 metres

    # Newbie   ~ up to 1 day's work, 10 * 50_000 * 1 = 500_000
    # Bronze   ~ up to 1 month's work, 10 * 50_000 * 30 = 15_000_000
    # Silver   ~ up to 6 month's work, 10 * 50_000 * 30 * 6 = 90_000_000
    # Gold     ~ up to 1 year's work, 10 * 50_000 * 30 * 12 = 180_000_000
    # Platinum ~ up to 3 year's work, 10 * 50_000 * 30 * 12 * 3 = 540_000_000
    # Veteran  ~ more than 3 year's work

    badges_max_scores = [
        500_000,
        15_000_000,
        90_000_000,
        180_000_000,
        540_000_000,
    ]  # metres
    ban_duration = 604800  # 7 days # https:#www.epochconverter.com/
    force_end_delay = 86400  # 1 day
    rating_min = 1
    rating_max = 5
    cancellation_fee_USD = "5 ether"  # $5 for random search on Uber: Central Park --> Brooklyn https:#www.uber.com/global/en/price-estimate/
    base_fee_USD = "3 ether"  # $8 for random search on Uber: Central Park --> Brooklyn https:#www.uber.com/global/en/price-estimate/
    cost_per_minute_USD = "0.0001 ether"  # $0 for random search on Uber: Central Park --> Brooklyn https:#www.uber.com/global/en/price-estimate/
    badges_cost_per_metre_USD = [
        "0.0010 ether",
        "0.0012 ether",
        "0.0014 ether",
        "0.0016 ether",
        "0.0017 ether",
        "0.0020 ether",
    ]  # $2.51 per mile for random search on Uber: Central Park --> Brooklyn https://www.uber.com/global/en/price-estimate/

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
        badges_max_scores,
        ban_duration,
        force_end_delay,
        rating_min,
        rating_max,
        cancellation_fee_USD,
        base_fee_USD,
        cost_per_minute_USD,
        badges_cost_per_metre_USD,
        tokens,
        price_feeds,
    ]

    encoded_function_data = deployed_contract_ride_initializer0.init.encode_input(
        *initial_params
    )

    print("💎 Cutting RideHub 💎")
    contract_ride_cut = brownie.Contract.from_abi(
        "RideCut", deployed_contract_ride_hub.address, deployed_contract_ride_cut.abi
    )
    tx = contract_ride_cut.rideCut(
        facets_to_cut,
        deployed_contract_ride_initializer0.address,
        encoded_function_data,
        {"from": deployer},
    )
    tx.wait(1)

    print(f"RideHub: {deployed_contract_ride_hub.address}")

    if (
        network.show_active() in utils.ENV_LOCAL_BLOCKS
        or network.show_active() in utils.ENV_LOCAL_FORKS
    ):
        return deployed_contract_ride_hub, tokens
    else:
        return deployed_contract_ride_hub, None
