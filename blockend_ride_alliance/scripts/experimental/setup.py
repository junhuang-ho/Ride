import brownie
from brownie import network, config

import scripts.utils as utils

# done
def diamond_bulk_deploy(facets, deployer):
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

    return facets_to_cut


# done
def deploy_multisigs(deployer, co_founder):
    members = [deployer.address, co_founder.address]
    confirmations_required = 1  # (len(members) / 2) + 1

    ride_multisig_administration = brownie.RideMultiSignatureWallet.deploy(
        "Administration",
        members,
        confirmations_required,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    ride_multisig_maintainer = brownie.RideMultiSignatureWallet.deploy(
        "Maintainer",
        members,
        confirmations_required,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    ride_multisig_strategist = brownie.RideMultiSignatureWallet.deploy(
        "Strategist",
        members,
        confirmations_required,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    return (
        ride_multisig_administration,
        ride_multisig_maintainer,
        ride_multisig_strategist,
    )


# done
def deploy_ride_token(deployer):
    ride_token = brownie.Ride.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    return ride_token


# done
def deploy_ride_governance(ride_token, deployer):
    min_delay = 1
    voting_delay = 1
    voting_period = 10
    proposal_threshold = 0
    quorum_percentage = 4

    ride_governance = brownie.RideGovernance.deploy(
        ride_token,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    ride_timelock = brownie.RideTimelock.deploy(
        min_delay,
        [],
        [],
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    ride_governor = brownie.RideGovernor.deploy(
        ride_governance.address,
        ride_timelock.address,
        voting_delay,
        voting_period,
        proposal_threshold,
        quorum_percentage,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    return ride_governance, ride_timelock, ride_governor


# done
def deploy_alliance_factory(deployer):
    ride_alliance_cut = brownie.RideAllianceCut.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    ride_alliance_factory = brownie.RideAllianceFactory.deploy(
        deployer.address,
        ride_alliance_cut.address,
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    facets = [
        "RideAllianceLoupe",
        "RideAllianceAccessControl",
        "RideAlliancePrinter",
        "RideAlliancePrinterTimelock",
        "RideAlliancePrinterGovernor",
        "RideAllianceForger",
    ]

    facets_to_cut = diamond_bulk_deploy(facets, deployer)

    # # get contract to interact (need to do explicitly for diamond deployments)
    contract_ride_alliance_access_control = brownie.Contract.from_abi(
        "RideAllianceAccessControl",
        ride_alliance_factory.address,
        brownie.RideAllianceAccessControl.abi,
    )
    contract_ride_alliance_cut = brownie.Contract.from_abi(
        "RideAllianceCut", ride_alliance_factory.address, brownie.RideAllianceCut.abi,
    )
    contract_ride_alliance_forger = brownie.Contract.from_abi(
        "RideAllianceForger",
        ride_alliance_factory.address,
        brownie.RideAllianceForger.abi,
    )

    print("💎 Cutting RideAllianceFactory 💎")
    tx = contract_ride_alliance_cut.rideCut(
        facets_to_cut, utils.ZERO_ADDRESS, utils.ZERO_CALLDATAS, {"from": deployer},
    )
    tx.wait(1)

    return (
        ride_alliance_factory,
        contract_ride_alliance_access_control,
        contract_ride_alliance_cut,
        contract_ride_alliance_forger,
    )


# done
def deploy_hub(deployer):
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

    facets = [
        "RideLoupe",
        "RideAccessControl",
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

    facets_to_cut = diamond_bulk_deploy(facets, deployer)

    ride_hub_initializer0 = brownie.RideHubInitializer0.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )

    rating_min = 1
    rating_max = 5

    contract_WETH9 = brownie.WETH9.deploy(
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    contract_mock_V3_aggregator = brownie.MockV3Aggregator.deploy(
        18,
        "2 ether",
        {"from": deployer},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    tokens = [contract_WETH9.address]
    price_feeds = [contract_mock_V3_aggregator.address]

    initial_params = [
        rating_min,
        rating_max,
        tokens,
        price_feeds,
    ]

    encoded_function_data = ride_hub_initializer0.init.encode_input(*initial_params)

    # # get contract to interact (need to do explicitly for diamond deployments)
    contract_ride_access_control = brownie.Contract.from_abi(
        "RideAccessControl", ride_hub.address, brownie.RideAccessControl.abi,
    )
    contract_ride_hub_cut = brownie.Contract.from_abi(
        "RideCut", ride_hub.address, brownie.RideCut.abi,
    )
    contract_ride_currency_registry = brownie.Contract.from_abi(
        "RideCurrencyRegistry",
        ride_hub.address,
        brownie.RideCurrencyRegistry.abi,
        deployer,
    )

    contract_ride_exchange = brownie.Contract.from_abi(
        "RideExchange", ride_hub.address, brownie.RideExchange.abi, deployer,
    )

    contract_ride_fee = brownie.Contract.from_abi(
        "RideFee", ride_hub.address, brownie.RideFee.abi, deployer,
    )

    contract_ride_holding = brownie.Contract.from_abi(
        "RideHolding", ride_hub.address, brownie.RideHolding.abi, deployer,
    )

    contract_ride_penalty = brownie.Contract.from_abi(
        "RidePenalty", ride_hub.address, brownie.RidePenalty.abi, deployer,
    )

    contract_ride_rater = brownie.Contract.from_abi(
        "RideRater", ride_hub.address, brownie.RideRater.abi, deployer,
    )

    contract_ride_ticket = brownie.Contract.from_abi(
        "RideTicket", ride_hub.address, brownie.RideTicket.abi, deployer,
    )

    contract_ride_driver_details = brownie.Contract.from_abi(
        "RideDriverDetails", ride_hub.address, brownie.RideDriverDetails.abi, deployer,
    )

    contract_ride_driver_registry = brownie.Contract.from_abi(
        "RideDriverRegistry",
        ride_hub.address,
        brownie.RideDriverRegistry.abi,
        deployer,
    )

    contract_ride_driver = brownie.Contract.from_abi(
        "RideDriver", ride_hub.address, brownie.RideDriver.abi, deployer,
    )

    contract_ride_passenger = brownie.Contract.from_abi(
        "RidePassenger", ride_hub.address, brownie.RidePassenger.abi, deployer,
    )

    print("💎 Cutting RideHub 💎")
    tx = contract_ride_hub_cut.rideCut(
        facets_to_cut,
        ride_hub_initializer0.address,
        encoded_function_data,
        {"from": deployer},
    )
    tx.wait(1)

    return (
        ride_hub,
        contract_ride_access_control,
        contract_ride_hub_cut,
        contract_ride_currency_registry,
        contract_ride_exchange,
        contract_ride_fee,
        contract_ride_holding,
        contract_ride_penalty,
        contract_ride_rater,
        contract_ride_ticket,
        contract_ride_driver_details,
        contract_ride_driver_registry,
        contract_ride_driver,
        contract_ride_passenger,
    )


def role_setup_ride_token(ride_token, ride_multisig_administration, deployer):
    assert ride_token.owner() == deployer

    tx = ride_token.transferOwnership(
        ride_multisig_administration.address, {"from": deployer}
    )
    tx.wait(1)

    assert ride_token.owner() == ride_multisig_administration.address

    pass


def role_setup_governance(timelock, governor, deployer):
    role_proposer = timelock.PROPOSER_ROLE()
    role_executor = timelock.EXECUTOR_ROLE()
    role_admin = timelock.TIMELOCK_ADMIN_ROLE()

    # check that 2 addresses owns the role_admin
    assert timelock.hasRole(role_admin, timelock.address)
    assert timelock.hasRole(role_admin, deployer)

    # set proposer role to governor (voters - those who hold token)
    tx = timelock.grantRole(role_proposer, governor.address, {"from": deployer})
    tx.wait(1)

    # set executor role to zero address (anyone)
    tx = timelock.grantRole(role_executor, utils.ZERO_ADDRESS, {"from": deployer})
    tx.wait(1)

    # deployer renounce control of timelock as no one should own the timelock contract, but the timelock itself
    tx = timelock.renounceRole(role_admin, deployer.address, {"from": deployer})
    tx.wait(1)

    # check timelock admin roles
    assert timelock.hasRole(role_admin, timelock.address)
    assert not timelock.hasRole(role_admin, deployer)
    # with brownie.reverts():
    #     timelock.grantRole(
    #         role_admin, deployer.address, {"from": deployer}
    #     )
    # TODO: this reverts currently got error: https://github.com/eth-brownie/brownie/issues/1452
    pass


def role_setup_diamond_based_contracts(
    access_control,
    multisig_administration,
    multisig_maintainer,
    multisig_strategist,
    deployer,
):
    role_admin = access_control.getDefaultAdminRole()
    role_maintainer = access_control.getRole("MAINTAINER_ROLE")
    role_strategist = access_control.getRole("STRATEGIST_ROLE")

    assert not access_control.hasRole(role_admin, multisig_administration.address)
    assert not access_control.hasRole(role_maintainer, multisig_maintainer.address)
    assert not access_control.hasRole(role_strategist, multisig_strategist.address)
    assert access_control.hasRole(role_admin, deployer)
    assert access_control.hasRole(role_maintainer, deployer)
    assert access_control.hasRole(role_strategist, deployer)

    tx = access_control.grantRole(
        role_admin, multisig_administration.address, {"from": deployer}
    )
    tx.wait(1)
    tx = access_control.grantRole(
        role_maintainer, multisig_maintainer.address, {"from": deployer}
    )
    tx.wait(1)
    tx = access_control.grantRole(
        role_strategist, multisig_strategist.address, {"from": deployer}
    )
    tx.wait(1)

    # WARNING | renounceRole
    tx = access_control.renounceRole(role_strategist, {"from": deployer})
    tx.wait(1)
    tx = access_control.renounceRole(role_maintainer, {"from": deployer})
    tx.wait(1)
    tx = access_control.renounceRole(role_admin, {"from": deployer})
    tx.wait(1)

    assert access_control.hasRole(role_admin, multisig_administration.address)
    assert access_control.hasRole(role_maintainer, multisig_maintainer.address)
    assert access_control.hasRole(role_strategist, multisig_strategist.address)
    assert not access_control.hasRole(role_admin, deployer)
    assert not access_control.hasRole(role_maintainer, deployer)
    assert not access_control.hasRole(role_strategist, deployer)

    pass


def execute_multisig_decision(
    tx_index, ride_multisig_strategist, target, value, encoding, description, co_founder
):
    tx = ride_multisig_strategist.submitTransaction(
        target, value, encoding, description, {"from": co_founder}
    )
    tx.wait(1)

    tx = ride_multisig_strategist.confirmTransaction(tx_index, {"from": co_founder})
    tx.wait(1)

    tx = ride_multisig_strategist.executeTransaction(tx_index, {"from": co_founder})
    tx.wait(1)

    pass


def forge_alliance(
    ride_alliance_factory,
    ride_alliance_forger,
    ride_token,
    ride_hub,
    ride_multisig_strategist,
    deployer,
    co_founder,
):
    name = "TukTukers"
    symbol = "TT"
    min_delay = 1
    voting_delay = 1
    voting_period = 10
    proposal_threshold = 0
    quorum_percentage = 4

    args = (
        ride_token,
        name,
        symbol,
        min_delay,
        ride_hub.address,
        voting_delay,
        voting_period,
        proposal_threshold,
        quorum_percentage,
    )
    encoding = ride_alliance_forger.forge.encode_input(*args)

    assert ride_alliance_forger.getLatestAlliance() == utils.ZERO_ADDRESS
    assert ride_alliance_forger.getLatestAllianceTimelock() == utils.ZERO_ADDRESS
    assert ride_alliance_forger.getLatestAllianceGovernor() == utils.ZERO_ADDRESS

    execute_multisig_decision(
        0,  # TODO: get tx index from event of multisig's submitTransaction
        ride_multisig_strategist,
        ride_alliance_factory.address,
        0,
        encoding,
        "Forge TukTukers",
        co_founder,
    )

    address_alliance = ride_alliance_forger.getLatestAlliance()
    address_alliance_timelock = ride_alliance_forger.getLatestAllianceTimelock()
    address_alliance_governor = ride_alliance_forger.getLatestAllianceGovernor()

    assert address_alliance != utils.ZERO_ADDRESS
    assert address_alliance_timelock != utils.ZERO_ADDRESS
    assert address_alliance_governor != utils.ZERO_ADDRESS

    contract_ride_alliance = brownie.Contract.from_abi(
        "RideAlliance", address_alliance, brownie.RideAlliance.abi, deployer,
    )

    contract_ride_alliance_timelock = brownie.Contract.from_abi(
        "RideAllianceTimelock",
        address_alliance_timelock,
        brownie.RideAllianceTimelock.abi,
        deployer,
    )

    contract_ride_alliance_governor = brownie.Contract.from_abi(
        "RideAllianceGovernor",
        address_alliance_governor,
        brownie.RideAllianceGovernor.abi,
        deployer,
    )

    return (
        contract_ride_alliance,
        contract_ride_alliance_timelock,
        contract_ride_alliance_governor,
    )


def role_setup_alliance(
    ride_multisig_administration,
    ride_hub,
    ride_access_control,
    ride_alliance_timelock,
    deployer,
):
    role_alliance = ride_access_control.getRole("ALLIANCE_ROLE")

    assert not ride_access_control.hasRole(
        role_alliance, ride_alliance_timelock.address
    )
    assert not ride_access_control.hasRole(role_alliance, deployer)

    args = (role_alliance, ride_alliance_timelock.address)
    encoding = ride_access_control.grantRole.encode_input(*args)

    execute_multisig_decision(
        0,  # TODO: get tx index from event of multisig's submitTransaction
        ride_multisig_administration,
        ride_hub.address,
        0,
        encoding,
        "TukTukers Role Setup",
        deployer,
    )

    assert ride_access_control.hasRole(role_alliance, ride_alliance_timelock.address)
    assert not ride_access_control.hasRole(role_alliance, deployer)

    pass
