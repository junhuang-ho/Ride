// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Initializable} from "./utils/Initializable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {IERC165} from "../interfaces/utils/IERC165.sol";
import {IERC173} from "../interfaces/utils/IERC173.sol";
import {IRideCut} from "../interfaces/utils/IRideCut.sol";
import {IRideLoupe} from "../interfaces/utils/IRideLoupe.sol";

import {IRideBadge} from "../interfaces/core/IRideBadge.sol";
import {IRideFee} from "../interfaces/core/IRideFee.sol";
import {IRidePenalty} from "../interfaces/core/IRidePenalty.sol";
import {IRideTicket} from "../interfaces/core/IRideTicket.sol";
import {IRideUser} from "../interfaces/core/IRideUser.sol";
import {IRidePassenger} from "../interfaces/core/IRidePassenger.sol";
import {IRideDriver} from "../interfaces/core/IRideDriver.sol";

import {RideBadge} from "../facets/core/RideBadge.sol";
import {RideFee} from "../facets/core/RideFee.sol";
import {RidePenalty} from "../facets/core/RidePenalty.sol";
import {RidePassenger} from "../facets/core/RidePassenger.sol";
import {RideDriver} from "../facets/core/RideDriver.sol";

import {RideLibCutAndLoupe} from "../libraries/utils/RideLibCutAndLoupe.sol";
import {RideLibUser} from "../libraries/core/RideLibUser.sol";

// It is exapected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

// ways to call fns from another facet (without knowing address)
// 1. use delegatecall: https://eip2535diamonds.substack.com/p/how-to-share-functions-between-facets
// 2. make those external fns internal and move them to library,
//    then make external fns in respective facets that call those internal fns
//    (can import library and just use the fns needed instead of inheriting)

contract RideInitializer0 is
    Initializable,
    RideBadge,
    RideFee,
    RidePenalty,
    RidePassenger,
    RideDriver
{
    function init(
        address _tokenAddress,
        uint256[] memory _badgesMaxScores,
        uint256 _requestFee,
        uint256 _baseFee,
        uint256 _costPerMinute,
        uint256[] memory _costPerMetre,
        uint256 _banDuration,
        uint256 _ratingMin,
        uint256 _ratingMax
    ) external initializer {
        // ass inits within this function as needed

        // adding ERC165 data
        RideLibCutAndLoupe.StorageCutAndLoupe storage s1 = RideLibCutAndLoupe
            ._storageCutAndLoupe();
        s1.supportedInterfaces[type(IERC165).interfaceId] = true;
        s1.supportedInterfaces[type(IERC173).interfaceId] = true;
        s1.supportedInterfaces[type(IRideCut).interfaceId] = true;
        s1.supportedInterfaces[type(IRideLoupe).interfaceId] = true;

        s1.supportedInterfaces[type(IRideBadge).interfaceId] = true;
        s1.supportedInterfaces[type(IRideFee).interfaceId] = true;
        s1.supportedInterfaces[type(IRidePenalty).interfaceId] = true;
        s1.supportedInterfaces[type(IRideTicket).interfaceId] = true;
        s1.supportedInterfaces[type(IRideUser).interfaceId] = true;
        s1.supportedInterfaces[type(IRidePassenger).interfaceId] = true;
        s1.supportedInterfaces[type(IRideDriver).interfaceId] = true;

        RideLibUser.StorageUser storage s2 = RideLibUser._storageUser();
        s2.token = ERC20(_tokenAddress);

        setBadgesMaxScores(_badgesMaxScores);

        setRequestFee(_requestFee);
        setBaseFee(_baseFee);
        setCostPerMinute(_costPerMinute);
        setCostPerMetre(_costPerMetre);

        setRatingBounds(_ratingMin, _ratingMax);

        setBanDuration(_banDuration);

        _burnFirstDriverId();
    }
}
