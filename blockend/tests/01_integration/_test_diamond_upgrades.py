import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils

chain = brownie.network.state.Chain()

#######################################################################################
##### --------------------------------------------------------------------------- #####
##### ----- TODO: any multisig decision need pass through multisig vote !!! ----- #####
##### --------------------------------------------------------------------------- #####
#######################################################################################


@pytest.fixture(scope="module", autouse=True)
def ride_box_5(ride_hub, Box5, Contract, deployer):
    yield Contract.from_abi(
        "Box5", ride_hub[0].address, Box5.abi, deployer,
    )


@pytest.fixture(scope="module", autouse=True)
def ride_box_6(ride_hub, Box6, Contract, deployer):
    yield Contract.from_abi(
        "Box6", ride_hub[0].address, Box6.abi, deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_diamond_add(ride_cut, ride_loupe, dBox5, ride_multi_sigs):
    assert len(ride_loupe.facetFunctionSelectors(dBox5.address)) == 0

    selectors = utils.get_function_selectors(dBox5)

    tx = ride_cut.cut(
        [[dBox5.address, utils.FACET_CUT_ACTIONS["Add"], selectors]],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": ride_multi_sigs[1]},
    )
    tx.wait(1)

    assert ride_loupe.facetFunctionSelectors(dBox5.address) == selectors


def test_diamond_remove(ride_cut, ride_loupe, dBox5, ride_multi_sigs):
    test_diamond_add(ride_cut, ride_loupe, dBox5, ride_multi_sigs)

    selectors = utils.get_function_selectors(dBox5)

    tx = ride_cut.cut(
        [
            [
                utils.ZERO_ADDRESS,  # --> # !!! # remember, for Remove, target address is ZERO ADDRESS
                utils.FACET_CUT_ACTIONS["Remove"],
                selectors,
            ]
        ],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": ride_multi_sigs[1]},
    )
    tx.wait(1)

    assert len(ride_loupe.facetFunctionSelectors(dBox5.address)) == 0


def test_diamond_remove_partial(ride_cut, ride_loupe, dBox5, ride_multi_sigs):
    test_diamond_add(ride_cut, ride_loupe, dBox5, ride_multi_sigs)

    selectors = utils.get_function_selectors(dBox5)

    tx = ride_cut.cut(
        [
            [
                utils.ZERO_ADDRESS,
                utils.FACET_CUT_ACTIONS["Remove"],
                selectors[: len(selectors) - 1],
            ]
        ],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": ride_multi_sigs[1]},
    )
    tx.wait(1)

    assert len(ride_loupe.facetFunctionSelectors(dBox5.address)) == 1
    assert ride_loupe.facetAddress(selectors[-1]) == dBox5.address


def test_diamond_remove_partial_then_remaining(
    ride_cut, ride_loupe, dBox5, ride_multi_sigs
):
    # note: facet address should be removed after removing remaining as well
    test_diamond_remove_partial(ride_cut, ride_loupe, dBox5, ride_multi_sigs)

    selectors = utils.get_function_selectors(dBox5)
    number_of_facets = len(ride_loupe.facetAddresses())

    tx = ride_cut.cut(
        [[utils.ZERO_ADDRESS, utils.FACET_CUT_ACTIONS["Remove"], [selectors[-1]],]],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": ride_multi_sigs[1]},
    )
    tx.wait(1)

    assert len(ride_loupe.facetFunctionSelectors(dBox5.address)) == 0
    assert len(ride_loupe.facetAddresses()) == number_of_facets - 1
    for selector in selectors:
        assert ride_loupe.facetAddress(selector) == utils.ZERO_ADDRESS


@pytest.mark.skip(
    reason="replace should not be used - dodgy | marked as skip as reminder not to use"
)
def test_diamond_replace():
    pass


def test_diamond_add_then_remove(ride_cut, ride_loupe, dBox5, dBox6, ride_multi_sigs):
    selectors_box5 = utils.get_function_selectors(dBox5)
    selectors_box6 = utils.get_function_selectors(dBox6)

    test_diamond_add(ride_cut, ride_loupe, dBox5, ride_multi_sigs)

    assert ride_loupe.facetFunctionSelectors(dBox5.address) == selectors_box5
    assert len(ride_loupe.facetFunctionSelectors(dBox6.address)) == 0

    tx = ride_cut.cut(
        [
            [utils.ZERO_ADDRESS, utils.FACET_CUT_ACTIONS["Remove"], selectors_box5],
            [dBox6.address, utils.FACET_CUT_ACTIONS["Add"], selectors_box6],
        ],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": ride_multi_sigs[1]},
    )
    tx.wait(1)

    assert len(ride_loupe.facetFunctionSelectors(dBox5.address)) == 0
    assert ride_loupe.facetFunctionSelectors(dBox6.address) == selectors_box6


def test_diamond_state_persists_read(
    ride_hub,
    ride_cut,
    ride_loupe,
    dBox5,
    dBox6,
    Box5,
    Box6,
    Contract,
    ride_multi_sigs,
    deployer,
):
    value = 5

    selectors_5 = utils.get_function_selectors(dBox5)
    selectors_6 = utils.get_function_selectors(dBox6)

    # Add Box5

    tx = ride_cut.cut(
        [[dBox5.address, utils.FACET_CUT_ACTIONS["Add"], selectors_5]],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": ride_multi_sigs[1]},
    )
    tx.wait(1)

    assert ride_loupe.facetFunctionSelectors(dBox5.address) == selectors_5

    ride_box_5 = Contract.from_abi("Box5", ride_hub[0].address, Box5.abi, deployer,)

    tx = ride_box_5.store5Add(value)
    tx.wait(1)

    stored_value = value + ride_box_5.getOperationValue()

    assert ride_box_5.retrieve5() == stored_value

    # Remove Box5

    tx = ride_cut.cut(
        [[utils.ZERO_ADDRESS, utils.FACET_CUT_ACTIONS["Remove"], selectors_5,]],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": ride_multi_sigs[1]},
    )
    tx.wait(1)

    assert len(ride_loupe.facetFunctionSelectors(dBox5.address)) == 0

    # add Box6

    tx = ride_cut.cut(
        [[dBox6.address, utils.FACET_CUT_ACTIONS["Add"], selectors_6]],
        utils.ZERO_ADDRESS,
        utils.ZERO_CALLDATAS,
        {"from": ride_multi_sigs[1]},
    )
    tx.wait(1)

    assert ride_loupe.facetFunctionSelectors(dBox6.address) == selectors_6

    ride_box_6 = Contract.from_abi("Box6", ride_hub[0].address, Box6.abi, deployer,)

    assert ride_box_6.retrieve6() == stored_value

    return stored_value, ride_box_6


def test_diamond_state_persists_write(
    ride_hub,
    ride_cut,
    ride_loupe,
    dBox5,
    dBox6,
    Box5,
    Box6,
    Contract,
    ride_multi_sigs,
    deployer,
):
    stored_value, ride_box_6 = test_diamond_state_persists_read(
        ride_hub,
        ride_cut,
        ride_loupe,
        dBox5,
        dBox6,
        Box5,
        Box6,
        Contract,
        ride_multi_sigs,
        deployer,
    )

    new_value = 2

    tx = ride_box_6.store6Minus(new_value)
    tx.wait(1)

    assert ride_box_6.retrieve6() == stored_value - new_value
