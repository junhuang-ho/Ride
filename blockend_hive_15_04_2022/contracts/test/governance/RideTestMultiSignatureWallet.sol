// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../../governance/RideMultiSignatureWallet.sol";

contract RideTestMultiSignatureWallet is RideMultiSignatureWallet {
    constructor(
        string memory _name,
        address[] memory _members,
        uint256 _numConfirmationsRequired
    ) RideMultiSignatureWallet(_name, _members, _numConfirmationsRequired) {}

    function ssMembers_(address[] memory _members) external {
        for (uint256 i = 0; i < _members.length; i++) {
            members.push(_members[i]);
        }
    }

    function ssIsMember_(address _member, bool _bool) external {
        isMember[_member] = _bool;
    }

    function ssNumConfirmationsRequired(uint256 _value) external {
        numConfirmationsRequired = _value;
    }

    function ssIsConfirmed_(
        uint256 _txIndex,
        address _member,
        bool _bool
    ) external {
        isConfirmed[_txIndex][_member] = _bool;
    }

    function ssTransactions_(
        address _to,
        uint256 _value,
        bytes memory _data,
        string memory _description,
        bool _executed,
        uint256 _numConfirmations
    ) external {
        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                description: _description,
                executed: _executed,
                numConfirmations: _numConfirmations
            })
        );
    }

    function onlyThis_() external onlyThis returns (bool) {
        return true;
    }

    function onlyMember_() external onlyMember returns (bool) {
        return true;
    }

    function txExists_(uint256 _txIndex)
        external
        txExists(_txIndex)
        returns (bool)
    {
        return true;
    }

    function notExecuted_(uint256 _txIndex)
        external
        notExecuted(_txIndex)
        returns (bool)
    {
        return true;
    }

    function notConfirmed_(uint256 _txIndex)
        external
        notConfirmed(_txIndex)
        returns (bool)
    {
        return true;
    }

    function setMembers_(
        address[] memory _members,
        uint256 _numConfirmationsRequired
    ) external {
        _setMembers(_members, _numConfirmationsRequired);
    }
}
