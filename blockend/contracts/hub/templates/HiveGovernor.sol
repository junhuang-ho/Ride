// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

import "../facets/core/RunnerDetail.sol";

contract HiveGovernor is
    Governor,
    GovernorSettings,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl,
    Ownable
{
    address public timelockAddress;
    address public underlyingContract;
    mapping(uint256 => bool) public expiredProposalIdToExecuted;

    constructor(
        string memory _name,
        ERC20Votes _token,
        TimelockController _timelock,
        address _underlyingContract,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    )
        Governor(_name)
        GovernorSettings(
            _votingDelay, /* 1 = 1 block, 6570 blocks ~= 1 day */
            _votingPeriod, /* 45818 blocks ~= 1 week */
            _proposalThreshold /* 0, value is in terms of number of votes (voting power) */
        )
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(_quorumPercentage)
        GovernorTimelockControl(_timelock)
    {
        timelockAddress = address(_timelock);
        underlyingContract = _underlyingContract;
    }

    // custom

    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        ProposalState baseState = super.state(proposalId);
        if (
            baseState == ProposalState.Defeated && !_quorumReached(proposalId)
        ) {
            if (expiredProposalIdToExecuted[proposalId]) {
                return ProposalState.Executed;
            } else {
                return ProposalState.Expired; // note: when quorum not reached
            }
        } else {
            return baseState;
        }
    }

    // TODO: test
    // TODO: transfer ownership to multisig
    function fallbackExecute(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) external payable onlyOwner returns (uint256) {
        uint256 proposalId = hashProposal(
            targets,
            values,
            calldatas,
            descriptionHash
        );

        ProposalState status = state(proposalId);
        require(
            status == ProposalState.Expired,
            "HiveGovernor: proposal not expired"
        );
        // _proposals[proposalId].executed = true; // private state variable not visible
        expiredProposalIdToExecuted[proposalId] = true;

        emit ProposalExecuted(proposalId);

        _execute(proposalId, targets, values, calldatas, descriptionHash);

        return proposalId;
    }

    // TODO: set only runners can vote

    // modifier onlyHiveRunner() {
    //     require(
    //         LibRunnerDetail
    //             ._storageRunnerDetail()
    //             .runnerToRunnerDetail[msg.sender]
    //             .hive == timelockAddress,
    //         "HiveGovernor: caller not runner of hive"
    //     );
    //     _;
    // }

    modifier onlyHiveRunner() {
        require(
            RunnerDetail(underlyingContract)
                .getRunnerToRunnerDetail(msg.sender)
                .hive == timelockAddress,
            "HiveGovernor: caller not runner of hive"
        );
        _;
    }

    function castVote(uint256 proposalId, uint8 support)
        public
        virtual
        override(Governor, IGovernor)
        onlyHiveRunner
        returns (uint256)
    {
        return super.castVote(proposalId, support);
    }

    function castVoteWithReason(
        uint256 proposalId,
        uint8 support,
        string calldata reason
    )
        public
        virtual
        override(Governor, IGovernor)
        onlyHiveRunner
        returns (uint256)
    {
        return super.castVoteWithReason(proposalId, support, reason);
    }

    // function castVoteWithReasonAndParams(
    //     uint256 proposalId,
    //     uint8 support,
    //     string calldata reason,
    //     bytes memory params
    // ) public virtual override(Governor, IGovernor) onlyHiveRunner returns (uint256) {
    //     return
    //         super.castVoteWithReasonAndParams(
    //             proposalId,
    //             support,
    //             reason,
    //             params
    //         );
    // }

    function castVoteBySig(
        uint256 proposalId,
        uint8 support,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        public
        virtual
        override(Governor, IGovernor)
        onlyHiveRunner
        returns (uint256)
    {
        return super.castVoteBySig(proposalId, support, v, r, s);
    }

    // function castVoteWithReasonAndParamsBySig(
    //     uint256 proposalId,
    //     uint8 support,
    //     string calldata reason,
    //     bytes memory params,
    //     uint8 v,
    //     bytes32 r,
    //     bytes32 s
    // ) public virtual override(Governor, IGovernor) onlyHiveRunner returns (uint256) {
    //
    //     return
    //         super.castVoteWithReasonAndParamsBySig(
    //             support,
    //             reason,
    //             params,
    //             v,
    //             r,
    //             s
    //         );
    // }

    // The following functions are overrides required by Solidity.

    function votingDelay()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    function quorum(uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function getVotes(address account, uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotes)
        returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    // function state(uint256 proposalId)
    //     public
    //     view
    //     override(Governor, GovernorTimelockControl)
    //     returns (ProposalState)
    // {
    //     return super.state(proposalId);
    // }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override(Governor, IGovernor) returns (uint256) {
        return super.propose(targets, values, calldatas, description);
    }

    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
