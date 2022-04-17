import pytest
import brownie
import scripts.utils as utils
import scripts.execution_patterns as ep


@pytest.fixture(scope="module", autouse=True)
def role_maintainer(ride_access_control):
    yield ride_access_control.getRole("MAINTAINER_ROLE")


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_cut_add(
    ride_cut, ride_hub, ride_loupe, dBox3, deployer, person1, ride_multi_sigs,
):
    dBox3_selectors = utils.get_function_selectors(dBox3)
    facets_to_cut = [
        dBox3.address,
        utils.FACET_CUT_ACTIONS["Add"],
        dBox3_selectors,
    ]

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_cut.cut(
            [facets_to_cut],
            utils.ZERO_ADDRESS,
            utils.ZERO_CALLDATAS,
            {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        [facets_to_cut],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
    )
    encoded_function = ride_cut.cut.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert len(ride_loupe.facetFunctionSelectors(dBox3.address)) == 0

    # address without role cannot execute
    with brownie.reverts():
        ride_cut.cut(
            [facets_to_cut],
            utils.ZERO_ADDRESS,
            utils.ZERO_CALLDATAS,
            {"from": deployer},
        )

    # multisig
    members = [deployer, person1]
    ep.execute_multisig_decision(
        0, ride_multi_sigs[1], ride_hub[0].address, encoded_function, deployer, members
    )

    # # governance
    # governance_process(
    #     encoded_function,
    #     ride_hub,
    #     ride_governor,
    #     ride_access_control,
    #     deployer,
    #     person1,
    #     person2,
    # )

    # after
    assert ride_loupe.facetFunctionSelectors(dBox3.address) == dBox3_selectors


def test_cut_remove(
    ride_cut, ride_hub, ride_loupe, dBox3, deployer, person1, ride_multi_sigs,
):
    test_cut_add(
        ride_cut, ride_hub, ride_loupe, dBox3, deployer, person1, ride_multi_sigs,
    )

    dBox3_selectors = utils.get_function_selectors(dBox3)
    facets_to_cut = [
        utils.ZERO_ADDRESS,
        utils.FACET_CUT_ACTIONS["Remove"],
        dBox3_selectors,
    ]

    # 1 # --> revert as not contract owner
    with brownie.reverts():
        ride_cut.cut(
            [facets_to_cut],
            utils.ZERO_ADDRESS,
            utils.ZERO_CALLDATAS,
            {"from": deployer},
        )

    # 2 # --> encode function to be executed
    args = (
        [facets_to_cut],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
    )
    encoded_function = ride_cut.cut.encode_input(*args)

    # 3 # --> passs through governance process

    # before
    assert ride_loupe.facetFunctionSelectors(dBox3.address) == dBox3_selectors

    # address without role cannot execute
    with brownie.reverts():
        ride_cut.cut(
            [facets_to_cut],
            utils.ZERO_ADDRESS,
            utils.ZERO_CALLDATAS,
            {"from": deployer},
        )

    # multisig
    members = [deployer, person1]
    ep.execute_multisig_decision(
        1, ride_multi_sigs[1], ride_hub[0].address, encoded_function, deployer, members
    )

    # # governance
    # governance_process(
    #     encoded_function,
    #     ride_hub,
    #     ride_governor,
    #     ride_access_control,
    #     deployer,
    #     person1,
    #     person2,
    # )

    # after
    assert len(ride_loupe.facetFunctionSelectors(dBox3.address)) == 0


## clearJobs


def test_clearJobs(ride_hub, ride_job_board, deployer, person1, ride_multi_sigs):
    # 1 # address without role cannot execute

    with brownie.reverts():
        ride_job_board.clearJobs(
            [utils.ZERO_BYTES32, utils.ZERO_BYTES32], {"from": deployer},
        )

    # 2 # execute
    members = [deployer, person1]
    args = ([utils.ZERO_BYTES32, utils.ZERO_BYTES32],)
    encoding = ride_job_board.clearJobs.encode_input(*args)
    ep.execute_multisig_decision(
        0, ride_multi_sigs[1], ride_hub[0].address, encoding, deployer, members
    )

