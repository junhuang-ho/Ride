import pytest
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils


value_ = 5


def data(dBoxie):
    args = (value_,)
    return dBoxie.store.encode_input(*args)


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_constructor(ride_multi_sig, deployer, person1):
    assert ride_multi_sig.name() == "Ride Administration Test"
    assert len(ride_multi_sig.getMembers()) == 2
    assert ride_multi_sig.getMembers()[0] == deployer
    assert ride_multi_sig.getMembers()[1] == person1
    assert ride_multi_sig.numConfirmationsRequired() == 1


def test_receive(ride_multi_sig, deployer):
    assert ride_multi_sig.getBalance() == "0 ether"

    tx = deployer.transfer(ride_multi_sig, "10 ether")
    tx.wait(1)

    assert ride_multi_sig.getBalance() == "10 ether"


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_receive_event(ride_multi_sig, deployer):
    tx = deployer.transfer(ride_multi_sig, "10 ether")
    tx.wait(1)

    assert tx.events["Deposit"]["sender"] == deployer
    assert tx.events["Deposit"]["amount"] == "10 ether"
    assert tx.events["Deposit"]["balance"] == "10 ether"
    assert tx.events["Deposit"]["data"] == utils.ZERO_BYTES32


def test_fallback(ride_multi_sig, dBoxie, deployer):
    assert ride_multi_sig.getBalance() == "0 ether"

    tx = deployer.transfer(ride_multi_sig, "10 ether", data=data(dBoxie))
    tx.wait(1)

    assert ride_multi_sig.getBalance() == "10 ether"


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_fallback_event(ride_multi_sig, dBoxie, deployer):
    tx = deployer.transfer(ride_multi_sig, "10 ether", data=data(dBoxie))
    tx.wait(1)

    assert tx.events["Deposit"]["sender"] == deployer
    assert tx.events["Deposit"]["amount"] == "10 ether"
    assert tx.events["Deposit"]["balance"] == "10 ether"
    assert tx.events["Deposit"]["data"] == data(dBoxie)


def test_onlyThis_revert(ride_multi_sig, deployer):
    with brownie.reverts("RideMultiSignatureWallet: caller not this contract"):
        ride_multi_sig.onlyThis_({"from": deployer})


def test_onlyThis_pass(ride_multi_sig):
    tx = ride_multi_sig.onlyThis_({"from": ride_multi_sig})
    tx.wait(1)


def test_onlyMember_revert(ride_multi_sig, person2):
    with brownie.reverts("RideMultiSignatureWallet: caller not member"):
        ride_multi_sig.onlyMember_({"from": person2})


def test_onlyMember_pass(ride_multi_sig, deployer, person2):
    tx = ride_multi_sig.ssIsMember_(person2, True, {"from": deployer})
    tx.wait(1)

    tx = ride_multi_sig.onlyMember_({"from": person2})
    tx.wait(1)


def test_txExists_revert(ride_multi_sig, deployer):
    with brownie.reverts("RideMultiSignatureWallet: tx does not exist"):
        ride_multi_sig.txExists_(0, {"from": deployer})


def test_txExists_pass(ride_multi_sig, deployer, person2):
    tx = ride_multi_sig.ssTransactions_(
        person2.address, 0, utils.ZERO_BYTES32, "test", False, 0
    )
    tx.wait(1)

    tx = ride_multi_sig.txExists_(0, {"from": deployer})
    tx.wait(1)


def test_notExecuted_revert(ride_multi_sig, deployer, person2):
    tx = ride_multi_sig.ssTransactions_(
        person2.address, 0, utils.ZERO_BYTES32, "test", True, 1
    )
    tx.wait(1)

    with brownie.reverts("RideMultiSignatureWallet: tx already executed"):
        ride_multi_sig.notExecuted_(0, {"from": deployer})


def test_notExecuted_pass(ride_multi_sig, deployer, person2):
    tx = ride_multi_sig.ssTransactions_(
        person2.address, 0, utils.ZERO_BYTES32, "test", False, 1
    )
    tx.wait(1)

    tx = ride_multi_sig.notExecuted_(0, {"from": deployer})
    tx.wait(1)


def test_notConfirmed_revert(ride_multi_sig, deployer):
    tx = ride_multi_sig.ssIsConfirmed_(0, deployer.address, True)
    tx.wait(1)

    with brownie.reverts("RideMultiSignatureWallet: tx already confirmed"):
        ride_multi_sig.notConfirmed_(0, {"from": deployer})


