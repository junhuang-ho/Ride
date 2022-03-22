// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./libraries/utils/DLibAccessControl.sol";
import "./libraries/utils/DLibCutAndLoupe.sol";

import "./facets/utils/DCut.sol";

contract Diamond {
    constructor(address _multisig, address _cutFacet) payable {
        DLibAccessControl._setupRole(
            DLibAccessControl.DEFAULT_ADMIN_ROLE,
            _multisig
        ); // required for initial deployment setup
        DLibAccessControl._setupRole(
            DLibAccessControl.MAINTAINER_ROLE,
            _multisig
        ); // required for initial deployment setup
        DLibAccessControl._setupRole(
            DLibAccessControl.STRATEGIST_ROLE,
            _multisig
        ); // required for initial deployment setup

        // Add the cut external function from the DCut.sol
        DCut.FacetCut[] memory cut = new DCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = DCut.cut.selector;
        cut[0] = DCut.FacetCut({
            facetAddress: _cutFacet,
            action: DCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        DLibCutAndLoupe.cut(cut, address(0), "");
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        DLibCutAndLoupe.StorageCutAndLoupe storage s1;
        bytes32 position = DLibCutAndLoupe.STORAGE_POSITION_CUTANDLOUPE;
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
