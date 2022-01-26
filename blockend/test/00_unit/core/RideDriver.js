// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibDriver", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideDriver = await ethers.getContractAt('RideTestDriver', rideHubAddress)
            contractRideTestTicket = await ethers.getContractAt('RideTestTicket', rideHubAddress)
            contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress)

            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test123"))
            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))

            var tx = await contractRideTestTicket.ssTixIdToTicket_(
                tixId, accounts[1].address, accounts[0].address, 0, false, 3,
                keyLocal, keyPay, 4, 2, false
            )
            var rcpt = await tx.wait()

            var tx = await contractRideTestTicket.ssTixIdToTicket_2(
                tixId, 1234
            )
            var rcpt = await tx.wait()

            var tx = await contractRideTestTicket.ssUserToTixId_(
                accounts[0].address, tixId
            )
            var rcpt = await tx.wait()
        })

        describe("_requireDrvMatchTixDrv", function ()
        {
            it("Should allow pass if driver match driver ticket", async function ()
            {
                expect(await contractRideDriver.requireDrvMatchTixDrv_(accounts[0].address)).to.equal(true)
            })
            it("Should revert if driver not match driver ticket", async function ()
            {
                await expect(contractRideDriver.requireDrvMatchTixDrv_(accounts[2].address)).to.revertedWith("drv not match tix drv")
            })
        })

        describe("_requireIsDriver", function ()
        {
            it("Should allow pass if caller is driver", async function ()
            {
                var tx = await contractRideBadge.ssDriverToDriverReputation_(accounts[0].address, 1, "test123", 500, 50, 2, 2, 10, 2)
                var rcpt = await tx.wait()

                expect(await contractRideDriver.requireIsDriver_()).to.equal(true)
            })
            it("Should revert if caller not driver", async function ()
            {
                contractRideDriver2 = await ethers.getContractAt('RideTestDriver', rideHubAddress, accounts[2].address)
                await expect(contractRideDriver2.requireIsDriver_()).to.revertedWith("caller not driver")
            })
        })

        describe("_requireNotDriver", function ()
        {
            it("Should allow pass if caller not driver", async function ()
            {
                expect(await contractRideDriver2.requireNotDriver_()).to.equal(true)
            })
            it("Should revert if caller is driver", async function ()
            {
                await expect(contractRideDriver.requireNotDriver_()).to.revertedWith("caller is driver")
            })
        })
    })

    describe("RideDriver", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideDriver = await ethers.getContractAt('RideTestDriver', rideHubAddress)
            contractRideTestTicket = await ethers.getContractAt('RideTestTicket', rideHubAddress)
            contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress)
            contractRideExchange = await ethers.getContractAt('RideTestExchange', rideHubAddress)
            contractRideRater = await ethers.getContractAt('RideTestRater', rideHubAddress)
            contractRideHolding = await ethers.getContractAt('RideTestHolding', rideHubAddress)
            contractRideFee = await ethers.getContractAt('RideTestFee', rideHubAddress)

            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test123"))
            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))

            badges = [10000, 100000, 500000, 1000000, 2000000]

            var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyLocal, keyPay, "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e")
            var rcpt = await tx.wait()
            var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyPay, keyLocal, "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e")
            var rcpt = await tx.wait()
            var tx = await contractRideExchange.ssXToYToXPerYInverse_(keyLocal, keyPay, true)
            var rcpt = await tx.wait()

            var tx = await contractRideTestTicket.ssTixIdToTicket_(
                tixId, accounts[1].address, accounts[0].address, 0, false, 3,
                keyLocal, keyPay, 4, 2, false
            )
            var rcpt = await tx.wait()

            var tx = await contractRideTestTicket.ssTixIdToTicket_2(
                tixId, 1234
            )
            var rcpt = await tx.wait()

            var tx = await contractRideRater.setRatingBounds_(1, 5)
            var rcpt = await tx.wait()

            var tx = await contractRideBadge.setBadgesMaxScores_(badges)
            var rcpt = await tx.wait()
            var tx = await contractRideBadge.ssDriverToDriverReputation_(accounts[0].address, 1, "test123", 500, 50, 2, 2, 10, 2)
            var rcpt = await tx.wait()

            var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyPay, "5")
            var rcpt = await tx.wait()
        })

        describe("acceptTicket", function ()
        {
            it("Should revert if pax address is zero", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, ethers.constants.AddressZero, accounts[0].address, 0, false, 3,
                    keyLocal, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, 0)).to.revertedWith("ticket not exists")
            })
            it("Should revert if local key not match", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, accounts[0].address, 0, false, 3,
                    keyPay, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, 0)).to.revertedWith("local currency key not match")
            })
            it("Should revert if payment key not match", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, accounts[0].address, 0, false, 3,
                    keyLocal, keyLocal, 4, 2, false
                )
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, 0)).to.revertedWith("payment currency key not match")
            })
            it("Should revert if driver not using suitable badge rank", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, accounts[0].address, 0, false, 3,
                    keyLocal, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, 2)).to.revertedWith("badge rank not achieved")
            })
            it("Should revert if holding not more than cancellation fee or fare", async function ()
            {
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyPay, "4")
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, 0)).to.revertedWith("driver's holding < cancellationFee or fare")
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyPay, "1")
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, 0)).to.revertedWith("driver's holding < cancellationFee or fare")
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyPay, "5")
                var rcpt = await tx.wait()
            })
            it("Should revert if metres more than driver's max distance preference", async function ()
            {
                var tx = await contractRideBadge.ssDriverToDriverReputation_(accounts[0].address, 1, "test123", 1, 50, 2, 2, 10, 2)
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, 0)).to.revertedWith("trip too long")
            })
            it("Should revert if requested badge not meet driver's badge - strict", async function ()
            { // TODO: case where acceptable - matching badge
                var tx = await contractRideBadge.ssDriverToDriverReputation_(accounts[0].address, 1, "test123", 500, 500001, 2, 2, 10, 2)
                var rcpt = await tx.wait()
                var score = await contractRideBadge.calculateScore_()
                var badge = await contractRideBadge.getBadge_(score.toString())
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, accounts[0].address, parseInt(badge.toString()) - 1, true, 3,
                    keyLocal, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, badge.toString())).to.revertedWith("driver not meet badge - strict")

                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, accounts[0].address, parseInt(badge.toString()) + 1, true, 3,
                    keyLocal, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, badge.toString())).to.revertedWith("driver not meet badge - strict")
            })
            it("Should revert if requested badge not meet driver's badge", async function ()
            { // TODO: case where acceptable - matching badge OR pax request lower badge than driver's badge
                var tx = await contractRideBadge.ssDriverToDriverReputation_(accounts[0].address, 1, "test123", 500, 500001, 2, 2, 10, 2)
                var rcpt = await tx.wait()
                var score = await contractRideBadge.calculateScore_()
                var badge = await contractRideBadge.getBadge_(score.toString())
                // var tx = await contractRideTestTicket.ssTixIdToTicket_(
                //     tixId, accounts[1].address, accounts[0].address, parseInt(badge.toString()) - 1, false, 3,
                //     keyLocal, keyPay, 4, 2, false
                // )
                // var rcpt = await tx.wait()
                // await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, badge.toString())).to.revertedWith("driver not meet badge")

                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, accounts[0].address, parseInt(badge.toString()) + 1, false, 3,
                    keyLocal, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()
                await expect(contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, badge.toString())).to.revertedWith("driver not meet badge")
            })
            it("Should set driver's address in ticket", async function ()
            {
                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyLocal, keyPay, "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e")
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(keyPay, keyLocal, "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e")
                var rcpt = await tx.wait()
                var tx = await contractRideExchange.ssXToYToXPerYInverse_(keyLocal, keyPay, true)
                var rcpt = await tx.wait()

                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, ethers.constants.AddressZero, 0, false, 3,
                    keyLocal, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()

                var tx = await contractRideTestTicket.ssTixIdToTicket_2(
                    tixId, 1234
                )
                var rcpt = await tx.wait()

                var tx = await contractRideRater.setRatingBounds_(1, 5)
                var rcpt = await tx.wait()

                var tx = await contractRideBadge.ssDriverToDriverReputation_(accounts[0].address, 1, "test123", 500, 50, 2, 2, 10, 2)
                var rcpt = await tx.wait()

                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyPay, "5")
                var rcpt = await tx.wait()

                var tx = await contractRideDriver.acceptTicket(keyLocal, keyPay, tixId, 0)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideTestTicket.sTixIdToTicket_(tixId)).driver).to.equal(accounts[0].address)
                expect(await contractRideTestTicket.sUserToTixId_(accounts[0].address)).to.equal(tixId)
            })
        })

        describe("cancelPickUp", function ()
        {
            // uses helper functions only
        })

        describe("endTripDrv", function ()
        {
            it("Should set driver end details", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, accounts[0].address, 0, false, 3,
                    keyLocal, keyPay, 4, 2, true
                )
                var rcpt = await tx.wait()

                expect((await contractRideTestTicket.sTixToDriverEnd_(tixId)).driver).to.equal(ethers.constants.AddressZero)
                expect((await contractRideTestTicket.sTixToDriverEnd_(tixId)).reached).to.equal(false)

                var tx = await contractRideDriver.endTripDrv(true)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideTestTicket.sTixToDriverEnd_(tixId)).driver).to.equal(accounts[0].address)
                expect((await contractRideTestTicket.sTixToDriverEnd_(tixId)).reached).to.equal(true)
            })
        })

        describe("forceEndDrv", function ()
        {
            it("Should revert if driver has not end trip", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[1].address, accounts[0].address, 0, false, 3,
                    keyLocal, keyPay, 4, 2, true
                )
                var rcpt = await tx.wait()

                var tx = await contractRideTestTicket.ssTixToDriverEnd_(
                    tixId, ethers.constants.AddressZero, false
                )
                var rcpt = await tx.wait()

                await expect(contractRideDriver.forceEndDrv()).to.revertedWith("driver must end trip")
            })
        })
    })
}