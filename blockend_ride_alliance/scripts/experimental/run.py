import brownie

import scripts.utils as utils
import scripts.experimental.setup as setup


def main():
    deployer = utils.get_account(index=0)
    developer_2 = utils.get_account(index=1)
    driver_ally_1 = utils.get_account(index=2)
    # driver_ally_3 = utils.get_account(index=3)
    # passenger = utils.get_account(index=4)
    # random_hooman = utils.get_account(index=5)

    ###################################
    ### --------------------------- ###
    ### -------- deployment ------- ###
    ### --------------------------- ###
    ###################################

    (
        ride_multisig_administration,
        ride_multisig_maintainer,
        ride_multisig_strategist,
    ) = setup.deploy_multisigs(deployer, developer_2)

    ride_token = setup.deploy_ride_token(deployer)

    ride_governance, ride_timelock, ride_governor = setup.deploy_ride_governance(
        ride_token, deployer
    )

    (
        ride_alliance_factory,
        ride_alliance_access_control,
        ride_alliance_cut,
        ride_alliance_forger,
    ) = setup.deploy_alliance_factory(deployer)

    (
        ride_hub,
        ride_access_control,
        ride_hub_cut,
        ride_currency_registry,
        ride_exchange,
        ride_fee,
        ride_holding,
        ride_penalty,
        ride_rater,
        ride_ticket,
        ride_driver_details,
        ride_driver_registry,
        ride_driver,
        ride_passenger,
    ) = setup.deploy_hub(deployer)

    ###################################
    ### --------------------------- ###
    ### ----- role assignment ----- ###
    ### --------------------------- ###
    ###################################

    setup.role_setup_ride_token(ride_token, ride_multisig_administration, deployer)
    setup.role_setup_governance(ride_timelock, ride_governor, deployer)
    setup.role_setup_diamond_based_contracts(
        ride_alliance_access_control,
        ride_multisig_administration,
        ride_multisig_maintainer,
        ride_multisig_strategist,
        deployer,
    )
    setup.role_setup_diamond_based_contracts(
        ride_access_control,
        ride_multisig_administration,
        ride_multisig_maintainer,
        ride_multisig_strategist,
        deployer,
    )

    ## after assignment, the main owner addresses should belong to multisigs and timelocks

    #########################################
    ### --------------------------------- ###
    ### ----- ⚒️ forging alliances ⚒️ ----- ###
    ### --------------------------------- ###
    #########################################

    (
        ride_alliance,
        ride_alliance_timelock,
        ride_alliance_governor,
    ) = setup.forge_alliance(
        ride_alliance_factory,
        ride_alliance_forger,
        ride_token,
        ride_hub,
        ride_multisig_strategist,
        deployer,
        developer_2,
    )

    setup.role_setup_alliance(
        ride_multisig_administration,
        ride_hub,
        ride_access_control,
        ride_alliance_timelock,
        deployer,
    )

    ## assign ally representative (first driver of new alliance)

    args = (
        driver_ally_1,
        "Frist Ally",
        ride_alliance_timelock.address,
    )
    encoding = ride_driver_registry.approveNewAlly.encode_input(*args)

    assert ride_driver_details.getDriverToDriverDetails(driver_ally_1)[0] == 0
    assert ride_driver_details.getDriverToDriverDetails(driver_ally_1)[1] == ""
    assert (
        ride_driver_details.getDriverToDriverDetails(driver_ally_1)[2]
        == utils.ZERO_ADDRESS
    )

    setup.execute_multisig_decision(
        1,  # TODO: get tx index from event of multisig's submitTransaction
        ride_multisig_strategist,
        ride_hub.address,
        0,
        encoding,
        "TukTukers Representative",
        developer_2,
    )

    assert (
        ride_driver_details.getDriverToDriverDetails(driver_ally_1)[1] == "Frist Ally"
    )
    assert (
        ride_driver_details.getDriverToDriverDetails(driver_ally_1)[2]
        == ride_alliance_timelock.address
    )

    print("settle")
