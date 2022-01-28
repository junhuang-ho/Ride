// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibRater", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideRater = await ethers.getContractAt('RideTestRater', rideHubAddress)
            contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress)
        })

        describe("_giveRating", function ()
        {
            // it("Should revert if max rating is zero", async function ()
            // {
            //     await expect(contractRideRater.giveRating_(accounts[0].address, 3)).to.revertedWith("maximum rating must be more than zero")
            // })
            // it("Should revert if min rating is zero", async function ()
            // {
            //     var tx = await contractRideRater.setRatingBounds_(0, 5)
            //     var rcpt = await tx.wait()
            //     expect(tx.confirmations).to.equal(1)

            //     await expect(contractRideRater.giveRating_(accounts[0].address, 3)).to.revertedWith("minimum rating must be more than zero")
            // })
            it("Should revert if given rating is out of bounds", async function ()
            {
                var tx = await contractRideRater.setRatingBounds_(2, 4)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(contractRideRater.giveRating_(accounts[0].address, 1)).to.revertedWith("rating must be within min and max ratings (inclusive)")
                await expect(contractRideRater.giveRating_(accounts[0].address, 5)).to.revertedWith("rating must be within min and max ratings (inclusive)")
            })
            it("Should set rating for driver", async function ()
            {
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).totalRating).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).countRating).to.equal(0)

                var tx = await contractRideRater.giveRating_(accounts[0].address, 3)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).totalRating).to.equal(3)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[0].address)).countRating).to.equal(1)
            })
        })

        describe("_setRatingBounds", function ()
        {
            it("Should revert if min rating zero", async function ()
            {
                await expect(contractRideRater.setRatingBounds_(0, 1)).to.revertedWith("cannot have zero rating bound")
            })
            it("Should revert if max less than min rating bound", async function ()
            {
                await expect(contractRideRater.setRatingBounds_(3, 1)).to.revertedWith("maximum rating must be more than minimum rating")
            })
            it("Should set min and max rating bounds", async function ()
            {
                expect(await contractRideRater.sRatingMin_()).to.equal(2)
                expect(await contractRideRater.sRatingMax_()).to.equal(4)

                var tx = await contractRideRater.setRatingBounds_(1, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideRater.sRatingMin_()).to.equal(1)
                expect(await contractRideRater.sRatingMax_()).to.equal(5)
            })
        })
    })

    describe("RideRater", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideRater = await ethers.getContractAt('RideTestRater', rideHubAddress)
        })

        describe("setRatingBounds", function ()
        {
            it("Should set min and max rating bounds", async function ()
            {
                expect(await contractRideRater.sRatingMin_()).to.equal(0)
                expect(await contractRideRater.sRatingMax_()).to.equal(0)

                var tx = await contractRideRater.setRatingBounds(1, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideRater.sRatingMin_()).to.equal(1)
                expect(await contractRideRater.sRatingMax_()).to.equal(5)
            })
        })

        describe("getRatingMin", function ()
        {
            it("Should return min rating value", async function ()
            {
                expect(await contractRideRater.getRatingMin()).to.equal(1)
            })
        })

        describe("getRatingMax", function ()
        {
            it("Should return max rating value", async function ()
            {
                expect(await contractRideRater.getRatingMax()).to.equal(5)
            })
        })
    })
}