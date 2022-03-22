import scripts.utils as utils
import scripts.execution_patterns as ep


def setup_main_token(token, multi_sig_admin, deployer):
    assert token.owner() == deployer

    tx = token.transferOwnership(multi_sig_admin.address, {"from": deployer})
    tx.wait(1)

    assert token.owner() == multi_sig_admin.address


def setup_governance_roles(timelock, governor, deployer, multi_sig_strategist):
    role_proposer = timelock.PROPOSER_ROLE()
    role_executor = timelock.EXECUTOR_ROLE()
    role_admin = timelock.TIMELOCK_ADMIN_ROLE()

    # check that 2 addresses owns the role_admin
    assert timelock.hasRole(role_admin, timelock.address)
    assert timelock.hasRole(role_admin, deployer)

    # set proposer role to governor contract
    # in TimelockController, proposer role is incharge of "schedule/scheduleBatch" function
    # so "schedule/scheduleBatch" function is only callable by whoever has TimelockController's PROPOSER_ROLE
    # Governor(timelock) module uses "schedule/scheduleBatch" in "queue" function
    # which it so happen can call because proposer role is given to governor
    # since "queue" function is callable by anyone, in a way anyone can call "schedule/scheduleBatch"
    # as long as it passes through the governor contract
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

    # for governor with fallback option
    try:
        assert governor.owner() == deployer

        tx = governor.transferOwnership(
            multi_sig_strategist.address, {"from": deployer}
        )
        tx.wait(1)

        assert governor.owner() == multi_sig_strategist.address
    except:
        print("not ownable")
        pass


def setup_hub_with_multi_sigs(
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


def transfer_hub_roles_to_governance(
    access_control,
    hub,
    multisig_administration,
    multisig_maintainer,
    multisig_strategist,
    timelock,
    proposer,
    members,
):
    role_admin = access_control.getDefaultAdminRole()
    role_maintainer = access_control.getRole("MAINTAINER_ROLE")
    role_strategist = access_control.getRole("STRATEGIST_ROLE")

    assert access_control.hasRole(role_admin, multisig_administration.address)
    assert access_control.hasRole(role_maintainer, multisig_maintainer.address)
    assert access_control.hasRole(role_strategist, multisig_strategist.address)
    assert not access_control.hasRole(role_admin, timelock.address)
    assert not access_control.hasRole(role_maintainer, timelock.address)
    assert not access_control.hasRole(role_strategist, timelock.address)

    tx_index = 0
    multi_sig = multisig_administration
    target_contract = hub

    args = (role_admin, timelock.address)
    encoding = access_control.grantRole.encode_input(*args)
    ep.execute_multisig_decision(
        0, multi_sig, target_contract, encoding, proposer, members
    )

    args = (role_maintainer, timelock.address)
    encoding = access_control.grantRole.encode_input(*args)
    ep.execute_multisig_decision(
        1, multi_sig, target_contract, encoding, proposer, members
    )

    args = (role_strategist, timelock.address)
    encoding = access_control.grantRole.encode_input(*args)
    ep.execute_multisig_decision(
        2, multi_sig, target_contract, encoding, proposer, members
    )

    # WARNING | renounceRole
    args = (role_strategist,)
    encoding = access_control.renounceRole.encode_input(*args)
    ep.execute_multisig_decision(
        tx_index, multi_sig, target_contract, encoding, proposer, members
    )

    args = (role_maintainer,)
    encoding = access_control.renounceRole.encode_input(*args)
    ep.execute_multisig_decision(
        tx_index, multi_sig, target_contract, encoding, proposer, members
    )

    args = (role_admin,)
    encoding = access_control.renounceRole.encode_input(*args)
    ep.execute_multisig_decision(
        tx_index, multi_sig, target_contract, encoding, proposer, members
    )

    assert not access_control.hasRole(role_admin, multisig_administration.address)
    assert not access_control.hasRole(role_maintainer, multisig_maintainer.address)
    assert not access_control.hasRole(role_strategist, multisig_strategist.address)
    assert access_control.hasRole(role_admin, timelock.address)
    assert access_control.hasRole(role_maintainer, timelock.address)
    assert access_control.hasRole(role_strategist, timelock.address)
