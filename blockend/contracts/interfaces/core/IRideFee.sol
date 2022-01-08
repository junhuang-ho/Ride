// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideFee {
    event FeeSetRequest(address indexed sender, uint256 fee);

    function setRequestFee(uint256 _requestFee) external;

    event FeeSetBase(address indexed sender, uint256 fee);

    function setBaseFee(uint256 _baseFee) external;

    event FeeSetCostPerMinute(address indexed sender, uint256 fee);

    function setCostPerMinute(uint256 _costPerMinute) external;

    event FeeSetCostPerMetre(address indexed sender, uint256[] fee);

    function setCostPerMetre(uint256[] memory _costPerMetre) external;

    function getRequestFee() external view returns (uint256);

    function getBaseFee() external view returns (uint256);

    function getCostPerMinute() external view returns (uint256);

    function getBadgeToCostPerMetre(uint256 _badge)
        external
        view
        returns (uint256);
}
