let { networkConfig } = require('../scripts/utils')
const fs = require('fs')
const { expect } = require("chai");

const contractName = "RideHub" // SET contract to deploy

module.exports = async ({
    deployments,
    getNamedAccounts,
    getChainId,

}) => {
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = await getChainId()

    log("////////////////////////////////////////////")
    log("///// -------------------------------- /////")
    log("///// ---------- Deployment ---------- /////")
    log("///// -------------------------------- /////")
    log("////////////////////////////////////////////")

    const keyHash = networkConfig[chainId]["keyHash"]
    const feeLink = networkConfig[chainId]["feeLink"]

    let vrfCoordinator
    let linkToken
    if (parseInt(chainId) === 31337) {
        const VRFCoordinatorMock_ = await get('VRFCoordinatorMock')
        const linkToken_ = await get('LinkToken')
        vrfCoordinator = VRFCoordinatorMock_.address
        linkToken = linkToken_.address
    } else {
        vrfCoordinator = networkConfig[chainId]["VRFCoordinator"]
        linkToken = networkConfig[chainId]["linkToken"]
    }

    const args = [vrfCoordinator, linkToken, keyHash, feeLink]

    const contract = await deploy(contractName, {
        from: deployer,
        args: args,
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

    try {
        if (parseInt(chainId) !== 31337) {
            await sleep(100000) // 1 min zZZ
            // WARNING: might need wait awahile for block confirmations !!!
            await hre.run("verify:verify", { // https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#using-programmatically
                address: contract.address,
                constructorArguments: args,
                // contract: `contracts/${contractName}.sol:${contractName}`
            })
            log("#####")
            log(`##### Verified ${contract.address}`)
            log("#####")
        } else {
            log("#####")
            log("##### No verification needed for local deployment")
            log("#####")
        }
    } catch (error) {
        console.log(error)
    }

    log("////////////////////////////////////////////")
    log("///// -------------------------------- /////")
    log("///// --------- Custom Saving -------- /////")
    log("///// -------------------------------- /////")
    log("////////////////////////////////////////////")

    const dir = `./deployed_contract_details/${contractName}/`

    try {
        if (parseInt(chainId) !== 31337) {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }

            const abi = JSON.stringify({ abi: contract.abi })
            const address = JSON.stringify({ address: contract.address })

            fs.writeFileSync(`${dir}abi.json`, abi, function (err) {
                if (err) {
                    console.log(err)
                }
            })
            fs.writeFileSync(`${dir}address.json`, address, function (err) {
                if (err) {
                    console.log(err)
                }
            })
            log("#####")
            log(`##### Saved to ${dir}`)
            log("#####")
        } else {
            log("#####")
            log("##### No saving needed for local deployment")
            log("#####")
        }
    } catch (error) {
        console.log(error)
    }

    log("////////////////////////////////////////////")
    log("///// -------------------------------- /////")
    log("///// ------ Important Tasks TODO ---- /////")
    log("///// ----  right after deployment --- /////")
    log("///// -------------------------------- /////")
    log("////////////////////////////////////////////")

    const contractRideToken = await hre.ethers.getContract("Ride");

    const tokenAddress = contractRideToken.address
    const badgesMaxScore = ["10000", "100000", "500000", "1000000", "2000000"]
    const collateralMultiplier = 2 // input format: integer only, currently eg 2
    const requestFee = "5000000000000000000" // input format: token in Wei
    const baseFare = "2000000000000000000" // input format: token in Wei
    // const costPerMetre = "200000000000000000" // input format: token in Wei // rounded down
    const badgesCostPerMetre = ["100000000000000000", "200000000000000000", "300000000000000000", "400000000000000000", "500000000000000000", "600000000000000000"]
    const costPerMinute = "150000000000000000" // input format: token in Wei // rounded down (5:59 == 5 minutes)

    const contractRideHub = await hre.ethers.getContract(contractName)

    expect(await contractRideHub.owner()).to.equal(deployer)
    expect(await contractRideHub.initialized()).to.equal(false)

    var tx = await contractRideHub.initializeRideBase(tokenAddress, badgesMaxScore, collateralMultiplier, requestFee, baseFare, badgesCostPerMetre, costPerMinute)
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

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms))
}