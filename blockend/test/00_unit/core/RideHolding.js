// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibHolding", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideHolding = await ethers.getContractAt('RideTestHolding', rideHubAddress)
            contractRideCurrencyRegistry = await ethers.getContractAt('RideTestCurrencyRegistry', rideHubAddress)

            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("tixId"))

            var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyLocal, true)
            var rcpt = await tx.wait()
        })

        describe("_transferCurrency", function ()
        {
            it("Should transfer amount", async function ()
            {
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyLocal, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[1].address, keyLocal, 5)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await contractRideHolding.transferCurrency_(tixId, keyLocal, 2, accounts[0].address, accounts[1].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideHolding.sUserToCurrencyKeyToHolding_(accounts[0].address, keyLocal)).to.equal(3)
                expect(await contractRideHolding.sUserToCurrencyKeyToHolding_(accounts[1].address, keyLocal)).to.equal(7)
            })
        })
    })

    describe("RideHolding", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideHolding = await ethers.getContractAt('RideTestHolding', rideHubAddress)
            contractRideCurrencyRegistry = await ethers.getContractAt('RideTestCurrencyRegistry', rideHubAddress)

            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))
            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("tixId"))

            var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(keyLocal, true)
            var rcpt = await tx.wait()
            var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToCrypto_(keyLocal, true)
            var rcpt = await tx.wait()
        })

        describe("depositTokens", function ()
        {
            it("Should revert if input amount is zero", async function ()
            {
                await expect(contractRideHolding.depositTokens(keyLocal, 0)).to.revertedWith("zero amount")
            })
            // it("Should revert if decoded address is zero address", async function ()
            // {
            //     zeroBytes32Key = "0x0000000000000000000000000000000000000000000000000000000000000000"
            //     var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(zeroBytes32Key, true)
            //     var rcpt = await tx.wait()
            //     var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToCrypto_(zeroBytes32Key, true)
            //     var rcpt = await tx.wait()

            //     await expect(contractRideHolding.depositTokens(zeroBytes32Key, 5)).to.revertedWith("zero token address")
            // })
            it("Should revert if allowance not approved")
            it("Should set amount of holding for currency to user")
        })

        describe("withdrawTokens", function ()
        {
            it("Should revert if input amount is zero", async function ()
            {
                await expect(contractRideHolding.withdrawTokens(keyLocal, 0)).to.revertedWith("zero amount")
            })
            // it("Should revert if decoded address is zero address", async function ()
            // {
            //     zeroBytes32Key = "0x0000000000000000000000000000000000000000000000000000000000000000"
            //     var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(zeroBytes32Key, true)
            //     var rcpt = await tx.wait()
            //     var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToCrypto_(zeroBytes32Key, true)
            //     var rcpt = await tx.wait()

            //     await expect(contractRideHolding.withdrawTokens(zeroBytes32Key, 5)).to.revertedWith("zero token address")
            // })
            it("Should revert if user has insufficient deposits for currency", async function ()
            {
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyLocal, 3)
                var rcpt = await tx.wait()

                await expect(contractRideHolding.withdrawTokens(keyLocal, 5)).to.revertedWith("insufficient holdings")
            })
            it("Should revert if amount to withdraw is larger than amount in currency contract")
            it("Should reduce amount in holdings")
            it("Should transfer the token out of RideHub contract into caller's wallet")
        })

        describe("getHolding", function ()
        {
            it("Should get holding of currency requested of user", async function ()
            {
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[2].address, keyLocal, 22)
                var rcpt = await tx.wait()

                expect(await contractRideHolding.getHolding(accounts[2].address, keyLocal)).to.equal(22)
            })
        })
    })
}
