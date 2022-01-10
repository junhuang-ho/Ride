// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat");
const chainId = hre.network.config.chainId

if (parseInt(chainId) === 31337) {
    describe("RideCost", function () {
        beforeEach(async function () {
            const RideCost = await ethers.getContractFactory("TestRideCost")
            const rideCost = await RideCost.deploy()
            rideCostContract = await rideCost.deployed()
        })

        describe("setRequestFee", function () {
            it("Should set request fee accordingly", async function () {
                expect(await rideCostContract.requestFee()).to.equal(0)

                var tx = await rideCostContract.setRequestFee(2)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideCostContract.requestFee()).to.equal(2)
            })
        })

        describe("setBaseFare", function () {
            it("Should set base fare accordingly", async function () {
                expect(await rideCostContract.baseFare()).to.equal(0)

                var tx = await rideCostContract.setBaseFare(2)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideCostContract.baseFare()).to.equal(2)
            })
        })

        describe("setCostPerMinute", function () {
            it("Should set cost per minute accordingly", async function () {
                expect(await rideCostContract.costPerMinute()).to.equal(0)

                var tx = await rideCostContract.setCostPerMinute(2)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideCostContract.costPerMinute()).to.equal(2)
            })
        })

        describe("setBanDuration", function () {
            it("Should set ban duration accordingly", async function () {
                expect(await rideCostContract.banDuration()).to.equal(0)

                var tx = await rideCostContract.setBanDuration(2)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideCostContract.banDuration()).to.equal(2)
            })
        })

        describe("setCostPerMetre", function () {
            it("Should set cost per metre accordingly", async function () {
                expect(await rideCostContract.badgeToCostPerMetre(0)).to.equal(0)
                expect(await rideCostContract.badgeToCostPerMetre(1)).to.equal(0)
                expect(await rideCostContract.badgeToCostPerMetre(2)).to.equal(0)
                expect(await rideCostContract.badgeToCostPerMetre(3)).to.equal(0)
                expect(await rideCostContract.badgeToCostPerMetre(4)).to.equal(0)
                expect(await rideCostContract.badgeToCostPerMetre(5)).to.equal(0)

                const costPerMetre = [1, 2, 3, 4, 5, 6]

                var tx = await rideCostContract.setCostPerMetre(costPerMetre)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideCostContract.badgeToCostPerMetre(0)).to.equal(1)
                expect(await rideCostContract.badgeToCostPerMetre(1)).to.equal(2)
                expect(await rideCostContract.badgeToCostPerMetre(2)).to.equal(3)
                expect(await rideCostContract.badgeToCostPerMetre(3)).to.equal(4)
                expect(await rideCostContract.badgeToCostPerMetre(4)).to.equal(5)
                expect(await rideCostContract.badgeToCostPerMetre(5)).to.equal(6)
            })
            it("Should revert if _costPerMetre.length not equal Badges", async function () {
                await expect(rideCostContract.setCostPerMetre([1, 2, 3, 4, 5])).to.revertedWith("_costPerMetre.length must be equal Badges")
                await expect(rideCostContract.setCostPerMetre([1, 2, 3, 4, 5, 6, 7])).to.revertedWith("_costPerMetre.length must be equal Badges")
            })
        })
    })
}