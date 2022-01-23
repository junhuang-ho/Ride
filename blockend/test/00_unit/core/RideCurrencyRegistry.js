// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibCurrencyRegistry", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideCurrencyRegistry = await ethers.getContractAt('RideTestCurrencyRegistry', rideHubAddress)
            contractRideFee = await ethers.getContractAt('RideTestFee', rideHubAddress)
        })

        describe("_requireCurrencySupported", function ()
        {
            it("Should only allow pass if currency supported", async function ()
            {
                key = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test123"))

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(false)

                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(key, true)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.requireCurrencySupported_(key)).to.equal(true)
            })
            it("Should revert if currency not supported", async function ()
            {
                key = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("testnotsupp"))
                await expect(contractRideCurrencyRegistry.requireCurrencySupported_(key)).to.revertedWith("currency not supported")
            })
        })

        describe("_requireIsCrypto", function ()
        {
            it("Should only allow pass if crypto supported", async function ()
            {
                key = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test123"))

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToCrypto_(key)).to.equal(false)

                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToCrypto_(key, true)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.requireIsCrypto_(key)).to.equal(true)
            })
            it("Should revert if currency not crypto", async function ()
            {
                key = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("testnotsupp"))
                await expect(contractRideCurrencyRegistry.requireIsCrypto_(key)).to.revertedWith("not crypto")
            })
        })

        describe("_register", function ()
        {
            it("Should set bytes32 as supported", async function ()
            {
                key = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test456"))

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(false)

                var tx = await contractRideCurrencyRegistry.register_(key)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)
            })
        })

        describe("_registerFiat", function ()
        {
            it("Should convert string currency coode to bytes32 key and set as supported", async function ()
            {
                var tx = await contractRideCurrencyRegistry.registerFiat_("USD")
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)
            })
        })

        describe("_registerCrypto", function ()
        {
            it("Should revert if 0 address", async function ()
            {
                await expect(contractRideCurrencyRegistry.registerCrypto_(ethers.constants.AddressZero)).to.revertedWith("zero token address")
            })
            it("Should convert string currency coode to bytes32 key and set key and crypto as supported", async function ()
            {
                var tx = await contractRideCurrencyRegistry.registerCrypto_("0xc778417e063141139fce010982780140aa0cd5ab")
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)
                expect(await contractRideCurrencyRegistry.sCurrencyKeyToCrypto_(key)).to.equal(true)
            })
        })

        describe("_removeCurrency", function ()
        {
            it("Should delete supported key", async function ()
            {
                key = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("tester"))

                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(key, true)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)

                var tx = await contractRideCurrencyRegistry.removeCurrency_(key)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(false)
            })
            it("Should delete supported crypto key", async function ()
            {
                var tx = await contractRideCurrencyRegistry.registerCrypto_("0xc778417e063141139fce010982780140aa0cd5ab")
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)
                expect(await contractRideCurrencyRegistry.sCurrencyKeyToCrypto_(key)).to.equal(true)

                var tx = await contractRideCurrencyRegistry.removeCurrency_(key)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(false)
                expect(await contractRideCurrencyRegistry.sCurrencyKeyToCrypto_(key)).to.equal(false)
            })
        })
    })

    describe("RideCurrencyRegistry", function ()
    {
        describe("registerFiat", function ()
        {
            it("Should convert string currency coode to bytes32 key and set as supported", async function ()
            {
                var tx = await contractRideCurrencyRegistry.registerFiat("USD")
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)
            })
        })

        describe("registerCrypto", function ()
        {
            it("Should revert if 0 address", async function ()
            {
                await expect(contractRideCurrencyRegistry.registerCrypto(ethers.constants.AddressZero)).to.revertedWith("zero token address")
            })
            it("Should convert string currency coode to bytes32 key and set key and crypto as supported", async function ()
            {
                var tx = await contractRideCurrencyRegistry.registerCrypto("0xc778417e063141139fce010982780140aa0cd5ab")
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)
                expect(await contractRideCurrencyRegistry.sCurrencyKeyToCrypto_(key)).to.equal(true)
            })
        })

        describe("getKeyFiat", function ()
        {
            it("Should get the corresponding bytes32 key for given string currency code", async function ()
            {
                var tx = await contractRideCurrencyRegistry.registerFiat("USD")
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.getKeyFiat("USD")).to.equal(key)
            })
        })

        describe("getKeyCrypto", function ()
        {
            it("Should get the corresponding bytes32 key for given string currency code", async function ()
            {
                var tx = await contractRideCurrencyRegistry.registerCrypto("0xc778417e063141139fce010982780140aa0cd5ab")
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.getKeyCrypto("0xc778417e063141139fce010982780140aa0cd5ab")).to.equal(key)
            })
        })

        describe("removeCurrency", function ()
        {
            it("Should delete supported key", async function ()
            {
                key = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("tester"))

                var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(key, true)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)

                var tx = await contractRideCurrencyRegistry.removeCurrency(key)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(false)
            })
            it("Should delete supported crypto key", async function ()
            {
                var tx = await contractRideCurrencyRegistry.registerCrypto_("0xc778417e063141139fce010982780140aa0cd5ab")
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)
                expect(await contractRideCurrencyRegistry.sCurrencyKeyToCrypto_(key)).to.equal(true)

                var tx = await contractRideCurrencyRegistry.removeCurrency(key)
                var rcpt = await tx.wait()

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(false)
                expect(await contractRideCurrencyRegistry.sCurrencyKeyToCrypto_(key)).to.equal(false)
            })
        })

        describe("setupFiatWithFee", function ()
        {
            it("Should register fiat currency along with setting its fees", async function ()
            {
                var tx = await contractRideCurrencyRegistry.setupFiatWithFee("USA", 2, 3, 4, [1, 2, 3, 4, 5, 6])
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)

                expect(await contractRideFee.getRequestFee(key)).to.equal(2)
                expect(await contractRideFee.getBaseFee(key)).to.equal(3)
                expect(await contractRideFee.getCostPerMinute(key)).to.equal(4)
                expect(await contractRideFee.getCostPerMetre(key, 0)).to.equal(1)
                expect(await contractRideFee.getCostPerMetre(key, 1)).to.equal(2)
                expect(await contractRideFee.getCostPerMetre(key, 2)).to.equal(3)
                expect(await contractRideFee.getCostPerMetre(key, 3)).to.equal(4)
                expect(await contractRideFee.getCostPerMetre(key, 4)).to.equal(5)
                expect(await contractRideFee.getCostPerMetre(key, 5)).to.equal(6)
            })
        })

        describe("setupCryptoWithFee", function ()
        {
            it("Should register crypto currency along with setting its fees", async function ()
            {
                var tx = await contractRideCurrencyRegistry.setupCryptoWithFee("0xc778417e063141139fce010982780140aa0cd5ab", 2, 3, 4, [1, 2, 3, 4, 5, 6])
                var rcpt = await tx.wait()

                key = rcpt.logs[0].data

                expect(await contractRideCurrencyRegistry.sCurrencyKeyToSupported_(key)).to.equal(true)
                expect(await contractRideCurrencyRegistry.sCurrencyKeyToCrypto_(key)).to.equal(true)

                expect(await contractRideFee.getRequestFee(key)).to.equal(2)
                expect(await contractRideFee.getBaseFee(key)).to.equal(3)
                expect(await contractRideFee.getCostPerMinute(key)).to.equal(4)
                expect(await contractRideFee.getCostPerMetre(key, 0)).to.equal(1)
                expect(await contractRideFee.getCostPerMetre(key, 1)).to.equal(2)
                expect(await contractRideFee.getCostPerMetre(key, 2)).to.equal(3)
                expect(await contractRideFee.getCostPerMetre(key, 3)).to.equal(4)
                expect(await contractRideFee.getCostPerMetre(key, 4)).to.equal(5)
                expect(await contractRideFee.getCostPerMetre(key, 5)).to.equal(6)
            })
        })
    })
}