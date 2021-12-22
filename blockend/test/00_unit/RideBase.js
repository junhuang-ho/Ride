// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat");
const chainId = hre.network.config.chainId

if (parseInt(chainId) === 31337)
{
    describe("RideBase", function ()
    {
        before(async function ()
        {
            const maxSupply = ethers.utils.parseEther("100000000")
            const Ride = await ethers.getContractFactory("Ride")
            const ride = await Ride.deploy(maxSupply)
            rideContract = await ride.deployed()
        })

        beforeEach(async function ()
        {
            accounts = await ethers.getSigners()

            rideContract0 = new ethers.Contract(rideContract.address, rideContract.interface, accounts[0])
            rideContract1 = new ethers.Contract(rideContract.address, rideContract.interface, accounts[1])

            var tx = await rideContract0.transfer(accounts[1].address, ethers.utils.parseEther("10000"))
            await tx.wait()
            expect(tx.confirmations).to.equal(1)

            const RideBase = await ethers.getContractFactory("TestRideBase")
            const rideBase = await RideBase.deploy()
            rideBaseContract = await rideBase.deployed()

            rideBaseContract0 = new ethers.Contract(rideBaseContract.address, rideBaseContract.interface, accounts[0])
            rideBaseContract1 = new ethers.Contract(rideBaseContract.address, rideBaseContract.interface, accounts[1])

            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("TIX_ID"))
        })

        describe("notDriver", function ()
        {
            it("Should revert if is driver", async function ()
            {
                var tx = await rideBaseContract0.setter_addressToDriverReputation(accounts[0].address, 1, "uri", 0, 0, 0, 0, 0, 0)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(rideBaseContract0.notDriver_()).to.revertedWith("caller is driver")
            })

            it("Should pass if not driver", async function ()
            {
                expect(await rideBaseContract1.notDriver_()).to.equal(true)
            })
        })

        describe("notActive", function ()
        {
            it("Should revert if is active", async function ()
            {
                var tx = await rideBaseContract0.setter_addressToActive(accounts[0].address, true)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(rideBaseContract0.notActive_()).to.revertedWith("caller is active")
            })

            it("Should pass if not active", async function ()
            {
                expect(await rideBaseContract1.notActive_()).to.equal(true)
            })
        })

        describe("driverMatchTixDriver", function ()
        {
            beforeEach(async function ()
            {
                var tx = await rideBaseContract0.setter_tixIdToTicket(tixId, accounts[0].address, accounts[1].address, 0, false, 0, 0, false, 1639644243)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
            })
            it("Should revert if not proper driver", async function ()
            {
                await expect(rideBaseContract0.driverMatchTixDriver_(tixId, accounts[2].address)).to.revertedWith("driver not match tix driver")
            })

            it("Should pass if proper driver", async function ()
            {
                expect(await rideBaseContract1.driverMatchTixDriver_(tixId, accounts[1].address)).to.equal(true)
            })
        })

        describe("tripNotStart", function ()
        {
            it("Should revert if trip started", async function ()
            {
                var tx = await rideBaseContract0.setter_tixIdToTicket(tixId, accounts[0].address, accounts[1].address, 0, false, 0, 0, true, 1639644243)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(rideBaseContract0.tripNotStart_(tixId)).to.revertedWith("trip already started")
            })

            it("Should pass if trip not start", async function ()
            {
                var tx = await rideBaseContract0.setter_tixIdToTicket(tixId, accounts[0].address, accounts[1].address, 0, false, 0, 0, false, 1639644243)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBaseContract1.tripNotStart_(tixId)).to.equal(true)
            })
        })

        describe("tripInProgress", function ()
        {
            it("Should revert if trip started", async function ()
            {
                var tx = await rideBaseContract0.setter_tixIdToTicket(tixId, accounts[0].address, accounts[1].address, 0, false, 0, 0, false, 1639644243)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(rideBaseContract0.tripInProgress_(tixId)).to.revertedWith("trip not started")
            })

            it("Should pass if trip not start", async function ()
            {
                var tx = await rideBaseContract0.setter_tixIdToTicket(tixId, accounts[0].address, accounts[1].address, 0, false, 0, 0, true, 1639644243)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBaseContract1.tripInProgress_(tixId)).to.equal(true)
            })
        })

        describe("forceEndAllowed", function ()
        {
            it("Should revert if force end timestamp not reached", async function ()
            {
                var tx = await rideBaseContract0.setter_tixIdToTicket(tixId, accounts[0].address, accounts[1].address, 0, false, 0, 0, true, 4132630783)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(rideBaseContract0.forceEndAllowed_(tixId)).to.revertedWith("too early")
            })

            it("Should pass if force end timestamp reached", async function ()
            {
                var tx = await rideBaseContract0.setter_tixIdToTicket(tixId, accounts[0].address, accounts[1].address, 0, false, 0, 0, true, 1639644243)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBaseContract1.forceEndAllowed_(tixId)).to.equal(true)
            })
        })

        describe("notBan", function ()
        {
            it("Should revert if address's banned duration not passed", async function ()
            {
                var tx = await rideBaseContract0.setter_addressToBanEndTimestamp(accounts[0].address, 4132630783)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(rideBaseContract0.notBan_()).to.revertedWith("still banned")
            })

            it("Should pass if address's banned duration expired", async function ()
            {
                var tx = await rideBaseContract0.setter_addressToBanEndTimestamp(accounts[0].address, 1639644243)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBaseContract1.notBan_()).to.equal(true)
            })
        })

        describe("initializedRideBase", function ()
        {
            it("Should revert if not initialized", async function ()
            {
                await expect(rideBaseContract0.initializedRideBase_()).to.revertedWith("not init RideBase")
            })

            it("Should pass if initialized", async function ()
            {
                var tx = await rideBaseContract0.setter_initialized(true)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBaseContract1.initializedRideBase_()).to.equal(true)
            })
        })

        describe("initializeRideBase", function ()
        {
            beforeEach(async function ()
            {
                const badges = [10000, 100000, 500000, 1000000, 2000000]
                const costPerMetre = [1, 2, 3, 4, 5, 6]
                var tx = await rideBaseContract0.initializeRideBase(rideContract.address, badges, 0, 0, costPerMetre, 0, 604800)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
            })
            it("Should set initialized = true", async function ()
            {
                expect(await rideBaseContract0.initialized()).to.equal(true)
            })
            it("Should have proper ERC20 address", async function ()
            {
                expect(await rideBaseContract0.token()).to.equal(rideContract.address)
            })
        })

        describe("placeDeposit", function ()
        {
            beforeEach(async function ()
            {
                const badges = [10000, 100000, 500000, 1000000, 2000000]
                const costPerMetre = [1, 2, 3, 4, 5, 6]
                var tx = await rideBaseContract0.initializeRideBase(rideContract.address, badges, 0, 0, costPerMetre, 0, 604800)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideContract0.approve(rideBaseContract0.address, ethers.utils.parseEther("10"))
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
            })
            it("Should revert if 0 amount", async function ()
            {
                await expect(rideBaseContract0.placeDeposit(0)).to.revertedWith("0 amount")
            })
            it("Should revert if insufficient allowance", async function ()
            {
                await expect(rideBaseContract0.placeDeposit(ethers.utils.parseEther("11"))).to.revertedWith("check token allowance")
            })
            it("Should have set amount tokens in Ride contract", async function ()
            {
                var tx = await rideBaseContract0.placeDeposit(1000)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
                expect(await rideContract.balanceOf(rideBaseContract0.address)).to.equal(1000)
            })
            it("Should have set amount to caller for addressToDeposit", async function ()
            {
                var tx = await rideBaseContract0.placeDeposit(1000)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
                expect(await rideBaseContract0.addressToDeposit(accounts[0].address)).to.equal(1000)
            })
        })

        describe("removeDeposit", function ()
        {
            beforeEach(async function ()
            {
                const badges = [10000, 100000, 500000, 1000000, 2000000]
                const costPerMetre = [1, 2, 3, 4, 5, 6]
                var tx = await rideBaseContract0.initializeRideBase(rideContract.address, badges, 0, 0, costPerMetre, 0, 604800)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideContract0.approve(rideBaseContract0.address, ethers.utils.parseEther("10"))
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideBaseContract0.placeDeposit(1000)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
            })

            it("Should revert if 0 deposit", async function ()
            {
                var tx = await rideContract1.approve(rideBaseContract1.address, ethers.utils.parseEther("10"))
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                await expect(rideBaseContract1.removeDeposit()).to.revertedWith("deposit empty")
            })
            // it("Should revert if contract insufficient tokens") // TODO
            it("Should zero out addressToDeposit of caller", async function ()
            {
                expect(await rideBaseContract0.addressToDeposit(accounts[0].address)).to.not.equal(0)

                var tx = await rideBaseContract0.removeDeposit()
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
                expect(await rideBaseContract0.addressToDeposit(accounts[0].address)).to.equal(0)
            })

            it("Should restore user's Ride token balance", async function ()
            {
                var balance1 = await rideContract.balanceOf(accounts[1].address)

                var tx = await rideContract1.approve(rideBaseContract1.address, ethers.utils.parseEther("10"))
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideBaseContract1.placeDeposit(1000)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideBaseContract1.removeDeposit()
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var balance2 = await rideContract.balanceOf(accounts[1].address)
                expect((balance1).toString()).to.equal(balance2.toString())
            })
        })

        describe("_transfer", function ()
        {
            it("Should addressToDeposit should reflect token transferred", async function ()
            {
                var tx = await rideBaseContract0.setter_addressToDeposit(accounts[0].address, 10)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBaseContract0.addressToDeposit(accounts[0].address)).to.equal(10)
                expect(await rideBaseContract0.addressToDeposit(accounts[1].address)).to.equal(0)

                var tx = await rideBaseContract0._transfer_(tixId, 10, accounts[0].address, accounts[1].address)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBaseContract0.addressToDeposit(accounts[0].address)).to.equal(0)
                expect(await rideBaseContract0.addressToDeposit(accounts[1].address)).to.equal(10)
            })
        })

        describe("_cleanUp", function ()
        {
            beforeEach(async function ()
            {
                const badges = [10000, 100000, 500000, 1000000, 2000000]
                const costPerMetre = [1, 2, 3, 4, 5, 6]
                var tx = await rideBaseContract0.initializeRideBase(rideContract.address, badges, 0, 0, costPerMetre, 0, 604800)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideBaseContract0.setter_tixIdToTicket(tixId, accounts[0].address, accounts[1].address, 5, true, 6, 7, true, 1639644243)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideBaseContract0.setter_tixToEndDetails(tixId, accounts[1].address, true)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideBaseContract0.setter_addressToActive(accounts[0].address, true)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await rideBaseContract0.setter_addressToActive(accounts[1].address, true)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
            })

            it("Should clear variables", async function ()
            {
                var ticket = await rideBaseContract0.tixIdToTicket_(tixId)
                expect(ticket.passenger).to.equal(accounts[0].address)
                expect(ticket.driver).to.equal(accounts[1].address)
                expect(ticket.badge.toString()).to.equal("5")
                expect(ticket.strict).to.equal(true)
                expect(ticket.metres.toString()).to.equal("6")
                expect(ticket.fare.toString()).to.equal("7")
                expect(ticket.tripStart).to.equal(true)
                expect(ticket.forceEndTimestamp.toString()).to.equal("1639644243")

                var endDetails = await rideBaseContract0.tixToEndDetails_(tixId)
                expect(endDetails.driver).to.equal(accounts[1].address)
                expect(endDetails.reached).to.equal(true)

                expect(await rideBaseContract0.addressToActive(accounts[0].address)).to.equal(true)
                expect(await rideBaseContract0.addressToActive(accounts[1].address)).to.equal(true)

                var tx = await rideBaseContract0._cleanUp_(tixId, accounts[0].address, accounts[1].address)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var ticket = await rideBaseContract0.tixIdToTicket_(tixId)
                expect(ticket.passenger).to.equal(ethers.constants.AddressZero)
                expect(ticket.driver).to.equal(ethers.constants.AddressZero)
                expect(ticket.badge.toString()).to.equal("0")
                expect(ticket.strict).to.equal(false)
                expect(ticket.metres.toString()).to.equal("0")
                expect(ticket.fare.toString()).to.equal("0")
                expect(ticket.tripStart).to.equal(false)
                expect(ticket.forceEndTimestamp.toString()).to.equal("0")

                var endDetails = await rideBaseContract0.tixToEndDetails_(tixId)
                expect(endDetails.driver).to.equal(ethers.constants.AddressZero)
                expect(endDetails.reached).to.equal(false)

                expect(await rideBaseContract0.addressToActive(accounts[0].address)).to.equal(false)
                expect(await rideBaseContract0.addressToActive(accounts[1].address)).to.equal(false)
            })
        })

        describe("_temporaryBan", function ()
        {
            it("Should set ban duration", async function ()
            {
                expect(await rideBaseContract0.addressToBanEndTimestamp(accounts[0].address)).to.equal("0")

                var tx = await rideBaseContract0.setBanDuration(604800)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                // const banDuration = await rideBaseContract0.banDuration()

                var tx = await rideBaseContract0._temporaryBan_(accounts[0].address)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await rideBaseContract0.addressToBanEndTimestamp(accounts[0].address)).to.not.equal("0")
                // console.log((await rideBaseContract0.addressToBanEndTimestamp(accounts[0].address)).toString())
            })
        })

        describe("backgroundCheck", function ()
        {
            beforeEach(async function ()
            {
                const badges = [10000, 100000, 500000, 1000000, 2000000]
                const costPerMetre = [1, 2, 3, 4, 5, 6]
                var tx = await rideBaseContract0.initializeRideBase(rideContract.address, badges, 0, 0, costPerMetre, 0, 604800)
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
            })
            it("Should set uri of driver in addressToDriverReputation", async function ()
            {
                expect((await rideBaseContract0.addressToDriverReputation(accounts[1].address)).uri.length).to.equal(0)

                var tx = await rideBaseContract0.passBackgroundCheck(accounts[1].address, "123")
                await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await rideBaseContract0.addressToDriverReputation(accounts[1].address)).uri).to.equal("123")
            })
            it("Should revert if uri already set", async function ()
            {
                var tx = await rideBaseContract0.passBackgroundCheck(accounts[1].address, "123")
                await tx.wait()
                expect(tx.confirmations).to.equal(1)
                expect((await rideBaseContract0.addressToDriverReputation(accounts[1].address)).uri).to.equal("123")

                await expect(rideBaseContract0.passBackgroundCheck(accounts[1].address, "222")).to.revertedWith("uri already set")
            })
        })
    })
}