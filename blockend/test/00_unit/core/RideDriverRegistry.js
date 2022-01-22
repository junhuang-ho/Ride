// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibDriverRegistry", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(true, false)
            rideHubAddress = contractAddresses[0]
            contractRideDriverRegistry = await ethers.getContractAt('RideTestDriverRegistry', rideHubAddress)
        })

        describe("_burnFirstDriverId", function ()
        {
            it("Should mint first id", async function ()
            {
                expect((await contractRideDriverRegistry.s_driverIdCounter_())[0]).to.equal(0)

                var tx = await contractRideDriverRegistry.burnFirstDriverId_()
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideDriverRegistry.s_driverIdCounter_())[0]).to.equal(1)
            })
            it("Should revert when called again", async function ()
            {
                expect((await contractRideDriverRegistry.s_driverIdCounter_())[0]).to.equal(1)

                await expect(contractRideDriverRegistry.burnFirstDriverId_()).to.revertedWith("must be zero")
            })
        })

        describe("_mint", function ()
        {
            it("Should iterate id by one", async function ()
            {
                expect((await contractRideDriverRegistry.s_driverIdCounter_())[0]).to.equal(1)

                var tx = await contractRideDriverRegistry.mint_()
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideDriverRegistry.s_driverIdCounter_())[0]).to.equal(2)
            })
        })
    })

    describe("RideDriverRegistry", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(true, false)
            rideHubAddress = contractAddresses[0]
            contractRideDriverRegistry = await ethers.getContractAt('RideTestDriverRegistry', rideHubAddress)
            contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress)
        })

        describe("approveApplicant", function ()
        {
            it("Should set applicant uri", async function ()
            {
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).uri).to.equal("")

                var tx = await contractRideDriverRegistry.approveApplicant(accounts[0].address, "testme123")
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).uri).to.equal("testme123")
            })
            it("Should revert if uri already set", async function ()
            {
                await expect(contractRideDriverRegistry.approveApplicant(accounts[0].address, "testme456")).to.revertedWith("uri already set")
            })
        })

        describe("registerAsDriver", function ()
        {
            it("Should revert if driver not pass bg check", async function ()
            {
                contractRideDriverRegistry2 = await ethers.getContractAt('RideTestDriverRegistry', rideHubAddress, accounts[2].address)
                await expect(contractRideDriverRegistry2.registerAsDriver(500)).to.revertedWith("uri not set in bg check")
            })
            it("Should set driver reputation details", async function ()
            {


                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).id).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).uri).to.equal("testme123")
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).maxMetresPerTrip).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).metresTravelled).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).countStart).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).countEnd).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).totalRating).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).countRating).to.equal(0)

                var tx = await contractRideDriverRegistry.burnFirstDriverId_()
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await contractRideDriverRegistry.registerAsDriver(500)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).id).to.equal(1)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).uri).to.equal("testme123")
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).maxMetresPerTrip).to.equal(500)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).metresTravelled).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).countStart).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).countEnd).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).totalRating).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).countRating).to.equal(0)
            })
        })

        describe("updateMaxMetresPerTrip", function ()
        {
            it("Should update max distance per trip value", async function ()
            {
                var tx = await contractRideDriverRegistry.updateMaxMetresPerTrip(555)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).maxMetresPerTrip).to.equal(555)
            })

        })
    })
}