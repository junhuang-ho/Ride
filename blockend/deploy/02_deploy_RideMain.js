let { networkConfig } = require('../scripts/utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")

const contractName = "RideHub" // SET contract to deploy

module.exports = async ({
    deployments,
    getNamedAccounts,
    getChainId,

}) =>
{
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = await getChainId()

    log("////////////////////////////////////////////")
    log("///// -------------------------------- /////")
    log("///// ---------- Deployment ---------- /////")
    log("///// -------------------------------- /////")
    log("////////////////////////////////////////////")

    // const args = [vrfCoordinator, linkToken, keyHash, feeLink]

    const contract = await deploy(contractName, {
        from: deployer,
        // args: args,
        log: true,
        autoMine: true, // speed up deployment on local network (ganache, hardhat), no effect on live networks
    })

    log("#####")
    log(`##### Deployed ${contractName} with address: ${contract.address}`)
    log("#####")

    log("////////////////////////////////////////////")
    log("///// -------------------------------- /////")
    log("///// --------- Verification --------- /////")
    log("///// -------------------------------- /////")
    log("////////////////////////////////////////////")

    try
    {
        if (parseInt(chainId) !== 31337)
        {
            await sleep(100000) // 1 min zZZ
            // WARNING: might need wait awahile for block confirmations !!!
            await hre.run("verify:verify", { // https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#using-programmatically
                address: contract.address,
                // constructorArguments: args,
                // contract: `contracts/${contractName}.sol:${contractName}`
            })
            log("#####")
            log(`##### Verified ${contract.address}`)
            log("#####")
        } else
        {
            log("#####")
            log("##### No verification needed for local deployment")
            log("#####")
        }
    } catch (error)
    {
        console.log(error)
    }

    log("////////////////////////////////////////////")
    log("///// -------------------------------- /////")
    log("///// --------- Custom Saving -------- /////")
    log("///// -------------------------------- /////")
    log("////////////////////////////////////////////")

    const dir = `./deployed_contract_details/${contractName}/`

    try
    {
        if (parseInt(chainId) !== 31337)
        {
            if (!fs.existsSync(dir))
            {
                fs.mkdirSync(dir, { recursive: true });
            }

            const abi = JSON.stringify({ abi: contract.abi })
            const address = JSON.stringify({ address: contract.address })

            fs.writeFileSync(`${dir}abi.json`, abi, function (err)
            {
                if (err)
                {
                    console.log(err)
                }
            })
            fs.writeFileSync(`${dir}address.json`, address, function (err)
            {
                if (err)
                {
                    console.log(err)
                }
            })
            log("#####")
            log(`##### Saved to ${dir}`)
            log("#####")
        } else
        {
            log("#####")
            log("##### No saving needed for local deployment")
            log("#####")
        }
    } catch (error)
    {
        console.log(error)
    }

    log("////////////////////////////////////////////")
    log("///// -------------------------------- /////")
    log("///// ------ Important Tasks TODO ---- /////")
    log("///// ----  right after deployment --- /////")
    log("///// -------------------------------- /////")
    log("////////////////////////////////////////////")

    const contractRideToken = await hre.ethers.getContract("Ride")

    // note:
    // some perspective for badgesMaxScore
    // say 1 day work 10 hours and can travel 50_000 metres per hour (Subang to KL)
    // In 1 day, distance = 500_000 metres
    // In 1 year, distance = 180_000_000 metres
    // In 5 years, distance = 900_000_000 metres

    // Newbie   ~ up to 1 day's work, 10 * 50_000 * 1 = 500_000
    // Bronze   ~ up to 1 month's work, 10 * 50_000 * 30 = 15_000_000
    // Silver   ~ up to 6 month's work, 10 * 50_000 * 30 * 6 = 90_000_000
    // Gold     ~ up to 1 year's work, 10 * 50_000 * 30 * 12 = 180_000_000
    // Platinum ~ up to 3 year's work, 10 * 50_000 * 30 * 12 * 3 = 540_000_000
    // Veteran  ~ more than 3 year's work

    const tokenAddress = contractRideToken.address
    const badgesMaxScore = ["500000", "15000000", "90000000", "180000000", "540000000"]
    const requestFee = ethers.utils.parseEther("5")
    const baseFare = ethers.utils.parseEther("2")
    const badgesCostPerMetre =
        [
            ethers.utils.parseEther("0.10"),
            ethers.utils.parseEther("0.20"),
            ethers.utils.parseEther("0.30"),
            ethers.utils.parseEther("0.40"),
            ethers.utils.parseEther("0.50"),
            ethers.utils.parseEther("0.60")
        ]
    const costPerMinute = ethers.utils.parseEther("0.15")
    const banDuration = "604800" // 7 days // https://www.epochconverter.com/

    const contractRideHub = await hre.ethers.getContract(contractName)

    expect(await contractRideHub.owner()).to.equal(deployer)
    expect(await contractRideHub.initialized()).to.equal(false)

    var tx = await contractRideHub.initializeRideBase(tokenAddress, badgesMaxScore, requestFee, baseFare, badgesCostPerMetre, costPerMinute, banDuration)
    var receipt = await tx.wait()

    const tokenAddress_ = receipt.events[0].args.token
    const sender = receipt.events[0].args.deployer

    expect(sender).to.equal(deployer)
    expect(await contractRideHub.initialized()).to.equal(true)
    expect(tokenAddress).to.equal(tokenAddress_)
    expect(await contractRideHub.token()).to.equal(tokenAddress)

    log("#####")
    log(`##### ${contractName} initialized with token: ${tokenAddress}`)
    log("#####")
}

function sleep(ms)
{
    return new Promise(resolve => setTimeout(resolve, ms))
}