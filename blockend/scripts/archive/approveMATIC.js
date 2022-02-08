let { deploy, networkConfig } = require('./utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

async function approveMATIC()
{
    if (parseInt(chainId) === 80001)
    {
        accounts = await ethers.getSigners()
        drv = accounts[0].address
        pax = accounts[1].address

        contractNameMATIC = "MRC20"
        tokenMATICAddress = "0x0000000000000000000000000000000000001010"
        rideHubAddress = "0x659b4bD5fe43bB90496635165eBDB535419960C9"
        approveAmount = "3000000000000000000"

        contractMATICDrv = await ethers.getContractAt(contractNameMATIC, tokenMATICAddress, drv)
        await contractMATICDrv.approve(rideHubAddress, approveAmount)

        contractMATICDrv = await ethers.getContractAt(contractNameMATIC, tokenMATICAddress, pax)
        await contractMATICDrv.approve(rideHubAddress, approveAmount)
    }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    approveMATIC()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.approveMATIC = approveMATIC