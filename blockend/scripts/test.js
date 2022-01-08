let { deploy } = require('./utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")
const { getSelectors, FacetCutAction } = require('./utilsDiamond.js')

async function tester()
{
    const chainId = hre.network.config.chainId // returns undefined if not local hh network
    const networkName = hre.network.name
    const accounts = await ethers.getSigners()
    const signer = accounts[1]
    console.log("SIGNER:", signer)

    const RideInit = await ethers.getContractAt('RideInitializer0', "0xAe5C7b9105b111a59940DfF8764A73B7ac1661d9")

    const tokenAddress = "0x9E8Af62d8CF28e395F2743f8d5c1bd844Df975E7"
    const badgesMaxScore = ["500000", "15000000", "90000000", "180000000", "540000000"]
    const requestFee = ethers.utils.parseEther("5")
    const baseFee = ethers.utils.parseEther("2")
    const costPerMinute = ethers.utils.parseEther("0.15")
    const badgesCostPerMetre =
        [
            ethers.utils.parseEther("0.10"),
            ethers.utils.parseEther("0.20"),
            ethers.utils.parseEther("0.30"),
            ethers.utils.parseEther("0.40"),
            ethers.utils.parseEther("0.50"),
            ethers.utils.parseEther("0.60")
        ]
    const banDuration = "604800" // 7 days // https://www.epochconverter.com/
    const ratingMin = "1"
    const ratingMax = "5"

    const initParams = [
        tokenAddress,
        badgesMaxScore,
        requestFee,
        baseFee,
        costPerMinute,
        badgesCostPerMetre,
        banDuration,
        ratingMin,
        ratingMax
    ]

    tx = await RideInit.init(...initParams)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    tester()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.tester = tester