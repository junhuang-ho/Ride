// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract RideMultiSignatureWallet {
    event MembersAdded(address indexed sender, address[] members);
    event Deposit(
        address indexed sender,
        uint256 amount,
        uint256 balance,
        bytes data
    );
    event SubmitTransaction(address indexed member, uint256 indexed txIndex);
    event ConfirmTransaction(address indexed member, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed member, uint256 indexed txIndex);
    event ExecuteTransaction(address indexed member, uint256 indexed txIndex);

    string public name;
    address[] internal members;
    mapping(address => bool) public isMember;
    uint256 public numConfirmationsRequired;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        string description;
        bool executed;
        uint256 numConfirmations;
    }

    mapping(uint256 => mapping(address => bool)) public isConfirmed; // mapping from tx index => member => bool

    Transaction[] internal transactions;

    modifier onlyThis() {
        require(
            msg.sender == address(this),
            "RideMultiSignatureWallet: caller not this contract"
        );
        _;
    }

    modifier onlyMember() {
        require(
            isMember[msg.sender],
            "RideMultiSignatureWallet: caller not member"
        );
        _;
    }

    modifier txExists(uint256 _txIndex) {
        require(
            _txIndex < transactions.length,
            "RideMultiSignatureWallet: tx does not exist"
        );
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        require(
            !transactions[_txIndex].executed,
            "RideMultiSignatureWallet: tx already executed"
        );
        _;
    }

    modifier notConfirmed(uint256 _txIndex) {
        require(
            !isConfirmed[_txIndex][msg.sender],
            "RideMultiSignatureWallet: tx already confirmed"
        );
        _;
    }

    constructor(
        string memory _name,
        address[] memory _members,
        uint256 _numConfirmationsRequired
    ) {
        name = _name;
        _setMembers(_members, _numConfirmationsRequired);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance, "");
    }

    fallback() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance, msg.data);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function submitTransaction(
        address _to,
        uint256 _value,
        bytes memory _data,
        string memory _description
    ) external onlyMember {
        uint256 txIndex = transactions.length;

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                description: _description,
                executed: false,
                numConfirmations: 0
            })
        );

        emit SubmitTransaction(msg.sender, txIndex);
    }

    function confirmTransaction(uint256 _txIndex)
        external
        onlyMember
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    function revokeConfirmation(uint256 _txIndex)
        external
        onlyMember
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(
            isConfirmed[_txIndex][msg.sender],
            "RideMultiSignatureWallet: tx not confirmed"
        );

        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    function executeTransaction(uint256 _txIndex)
        external
        onlyMember
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "RideMultiSignatureWallet: not enough confirmations"
        );

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        ); // can be used to withdraw
        require(success, "RideMultiSignatureWallet: tx call failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    // TODO: audit: only can be called by executeTransaction (onlyThis address)
    function resetMembers(
        address[] memory _members,
        uint256 _numConfirmationsRequired
    ) external onlyThis {
        for (uint256 i = 0; i < members.length; i++) {
            delete isMember[members[i]];
        }
        delete members;

        _setMembers(_members, _numConfirmationsRequired);
    }

    function _setMembers(
        address[] memory _members,
        uint256 _numConfirmationsRequired
    ) internal {
        require(
            _members.length > 0,
            "RideMultiSignatureWallet: members required"
        );
        require(
            _numConfirmationsRequired > 0 &&
                _numConfirmationsRequired <= _members.length,
            "RideMultiSignatureWallet: invalid number of required confirmations"
        );

        for (uint256 i = 0; i < _members.length; i++) {
            address member = _members[i];

            require(
                member != address(0),
                "RideMultiSignatureWallet: zero address member"
            );
            require(
                !isMember[member],
                "RideMultiSignatureWallet: member not unique"
            );

            isMember[member] = true;
            members.push(member);
        }

        numConfirmationsRequired = _numConfirmationsRequired;

        emit MembersAdded(msg.sender, _members);
    }

    function getMembers() external view returns (address[] memory) {
        return members;
    }

    function getTransactionCount() external view returns (uint256) {
        return transactions.length;
    }

    function getTransactionDetails(uint256 _txIndex)
        external
        view
        returns (
            address to,
            uint256 value,
            bytes memory data,
            string memory description,
            bool executed,
            uint256 numConfirmations
        )
    {
        Transaction storage transaction = transactions[_txIndex];

        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.description,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}
