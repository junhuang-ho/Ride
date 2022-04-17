import pytest
import brownie
import scripts.utils as utils
import scripts.execution_patterns as ep


@pytest.fixture(scope="module", autouse=True)
def role_admin(ride_access_control):
    yield ride_access_control.getDefaultAdminRole()


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_grantRole(
    role_admin, ride_hub, ride_access_control, ride_multi_sigs, deployer, person1
):
    # 1 # address without role cannot execute

    assert not ride_access_control.hasRole(role_admin, person1)
    assert ride_access_control.hasRole(role_admin, ride_multi_sigs[0].address)

    with brownie.reverts():
        ride_access_control.grantRole(role_admin, person1, {"from": person1})

    # 2 # execute

    members = [deployer, person1]
    args = (role_admin, person1)
    encoding = ride_access_control.grantRole.encode_input(*args)
    ep.execute_multisig_decision(
        0, ride_multi_sigs[0], ride_hub[0].address, encoding, deployer, members
    )

    assert ride_access_control.hasRole(role_admin, person1)
    assert ride_access_control.hasRole(role_admin, ride_multi_sigs[0].address)


def test_revokeRole(
    role_admin, ride_hub, ride_access_control, ride_multi_sigs, deployer, person1
):
    # 1 # address without role cannot execute

    assert not ride_access_control.hasRole(role_admin, person1)
    assert ride_access_control.hasRole(role_admin, ride_multi_sigs[0].address)

    with brownie.reverts():
        ride_access_control.revokeRole(role_admin, person1, {"from": person1})

    # 2 # execute

    members = [deployer, person1]
    args = (role_admin, ride_multi_sigs[0].address)
    encoding = ride_access_control.revokeRole.encode_input(
        *args
    )  # WARNING: revoking self
    ep.execute_multisig_decision(
        0, ride_multi_sigs[0], ride_hub[0].address, encoding, deployer, members
    )

    assert not ride_access_control.hasRole(role_admin, person1)
    assert not ride_access_control.hasRole(role_admin, ride_multi_sigs[0].address)


def test_setNativeToken(
    ride_hub, ride_currency_registry, ride_token, ride_multi_sigs, deployer, person1
):
    assert ride_currency_registry.getNativeToken() == ride_token.address

    dummy_token = person1.address

    members = [deployer, person1]
    args = (dummy_token,)
    encoding = ride_currency_registry.setNativeToken.encode_input(*args)
    ep.execute_multisig_decision(
        0, ride_multi_sigs[0], ride_hub[0].address, encoding, deployer, members
    )

    assert ride_currency_registry.getNativeToken() == dummy_token
