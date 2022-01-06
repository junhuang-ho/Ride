// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideFee {
    function setRequestFee(uint256 _requestFee) external;

    function setBaseFee(uint256 _baseFee) external;

    function setCostPerMinute(uint256 _costPerMinute) external;

    function setCostPerMetre(uint256[] memory _costPerMetre) external;

    function getRequestFee() external view returns (uint256);

    function getBaseFee() external view returns (uint256);

    function getCostPerMinute() external view returns (uint256);

    function getBadgeToCostPerMetre(uint256 _badge)
        external
        view
        returns (uint256);
}
