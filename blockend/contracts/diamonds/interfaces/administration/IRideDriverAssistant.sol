//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

interface IRideDriverAssistant {
    event ApplicantApproved(address indexed applicant);

    function approveApplicant(address _driver, string memory _uri) external;

    function getDriverURI(address _driver)
        external
        view
        returns (string memory);
}
