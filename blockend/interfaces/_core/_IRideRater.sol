//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

interface IRideRater {
    event SetRatingBounds(address indexed sender, uint256 min, uint256 max);

    function setRatingBounds(uint256 _min, uint256 _max) external;

    function getRatingMin() external view returns (uint256);

    function getRatingMax() external view returns (uint256);
}
