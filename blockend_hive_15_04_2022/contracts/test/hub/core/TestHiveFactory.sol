//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/HiveFactory.sol";
import "../../../hub/libraries/core/LibHiveFactory.sol";

contract TestHiveFactory is HiveFactory {
    function sCount_() external view returns (uint256) {
        return LibHiveFactory._storageHiveFactory().count;
    }

    function ssCount_(uint256 _count) external {
        LibHiveFactory._storageHiveFactory().count = _count;
    }

    function sHiveKeyToHive_(bytes32 _key) external view returns (address) {
        return
            LibHiveFactory._storageHiveFactory().hiveKeyToHiveGovernanceToken[
                _key
            ];
    }

    function ssHiveKeyToHive_(bytes32 _key, address _address) external {
        LibHiveFactory._storageHiveFactory().hiveKeyToHiveGovernanceToken[
                _key
            ] = _address;
    }

    function sHiveKeyToHiveTimelock_(bytes32 _key)
        external
        view
        returns (address)
    {
        return LibHiveFactory._storageHiveFactory().hiveKeyToHiveTimelock[_key];
    }

    function ssHiveKeyToHiveTimelock_(bytes32 _key, address _address) external {
        LibHiveFactory._storageHiveFactory().hiveKeyToHiveTimelock[
            _key
        ] = _address;
    }

    function sHiveKeyToHiveGovernor_(bytes32 _key)
        external
        view
        returns (address)
    {
        return LibHiveFactory._storageHiveFactory().hiveKeyToHiveGovernor[_key];
    }

    function ssHiveKeyToHiveGovernor_(bytes32 _key, address _address) external {
        LibHiveFactory._storageHiveFactory().hiveKeyToHiveGovernor[
            _key
        ] = _address;
    }
}
