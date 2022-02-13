//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../interfaces/administration/IRideDriverAssistant.sol";
import "../../libraries/administration/RideLibDriverAssistant.sol";
import "../../libraries/utils/RideLibAccessControl.sol";

contract RideDriverAssistant is IRideDriverAssistant {
    /**
     * approveApplicant of driver applicants
     *
     * @param _driver applicant
     * @param _uri information of applicant
     *
     * @custom:event ApplicantApproved
     */
    function approveApplicant(address _driver, string memory _uri)
        external
        override
    {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.DEFAULT_ADMIN_ROLE
        );

        RideLibDriverAssistant.StorageDriverAssistant
            storage s1 = RideLibDriverAssistant._storageDriverAssistant();

        require(
            bytes(s1.applicantToUri[_driver]).length == 0,
            "uri already set"
        );
        s1.applicantToUri[_driver] = _uri;

        emit ApplicantApproved(_driver);
    }

    function getDriverURI(address _driver)
        external
        view
        override
        returns (string memory)
    {
        return
            RideLibDriverAssistant._storageDriverAssistant().applicantToUri[
                _driver
            ];
    }
}
