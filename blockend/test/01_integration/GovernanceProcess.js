// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers, waffle } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const Web3EthAbi = require('web3-eth-abi')
const fs = require("fs")

const { deployTokenAndGovernor } = require("../../scripts/deployTokenAndGovernor.js")
const { deployTestBox } = require("../../scripts/experimental/deployTestBox.js")

if (parseInt(chainId) === 31337)
{
    describe("Governance Process", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            admin = accounts[0].address
            driver = accounts[1].address // pre-registration is considered an applicant
            passenger = accounts[2].address
            other = accounts[9].address

            contractAddresses = await deployTokenAndGovernor(admin, true, true)
            addressRideToken = contractAddresses[0]
            addressRideTimelock = contractAddresses[1]
            addressRideGovernor = contractAddresses[2]

            addressBoxes = await deployTestBox(admin, true, true)
            addressBox1 = addressBoxes[0]
            addressBox2 = addressBoxes[1]

            contractRideA = await ethers.getContractAt("Ride", addressRideToken, admin)
            contractRideTimelockA = await ethers.getContractAt("RideTimelock", addressRideTimelock, admin)
            contractRideGovernorA = await ethers.getContractAt("RideGovernor", addressRideGovernor, admin)
            contractBox1A = await ethers.getContractAt("Box", addressBox1, admin)
            contractBox2A = await ethers.getContractAt("Box2", addressBox2, admin)

            const supply = 100 //ethers.utils.parseEther("100000000") // 100 mil - demo purposes // TODO
            var tx = await contractRideA.mint(admin, supply)
            var rcpt = tx.wait()

            expect(await contractBox1A.owner()).to.equal(admin)
            var tx = await contractBox1A.transferOwnership(addressRideTimelock)
            var rcpt = tx.wait()
            expect(await contractBox1A.owner()).to.equal(addressRideTimelock)

            var tx = await contractRideA.delegate(admin) // self delegate
            var rcpt = await tx.wait()

            proposalState =
                [
                    "Pending",
                    "Active",
                    "Canceled",
                    "Defeated",
                    "Succeeded",
                    "Queued",
                    "Expired",
                    "Executed"
                ]
        })

        describe("A successful process - basic", function ()
        {
            it("Should propose, vote and execute", async function ()
            {
                // propose

                let abi = ["function store(uint256 newValue)"]
                let iface = new ethers.utils.Interface(abi)
                encoded_fn = iface.encodeFunctionData("store", [69])

                targets = [contractBox1A.address] // addresses
                values = [0] // native coin, eth/matic.. etc | uint256
                calldatas = [encoded_fn] // bytes
                description = "Store 69 in the box!"
                var tx = await contractRideGovernorA.propose(targets, values, calldatas, description)

                var txTmp = await contractBox2A.store(1) // move block
                var rcptTmp = txTmp.wait()

                var rcpt = await tx.wait(1 + parseInt((await contractRideGovernorA.votingDelay()).toString())) // 2 blocks to include voting delay

                proposalId = rcpt.events[0].args.proposalId.toString()
                blockNumber = await waffle.provider.getBlockNumber()

                expect(await contractRideGovernorA.proposalSnapshot(proposalId)).to.equal(blockNumber)
                expect(await contractRideGovernorA.proposalEta(proposalId)).to.equal(0)
                expect(proposalState[await contractRideGovernorA.state(proposalId)]).to.equal("Pending")

                // console.log("Proposal Deadline:", )

                // vote // 0 = Against, 1 = For, 2 = Abstain

                console.log("Counting MODE:", await contractRideGovernorA.COUNTING_MODE())
                expect(await contractRideGovernorA.COUNTING_MODE()).to.equal("support=bravo&quorum=for,abstain")
                expect(proposalState[await contractRideGovernorA.state(proposalId)]).to.equal("Pending")

                expect(await contractRideGovernorA.hasVoted(proposalId, admin)).to.equal(false)

                var tx = await contractRideGovernorA.castVoteWithReason(proposalId, 1, "this is my reason") // or castVote or castVoteBySig (coded inside another contract)
                var rcpt = tx.wait()

                expect(await contractRideGovernorA.hasVoted(proposalId, admin)).to.equal(true)
                expect(proposalState[await contractRideGovernorA.state(proposalId)]).to.equal("Active")

                blockNumber = await waffle.provider.getBlockNumber()

                // cannot cast vote again
                await expect(contractRideGovernorA.castVoteWithReason(proposalId, 1, "this is my reason")).to.revertedWith("GovernorVotingSimple: vote already cast")
                await expect(contractRideGovernorA.castVote(proposalId, 1)).to.revertedWith("GovernorVotingSimple: vote already cast")
                await expect(contractRideGovernorA.castVoteWithReason(proposalId, 0, "this is my reason")).to.revertedWith("GovernorVotingSimple: vote already cast")
                await expect(contractRideGovernorA.castVote(proposalId, 0)).to.revertedWith("GovernorVotingSimple: vote already cast")
                await expect(contractRideGovernorA.castVoteWithReason(proposalId, 2, "this is my reason")).to.revertedWith("GovernorVotingSimple: vote already cast")
                await expect(contractRideGovernorA.castVote(proposalId, 2)).to.revertedWith("GovernorVotingSimple: vote already cast")

                // revert also moves blocks forward
                expect(await waffle.provider.getBlockNumber()).to.be.gt(blockNumber)

                votes = await contractRideGovernorA.proposalVotes(proposalId)
                expect(votes[0]).to.equal(0)
                expect(votes[1]).to.equal(await contractRideA.balanceOf(admin))
                expect(votes[2]).to.equal(0)

                // move blocks by voting period
                var txTmp = await contractBox2A.store(1)
                var rcptTmp = txTmp.wait()
                var txTmp = await contractBox2A.store(1)
                var rcptTmp = txTmp.wait()

                expect(await contractRideGovernorA.proposalEta(proposalId)).to.equal(0)
                expect(proposalState[await contractRideGovernorA.state(proposalId)]).to.equal("Active")

                var txTmp = await contractBox2A.store(1)
                var rcptTmp = txTmp.wait()

                // votes cannot be cast anymore, deadline reached
                expect(await waffle.provider.getBlockNumber()).to.equal(await contractRideGovernorA.proposalDeadline(proposalId))
                await expect(contractRideGovernorA.castVote(proposalId, 2)).to.revertedWith("Governor: vote not currently active")
                expect(await contractRideGovernorA.proposalEta(proposalId)).to.equal(0)

                // queue
                expect(proposalState[await contractRideGovernorA.state(proposalId)]).to.equal("Succeeded") // or Defeated

                description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

                var tx = await contractRideGovernorA.queue(targets, values, calldatas, description_hash)
                var rcpt = tx.wait()

                expect(proposalState[await contractRideGovernorA.state(proposalId)]).to.equal("Queued")
                console.log("ETA of proposal being queued:", (await contractRideGovernorA.proposalEta(proposalId)).toString())

                expect(await contractBox1A.retrieve()).to.equal(0)

                // execute

                var tx = await contractRideGovernorA.execute(targets, values, calldatas, description_hash)
                var rcpt = tx.wait()

                expect(proposalState[await contractRideGovernorA.state(proposalId)]).to.equal("Executed")
                expect(await contractBox1A.retrieve()).to.equal(69)
                expect(await contractRideGovernorA.proposalEta(proposalId)).to.equal(0)

            })
        })
    })
}