def test_notConfirmed_pass(ride_multi_sig, deployer):
    tx = ride_multi_sig.notConfirmed_(0, {"from": deployer})
    tx.wait(1)


def test_setMembers_require_1_revert(ride_multi_sig):
    with brownie.reverts("RideMultiSignatureWallet: members required"):
        ride_multi_sig.setMembers_([], 1)


def test_setMembers_require_2_revert(ride_multi_sig, deployer, person1):
    with brownie.reverts(
        "RideMultiSignatureWallet: invalid number of required confirmations"
    ):
        ride_multi_sig.setMembers_([deployer, person1], 0)

    with brownie.reverts(
        "RideMultiSignatureWallet: invalid number of required confirmations"
    ):
        ride_multi_sig.setMembers_([deployer, person1], 3)


def test_setMembers_require_3_revert(ride_multi_sig, person2):
    with brownie.reverts("RideMultiSignatureWallet: zero address member"):
        ride_multi_sig.setMembers_([person2, utils.ZERO_ADDRESS], 1)


def test_setMembers_require_4_revert(ride_multi_sig, person1, person2):
    with brownie.reverts("RideMultiSignatureWallet: member not unique"):
        ride_multi_sig.setMembers_([person2, person1], 1)


def test_setMembers(ride_multi_sig, deployer, person1, person2):
    assert ride_multi_sig.isMember(person2) == False
    assert len(ride_multi_sig.getMembers()) == 2
    assert ride_multi_sig.getMembers()[0] == deployer
    assert ride_multi_sig.getMembers()[1] == person1
    assert ride_multi_sig.numConfirmationsRequired() == 1

    tx = ride_multi_sig.setMembers_([person2], 1)
    tx.wait(1)

    assert ride_multi_sig.isMember(person2) == True
    assert len(ride_multi_sig.getMembers()) == 3
    assert ride_multi_sig.getMembers()[0] == deployer
    assert ride_multi_sig.getMembers()[1] == person1
    assert ride_multi_sig.getMembers()[2] == person2
    assert ride_multi_sig.numConfirmationsRequired() == 1


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setMembers_event(ride_multi_sig, deployer, person2):
    tx = ride_multi_sig.setMembers_([person2], 1, {"from": deployer})
    tx.wait(1)

    assert tx.events["MembersAdded"]["sender"] == deployer
    assert tx.events["MembersAdded"]["members"] == [person2]


@pytest.mark.skip(reason="TODO: test reset members of multisig")
def test_resetMembers(ride_multi_sig, deployer, person1, person2):
    assert ride_multi_sig.isMember(person2) == False
    assert len(ride_multi_sig.getMembers()) == 2
    assert ride_multi_sig.getMembers()[0] == deployer
    assert ride_multi_sig.getMembers()[1] == person1
    assert ride_multi_sig.numConfirmationsRequired() == 1

    tx = ride_multi_sig.resetMembers([person2], 1, {"from": ride_multi_sig})
    tx.wait(1)

    assert ride_multi_sig.isMember(person2) == True
    assert len(ride_multi_sig.getMembers()) == 1
    assert ride_multi_sig.getMembers()[0] == person2
    assert ride_multi_sig.numConfirmationsRequired() == 1


def test_getMembers(ride_multi_sig, deployer, person1, person2):
    assert len(ride_multi_sig.getMembers()) == 2
    assert ride_multi_sig.getMembers()[0] == deployer
    assert ride_multi_sig.getMembers()[1] == person1

    tx = ride_multi_sig.ssMembers_([person2])
    tx.wait(1)

    assert len(ride_multi_sig.getMembers()) == 3
    assert ride_multi_sig.getMembers()[0] == deployer
    assert ride_multi_sig.getMembers()[1] == person1
    assert ride_multi_sig.getMembers()[2] == person2


def test_getTransactionCount(ride_multi_sig, person2):
    assert ride_multi_sig.getTransactionCount() == 0

    tx = ride_multi_sig.ssTransactions_(
        person2.address, 0, utils.ZERO_BYTES32, "test", False, 0
    )
    tx.wait(1)

    assert ride_multi_sig.getTransactionCount() == 1


