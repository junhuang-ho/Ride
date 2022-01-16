// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideFee {
    event FeeSetRequest(address indexed sender, uint256 fee);

    function setRequestFee(bytes32 _key, uint256 _requestFee) external;

    event FeeSetBase(address indexed sender, uint256 fee);

    function setBaseFee(bytes32 _key, uint256 _baseFee) external;

    event FeeSetCostPerMinute(address indexed sender, uint256 fee);

    function setCostPerMinute(bytes32 _key, uint256 _costPerMinute) external;

    event FeeSetCostPerMetre(address indexed sender, uint256[] fee);

    function setCostPerMetre(bytes32 _key, uint256[] memory _costPerMetre)
        external;

    function getFare(
        bytes32 _key,
        uint256 _badge,
        uint256 _minutesTaken,
        uint256 _metresTravelled
    ) external view returns (uint256);

    function getRequestFee(bytes32 _key) external view returns (uint256);

    function getBaseFee(bytes32 _key) external view returns (uint256);

    function getCostPerMinute(bytes32 _key) external view returns (uint256);

    function getCostPerMetre(bytes32 _key, uint256 _badge)
        external
        view
        returns (uint256);
}
