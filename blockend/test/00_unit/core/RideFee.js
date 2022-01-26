// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibFee", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideFee = await ethers.getContractAt('RideTestFee', rideHubAddress)
            contractRideCurrencyRegistry = await ethers.getContractAt('RideTestCurrencyRegistry', rideHubAddress)

            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            // keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))

            var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyLocal, true)
            var rcpt = await tx.wait()
        })

        describe("_setCancellationFee", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideFee.sCurrencyKeyToCancellationFee_(keyLocal)).to.equal(0)

                var tx = await contractRideFee.setCancellationFee_(keyLocal, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideFee.sCurrencyKeyToCancellationFee_(keyLocal)).to.equal(5)
            })
        })

        describe("_setBaseFee", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideFee.sCurrencyKeyToBaseFee_(keyLocal)).to.equal(0)

                var tx = await contractRideFee.setBaseFee_(keyLocal, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideFee.sCurrencyKeyToBaseFee_(keyLocal)).to.equal(5)
            })
        })

        describe("_setCostPerMinute", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideFee.sCurrencyKeyToCostPerMinute_(keyLocal)).to.equal(0)

                var tx = await contractRideFee.setCostPerMinute_(keyLocal, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideFee.sCurrencyKeyToCostPerMinute_(keyLocal)).to.equal(5)
            })
        })

        describe("_setCostPerMetre", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 0)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 1)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 2)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 3)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 4)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 5)).to.equal(0)

                var tx = await contractRideFee.setCostPerMetre_(keyLocal, [1, 2, 3, 4, 5, 6])
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 0)).to.equal(1)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 1)).to.equal(2)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 2)).to.equal(3)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 3)).to.equal(4)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 4)).to.equal(5)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 5)).to.equal(6)
            })
        })

        describe("_getFare", function ()
        {
            it("Should return correct fare value", async function ()
            {
                expect(await contractRideFee.getFare_(keyLocal, 1, 5, 5)).to.equal(40)
            })
        })

        describe("_getCancellationFee", function ()
        {
            it("Should return correct fee value", async function ()
            {
                expect(await contractRideFee.getCancellationFee_(keyLocal)).to.equal(5)
            })
        })
    })

    describe("RideFee", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideFee = await ethers.getContractAt('RideTestFee', rideHubAddress)
            contractRideCurrencyRegistry = await ethers.getContractAt('RideTestCurrencyRegistry', rideHubAddress)

            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            // keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))

            var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyLocal, true)
            var rcpt = await tx.wait()
        })

        describe("setCancellationFee", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideFee.sCurrencyKeyToCancellationFee_(keyLocal)).to.equal(0)

                var tx = await contractRideFee.setCancellationFee(keyLocal, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideFee.sCurrencyKeyToCancellationFee_(keyLocal)).to.equal(5)
            })
        })

        describe("setBaseFee", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideFee.sCurrencyKeyToBaseFee_(keyLocal)).to.equal(0)

                var tx = await contractRideFee.setBaseFee(keyLocal, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideFee.sCurrencyKeyToBaseFee_(keyLocal)).to.equal(5)
            })
        })

        describe("setCostPerMinute", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideFee.sCurrencyKeyToCostPerMinute_(keyLocal)).to.equal(0)

                var tx = await contractRideFee.setCostPerMinute(keyLocal, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideFee.sCurrencyKeyToCostPerMinute_(keyLocal)).to.equal(5)
            })
        })

        describe("setCostPerMetre", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 0)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 1)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 2)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 3)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 4)).to.equal(0)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 5)).to.equal(0)

                var tx = await contractRideFee.setCostPerMetre(keyLocal, [1, 2, 3, 4, 5, 6])
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 0)).to.equal(1)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 1)).to.equal(2)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 2)).to.equal(3)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 3)).to.equal(4)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 4)).to.equal(5)
                expect(await contractRideFee.sCurrencyKeyToBadgeToCostPerMetre_(keyLocal, 5)).to.equal(6)
            })
        })

        describe("getFare", function ()
        {
            it("Should return correct fare value", async function ()
            {
                expect(await contractRideFee.getFare(keyLocal, 1, 5, 5)).to.equal(40)
            })
        })

        describe("getCancellationFee", function ()
        {
            it("Should return correct fee value", async function ()
            {
                expect(await contractRideFee.getCancellationFee(keyLocal)).to.equal(5)
            })
        })

        describe("getBaseFee", function ()
        {
            it("Should return correct fee value", async function ()
            {
                expect(await contractRideFee.getBaseFee(keyLocal)).to.equal(5)
            })
        })

        describe("getCostPerMinute", function ()
        {
            it("Should return correct fee value", async function ()
            {
                expect(await contractRideFee.getCostPerMinute(keyLocal)).to.equal(5)
            })
        })

        describe("getCostPerMetre", function ()
        {
            it("Should return correct fee value", async function ()
            {
                expect(await contractRideFee.getCostPerMetre(keyLocal, 0)).to.equal(1)
                expect(await contractRideFee.getCostPerMetre(keyLocal, 1)).to.equal(2)
                expect(await contractRideFee.getCostPerMetre(keyLocal, 2)).to.equal(3)
                expect(await contractRideFee.getCostPerMetre(keyLocal, 3)).to.equal(4)
                expect(await contractRideFee.getCostPerMetre(keyLocal, 4)).to.equal(5)
                expect(await contractRideFee.getCostPerMetre(keyLocal, 5)).to.equal(6)
            })
        })
    })
}