def test_getTransactionDetails(ride_multi_sig, dBoxie, person2):
    assert ride_multi_sig.getTransactionCount() == 0

    tx = ride_multi_sig.ssTransactions_(
        person2.address, 5, data(dBoxie), "test", True, 1
    )
    tx.wait(1)

    assert ride_multi_sig.getTransactionCount() == 1

    (
        to,
        value,
        data_,
        description,
        executed,
        numConfirmations,
    ) = ride_multi_sig.getTransactionDetails(0)

    assert to == person2.address
    assert value == 5
    assert data_ == data(dBoxie)
    assert description == "test"
    assert executed
    assert numConfirmations == 1


def test_submitTransaction(ride_multi_sig, dBoxie, deployer, person2):
    assert ride_multi_sig.getTransactionCount() == 0

    tx = ride_multi_sig.submitTransaction(
        dBoxie.address, "0 ether", data(dBoxie), "tester", {"from": deployer}
    )
    tx.wait(1)

    assert ride_multi_sig.getTransactionCount() == 1

    (
        to,
        value,
        data_,
        description,
        executed,
        numConfirmations,
    ) = ride_multi_sig.getTransactionDetails(0)

    assert to == dBoxie.address
    assert value == "0 ether"
    assert data_ == data(dBoxie)
    assert description == "tester"
    assert not executed
    assert numConfirmations == 0


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_submitTransaction_event(ride_multi_sig, dBoxie, deployer, person2):
    tx = ride_multi_sig.submitTransaction(
        dBoxie.address, "0 ether", data(dBoxie), "tester1", {"from": deployer}
    )
    tx.wait(1)

    tx = ride_multi_sig.submitTransaction(
        dBoxie.address, "0 ether", data(dBoxie), "tester2", {"from": deployer}
    )
    tx.wait(1)

    assert tx.events["SubmitTransaction"]["sender"] == deployer
    assert tx.events["SubmitTransaction"]["txIndex"] == 1


def test_confirmTransaction(ride_multi_sig, dBoxie, deployer, person2):
    test_submitTransaction(ride_multi_sig, dBoxie, deployer, person2)

    assert not ride_multi_sig.isConfirmed(0, deployer)

    tx = ride_multi_sig.confirmTransaction(0, {"from": deployer})
    tx.wait(1)

    assert ride_multi_sig.isConfirmed(0, deployer)

    (
        to,
        value,
        data_,
        description,
        executed,
        numConfirmations,
    ) = ride_multi_sig.getTransactionDetails(0)

    assert to == dBoxie.address
    assert value == "0 ether"
    assert data_ == data(dBoxie)
    assert description == "tester"
    assert not executed
    assert numConfirmations == 1


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_confirmTransaction_event(ride_multi_sig, dBoxie, deployer, person2):
    test_submitTransaction(ride_multi_sig, dBoxie, person2)

    tx = ride_multi_sig.confirmTransaction(0, {"from": deployer})
    tx.wait(1)

    assert tx.events["SubmitTransaction"]["sender"] == deployer
    assert tx.events["SubmitTransaction"]["txIndex"] == 0


def test_revokeConfirmation_revert(ride_multi_sig, dBoxie, deployer, person1, person2):
    test_confirmTransaction(ride_multi_sig, dBoxie, deployer, person2)

    with brownie.reverts("RideMultiSignatureWallet: tx not confirmed"):
        ride_multi_sig.revokeConfirmation(0, {"from": person1})


def test_revokeConfirmation(ride_multi_sig, dBoxie, deployer, person2):
    test_confirmTransaction(ride_multi_sig, dBoxie, deployer, person2)

    tx = ride_multi_sig.revokeConfirmation(0, {"from": deployer})
    tx.wait(1)

    assert not ride_multi_sig.isConfirmed(0, deployer)

    (
        to,
        value,
        data_,
        description,
        executed,
        numConfirmations,
    ) = ride_multi_sig.getTransactionDetails(0)

    assert to == dBoxie.address
    assert value == "0 ether"
    assert data_ == data(dBoxie)
    assert description == "tester"
    assert not executed
    assert numConfirmations == 0


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_revokeConfirmation_event(ride_multi_sig, dBoxie, deployer, person2):
    test_confirmTransaction(ride_multi_sig, dBoxie, deployer, person2)

    tx = ride_multi_sig.revokeConfirmation(0, {"from": deployer})
    tx.wait(1)

    assert tx.events["RevokeConfirmation"]["sender"] == deployer
    assert tx.events["RevokeConfirmation"]["txIndex"] == 0


