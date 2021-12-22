let { networkConfig } = require('../scripts/utils')
const fs = require('fs')
const { expect } = require("chai");

const contractName = "Ride" // SET contract to deploy

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

    const maxSupply = 100000000 * (10 ** 18) // 100 mil - demo purposes

    const args = [maxSupply]

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

    const contractRideToken = await hre.ethers.getContract(contractName)

    expect((await contractRideToken.balanceOf(deployer)).toString()).to.equal((maxSupply * (10 ** 18)).toLocaleString('fullwide', { useGrouping: false }))

    log("#####")
    log(`##### Max supply matches deployer`)
    log("#####")

}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms))
}