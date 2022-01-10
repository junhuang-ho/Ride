// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat");
const chainId = hre.network.config.chainId

if (parseInt(chainId) === 31337)
{
    describe("RideUtils", function ()
    {
        beforeEach(async function ()
        {
            baseFare = 10
            metresTravelled = 200
            minutesTaken = 5
            costPerMetre = 123
            costPerMinute = 456
            countStart = 5
            countEnd = 4
            totalRating = 13
            countRating = countStart
            maxRating = 5

            fare = baseFare + (metresTravelled * costPerMetre) + (minutesTaken * costPerMinute)
            score = Math.floor((metresTravelled * countEnd * totalRating) / (countStart * countRating * maxRating))

            const RideUtils = await ethers.getContractFactory("TestRideUtils")
            const rideUtils = await RideUtils.deploy()
            rideUtilsContract = await rideUtils.deployed()
        })

        describe("getFare", function ()
        {
            it("Should return correct fare value", async function ()
            {
                expect(await rideUtilsContract._getFare_(baseFare, metresTravelled, minutesTaken, costPerMetre, costPerMinute)).to.equal(fare)
            })
        })

        describe("calculateScore", function ()
        {
            it("Should return correct score value", async function ()
            {
                expect(await rideUtilsContract._calculateScore_(metresTravelled, countStart, countEnd, totalRating, countRating, maxRating)).to.equal(score)
            })
            it("Should return 0 value", async function ()
            {
                expect(await rideUtilsContract._calculateScore_(metresTravelled, 0, countEnd, totalRating, countRating, maxRating)).to.equal(0)
            })
        })

        // describe("shuffle", function () {
        //     it("Should return different ordered array", async function () {
        //         const addresses = [
        //             "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        //             "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        //             "0x71bE63f3384f5fb98995898A86B02Fb2426c5788",
        //             "0xdD2FD4581271e230360230F9337D5c0430Bf44C0",
        //             "0xcd3B766CCDd6AE721141F452C550Ca635964ce71"
        //         ]
        //         expect(await rideUtilsContract.shuffleTestOnly(addresses, 12345)).to.not.equal(addresses)
        //         // var tx = await rideUtilsContract.shuffleTestOnly(addresses, 12345)
        //         // console.log(tx)
        //     })
        // })
    })
}