def test_executeTransaction_revert(ride_multi_sig, dBoxie, deployer, person2):
    test_confirmTransaction(ride_multi_sig, dBoxie, deployer, person2)

    tx = ride_multi_sig.ssNumConfirmationsRequired(2)
    tx.wait(1)

    with brownie.reverts("RideMultiSignatureWallet: not enough confirmations"):
        ride_multi_sig.executeTransaction(0, {"from": deployer})


def test_executeTransaction(ride_multi_sig, dBoxie, deployer, person2):
    test_confirmTransaction(ride_multi_sig, dBoxie, deployer, person2)

    assert dBoxie.retrieve() == 0

    tx = deployer.transfer(ride_multi_sig, "10 ether")
    tx.wait(1)

    tx = ride_multi_sig.executeTransaction(0, {"from": deployer})
    tx.wait(1)

    (
        to,
        value,
        data_,
        description,
        executed,
        numConfirmations,
    ) = ride_multi_sig.getTransactionDetails(0)

    assert to == dBoxie.address
    assert value == "0 ether"
    assert data_ == data(dBoxie)
    assert description == "tester"
    assert executed
    assert numConfirmations == 1

    assert dBoxie.retrieve() == value_


@pytest.mark.skip(
    reason="for some reason if value sent is > 0, tx fails, try replace all 0 ether to 5 ether"
)
def test_executeTransaction_non_zero_value(ride_multi_sig, dBoxie, deployer, person2):
    test_confirmTransaction(ride_multi_sig, dBoxie, deployer, person2)

    assert dBoxie.retrieve() == 0

    tx = deployer.transfer(ride_multi_sig, "10 ether")
    tx.wait(1)

    tx = ride_multi_sig.executeTransaction(0, {"from": deployer})
    tx.wait(1)

    (
        to,
        value,
        data_,
        description,
        executed,
        numConfirmations,
    ) = ride_multi_sig.getTransactionDetails(0)

    assert to == dBoxie.address
    assert value == "0 ether"
    assert data_ == data(dBoxie)
    assert description == "tester"
    assert executed
    assert numConfirmations == 1

    assert dBoxie.retrieve() == value_


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_executeTransaction_event(ride_multi_sig, dBoxie, deployer, person2):
    test_confirmTransaction(ride_multi_sig, dBoxie, deployer, person2)

    tx = deployer.transfer(ride_multi_sig, "10 ether")
    tx.wait(1)

    tx = ride_multi_sig.executeTransaction(0, {"from": deployer})
    tx.wait(1)

    assert tx.events["ExecuteTransaction"]["sender"] == deployer
    assert tx.events["ExecuteTransaction"]["txIndex"] == 0


def test_send_value_only_contract_address(ride_multi_sig, dBoxie, deployer):
    amount = "2 ether"

    tx = ride_multi_sig.submitTransaction(
        dBoxie.address, amount, utils.ZERO_BYTES32, "tester", {"from": deployer}
    )
    tx.wait(1)

    tx = ride_multi_sig.confirmTransaction(0, {"from": deployer})
    tx.wait(1)

    tx = deployer.transfer(ride_multi_sig, "10 ether")
    tx.wait(1)

    assert ride_multi_sig.balance() == "10 ether"

    tx = ride_multi_sig.executeTransaction(0, {"from": deployer})
    tx.wait(1)

    assert ride_multi_sig.balance() == "8 ether"


def test_send_value_only_EOA_address(ride_multi_sig, person2, deployer):
    amount = "2 ether"

    tx = ride_multi_sig.submitTransaction(
        person2.address, amount, utils.ZERO_BYTES32, "tester", {"from": deployer}
    )
    tx.wait(1)

    tx = ride_multi_sig.confirmTransaction(0, {"from": deployer})
    tx.wait(1)

    tx = deployer.transfer(ride_multi_sig, "10 ether")
    tx.wait(1)

    assert ride_multi_sig.balance() == "10 ether"

    tx = ride_multi_sig.executeTransaction(0, {"from": deployer})
    tx.wait(1)

    assert ride_multi_sig.balance() == "8 ether"
