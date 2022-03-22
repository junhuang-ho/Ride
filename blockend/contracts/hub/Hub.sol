// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./libraries/utils/LibAccessControl.sol";
import "./libraries/utils/LibCutAndLoupe.sol";

import "./facets/utils/Cut.sol";

contract Hub {
    constructor(address _multisig, address _cutFacet) payable {
        LibAccessControl._setupRole(
            LibAccessControl.DEFAULT_ADMIN_ROLE,
            _multisig
        ); // required for initial deployment setup
        LibAccessControl._setupRole(
            LibAccessControl.MAINTAINER_ROLE,
            _multisig
        ); // required for initial deployment setup
        LibAccessControl._setupRole(
            LibAccessControl.STRATEGIST_ROLE,
            _multisig
        ); // required for initial deployment setup

        // Add the cut external function from the Cut.sol
        Cut.FacetCut[] memory cut = new Cut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = Cut.cut.selector;
        cut[0] = Cut.FacetCut({
            facetAddress: _cutFacet,
            action: Cut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        LibCutAndLoupe.cut(cut, address(0), "");
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        LibCutAndLoupe.StorageCutAndLoupe storage s1;
        bytes32 position = LibCutAndLoupe.STORAGE_POSITION_CUTANDLOUPE;
        // get diamond storage
        assembly {
            s1.slot := position
        }
        // get facet from function selector
        // address facet = s1.selectorToFacetAndPosition[msg.sig].facetAddress; // diamond-3 implementation
        address facet = address(bytes20(s1.facets[msg.sig])); // diamond-2 implementation
        require(facet != address(0), "Hub: Function does not exist");
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}
}
