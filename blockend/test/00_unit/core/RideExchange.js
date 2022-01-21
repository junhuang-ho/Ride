// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployTest } = require("../../../scripts/deployTest.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibExchange", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployTest()
            rideHubAddress = contractAddresses[0]
            mockV3AggregatorAddress = contractAddresses[1]
            contractRideExchange = await ethers.getContractAt('RideTestExchange', rideHubAddress)
            contractRideCurrencyRegistry = await ethers.getContractAt('RideTestCurrencyRegistry', rideHubAddress)
            // contractMockV3Aggregator = await ethers.getContractAt("MockV3Aggregator", mockV3AggregatorAddress)

            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))
            priceFeed = "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e" // address

            keyLocal2 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("YEN"))
            keyPay2 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("BTC"))
            priceFeed2 = "0xc116851f0F506a4A1f304f8587ed4357F17643c5" // address
        })

        describe("_requireXPerYPriceFeedSupported", function ()
        {
            it("Should revert if price feed not supported", async function ()
            {
                await expect(contractRideExchange.requireXPerYPriceFeedSupported_(keyLocal, keyPay)).to.revertedWith("price feed not supported")
            })
            it("Should allow pass if price feed supported", async function ()
            {
                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyLocal, keyPay, priceFeed)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideExchange.requireXPerYPriceFeedSupported_(keyLocal, keyPay)).to.equal(true)
            })
        })

        describe("_addXPerYPriceFeed", function ()
        {
            it("Should revert if price feed is zero address", async function ()
            {
                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyLocal, true)
                var rcpt = await tx.wait()
                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyPay, true)
                var rcpt = await tx.wait()
                await expect(contractRideExchange.addXPerYPriceFeed_(keyLocal, keyPay, ethers.constants.AddressZero)).to.revertedWith("zero price feed address")
            })
            it("Should revert if price feed already supported", async function ()
            {
                await expect(contractRideExchange.addXPerYPriceFeed_(keyLocal, keyPay, priceFeed)).to.revertedWith("price feed already supported")
            })
            it("Should set price feed", async function ()
            {
                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyLocal2, true)
                var rcpt = await tx.wait()
                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyPay2, true)
                var rcpt = await tx.wait()

                var tx = await contractRideExchange.addXPerYPriceFeed_(keyLocal2, keyPay2, priceFeed2)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyLocal2, keyPay2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyPay2, keyLocal2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYInverse_(keyPay2, keyLocal2)).to.equal(true)
            })
        })

        describe("_removeXPerYPriceFeed", function ()
        {
            it("Should remove price feed", async function ()
            {
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyLocal2, keyPay2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyPay2, keyLocal2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYInverse_(keyPay2, keyLocal2)).to.equal(true)

                var tx = await contractRideExchange.removeXPerYPriceFeed_(keyLocal2, keyPay2)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyLocal2, keyPay2)).to.equal(ethers.constants.AddressZero)
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyPay2, keyLocal2)).to.equal(ethers.constants.AddressZero)
                expect(await contractRideExchange.sXToYToXPerYInverse_(keyPay2, keyLocal2)).to.equal(false)
            })
        })

        describe("_getXPerYInWei", function ()
        {
            it("Should get value from AggregatorV3Interface in wei", async function ()
            {
                var tx = await contractRideExchange.addXPerYPriceFeed_(keyLocal2, keyPay2, mockV3AggregatorAddress)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideExchange.getXPerYInWei_(keyLocal2, keyPay2)).toString()).to.equal("2000000000000000000")
            })
        })

        describe("_convertDirect", function ()
        {
            it("Should properly convert value", async function ()
            {
                expect((await contractRideExchange.convertDirect_(keyLocal2, keyPay2, "3300000000000000000")).toString()).to.equal("1650000000000000000")
            })
        })

        describe("_convertInverse", function ()
        {
            it("Should properly convert value", async function ()
            {
                expect((await contractRideExchange.convertInverse_(keyLocal2, keyPay2, "3300000000000000000")).toString()).to.equal("6600000000000000000")
            })
        })

        describe("_convertCurrency", function ()
        {
            // contains only other fn implementations
        })
    })

    describe("RideExchange", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployTest()
            rideHubAddress = contractAddresses[0]
            mockV3AggregatorAddress = contractAddresses[1]
            contractRideExchange = await ethers.getContractAt('RideTestExchange', rideHubAddress)
            contractRideCurrencyRegistry = await ethers.getContractAt('RideTestCurrencyRegistry', rideHubAddress)
            // contractMockV3Aggregator = await ethers.getContractAt("MockV3Aggregator", mockV3AggregatorAddress)

            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))
            priceFeed = "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e" // address

            keyLocal2 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("YEN"))
            keyPay2 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("BTC"))
            priceFeed2 = "0xc116851f0F506a4A1f304f8587ed4357F17643c5" // address
        })

        describe("addXPerYPriceFeed", function ()
        {
            it("Should revert if price feed is zero address", async function ()
            {
                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyLocal, true)
                var rcpt = await tx.wait()
                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyPay, true)
                var rcpt = await tx.wait()
                await expect(contractRideExchange.addXPerYPriceFeed(keyLocal, keyPay, ethers.constants.AddressZero)).to.revertedWith("zero price feed address")
            })
            it("Should set price feed", async function ()
            {
                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyLocal2, true)
                var rcpt = await tx.wait()
                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyPay2, true)
                var rcpt = await tx.wait()

                var tx = await contractRideExchange.addXPerYPriceFeed(keyLocal2, keyPay2, priceFeed2)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyLocal2, keyPay2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyPay2, keyLocal2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYInverse_(keyPay2, keyLocal2)).to.equal(true)
            })
            it("Should revert if price feed already supported", async function ()
            {
                await expect(contractRideExchange.addXPerYPriceFeed(keyLocal2, keyPay2, priceFeed2)).to.revertedWith("price feed already supported")
            })
        })

        describe("removeXPerYPriceFeed", function ()
        {
            it("Should remove price feed", async function ()
            {
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyLocal2, keyPay2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyPay2, keyLocal2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYInverse_(keyPay2, keyLocal2)).to.equal(true)

                var tx = await contractRideExchange.removeXPerYPriceFeed(keyLocal2, keyPay2)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyLocal2, keyPay2)).to.equal(ethers.constants.AddressZero)
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyPay2, keyLocal2)).to.equal(ethers.constants.AddressZero)
                expect(await contractRideExchange.sXToYToXPerYInverse_(keyPay2, keyLocal2)).to.equal(false)
            })
        })

        describe("getXPerYPriceFeed", function ()
        {
            it("Should return price feed", async function ()
            {
                var tx = await contractRideExchange.addXPerYPriceFeed(keyLocal2, keyPay2, priceFeed2)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideExchange.getXPerYPriceFeed(keyLocal2, keyPay2)).to.equal(priceFeed2)
            })
        })

        describe("convertCurrency", function ()
        {
            // contains only other fn implementations
        })
    })
}