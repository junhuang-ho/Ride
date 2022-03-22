import pytest
import math
import brownie
from web3 import Web3
import scripts.utils as utils

ZERO_BYTES32 = "0x0000000000000000000000000000000000000000000000000000000000000000"
TEST1_ROLE = Web3.toHex(Web3.solidityKeccak(["string"], ["TEST1_ROLE"]))
TEST1_ROLE_ADMIN = Web3.toHex(Web3.solidityKeccak(["string"], ["TEST1_ROLE_ADMIN"]))


@pytest.fixture(scope="module", autouse=True)
def ride_access_control(ride_hub, RideAccessControl, Contract, deployer):
    yield Contract.from_abi(
        "RideAccessControl", ride_hub[0].address, RideAccessControl.abi, deployer
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_default_admin_role(ride_access_control):
    # zero defined role should an admin role of DEFAULT_ADMIN_ROLE (zero)
    assert (
        ride_access_control.getRoleAdmin(ZERO_BYTES32)
        == ride_access_control.getDefaultAdminRole()
    )

    # any role should an admin role of DEFAULT_ADMIN_ROLE (zero)
    assert (
        ride_access_control.getRoleAdmin(TEST1_ROLE)
        == ride_access_control.getDefaultAdminRole()
    )


def test_admin_role(
    ride_hub,
    RideTestAccessControl,
    Contract,
    ride_access_control,
    deployer,
    person1,
    person2,
):
    # only admin of role can grant/revoke that role on addresses - DEFAULT_ADMIN_ROLE
    assert not ride_access_control.hasRole(TEST1_ROLE, person1)

    tx = ride_access_control.grantRole(TEST1_ROLE, person1, {"from": deployer})
    tx.wait(1)

    assert ride_access_control.hasRole(TEST1_ROLE, person1)

    # only admin of role can grant/revoke that role on addresses - TEST1_ROLE_ADMIN
    ride_access_control_1 = Contract.from_abi(
        "RideTestAccessControl",
        ride_hub[0].address,
        RideTestAccessControl.abi,
        deployer,
    )

    ### giving addresses admin role, note this fn is NOT exposed as external fn as it can be dangerous
    tx = ride_access_control_1.setRoleAdmin_(TEST1_ROLE, TEST1_ROLE_ADMIN)
    tx.wait(1)

    assert not ride_access_control.hasRole(TEST1_ROLE_ADMIN, person1)

    tx = ride_access_control.grantRole(TEST1_ROLE_ADMIN, person1, {"from": deployer})
    tx.wait(1)

    assert not ride_access_control.hasRole(TEST1_ROLE, person2)

    # reverts as now DEFAULT_ADMIN_ROLE is not admin role of TEST1_ROLE
    with brownie.reverts():
        ride_access_control.grantRole(TEST1_ROLE, person2, {"from": deployer})

    tx = ride_access_control.grantRole(TEST1_ROLE, person2, {"from": person1})
    tx.wait(1)

    assert ride_access_control.hasRole(TEST1_ROLE, person2)

