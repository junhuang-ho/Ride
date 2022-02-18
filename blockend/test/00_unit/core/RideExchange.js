// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibExchange", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
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

            keyLocal3 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("SOL"))
            keyPay3 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))
            priceFeed3 = "0x614539062F7205049917e03ec4C86FF808F083cb" // address

            keyLocal4 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("SOL"))
            keyPay4 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("LTC"))
            priceFeed4 = "0x0285E2453B9aaC708B9e58271d2eF6f5aEA82279" // address

            keyLocal5 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("BTC"))
            keyPay5 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))
            priceFeed5 = "0x0285E2453B9aaC708B9e58271d2eF6f5aEA82279" // address
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

        describe("_requireDerivedXPerYPriceFeedSupported", function () 
        {
            it("Should revert if derived price feed not supported", async function ()
            {
                await expect(contractRideExchange.requireDerivedXPerYPriceFeedSupported_(keyLocal, keyPay)).to.revertedWith("derived price feed not supported")
            })
            it("Should allow pass if derived price feed supported", async function ()
            {
                var tx = await contractRideExchange.ssXToYToXPerYDerivedPriceFeedDetails_(keyLocal2, keyPay2, priceFeed, priceFeed2, false, false)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideExchange.requireDerivedXPerYPriceFeedSupported_(keyLocal2, keyPay2)).to.equal(true)
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
                expect(await contractRideExchange.sXToYToXPerYInverse_(keyPay2, keyLocal2)).to.equal(false)

                var tx = await contractRideExchange.addXPerYPriceFeed_(keyLocal2, keyPay2, priceFeed2)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyLocal2, keyPay2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYPriceFeed_(keyPay2, keyLocal2)).to.equal(priceFeed2)
                expect(await contractRideExchange.sXToYToXPerYInverse_(keyPay2, keyLocal2)).to.equal(true)
            })
        })

        describe("_deriveXPerYPriceFeed", function ()
        {
            it("Should revert if input same keys", async function ()
            {
                await expect(contractRideExchange.deriveXPerYPriceFeed_(keyLocal, keyLocal, keyPay3)).to.revertedWith("underlying currency key cannot be identical")
            })
            it("Should set derived price feed - without inverse", async function ()
            {
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal3)).numerator).to.equal(ethers.constants.AddressZero)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal3)).denominator).to.equal(ethers.constants.AddressZero)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal3, keyLocal)).numerator).to.equal(ethers.constants.AddressZero)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal3, keyLocal)).denominator).to.equal(ethers.constants.AddressZero)

                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyLocal, keyLocal3)).to.equal(false)
                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyLocal3, keyLocal)).to.equal(false)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal3)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal3, keyLocal)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal3)).denominatorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal3, keyLocal)).denominatorInverse).to.equal(false)

                expect((await contractRideExchange.sXToYToReferenceIds_(keyLocal, keyPay3)).length).to.equal(0)
                expect((await contractRideExchange.sXToYToReferenceIds_(keyLocal3, keyPay3)).length).to.equal(0)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(0)).keyX).to.equal(ethers.constants.HashZero)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(0)).keyY).to.equal(ethers.constants.HashZero)

                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyLocal, keyPay, priceFeed)
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYInverse_(keyPay, keyLocal, false)
                var rcpt = await tx.wait()

                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyLocal3, keyPay3, priceFeed3)
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyPay3, keyLocal3, priceFeed3)
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYInverse_(keyPay3, keyLocal3, false)
                var rcpt = await tx.wait()

                var tx = await contractRideExchange.deriveXPerYPriceFeed_(keyLocal, keyLocal3, keyPay3)
                var rcpt = await tx.wait()

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal3)).numerator).to.equal(priceFeed)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal3)).denominator).to.equal(priceFeed3)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal3, keyLocal)).numerator).to.equal(priceFeed)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal3, keyLocal)).denominator).to.equal(priceFeed3)

                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyLocal, keyLocal3)).to.equal(false)
                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyLocal3, keyLocal)).to.equal(true)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal3)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal3, keyLocal)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal3)).denominatorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal3, keyLocal)).denominatorInverse).to.equal(false)

                expect((await contractRideExchange.sXToYToReferenceIds_(keyLocal, keyPay3)).length).to.equal(1)
                expect((await contractRideExchange.sXToYToReferenceIds_(keyLocal3, keyPay3)).length).to.equal(1)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(0)).keyX).to.equal(keyLocal)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(0)).keyY).to.equal(keyLocal3)
            })
            it("Should set derived price feed - with shared currency key with another derived price feed (and with inverse)", async function ()
            {
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal5)).numerator).to.equal(ethers.constants.AddressZero)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal5)).denominator).to.equal(ethers.constants.AddressZero)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal5, keyLocal)).numerator).to.equal(ethers.constants.AddressZero)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal5, keyLocal)).denominator).to.equal(ethers.constants.AddressZero)

                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyLocal, keyLocal5)).to.equal(false)
                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyLocal5, keyLocal)).to.equal(false)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal5)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal5, keyLocal)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal5)).denominatorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal5, keyLocal)).denominatorInverse).to.equal(false)

                expect((await contractRideExchange.sXToYToReferenceIds_(keyLocal5, keyPay3)).length).to.equal(0)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(1)).keyX).to.equal(ethers.constants.HashZero)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(1)).keyY).to.equal(ethers.constants.HashZero)

                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyLocal5, keyPay5, priceFeed3)
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyPay5, keyLocal5, priceFeed3)
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYInverse_(keyLocal5, keyPay5, true)
                var rcpt = await tx.wait()

                var tx = await contractRideExchange.deriveXPerYPriceFeed_(keyLocal, keyLocal5, keyPay3)
                var rcpt = await tx.wait()

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal5)).numerator).to.equal(priceFeed)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal5)).denominator).to.equal(priceFeed3)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal5, keyLocal)).numerator).to.equal(priceFeed)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal5, keyLocal)).denominator).to.equal(priceFeed3)

                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyLocal, keyLocal5)).to.equal(false)
                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyLocal5, keyLocal)).to.equal(true)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal5)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal5, keyLocal)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal, keyLocal5)).denominatorInverse).to.equal(true)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyLocal5, keyLocal)).denominatorInverse).to.equal(true)

                expect((await contractRideExchange.sXToYToReferenceIds_(keyLocal, keyPay3)).length).to.equal(2)
                expect((await contractRideExchange.sXToYToReferenceIds_(keyLocal5, keyPay3)).length).to.equal(1)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(1)).keyX).to.equal(keyLocal)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(1)).keyY).to.equal(keyLocal5)
            })
            it("Should set derived price feed - with reversed derived price feed (and with inverse)", async function ()
            {
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).numerator).to.equal(ethers.constants.AddressZero)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).denominator).to.equal(ethers.constants.AddressZero)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).numerator).to.equal(ethers.constants.AddressZero)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).denominator).to.equal(ethers.constants.AddressZero)

                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyPay3, keyPay4)).to.equal(false)
                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyPay4, keyPay3)).to.equal(false)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).denominatorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).denominatorInverse).to.equal(false)

                expect((await contractRideExchange.sXToYToReferenceIds_(keyPay3, keyLocal4)).length).to.equal(0)
                expect((await contractRideExchange.sXToYToReferenceIds_(keyPay4, keyLocal4)).length).to.equal(0)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(2)).keyX).to.equal(ethers.constants.HashZero)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(2)).keyY).to.equal(ethers.constants.HashZero)

                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyLocal4, keyPay4, priceFeed4)
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyPay4, keyLocal4, priceFeed4)
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYInverse_(keyPay4, keyLocal4, true)
                var rcpt = await tx.wait()

                var tx = await contractRideExchange.deriveXPerYPriceFeed_(keyPay3, keyPay4, keyLocal4)
                var rcpt = await tx.wait()

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).numerator).to.equal(priceFeed3)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).denominator).to.equal(priceFeed4)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).numerator).to.equal(priceFeed3)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).denominator).to.equal(priceFeed4)

                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyPay3, keyPay4)).to.equal(false)
                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyPay4, keyPay3)).to.equal(true)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).denominatorInverse).to.equal(true)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).denominatorInverse).to.equal(true)

                expect((await contractRideExchange.sXToYToReferenceIds_(keyPay3, keyLocal4)).length).to.equal(1)
                expect((await contractRideExchange.sXToYToReferenceIds_(keyPay4, keyLocal4)).length).to.equal(1)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(2)).keyX).to.equal(keyPay3)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(2)).keyY).to.equal(keyPay4)
            })
            it("Should revert if derived price feed already supported", async function ()
            {
                await expect(contractRideExchange.deriveXPerYPriceFeed_(keyPay3, keyPay4, keyLocal4)).to.revertedWith("derived price feed already supported")
            })
        })

        describe("_removeXPerYPriceFeed", function ()
        {
            it("Should remove price feed details", async function ()
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
            it("Should remove derived price feed details", async function ()
            {
                var tx = await contractRideExchange.removeXPerYPriceFeed_(keyPay4, keyLocal4)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).numerator).to.equal(ethers.constants.AddressZero)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).denominator).to.equal(ethers.constants.AddressZero)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).numerator).to.equal(ethers.constants.AddressZero)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).denominator).to.equal(ethers.constants.AddressZero)

                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyPay3, keyPay4)).to.equal(false)
                expect(await contractRideExchange.sXToYToXPerYInverseDerived_(keyPay4, keyPay3)).to.equal(false)

                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).numeratorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay3, keyPay4)).denominatorInverse).to.equal(false)
                expect((await contractRideExchange.sXToYToXPerYDerivedPriceFeedDetails_(keyPay4, keyPay3)).denominatorInverse).to.equal(false)

                expect((await contractRideExchange.sXToYToReferenceIds_(keyPay4, keyLocal4)).length).to.equal(0)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(2)).keyX).to.equal(ethers.constants.HashZero)
                expect((await contractRideExchange.sReferenceIdToDerivedPriceFeed_(2)).keyY).to.equal(ethers.constants.HashZero)
            })
            it("Should remove both price feed and relevant derived price feed details", async function ()
            { })
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
                xPerY = await contractRideExchange.getXPerYInWei_(keyLocal2, keyPay2)
                expect((await contractRideExchange.convertDirect_(xPerY, "3300000000000000000")).toString()).to.equal("1650000000000000000")
            })
        })

        describe("_convertInverse", function ()
        {
            it("Should properly convert value", async function ()
            {
                xPerY = await contractRideExchange.getXPerYInWei_(keyLocal2, keyPay2)
                expect((await contractRideExchange.convertInverse_(xPerY, "3300000000000000000")).toString()).to.equal("6600000000000000000")
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
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
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