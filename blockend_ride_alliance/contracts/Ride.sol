// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

////////// TODO: MINTING STRATEGY

contract Ride is ERC20, Ownable, ERC20Permit {
    constructor() ERC20("Ride", "RIDE") ERC20Permit("Ride") {
        // _mint(msg.sender, _maxSupply);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
