//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/utils/RideLibOwnership.sol";
import "../../libraries/core/RideLibCurrencyRegistry.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "hardhat/console.sol";

library RideLibExchange {
    using Counters for Counters.Counter;

    bytes32 constant STORAGE_POSITION_EXCHANGE = keccak256("ds.exchange");

    struct DerivedPriceFeed {
        bytes32 keyX;
        bytes32 keyY;
    }

    struct DerivedPriceFeedDetails {
        address numerator;
        address denominator;
        bool numeratorInverse;
        bool denominatorInverse;
    }

    struct StorageExchange {
        Counters.Counter _derivePriceFeedCounter;
        mapping(bytes32 => mapping(bytes32 => address)) xToYToXPerYPriceFeed;
        mapping(bytes32 => mapping(bytes32 => bool)) xToYToXPerYInverse;
        mapping(bytes32 => mapping(bytes32 => DerivedPriceFeedDetails)) xToYToXPerYDerivedPriceFeedDetails;
        mapping(bytes32 => mapping(bytes32 => bool)) xToYToXPerYInverseDerived; // note: don't share with original inverse mapping as in future if added as base case, it would override derived case
        // useful for removal
        mapping(bytes32 => mapping(bytes32 => uint256[])) xToYToReferenceIds; // example: X => Shared => uint256[]
        mapping(uint256 => DerivedPriceFeed) referenceIdToDerivedPriceFeed;
    }

    function _storageExchange()
        internal
        pure
        returns (StorageExchange storage s)
    {
        bytes32 position = STORAGE_POSITION_EXCHANGE;
        assembly {
            s.slot := position
        }
    }

    function _requireXPerYPriceFeedSupported(bytes32 _keyX, bytes32 _keyY)
        internal
        view
    {
        require(
            _storageExchange().xToYToXPerYPriceFeed[_keyX][_keyY] != address(0),
            "price feed not supported"
        );
    }

    function _requireDerivedXPerYPriceFeedSupported(
        bytes32 _keyX,
        bytes32 _keyY
    ) internal view {
        require(
            _storageExchange()
            .xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY].numerator !=
                address(0),
            "derived price feed not supported"
        ); // one check enough
    }

    event PriceFeedAdded(
        address indexed sender,
        bytes32 keyX,
        bytes32 keyY,
        address priceFeed
    );

    /**
     * NOTE: to add ETH/USD = $3,000 price feed (displayed on chainlink) --> read as USD per ETH (X per Y)
     * do: x = USD, y = ETH
     */
    function _addXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) internal {
        RideLibOwnership._requireIsOwner();
        RideLibCurrencyRegistry._requireCurrencySupported(_keyX);
        RideLibCurrencyRegistry._requireCurrencySupported(_keyY);

        require(_priceFeed != address(0), "zero price feed address");
        StorageExchange storage s1 = _storageExchange();
        require(
            s1.xToYToXPerYPriceFeed[_keyX][_keyY] == address(0),
            "price feed already supported"
        );
        s1.xToYToXPerYPriceFeed[_keyX][_keyY] = _priceFeed;
        s1.xToYToXPerYPriceFeed[_keyY][_keyX] = _priceFeed; // reverse pairing
        s1.xToYToXPerYInverse[_keyY][_keyX] = true;

        emit PriceFeedAdded(msg.sender, _keyX, _keyY, _priceFeed);
    }

    event PriceFeedDerived(
        address indexed sender,
        bytes32 keyX,
        bytes32 keyY,
        bytes32 keyShared
    );

    /**
     * NOTE: to derive ETH/EUR = €2,823 (chainlink equivalent) --> read as EUR per ETH (X per Y), from
     * ETH/USD = $3,000 price feed (displayed on chainlink) --> read as USD per ETH
     * EUR/USD = $1.14 price feed (displayed on chainlink) --> read as USD per EUR
     * do: x = EUR, y = ETH, shared = USD
     */
    function _deriveXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        bytes32 _keyShared
    ) internal {
        RideLibOwnership._requireIsOwner();
        require(_keyX != _keyY, "underlying currency key cannot be identical");
        _requireXPerYPriceFeedSupported(_keyX, _keyShared);
        _requireXPerYPriceFeedSupported(_keyY, _keyShared);

        StorageExchange storage s1 = _storageExchange();
        require(
            s1.xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY].numerator ==
                address(0),
            "derived price feed already supported"
        );

        s1.xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY].numerator = s1
            .xToYToXPerYPriceFeed[_keyX][_keyShared]; // numerator
        s1.xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY].denominator = s1
            .xToYToXPerYPriceFeed[_keyY][_keyShared]; // denominator

        // set inverse
        s1.xToYToXPerYDerivedPriceFeedDetails[_keyY][_keyX].numerator = s1
            .xToYToXPerYPriceFeed[_keyX][_keyShared]; // numerator
        s1.xToYToXPerYDerivedPriceFeedDetails[_keyY][_keyX].denominator = s1
            .xToYToXPerYPriceFeed[_keyY][_keyShared]; // denominator

        s1.xToYToXPerYInverseDerived[_keyY][_keyX] = true;

        // set underlying inverse state
        if (s1.xToYToXPerYInverse[_keyX][_keyShared]) {
            s1
            .xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY]
                .numeratorInverse = true;
            s1
            .xToYToXPerYDerivedPriceFeedDetails[_keyY][_keyX]
                .numeratorInverse = true;
        }
        if (s1.xToYToXPerYInverse[_keyY][_keyShared]) {
            s1
            .xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY]
                .denominatorInverse = true;
            s1
            .xToYToXPerYDerivedPriceFeedDetails[_keyY][_keyX]
                .denominatorInverse = true;
        }

        // for removal
        uint256 id = s1._derivePriceFeedCounter.current();
        s1.xToYToReferenceIds[_keyX][_keyShared].push(id);
        s1.xToYToReferenceIds[_keyY][_keyShared].push(id); // TODO: save the inverse as well?: eg s1.xToYToReferenceIds[_keyShared][_keyX].push(count);
        s1.referenceIdToDerivedPriceFeed[id] = DerivedPriceFeed({
            keyX: _keyX,
            keyY: _keyY
        });
        s1._derivePriceFeedCounter.increment();

        emit PriceFeedDerived(msg.sender, _keyX, _keyY, _keyShared);
    }

    event PriceFeedRemoved(
        address indexed sender,
        address priceFeed,
        bytes32[] derivedPriceFeedKeyXs,
        bytes32[] derivedPriceFeedKeyYs
    );

    function _removeXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY) internal {
        RideLibOwnership._requireIsOwner();
        _requireXPerYPriceFeedSupported(_keyX, _keyY);

        StorageExchange storage s1 = _storageExchange();

        address priceFeed = s1.xToYToXPerYPriceFeed[_keyX][_keyY];

        delete s1.xToYToXPerYPriceFeed[_keyX][_keyY];
        delete s1.xToYToXPerYPriceFeed[_keyY][_keyX]; // reverse pairing
        delete s1.xToYToXPerYInverse[_keyY][_keyX];

        uint256 idCount = s1.xToYToReferenceIds[_keyX][_keyY].length;
        bytes32[] memory derivedPriceFeedKeyXs = new bytes32[](idCount);
        bytes32[] memory derivedPriceFeedKeyYs = new bytes32[](idCount);

        for (uint256 i = 0; i < idCount; i++) {
            uint256 id = s1.xToYToReferenceIds[_keyX][_keyY][i];
            bytes32 keyX = s1.referenceIdToDerivedPriceFeed[id].keyX;
            bytes32 keyY = s1.referenceIdToDerivedPriceFeed[id].keyY;

            derivedPriceFeedKeyXs[i] = keyX;
            derivedPriceFeedKeyYs[i] = keyY;

            // delete s1.xToYToXPerYDerivedPriceFeedDetails[keyX][keyY];
            // delete s1.xToYToXPerYDerivedPriceFeedDetails[keyY][keyX]; // reverse pairing
            // delete s1.xToYToXPerYInverseDerived[keyY][keyX];
            _removeDerivedXPerYPriceFeed(keyX, keyY);

            delete s1.referenceIdToDerivedPriceFeed[id];
        }
        delete s1.xToYToReferenceIds[_keyX][_keyY];

        // require(
        //     s1.xToYToXPerYPriceFeed[_keyX][_keyY] == address(0),
        //     "price feed not removed 1"
        // );
        // require(
        //     s1.xToYToXPerYPriceFeed[_keyY][_keyX] == address(0),
        //     "price feed not removed 2"
        // ); // reverse pairing
        // require(!s1.xToYToXPerYInverse[_keyY][_keyX], "reverse not removed");

        emit PriceFeedRemoved(
            msg.sender,
            priceFeed,
            derivedPriceFeedKeyXs,
            derivedPriceFeedKeyYs
        );

        // TODO: remove price feed derived !!!! expand this fn or new fn ?????
    }

    event DerivedPriceFeedRemoved(
        address indexed sender,
        bytes32 keyX,
        bytes32 keyY
    );

    function _removeDerivedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        internal
    {
        RideLibOwnership._requireIsOwner();
        _requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);

        StorageExchange storage s1 = _storageExchange();

        delete s1.xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY];
        delete s1.xToYToXPerYDerivedPriceFeedDetails[_keyY][_keyX]; // reverse pairing
        delete s1.xToYToXPerYInverseDerived[_keyY][_keyX];

        // note: don't remove xToYToReferenceIds & referenceIdToDerivedPriceFeed as still required for _removeXPerYPriceFeed

        emit DerivedPriceFeedRemoved(msg.sender, _keyX, _keyY);
    }

    function _convertCurrency(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX /** in wei */
    ) internal view returns (uint256) {
        StorageExchange storage s1 = _storageExchange();

        uint256 xPerYWei;

        if (s1.xToYToXPerYPriceFeed[_keyX][_keyY] != address(0)) {
            xPerYWei = _getXPerYInWei(_keyX, _keyY);
        } else {
            xPerYWei = _deriveXPerYInWei(_keyX, _keyY);
        }

        if (
            s1.xToYToXPerYInverse[_keyX][_keyY] ||
            s1.xToYToXPerYInverseDerived[_keyX][_keyY]
        ) {
            return _convertInverse(xPerYWei, _amountX);
        } else {
            return _convertDirect(xPerYWei, _amountX);
        }
    }

    function _convertDirect(uint256 _xPerYWei, uint256 _amountX)
        internal
        pure
        returns (uint256)
    {
        return ((_amountX * 10**18) / _xPerYWei); // note: no rounding occurs as value is converted into wei
    }

    function _convertInverse(uint256 _xPerYWei, uint256 _amountX)
        internal
        pure
        returns (uint256)
    {
        return (_amountX * _xPerYWei) / 10**18; // note: no rounding occurs as value is converted into wei
    }

    function _getXPerYInWei(bytes32 _keyX, bytes32 _keyY)
        internal
        view
        returns (uint256)
    {
        _requireXPerYPriceFeedSupported(_keyX, _keyY);
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            _storageExchange().xToYToXPerYPriceFeed[_keyX][_keyY]
        );
        (, int256 xPerY, , , ) = priceFeed.latestRoundData();
        uint256 decimals = priceFeed.decimals();
        return uint256(uint256(xPerY) * 10**(18 - decimals)); // convert to wei
    }

    function _deriveXPerYInWei(bytes32 _keyX, bytes32 _keyY)
        internal
        view
        returns (uint256)
    {
        _requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);

        StorageExchange storage s1 = _storageExchange();

        // numerator
        AggregatorV3Interface priceFeedNumerator = AggregatorV3Interface(
            s1.xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY].numerator
        );
        (, int256 xPerYNumerator, , , ) = priceFeedNumerator.latestRoundData();
        uint256 decimalsNumerator = priceFeedNumerator.decimals();
        uint256 priceFeedNumeratorWei = uint256(
            uint256(xPerYNumerator) * 10**(18 - decimalsNumerator)
        ); // convert to wei
        bool isNumeratorInversed = s1
        .xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY].numeratorInverse;

        // denominator
        AggregatorV3Interface priceFeedDenominator = AggregatorV3Interface(
            s1.xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY].denominator
        );
        (, int256 xPerYDenominator, , , ) = priceFeedDenominator
            .latestRoundData();
        uint256 decimalsDenominator = priceFeedDenominator.decimals();
        uint256 priceFeedDenominatorWei = uint256(
            uint256(xPerYDenominator) * 10**(18 - decimalsDenominator)
        ); // convert to wei
        bool isDenominatorInversed = s1
        .xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY].denominatorInverse;

        uint256 xPerYWei;

        if (!isNumeratorInversed && !isDenominatorInversed) {
            xPerYWei =
                (priceFeedNumeratorWei * (10**18)) /
                priceFeedDenominatorWei;
        } else if (!isNumeratorInversed && isDenominatorInversed) {
            xPerYWei =
                (priceFeedNumeratorWei * (10**18)) /
                ((10**18) / priceFeedDenominatorWei);
        } else if (isNumeratorInversed && !isDenominatorInversed) {
            xPerYWei =
                (((10**18) / priceFeedNumeratorWei) * (10**18)) /
                priceFeedDenominatorWei;
        } else if (isNumeratorInversed && isDenominatorInversed) {
            xPerYWei =
                (10**18) /
                ((priceFeedNumeratorWei * (10**18)) / priceFeedDenominatorWei);
        } else {
            revert(
                "this revert should not ever be run - something seriously wrong with code"
            );
        }

        return xPerYWei;
    }
}
