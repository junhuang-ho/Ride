// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibTicket", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideTicket = await ethers.getContractAt('RideTestTicket', rideHubAddress)

            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test123"))
            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))
            bytes32Zero = "0x0000000000000000000000000000000000000000000000000000000000000000"

            var tx = await contractRideTicket.ssUserToTixId_(
                accounts[2].address, tixId
            )
            var rcpt = await tx.wait()
            var tx = await contractRideTicket.ssUserToTixId_(
                accounts[1].address, tixId
            )
            var rcpt = await tx.wait()
            var tx = await contractRideTicket.ssTixIdToTicket_(
                tixId, accounts[2].address, accounts[1].address, 1, true, 3,
                keyLocal, keyPay, 4, 2, true
            )
            var rcpt = await tx.wait()
            var tx = await contractRideTicket.ssTixIdToTicket_2(
                tixId, 1234
            )
            var rcpt = await tx.wait()
            var tx = await contractRideTicket.ssTixToDriverEnd_(
                tixId, accounts[1].address, true
            )
            var rcpt = await tx.wait()
        })

        describe("_requireNotActive", function ()
        {
            it("Should allow pass if user not active", async function ()
            {
                expect(await contractRideTicket.requireNotActive_()).to.equal(true)
            })
            it("Should revert if user active", async function ()
            {
                var tx = await contractRideTicket.ssUserToTixId_(
                    accounts[0].address, ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test456"))
                )
                var rcpt = await tx.wait()

                await expect(contractRideTicket.requireNotActive_()).to.revertedWith("caller is active")
            })
        })

        describe("_cleanUp", function ()
        {
            it("Should remove user to ticket, ticket and driver end data", async function ()
            {
                expect(await contractRideTicket.sUserToTixId_(accounts[2].address)).to.equal(tixId)
                expect(await contractRideTicket.sUserToTixId_(accounts[1].address)).to.equal(tixId)

                expect((await contractRideTicket.sTixIdToTicket_(tixId)).passenger).to.equal(accounts[2].address)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).driver).to.equal(accounts[1].address)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).badge).to.equal(1)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).strict).to.equal(true)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).metres).to.equal(3)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).keyLocal).to.equal(keyLocal)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).keyPay).to.equal(keyPay)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).requestFee).to.equal(4)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).fare).to.equal(2)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).tripStart).to.equal(true)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).forceEndTimestamp).to.equal(1234)

                expect((await contractRideTicket.sTixToDriverEnd_(tixId)).driver).to.equal(accounts[1].address)
                expect((await contractRideTicket.sTixToDriverEnd_(tixId)).reached).to.equal(true)

                var tx = await contractRideTicket.cleanUp_(tixId, accounts[2].address, accounts[1].address)
                var rcpt = await tx.wait()

                expect(await contractRideTicket.sUserToTixId_(accounts[2].address)).to.equal(bytes32Zero)
                expect(await contractRideTicket.sUserToTixId_(accounts[1].address)).to.equal(bytes32Zero)

                expect((await contractRideTicket.sTixIdToTicket_(tixId)).passenger).to.equal(ethers.constants.AddressZero)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).driver).to.equal(ethers.constants.AddressZero)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).badge).to.equal(0)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).strict).to.equal(false)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).metres).to.equal(0)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).keyLocal).to.equal(bytes32Zero)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).keyPay).to.equal(bytes32Zero)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).requestFee).to.equal(0)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).fare).to.equal(0)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).tripStart).to.equal(false)
                expect((await contractRideTicket.sTixIdToTicket_(tixId)).forceEndTimestamp).to.equal(0)

                expect((await contractRideTicket.sTixToDriverEnd_(tixId)).driver).to.equal(ethers.constants.AddressZero)
                expect((await contractRideTicket.sTixToDriverEnd_(tixId)).reached).to.equal(false)
            })
        })
    })



    describe("RideTicket", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideTicket = await ethers.getContractAt('RideTestTicket', rideHubAddress)

            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test123"))
            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))
            bytes32Zero = "0x0000000000000000000000000000000000000000000000000000000000000000"

            var tx = await contractRideTicket.ssUserToTixId_(
                accounts[2].address, tixId
            )
            var rcpt = await tx.wait()
            var tx = await contractRideTicket.ssUserToTixId_(
                accounts[1].address, tixId
            )
            var rcpt = await tx.wait()
            var tx = await contractRideTicket.ssTixIdToTicket_(
                tixId, accounts[2].address, accounts[1].address, 1, true, 3,
                keyLocal, keyPay, 4, 2, true
            )
            var rcpt = await tx.wait()
            var tx = await contractRideTicket.ssTixIdToTicket_2(
                tixId, 1234
            )
            var rcpt = await tx.wait()
            var tx = await contractRideTicket.ssTixToDriverEnd_(
                tixId, accounts[1].address, true
            )
            var rcpt = await tx.wait()
        })

        describe("getUserToTixId", function ()
        {
            it("Should get user to ticket id", async function ()
            {
                expect(await contractRideTicket.getUserToTixId(accounts[2].address)).to.equal(tixId)
                expect(await contractRideTicket.getUserToTixId(accounts[1].address)).to.equal(tixId)
            })
        })

        describe("getTixIdToTicket", function ()
        {
            it("Should get ticket details", async function ()
            {
                expect((await contractRideTicket.getTixIdToTicket(tixId)).passenger).to.equal(accounts[2].address)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).driver).to.equal(accounts[1].address)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).badge).to.equal(1)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).strict).to.equal(true)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).metres).to.equal(3)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).keyLocal).to.equal(keyLocal)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).keyPay).to.equal(keyPay)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).requestFee).to.equal(4)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).fare).to.equal(2)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).tripStart).to.equal(true)
                expect((await contractRideTicket.getTixIdToTicket(tixId)).forceEndTimestamp).to.equal(1234)
            })
        })

        describe("getTixToDriverEnd", function ()
        {
            it("Should get driver end details", async function ()
            {
                expect((await contractRideTicket.getTixToDriverEnd(tixId)).driver).to.equal(accounts[1].address)
                expect((await contractRideTicket.getTixToDriverEnd(tixId)).reached).to.equal(true)
            })
        })
    })
}