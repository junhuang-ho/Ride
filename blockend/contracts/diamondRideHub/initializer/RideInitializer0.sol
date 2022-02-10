// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {IERC165} from "../interfaces/utils/IERC165.sol";
import {IERC173} from "../interfaces/utils/IERC173.sol";
import {IRideCut} from "../interfaces/utils/IRideCut.sol";
import {IRideLoupe} from "../interfaces/utils/IRideLoupe.sol";
import {IRideBadge} from "../interfaces/core/IRideBadge.sol";
import {IRideCurrencyRegistry} from "../interfaces/core/IRideCurrencyRegistry.sol";
import {IRideFee} from "../interfaces/core/IRideFee.sol";
import {IRideExchange} from "../interfaces/core/IRideExchange.sol";
import {IRidePenalty} from "../interfaces/core/IRidePenalty.sol";
import {IRideTicket} from "../interfaces/core/IRideTicket.sol";
import {IRideHolding} from "../interfaces/core/IRideHolding.sol";
import {IRidePassenger} from "../interfaces/core/IRidePassenger.sol";
import {IRideRater} from "../interfaces/core/IRideRater.sol";
import {IRideDriver} from "../interfaces/core/IRideDriver.sol";
import {IRideDriverRegistry} from "../interfaces/core/IRideDriverRegistry.sol";

import {RideLibCutAndLoupe} from "../libraries/utils/RideLibCutAndLoupe.sol";
import {RideLibBadge} from "../libraries/core/RideLibBadge.sol";
import {RideLibPenalty} from "../libraries/core/RideLibPenalty.sol";
import {RideLibFee} from "../libraries/core/RideLibFee.sol";
import {RideLibHolding} from "../libraries/core/RideLibHolding.sol";
import {RideLibPassenger} from "../libraries/core/RideLibPassenger.sol";
import {RideLibDriver} from "../libraries/core/RideLibDriver.sol";
import {RideLibDriverRegistry} from "../libraries/core/RideLibDriverRegistry.sol";
import {RideLibRater} from "../libraries/core/RideLibRater.sol";
import {RideLibTicket} from "../libraries/core/RideLibTicket.sol";

import {RideLibExchange} from "../libraries/core/RideLibExchange.sol";
import {RideLibCurrencyRegistry} from "../libraries/core/RideLibCurrencyRegistry.sol";

// It is exapected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

// ways to call fns from another facet (without knowing address)
// 1. use delegatecall: https://eip2535diamonds.substack.com/p/how-to-share-functions-between-facets
// 2. make those external fns internal and move them to library,
//    then make external fns in respective facets that call those internal fns
//    (can import library and just use the fns needed instead of inheriting)

// import "hardhat/console.sol";

contract RideInitializer0 {
    function init(
        uint256[] memory _badgesMaxScores,
        uint256 _banDuration,
        uint256 _delayPeriod,
        uint256 _ratingMin,
        uint256 _ratingMax,
        uint256 _cancellationFeeUSD,
        uint256 _baseFeeUSD,
        uint256 _costPerMinuteUSD,
        uint256[] memory _costPerMetreUSD,
        address[] memory _tokens,
        address[] memory _priceFeeds
    ) external {
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
        s1.supportedInterfaces[type(IRideHolding).interfaceId] = true;
        s1.supportedInterfaces[type(IRidePassenger).interfaceId] = true;
        s1.supportedInterfaces[type(IRideDriver).interfaceId] = true;
        s1.supportedInterfaces[type(IRideDriverRegistry).interfaceId] = true;
        s1.supportedInterfaces[type(IRideCurrencyRegistry).interfaceId] = true;
        s1.supportedInterfaces[type(IRideExchange).interfaceId] = true;
        s1.supportedInterfaces[type(IRideRater).interfaceId] = true;

        // TODO: register function selectors in interfaces

        // setup
        RideLibBadge._setBadgesMaxScores(_badgesMaxScores);
        RideLibPenalty._setBanDuration(_banDuration);
        RideLibTicket._setForceEndDelay(_delayPeriod);
        RideLibRater._setRatingBounds(_ratingMin, _ratingMax);
        RideLibDriverRegistry._burnFirstDriverId();

        // setup fiat (or crypto)
        bytes32 keyX = RideLibCurrencyRegistry._registerFiat("USD");

        // setup fee
        RideLibFee._setCancellationFee(keyX, _cancellationFeeUSD);
        RideLibFee._setBaseFee(keyX, _baseFeeUSD);
        RideLibFee._setCostPerMinute(keyX, _costPerMinuteUSD);
        RideLibFee._setCostPerMetre(keyX, _costPerMetreUSD);

        require(
            _tokens.length == _priceFeeds.length,
            "number of tokens and price feeds must equal"
        );
        for (uint256 i = 0; i < _tokens.length; i++) {
            // setup crypto (or fiat)
            bytes32 keyY = RideLibCurrencyRegistry._registerCrypto(_tokens[i]);
            // setup pair
            RideLibExchange._addXPerYPriceFeed(keyX, keyY, _priceFeeds[i]);
        }

        // note: for frontend, call RideCurrencyRegistry.setupFiatWithFee/setupCryptoWithFee --> RideExchange.addXPerYPriceFeed
    }
}
