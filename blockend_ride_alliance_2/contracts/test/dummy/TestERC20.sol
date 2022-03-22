// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

////////// TODO: MINTING STRATEGY

contract TestERC20 is ERC20, Ownable, ERC20Permit, ERC20Votes {
    address[] public array;
    uint256 public yo;

    constructor(
        uint256 _yo,
        address[] memory _array,
        address[] memory _array2
    ) ERC20("TestERC20", "TE") ERC20Permit("TE") {
        // _mint(msg.sender, _maxSupply);
        yo = _yo;
        array = _array;
        array = _array2;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
