//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibHolding.sol";
import "../../libraries/core/LibCurrencyRegistry.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";

import "../../interfaces/IHubLibraryEvents.sol";

// TODO: keep an eye out for SafeERC20Permit

contract Holding is IHubLibraryEvents, ReentrancyGuard {
    using SafeERC20 for IERC20;

    event TokensDeposited(address indexed sender, uint256 amount);

    /**
     * placeDeposit allows users to deposit token into Hub contract
     *
     * @dev call token contract's "approve" first
     *
     * @param _amount | unit in token
     *
     * @custom:event TokensDeposited
     */
    function depositTokens(bytes32 _key, uint256 _amount) external {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        LibCurrencyRegistry._requireIsCrypto(_key);
        require(_amount > 0, "Holding: zero amount");
        address token = address(bytes20(_key)); // convert to address
        // require(token != address(0), "zero token address"); // checked at currency registration

        // require(
        //     IERC20(token).allowance(msg.sender, address(this)) >= _amount,
        //     "check token allowance"
        // ); // check done at token contract side

        // bool sent = IERC20(token).transferFrom(
        //     msg.sender,
        //     address(this),
        //     _amount
        // );
        // require(sent, "tx failed");
        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

        LibHolding._storageHolding().userToCurrencyKeyToHolding[msg.sender][
                _key
            ] += _amount;

        emit TokensDeposited(msg.sender, _amount);
    }

    function depositTokensPermit(
        bytes32 _key,
        uint256 _amount,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        LibCurrencyRegistry._requireIsCrypto(_key);
        require(_amount > 0, "Holding: zero amount");
        address token = address(bytes20(_key)); // convert to address

        IERC20Permit(token).permit(
            msg.sender,
            address(this),
            _amount,
            _deadline,
            _v,
            _r,
            _s
        );
        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

        LibHolding._storageHolding().userToCurrencyKeyToHolding[msg.sender][
                _key
            ] += _amount;

        emit TokensDeposited(msg.sender, _amount);
    }

    event TokensRemoved(address indexed sender, uint256 amount);

    /**
     * removeDeposit allows users to remove token from Hub contract
     *
     * @custom:event TokensRemoved
     */
    function withdrawTokens(bytes32 _key, uint256 _amount)
        external
        nonReentrant
    {
        require(_amount > 0, "Holding: zero amount");
        LibHolding._requireSufficientHolding(_key, _amount);
        LibCurrencyRegistry._requireCurrencySupported(_key);
        LibCurrencyRegistry._requireIsCrypto(_key);

        address token = address(bytes20(_key)); // convert to address
        // require(token != address(0), "zero token address"); // checked at currency registration

        LibHolding.StorageHolding storage s1 = LibHolding._storageHolding();
        require(
            s1.userToCurrencyKeyToHolding[msg.sender][_key] >= _amount,
            "Holding: insufficient holdings"
        );
        // require(
        //     IERC20(token).balanceOf(address(this)) >= _amount,
        //     "contract insufficient funds"
        // ); // note: if no bugs then this should never be called

        s1.userToCurrencyKeyToHolding[msg.sender][_key] -= _amount;
        // bool sent = IERC20(token).transfer(msg.sender, _amount);
        // // bool sent = token.transferFrom(address(this), msg.sender, _amount);
        // require(sent, "tx failed");
        IERC20(token).safeTransfer(msg.sender, _amount);

        emit TokensRemoved(msg.sender, _amount);
    }

    function getHolding(address _user, bytes32 _key)
        external
        view
        returns (uint256)
    {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        return
            LibHolding._storageHolding().userToCurrencyKeyToHolding[_user][
                _key
            ];
    }

    function getVault(address _user, bytes32 _key)
        external
        view
        returns (uint256)
    {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        return
            LibHolding._storageHolding().userToCurrencyKeyToVault[_user][_key];
    }
}
