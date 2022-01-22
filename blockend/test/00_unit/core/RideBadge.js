// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibBadge", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(true, false)
            rideHubAddress = contractAddresses[0]
            contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress)
            contractRideRater = await ethers.getContractAt('RideTestRater', rideHubAddress)

            badges = [10000, 100000, 500000, 1000000, 2000000]
        })
        describe("_setBadgesMaxScores", function ()
        {
            it("Should revert if max score count is not one less than badges count", async function ()
            {
                await expect(contractRideBadge.setBadgesMaxScores_([10000, 100000, 500000, 1000000])).to.revertedWith("_badgesMaxScores.length must be 1 less than Badges")
                await expect(contractRideBadge.setBadgesMaxScores_([10000, 100000, 500000, 1000000, 2000000, 3000000])).to.revertedWith("_badgesMaxScores.length must be 1 less than Badges")
            })
            it("Should set badges accordingly", async function ()
            {
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(0)).to.equal(0)

                var txi = await contractRideBadge.setBadgesMaxScores_(badges)
                var rcpt = await txi.wait()

                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(0)).to.equal(badges[0])
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(1)).to.equal(badges[1])
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(2)).to.equal(badges[2])
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(3)).to.equal(badges[3])
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(4)).to.equal(badges[4])
            })
        })

        describe("_getBadgesCount", function ()
        {
            it("Should return length of 6", async function ()
            {
                expect(await contractRideBadge.getBadgesCount_()).to.equal(6)
            })

        })
        describe("_getBadge", function ()
        {
            it("Should return the score for specific badge", async function ()
            {
                expect(await contractRideBadge.getBadge_(0)).to.equal(0)

                var tx = await contractRideBadge.setBadgesMaxScores(badges)
                var rcpt = await tx.wait()

                expect(await contractRideBadge.getBadge_(0)).to.equal(0)
                expect(await contractRideBadge.getBadge_(10000)).to.equal(0)
                expect(await contractRideBadge.getBadge_(10001)).to.equal(1)
                expect(await contractRideBadge.getBadge_(100000)).to.equal(1)
                expect(await contractRideBadge.getBadge_(100001)).to.equal(2)
                expect(await contractRideBadge.getBadge_(500000)).to.equal(2)
                expect(await contractRideBadge.getBadge_(500001)).to.equal(3)
                expect(await contractRideBadge.getBadge_(1000000)).to.equal(3)
                expect(await contractRideBadge.getBadge_(1000001)).to.equal(4)
                expect(await contractRideBadge.getBadge_(2000000)).to.equal(4)
                expect(await contractRideBadge.getBadge_(2000001)).to.equal(5)
                expect(await contractRideBadge.getBadge_(9999999)).to.equal(5)
            })
        })
        describe("_calculateScore", function ()
        {
            it("Should return zero value", async function ()
            {
                expect(await contractRideBadge.calculateScore_()).to.equal(0)
            })
            it("Should return correct score value", async function ()
            {
                metresTravelled = 200
                countStart = 5
                countEnd = 4
                totalRating = 13
                countRating = countStart
                maxRating = 5

                score = Math.floor((metresTravelled * countEnd * totalRating) / (countStart * countRating * maxRating))

                var tx = await contractRideBadge.ssDriverToDriverReputation_(accounts[0].address, 1, "test123", 500, metresTravelled, countStart, countEnd, totalRating, countRating)
                var rcpt = await tx.wait()

                var tx = await contractRideRater.setRatingBounds_(1, maxRating)
                var rcpt = await tx.wait()

                expect(await contractRideBadge.calculateScore_()).to.equal(score)
            })
        })
    })

    describe("RideBadge", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(true, false)
            rideHubAddress = contractAddresses[0]
            contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress)
            contractRideRater = await ethers.getContractAt('RideTestRater', rideHubAddress)

            badges = [10000, 100000, 500000, 1000000, 2000000]
        })

        describe("setBadgesMaxScores", function ()
        {
            it("Should revert if max score count is not one less than badges count", async function ()
            {
                await expect(contractRideBadge.setBadgesMaxScores([10000, 100000, 500000, 1000000])).to.revertedWith("_badgesMaxScores.length must be 1 less than Badges")
                await expect(contractRideBadge.setBadgesMaxScores([10000, 100000, 500000, 1000000, 2000000, 3000000])).to.revertedWith("_badgesMaxScores.length must be 1 less than Badges")
            })
            it("Should set badges accordingly", async function ()
            {
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(0)).to.equal(0)

                var tx = await contractRideBadge.setBadgesMaxScores(badges)
                var rcpt = await tx.wait()

                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(0)).to.equal(badges[0])
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(1)).to.equal(badges[1])
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(2)).to.equal(badges[2])
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(3)).to.equal(badges[3])
                expect(await contractRideBadge.sBadgeToBadgeMaxScore_(4)).to.equal(badges[4])
            })
        })

        describe("getBadgeToBadgeMaxScore", function ()
        {
            it("Should return the score for specific badge", async function ()
            {
                var tx = await contractRideBadge.setBadgesMaxScores(badges)
                var rcpt = await tx.wait()

                expect(await contractRideBadge.getBadgeToBadgeMaxScore(0)).to.equal(badges[0])
                expect(await contractRideBadge.getBadgeToBadgeMaxScore(1)).to.equal(badges[1])
                expect(await contractRideBadge.getBadgeToBadgeMaxScore(2)).to.equal(badges[2])
                expect(await contractRideBadge.getBadgeToBadgeMaxScore(3)).to.equal(badges[3])
                expect(await contractRideBadge.getBadgeToBadgeMaxScore(4)).to.equal(badges[4])
            })
        })

        describe("getDriverToDriverReputation", function ()
        {
            it("Should return driver reputation", async function ()
            {
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).id).to.equal(0)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).uri).to.equal("")
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).maxMetresPerTrip).to.equal(0)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).metresTravelled).to.equal(0)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).countStart).to.equal(0)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).countEnd).to.equal(0)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).totalRating).to.equal(0)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).countRating).to.equal(0)

                var tx = await contractRideBadge.ssDriverToDriverReputation_(accounts[0].address, 1, "test123", 500, 33, 2, 1, 3, 2)
                var rcpt = await tx.wait()

                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).id).to.equal(1)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).uri).to.equal("test123")
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).maxMetresPerTrip).to.equal(500)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).metresTravelled).to.equal(33)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).countStart).to.equal(2)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).countEnd).to.equal(1)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).totalRating).to.equal(3)
                expect((await contractRideBadge.getDriverToDriverReputation(accounts[0].address)).countRating).to.equal(2)

            })

        })
    })
}