// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideDriverRegistry {
    event RegisteredAsDriver(address indexed sender);

    function registerAsDriver(uint256 _maxMetresPerTrip) external;

    event MaxMetresUpdated(address indexed sender, uint256 metres);

    function updateMaxMetresPerTrip(uint256 _maxMetresPerTrip) external;

    // event ApplicantApproved(address indexed applicant);

    // function approveApplicant(address _driver, string memory _uri) external;
}
