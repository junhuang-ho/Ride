// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibPenalty", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRidePenalty = await ethers.getContractAt('RideTestPenalty', rideHubAddress)
        })

        describe("_requireNotBanned", function ()
        {
            it("Should allow pass if user not banned", async function ()
            {
                expect(await contractRidePenalty.requireNotBanned_()).to.equal(true)
            })

            it("Should revert if user is banned", async function ()
            {
                var tx = await contractRidePenalty.ssUserToBanEndTimestamp_(accounts[0].address, "2210744455")
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(contractRidePenalty.requireNotBanned_()).to.revertedWith("still banned")
            })
        })

        describe("_setBanDuration", function ()
        {
            it("Should set ban duration", async function ()
            {
                expect(await contractRidePenalty.sBanDuration_()).to.equal(0)

                var tx = await contractRidePenalty.setBanDuration_(1234)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRidePenalty.sBanDuration_()).to.equal(1234)
            })
        })

        describe("_temporaryBan", function ()
        {
            it("Should set user as banned until certain time", async function ()
            {
                expect(await contractRidePenalty.sUserToBanEndTimestamp_(accounts[1].address)).to.equal(0)

                var tx = await contractRidePenalty.temporaryBan_(accounts[1].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRidePenalty.sUserToBanEndTimestamp_(accounts[1].address)).toString()).to.not.equal(0)
            })
        })
    })

    describe("RidePenalty", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRidePenalty = await ethers.getContractAt('RideTestPenalty', rideHubAddress)
        })

        describe("setBanDuration", function ()
        {
            it("Should set ban duration", async function ()
            {
                expect(await contractRidePenalty.sBanDuration_()).to.equal(0)

                var tx = await contractRidePenalty.setBanDuration(1234)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRidePenalty.sBanDuration_()).to.equal(1234)
            })
        })

        describe("getBanDuration", function ()
        {
            it("Should get ban duration", async function ()
            {
                expect(await contractRidePenalty.getBanDuration()).to.equal(1234)
            })
        })

        describe("getUserToBanEndTimestamp", function ()
        {
            it("Should get user ban end timestamp duration", async function ()
            {
                expect(await contractRidePenalty.getUserToBanEndTimestamp(accounts[2].address)).to.equal(0)

                var tx = await contractRidePenalty.temporaryBan_(accounts[2].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRidePenalty.getUserToBanEndTimestamp(accounts[2].address)).to.not.equal(0)
            })
        })
    })
}