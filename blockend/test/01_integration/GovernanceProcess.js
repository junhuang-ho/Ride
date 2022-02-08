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

            const maxSupply = ethers.utils.parseEther("100000000") // 100 mil - demo purposes // TODO
            var tx = await contractRideA.mint(admin, maxSupply)
            var rcpt = tx.wait()

            expect(await contractBox1A.owner()).to.equal(admin)
            var tx = await contractBox1A.transferOwnership(addressRideTimelock)
            var rcpt = tx.wait()
            expect(await contractBox1A.owner()).to.equal(addressRideTimelock)
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

                var rcpt = await tx.wait(2) // 2 blocks to include voting delay

                proposalId = rcpt.events[0].args.proposalId.toString()

                console.log("Proposal State:", await contractRideGovernorA.state(proposalId))
                console.log("Proposal Snapshot:", (await contractRideGovernorA.proposalSnapshot(proposalId)).toString())
                console.log("Proposal Deadline:", (await contractRideGovernorA.proposalDeadline(proposalId)).toString())

                // vote // 0 = Against, 1 = For, 2 = Abstain

                var tx = await contractRideGovernorA.castVoteWithReason(proposalId, 1, "this is my reason")
                var rcpt = tx.wait()

                // move blocks by voting period
                var txTmp = await contractBox2A.store(1)
                var rcptTmp = txTmp.wait()
                var txTmp = await contractBox2A.store(1)
                var rcptTmp = txTmp.wait()
                var txTmp = await contractBox2A.store(1)
                var rcptTmp = txTmp.wait()
                var txTmp = await contractBox2A.store(1)
                var rcptTmp = txTmp.wait()
                var txTmp = await contractBox2A.store(1)
                var rcptTmp = txTmp.wait()

                // queue

                description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

                var tx = await contractRideGovernorA.queue(targets, values, calldatas, description_hash)
                var rcpt = tx.wait()

                expect(await contractBox1A.retrieve()).to.equal(0)

                // execute

                var tx = await contractRideGovernorA.execute(targets, values, calldatas, description_hash)
                var rcpt = tx.wait()

                expect(await contractBox1A.retrieve()).to.equal(69)

            })
        })
    })
}