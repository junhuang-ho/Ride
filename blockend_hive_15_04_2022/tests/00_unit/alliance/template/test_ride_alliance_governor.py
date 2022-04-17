import pytest
import math
import brownie
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def ride_driver_details(ride_hub, RideTestDriverDetails, Contract, deployer):
    contract_ride_driver_details = Contract.from_abi(
        "RideTestDriverDetails",
        ride_hub[0].address,
        RideTestDriverDetails.abi,
        deployer,
    )
    yield contract_ride_driver_details


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_castVote_revert(dRideAllianceGovernor):
    with brownie.reverts("RideAllianceGovernor: caller not ally"):
        dRideAllianceGovernor.castVote(123, 1)


def test_castVoteWithReason_revert(dRideAllianceGovernor):
    with brownie.reverts("RideAllianceGovernor: caller not ally"):
        dRideAllianceGovernor.castVoteWithReason(123, 1, "test")


def test_castVoteBySig_revert(dRideAllianceGovernor):
    with brownie.reverts("RideAllianceGovernor: caller not ally"):
        dRideAllianceGovernor.castVoteBySig(
            123, 1, 3, utils.ZERO_BYTES32, utils.ZERO_BYTES32
        )


@pytest.mark.skip(reason="TODO: test OZ's governor standard contract")
def test_(ride_driver_details, dRideAllianceTimelock, deployer):
    tx = ride_driver_details.ssDriverToDriverDetails_(
        deployer, 3, "tester", dRideAllianceTimelock.address, 500, 0, 0, 0, 0, 5
    )  # to pass onlyAlly check
    tx.wait(1)

    pass
