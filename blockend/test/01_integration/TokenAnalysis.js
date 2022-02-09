// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers, waffle } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const ethSigUtil = require('eth-sig-util')
const { fromRpcSig } = require('ethereumjs-util')

// const Web3 = require('web3');
// const localWeb3 = new Web3();
// const BN = localWeb3.utils.BN;

const { deployTestToken } = require("../../scripts/experimental/deployTestToken.js")

if (parseInt(chainId) === 31337)
{
    describe("ERC20 Modules", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            admin = accounts[0].address
            person1 = accounts[1].address // pre-registration is considered an applicant
            person2 = accounts[2].address
            other = accounts[9].address
            someone = accounts[8].address
            person3 = accounts[7].address

            pkAdmin0x = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
            pkPerson10x = "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
            pkPerson20x = "0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a"
            pkOther0x = "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6"

            pkAdmin = "ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
            pkPerson1 = "59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
            pkPerson2 = "5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a"
            pkOther = "2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6"

            addresses = await deployTestToken(admin, true, true)
            addressRide = addresses[0]
            addressUsingERC20s = addresses[1]

            contractRideA = await ethers.getContractAt("Ride", addressRide, admin)
            contractUsingERC20sA = await ethers.getContractAt("UsingERC20s", addressUsingERC20s, admin)

            maxSupply = ethers.utils.parseEther("100")
            var tx = await contractRideA.mint(admin, maxSupply)
            var rcpt = tx.wait()
            var tx = await contractRideA.mint(person1, 100)
            var rcpt = tx.wait()
        })

        describe("ERC20 - approve", function ()
        {
            it("Should approve for deposit", async function ()
            {
                expect(await contractRideA.balanceOf(contractUsingERC20sA.address)).to.equal(0)
                expect(await contractRideA.balanceOf(admin)).to.equal(maxSupply)
                expect(await contractRideA.allowance(admin, contractUsingERC20sA.address)).to.equal(0)
                expect(await contractRideA.allowance(admin, person1)).to.equal(0)
                expect(await contractRideA.allowance(admin, person2)).to.equal(0)

                allowAmount1 = ethers.utils.parseEther("5")

                // // Test ERC20

                // normal allowance
                var tx = await contractRideA.approve(contractUsingERC20sA.address, allowAmount1)
                var rcpt = tx.wait()

                // // same effect as normal allowance (above)
                // var tx = await contractRideA.increaseAllowance(contractUsingERC20sA.address, allowAmount1)
                // var rcpt = tx.wait()

                expect(await contractRideA.balanceOf(contractUsingERC20sA.address)).to.equal(0)
                expect(await contractRideA.balanceOf(admin)).to.equal(maxSupply)
                expect(await contractRideA.allowance(admin, contractUsingERC20sA.address)).to.equal(allowAmount1)

                var tx = await contractUsingERC20sA.deposit(allowAmount1)
                var rcpt = tx.wait()

                expect(await contractRideA.balanceOf(contractUsingERC20sA.address)).to.equal("5000000000000000000")
                expect(await contractRideA.balanceOf(admin)).to.equal("95000000000000000000")
                expect(await contractRideA.allowance(admin, contractUsingERC20sA.address)).to.equal(0)
                expect(await contractRideA.balanceOf(contractUsingERC20sA.address)).to.equal(allowAmount1)
                expect(await contractUsingERC20sA.userToBalance(admin)).to.equal(allowAmount1)

            })
        })

        describe("ERC20 - increaseAllowance", function ()
        {
            it("Should increaseAllowance for deposit - SAME as approve", async function ()
            {
                allowAmount1 = ethers.utils.parseEther("5")

                // // Test ERC20

                // // normal allowance
                // var tx = await contractRideA.approve(contractUsingERC20sA.address, allowAmount1)
                // var rcpt = tx.wait()

                // same effect as normal allowance (above)
                var tx = await contractRideA.increaseAllowance(contractUsingERC20sA.address, allowAmount1)
                var rcpt = tx.wait()

                expect(await contractRideA.allowance(admin, contractUsingERC20sA.address)).to.equal(allowAmount1)

                var tx = await contractUsingERC20sA.deposit(allowAmount1)
                var rcpt = tx.wait()

                expect(await contractRideA.balanceOf(contractUsingERC20sA.address)).to.equal("10000000000000000000")
                expect(await contractRideA.balanceOf(admin)).to.equal("90000000000000000000")
                expect(await contractRideA.allowance(admin, contractUsingERC20sA.address)).to.equal(0)

            })
        })

        describe("ERC20Permit - permit", function ()
        {
            it("Should all deposit in ONE transaction", async function ()
            {
                deadline = "1675651904"

                const Permit = [
                    { name: 'owner', type: 'address' },
                    { name: 'spender', type: 'address' },
                    { name: 'value', type: 'uint256' },
                    { name: 'nonce', type: 'uint256' },
                    { name: 'deadline', type: 'uint256' },
                ];

                const EIP712Domain = [
                    { name: 'name', type: 'string' },
                    { name: 'version', type: 'string' },
                    { name: 'chainId', type: 'uint256' },
                    { name: 'verifyingContract', type: 'address' },
                ];
                name_ = "Ride"
                version = "1"
                nonce = 0
                spender = contractUsingERC20sA.address
                value = 5 //allowAmount1 //new BN(5)

                const buildData = (chainId, verifyingContract, deadline, nonce) => ({
                    primaryType: 'Permit',
                    types: { EIP712Domain, Permit },
                    domain: { name: name_, version: version, chainId: chainId, verifyingContract: verifyingContract },
                    message: { owner: person1, spender: spender, value: value, nonce: nonce, deadline: deadline },
                })

                pk = "59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
                const hex = Buffer.from(pk, 'hex')

                const data = buildData(chainId, contractRideA.address, deadline, nonce);
                // const hex = Uint8Array.from(Buffer.from(pk, 'hex'))
                const signature = ethSigUtil.signTypedMessage(hex, { data })
                const { v, r, s } = fromRpcSig(signature)

                expect(await contractRideA.balanceOf(contractUsingERC20sA.address)).to.equal("10000000000000000000")
                expect(await contractRideA.balanceOf(person1)).to.equal(100)
                expect(await contractRideA.allowance(person1, contractUsingERC20sA.address)).to.equal(0)

                // var tx = await contractRideA.permit(person1, contractUsingERC20sA.address, value, deadline, v, r, s)
                // var rcpt = tx.wait()

                expect(await contractRideA.nonces(person1)).to.equal(0)

                contractUsingERC20s3 = await ethers.getContractAt("UsingERC20s", contractUsingERC20sA.address, person1)
                var tx = await contractUsingERC20s3.depositWtihPermit(value, deadline, v, r, s)
                var rcpt = tx.wait()

                expect(await contractRideA.balanceOf(contractUsingERC20sA.address)).to.equal("10000000000000000005")
                expect(await contractRideA.balanceOf(person1)).to.equal(95)
                expect(await contractRideA.allowance(person1, contractUsingERC20sA.address)).to.equal(0)

                expect(await contractRideA.nonces(person1)).to.equal(1)

            })

            it("Should be able to be deposited again", async function ()
            {
                // // transaction 2 | TODO (currently got error)

                // nonce1 = 1
                // data2 = buildData(chainId, contractRideA.address, deadline, nonce1)
                // const signature2 = ethSigUtil.signTypedMessage(hex, { data2 }) // TODO: TypeError: Cannot read properties of undefined (reading 'types')
                // const { v2, r2, s2 } = fromRpcSig(signature2)

                // var tx = await contractUsingERC20s3.depositWtihPermit(value, deadline, v2, r2, s2)
                // var rcpt = tx.wait()

                // expect(await contractRideA.balanceOf(contractUsingERC20sA.address)).to.equal(10)
                // expect(await contractRideA.balanceOf(person1)).to.equal(90)
                // expect(await contractRideA.allowance(person1, contractUsingERC20sA.address)).to.equal(0)
            })
        })

        describe("ERC20Votes - general stuff", function ()
        {
            it("Should", async function ()
            {
                expect(await contractRideA.balanceOf(person2)).to.equal(0)
                expect(await contractRideA.balanceOf(other)).to.equal(0)

                blockNumber = await waffle.provider.getBlockNumber()
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000100")

                var tx = await contractRideA.mint(person2, 100)
                var rcpt = tx.wait()
                var tx = await contractRideA.mint(other, 100)
                var rcpt = tx.wait()

                expect(await contractRideA.balanceOf(person2)).to.equal(100)
                expect(await contractRideA.balanceOf(other)).to.equal(100)

                blockNumber = await waffle.provider.getBlockNumber()
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000200")

                expect(await contractRideA.numCheckpoints(person2)).to.equal(0)
                expect(await contractRideA.numCheckpoints(other)).to.equal(0)
                expect(await contractRideA.delegates(person2)).to.equal(ethers.constants.AddressZero)
                expect(await contractRideA.delegates(other)).to.equal(ethers.constants.AddressZero)
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(0)
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(0)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(0)

                contractRideP2 = await ethers.getContractAt("Ride", addressRide, person2)
                contractRideO = await ethers.getContractAt("Ride", addressRide, other)

                // delegate caller's (person2) votes to some other address
                var tx = await contractRideP2.delegate(other)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // balance doesn't change
                expect(await contractRideA.balanceOf(person2)).to.equal(100)
                expect(await contractRideA.balanceOf(other)).to.equal(100)

                // other now has voting power, checkpoint iteration increases
                expect(await contractRideA.numCheckpoints(person2)).to.equal(0)
                expect(await contractRideA.numCheckpoints(other)).to.equal(1)

                // person2 delegates their voting power to other
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(other)).to.equal(ethers.constants.AddressZero)

                // current voting power of others increases by person2's balance, person2 remains zero
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(await contractRideA.balanceOf(person2))

                // pervious voting power is zero
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(0)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(0)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                // other now delegate self
                var tx = await contractRideO.delegate(other)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // balance doesn't change
                expect(await contractRideA.balanceOf(person2)).to.equal(100)
                expect(await contractRideA.balanceOf(other)).to.equal(100)

                // other's voting checkpoint iterates by 1
                expect(await contractRideA.numCheckpoints(person2)).to.equal(0)
                expect(await contractRideA.numCheckpoints(other)).to.equal(2)

                // other's delegates their voting power to self
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(other)).to.equal(other)

                // other's voting power has now increased by their balance
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(balancePerson2 + balanceOther)

                // pervious voting power of other is without self's balance
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(0)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(balancePerson2)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                // person2 delegates self
                var tx = await contractRideP2.delegate(person2)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // balance doesn't change
                expect(await contractRideA.balanceOf(person2)).to.equal(100)
                expect(await contractRideA.balanceOf(other)).to.equal(100)

                // both's voting checkpoint iterates by 1
                expect(await contractRideA.numCheckpoints(person2)).to.equal(1)
                expect(await contractRideA.numCheckpoints(other)).to.equal(3)

                // person2 self delegates
                expect(await contractRideA.delegates(person2)).to.equal(person2)
                expect(await contractRideA.delegates(other)).to.equal(other)

                // person2 gains voting power equal to self balance, other's voting power reduces
                expect(await contractRideA.getVotes(person2)).to.equal(await contractRideA.balanceOf(person2))
                expect(await contractRideA.getVotes(other)).to.equal(await contractRideA.balanceOf(other))

                // pervious voting power of other is person2 + other 's balance, person2 is zero
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(0)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(balancePerson2 + balanceOther)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                // person2 gives voting power to other again
                var tx = await contractRideP2.delegate(other)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // balance doesn't change
                expect(await contractRideA.balanceOf(person2)).to.equal(100)
                expect(await contractRideA.balanceOf(other)).to.equal(100)

                // both's voting checkpoint iterates by 1
                expect(await contractRideA.numCheckpoints(person2)).to.equal(2)
                expect(await contractRideA.numCheckpoints(other)).to.equal(4)

                // person2 delegates voting power to other
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(other)).to.equal(other)

                // other restores pervious voting power, person2 back to zero
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(balancePerson2 + balanceOther)

                // pervious voting power
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(balancePerson2)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(balanceOther)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                // other delegates voting power to person2
                var tx = await contractRideO.delegate(person2)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // balance doesn't change
                expect(await contractRideA.balanceOf(person2)).to.equal(100)
                expect(await contractRideA.balanceOf(other)).to.equal(100)

                // both's voting checkpoint iterates by 1
                expect(await contractRideA.numCheckpoints(person2)).to.equal(3)
                expect(await contractRideA.numCheckpoints(other)).to.equal(5)

                // swap delegates
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(other)).to.equal(person2)

                // swap voting power
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(balanceOther)
                expect(await contractRideA.getVotes(other)).to.equal(balancePerson2)

                // pervious voting power
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(0)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(balancePerson2 + balanceOther)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                // everyone gets back own voting power based on own balance
                var tx = await contractRideP2.delegate(person2)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()
                var tx = await contractRideO.delegate(other)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // balance doesn't change
                expect(await contractRideA.balanceOf(person2)).to.equal(100)
                expect(await contractRideA.balanceOf(other)).to.equal(100)

                // both's voting checkpoint iterates by 2
                expect(await contractRideA.numCheckpoints(person2)).to.equal(5)
                expect(await contractRideA.numCheckpoints(other)).to.equal(7)

                // both self delegates
                expect(await contractRideA.delegates(person2)).to.equal(person2)
                expect(await contractRideA.delegates(other)).to.equal(other)

                // both voting power based on own balance
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(balancePerson2)
                expect(await contractRideA.getVotes(other)).to.equal(balanceOther)

                // pervious voting power (account for the double call)
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(balancePerson2 + balanceOther)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(0)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                // person2 transfers half of their balance to other
                transferAmount = parseInt((await contractRideA.balanceOf(person2)).toString()) / 2
                var tx = await contractRideP2.transfer(other, transferAmount)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // balance changed
                expect(await contractRideA.balanceOf(person2)).to.equal(transferAmount)
                expect(await contractRideA.balanceOf(other)).to.equal(100 + transferAmount)

                // both's voting checkpoint iterates by 1
                expect(await contractRideA.numCheckpoints(person2)).to.equal(6)
                expect(await contractRideA.numCheckpoints(other)).to.equal(8)

                // both self delegates
                expect(await contractRideA.delegates(person2)).to.equal(person2)
                expect(await contractRideA.delegates(other)).to.equal(other)

                // other's voting power increase by transferAmount
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(balancePerson2)
                expect(await contractRideA.getVotes(other)).to.equal(balanceOther)

                // pervious voting power (account for the double call)
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(balancePerson2 + transferAmount)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(balanceOther - transferAmount)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                // person2 delegates to other
                var tx = await contractRideP2.delegate(other)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // balance remain same
                expect(await contractRideA.balanceOf(person2)).to.equal(transferAmount)
                expect(await contractRideA.balanceOf(other)).to.equal(100 + transferAmount)

                // both's voting checkpoint iterates by 1
                expect(await contractRideA.numCheckpoints(person2)).to.equal(7)
                expect(await contractRideA.numCheckpoints(other)).to.equal(9)

                // person2 delegates to other
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(other)).to.equal(other)

                // other's voting power increase by person2's balance
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(balanceOther + balancePerson2)

                // pervious voting power (account for the double call)
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(balancePerson2)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(balanceOther)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                /**
                 * KEY POINT FOR THE LAST PART
                 * if A delegates voting power to B
                 * even though B transfers certain amount to A afterwards
                 * B still holds all voting power
                 */
                // other transfers to person2
                prevBlockNumber = blockNumber
                transferAmount2 = parseInt((await contractRideA.balanceOf(other)).toString()) / 2
                var tx = await contractRideO.transfer(person2, transferAmount2)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // block moved
                expect(prevBlockNumber).to.equal(blockNumber - 1)

                // balance changed
                expect(await contractRideA.balanceOf(person2)).to.equal(transferAmount + transferAmount2)
                expect(await contractRideA.balanceOf(other)).to.equal(100 + transferAmount - transferAmount2)

                // both's voting checkpoint NO CHANGE
                expect(await contractRideA.numCheckpoints(person2)).to.equal(7)
                expect(await contractRideA.numCheckpoints(other)).to.equal(9)

                // both still delegate to other
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(other)).to.equal(other)

                // voting power NO CHANGE
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(balanceOther + balancePerson2)

                // pervious voting power changed since block number moved, but no voting power changed
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(0)
                expect(await contractRideA.getPastVotes(other, blockNumber - 1)).to.equal(balancePerson2 + balanceOther)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000300")

                // someone mint new
                var tx = await contractRideA.mint(someone, 100)
                var rcpt = tx.wait()

                contractRideS = await ethers.getContractAt("Ride", addressRide, someone)

                // someone with no voting power, transfers an amount to person2 with NO voting power, but delegated to other
                expect(await contractRideA.getVotes(someone)).to.equal(0)
                transferAmount3 = parseInt((await contractRideA.balanceOf(someone)).toString()) / 2
                var tx = await contractRideS.transfer(person2, transferAmount3.toString())
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // other voting power iterates by 1
                expect(await contractRideA.numCheckpoints(person2)).to.equal(7)
                expect(await contractRideA.numCheckpoints(other)).to.equal(10)
                expect(await contractRideA.numCheckpoints(someone)).to.equal(0)

                // someone delegates to no one
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(someone)).to.equal(ethers.constants.AddressZero)

                // voting power of other increased by someone's transfer to person2 because person2 still delegates to other
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(someone)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(balancePerson2 + balanceOther)

                // pervious voting power no change
                expect(await contractRideA.getPastVotes(person2, blockNumber - 1)).to.equal(0)
                expect(await contractRideA.getPastVotes(admin, blockNumber - 1)).to.equal(0)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000400")

                // person3 mint new
                var tx = await contractRideA.mint(person3, 100)
                var rcpt = tx.wait()

                contractRideP3 = await ethers.getContractAt("Ride", addressRide, person3)

                // someone with no voting power, transfers an amount to person3 with NO voting power, and no delegate
                expect(await contractRideA.getVotes(person3)).to.equal(0)
                transferAmount3 = parseInt((await contractRideA.balanceOf(person3)).toString()) / 2
                var tx = await contractRideS.transfer(person3, transferAmount3.toString())
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // all voting checkpoint NO CHANGE
                expect(await contractRideA.numCheckpoints(person2)).to.equal(7)
                expect(await contractRideA.numCheckpoints(other)).to.equal(10)
                expect(await contractRideA.numCheckpoints(someone)).to.equal(0)
                expect(await contractRideA.numCheckpoints(person3)).to.equal(0)

                // person3 delegates to no one
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(someone)).to.equal(ethers.constants.AddressZero)
                expect(await contractRideA.delegates(person3)).to.equal(ethers.constants.AddressZero)

                // voting power no change
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(someone)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(balancePerson2 + balanceOther)
                expect(await contractRideA.getVotes(person3)).to.equal(0)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000500")

                // person3 with no voting power, transfers an amount to other with voting power, and self delegates
                transferAmount4 = parseInt((await contractRideA.balanceOf(person3)).toString()) / 2
                var tx = await contractRideP3.transfer(other, transferAmount4)
                var rcpt = tx.wait()
                blockNumber = await waffle.provider.getBlockNumber()

                // other voting checkpoint iterates by 1
                expect(await contractRideA.numCheckpoints(person2)).to.equal(7)
                expect(await contractRideA.numCheckpoints(other)).to.equal(11)
                expect(await contractRideA.numCheckpoints(someone)).to.equal(0)
                expect(await contractRideA.numCheckpoints(person3)).to.equal(0)

                // no delegate changes
                expect(await contractRideA.delegates(person2)).to.equal(other)
                expect(await contractRideA.delegates(someone)).to.equal(ethers.constants.AddressZero)
                expect(await contractRideA.delegates(person3)).to.equal(ethers.constants.AddressZero)

                // voting power no change
                balancePerson2 = parseInt((await contractRideA.balanceOf(person2)).toString())
                balanceOther = parseInt((await contractRideA.balanceOf(other)).toString())
                expect(await contractRideA.getVotes(person2)).to.equal(0)
                expect(await contractRideA.getVotes(someone)).to.equal(0)
                expect(await contractRideA.getVotes(other)).to.equal(balancePerson2 + balanceOther)
                expect(await contractRideA.getVotes(person3)).to.equal(0)

                // total balances
                expect((await contractRideA.getPastTotalSupply(blockNumber - 1)).toString()).to.equal("100000000000000000500")
            })
        })
    })
}