//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

interface IRideSettings {
    function setAdministrationAddress(address _administration) external;

    function getAdministrationAddress() external view returns (address);
}
