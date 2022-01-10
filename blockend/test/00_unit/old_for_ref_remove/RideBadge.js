// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat");
const chainId = hre.network.config.chainId

if (parseInt(chainId) === 31337) {
    describe("RideBadge", function () {
        beforeEach(async function () {
            const RideBadge = await ethers.getContractFactory("TestRideBadge")
            const rideBadge = await RideBadge.deploy()
            rideBadgeContract = await rideBadge.deployed()

            badges = [10000, 100000, 500000, 1000000, 2000000]
        })

        describe("setBadgesMaxScores", function () {
            it("Should set badges accordingly", async function () {
                var tx = await rideBadgeContract.setBadgesMaxScores(badges)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBadgeContract.badgeToBadgeMaxScore(0)).to.equal(badges[0])
                expect(await rideBadgeContract.badgeToBadgeMaxScore(1)).to.equal(badges[1])
                expect(await rideBadgeContract.badgeToBadgeMaxScore(2)).to.equal(badges[2])
                expect(await rideBadgeContract.badgeToBadgeMaxScore(3)).to.equal(badges[3])
                expect(await rideBadgeContract.badgeToBadgeMaxScore(4)).to.equal(badges[4])
            })
            it("Should revert if _badgesMaxScores.length not 1 less Badges", async function () {
                await expect(rideBadgeContract.setBadgesMaxScores([10000, 100000, 500000, 1000000])).to.revertedWith("_badgesMaxScores.length must be 1 less than Badges")
                await expect(rideBadgeContract.setBadgesMaxScores([10000, 100000, 500000, 1000000, 2000000, 3000000])).to.revertedWith("_badgesMaxScores.length must be 1 less than Badges")
            })
        })

        describe("_getBadge", function () {
            it("Should return proper badge", async function () {
                var tx = await rideBadgeContract.setBadgesMaxScores(badges)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBadgeContract._getBadge_(0)).to.equal(0)
                expect(await rideBadgeContract._getBadge_(10000)).to.equal(0)
                expect(await rideBadgeContract._getBadge_(10001)).to.equal(1)
                expect(await rideBadgeContract._getBadge_(100000)).to.equal(1)
                expect(await rideBadgeContract._getBadge_(100001)).to.equal(2)
                expect(await rideBadgeContract._getBadge_(500000)).to.equal(2)
                expect(await rideBadgeContract._getBadge_(500001)).to.equal(3)
                expect(await rideBadgeContract._getBadge_(1000000)).to.equal(3)
                expect(await rideBadgeContract._getBadge_(1000001)).to.equal(4)
                expect(await rideBadgeContract._getBadge_(2000000)).to.equal(4)
                expect(await rideBadgeContract._getBadge_(2000001)).to.equal(5)
                expect(await rideBadgeContract._getBadge_(9999999)).to.equal(5)
            })
        })
    })
}