// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers, waffle } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

let { deploy, networkConfig } = require('../../scripts/utils')
const { deployEndToEnd } = require("../../scripts/deployEndToEnd.js")

const {
    getSelectors,
    FacetCutAction,
    removeSelectors,
    findAddressPositionInFacets
} = require('../../scripts/utilsDiamond.js')

if (parseInt(chainId) === 31337)
{
    before(async function ()
    {
        accounts = await ethers.getSigners()
        deployerAddress = accounts[0].address
        person1 = accounts[1].address
        person2 = accounts[2].address
        person3 = accounts[3].address
        person4 = accounts[4].address
        person5 = accounts[5].address
        person6 = accounts[6].address

        addresses = await deployEndToEnd(deployerAddress, true, true)
        addressRideToken = addresses[0]
        addressRideTimelock = addresses[1]
        addressRideGovernor = addresses[2]
        addressRideHub = addresses[3]

        contractRideToken = await ethers.getContractAt("Ride", addressRideToken, deployerAddress)

        expect(await contractRideToken.balanceOf(deployerAddress)).to.equal(supply)
        expect(await contractRideToken.balanceOf(person1)).to.equal(supply)
        expect(await contractRideToken.balanceOf(person2)).to.equal(supply)
        expect(await contractRideToken.balanceOf(person3)).to.equal(supply)
        expect(await contractRideToken.balanceOf(person4)).to.equal(supply)
        expect(await contractRideToken.balanceOf(person5)).to.equal(supply)

        contractRideTokenP1 = await ethers.getContractAt("Ride", addressRideToken, person1)
        contractRideTimelockP1 = await ethers.getContractAt("RideTimelock", addressRideTimelock, person1)
        contractRideGovernorP1 = await ethers.getContractAt("RideGovernor", addressRideGovernor, person1)

        contractCutP1 = await ethers.getContractAt("IRideCut", addressRideHub, person1)
        contractLoupeP1 = await ethers.getContractAt("IRideLoupe", addressRideHub, person1)
        contractOwnershipP1 = await ethers.getContractAt("IERC173", addressRideHub, person1)
        contractBadgeP1 = await ethers.getContractAt("IRideBadge", addressRideHub, person1)
        contractCurrencyRegistryP1 = await ethers.getContractAt("IRideCurrencyRegistry", addressRideHub, person1)
        contractExchangeP1 = await ethers.getContractAt("IRideExchange", addressRideHub, person1)
        contractFeeP1 = await ethers.getContractAt("IRideFee", addressRideHub, person1)
        contractPenaltyP1 = await ethers.getContractAt("IRidePenalty", addressRideHub, person1)
        contractRaterP1 = await ethers.getContractAt("IRideRater", addressRideHub, person1)

        contractRideGovernorP2 = await ethers.getContractAt("RideGovernor", addressRideGovernor, person2)
        contractRideTokenP2 = await ethers.getContractAt("Ride", addressRideToken, person2)

        var tx = await contractRideTokenP2.delegate(person2) // self delegate
        var rcpt = await tx.wait()

        expect(await contractOwnershipP1.owner()).to.equal(addressRideTimelock)

        // proposalState =
        //     [
        //         "Pending",
        //         "Active",
        //         "Canceled",
        //         "Defeated",
        //         "Succeeded",
        //         "Queued",
        //         "Expired",
        //         "Executed"
        //     ]
    })

    describe("Ownable functions of RideHub - to be executed via governor contract", function ()
    {
        it("RideBadge - setBadgesMaxScores", async function ()
        {
            badgesMaxScore = ["500000", "15000000", "90000000", "180000000", "540000000"] // metres
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(0)).toString()).to.equal(badgesMaxScore[0])
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(1)).toString()).to.equal(badgesMaxScore[1])
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(2)).toString()).to.equal(badgesMaxScore[2])
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(3)).toString()).to.equal(badgesMaxScore[3])
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(4)).toString()).to.equal(badgesMaxScore[4])

            badgesMaxScoreNew = ["600000", "16000000", "80000000", "190000000", "550000000"]
            await expect(contractBadgeP1.setBadgesMaxScores(badgesMaxScoreNew)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setBadgesMaxScores(uint256[] memory _badgesMaxScores)"]
            // abi = ["function setBadgesMaxScores(uint256[] memory)"] // it works // TODO check what is the minimum
            // abi = ["function setBadgesMaxScores(uint256[])"] // it works // TODO check what is the minimum
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setBadgesMaxScores", [badgesMaxScoreNew])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setBadgesMaxScores."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractBadgeP1.setBadgesMaxScores(badgesMaxScoreNew)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractBadgeP1.setBadgesMaxScores(badgesMaxScoreNew)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(0)).toString()).to.equal(badgesMaxScoreNew[0])
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(1)).toString()).to.equal(badgesMaxScoreNew[1])
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(2)).toString()).to.equal(badgesMaxScoreNew[2])
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(3)).toString()).to.equal(badgesMaxScoreNew[3])
            expect((await contractBadgeP1.getBadgeToBadgeMaxScore(4)).toString()).to.equal(badgesMaxScoreNew[4])
        })
        it("RideCurrencyRegistry - registerFiat", async function ()
        {
            localCurrency = "MYR"
            await expect(contractCurrencyRegistryP1.getKeyFiat(localCurrency)).to.revertedWith("currency not supported")
            await expect(contractCurrencyRegistryP1.registerFiat(localCurrency)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function registerFiat(string memory _code)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("registerFiat", [localCurrency])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test registerFiat."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractCurrencyRegistryP1.registerFiat(localCurrency)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractCurrencyRegistryP1.registerFiat(localCurrency)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            keyLocal = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(["string"], [localCurrency]))
            expect(await contractCurrencyRegistryP1.getKeyFiat(localCurrency)).to.equal(keyLocal)
        })
        it("RideCurrencyRegistry - registerCrypto", async function ()
        {
            tokenA = person3
            await expect(contractCurrencyRegistryP1.getKeyCrypto(tokenA)).to.revertedWith("currency not supported")
            await expect(contractCurrencyRegistryP1.registerCrypto(tokenA)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function registerCrypto(address _token)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("registerCrypto", [tokenA])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test registerCrypto."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractCurrencyRegistryP1.registerCrypto(tokenA)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractCurrencyRegistryP1.registerCrypto(tokenA)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            key = await contractCurrencyRegistryP1.getKeyCrypto(tokenA)
            keyToken = ethers.utils.hexlify(tokenA)
            appendZerosLength = key.length - keyToken.length
            expect(key).to.equal(keyToken.concat("0".repeat(appendZerosLength)))
        })
        it("RideCurrencyRegistry - removeCurrency", async function ()
        {
            // register crypto
            await expect(contractCurrencyRegistryP1.registerCrypto(person4)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function registerCrypto(address _token)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("registerCrypto", [person4])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test registerCrypto."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractCurrencyRegistryP1.registerCrypto(person4)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractCurrencyRegistryP1.registerCrypto(person4)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            keyTmp = await contractCurrencyRegistryP1.getKeyCrypto(person4)
            keyToken = ethers.utils.hexlify(person4)
            appendZerosLength = keyTmp.length - keyToken.length
            expect(keyTmp).to.equal(keyToken.concat("0".repeat(appendZerosLength)))

            // remove crypto
            await expect(contractCurrencyRegistryP1.removeCurrency(keyTmp)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function removeCurrency(bytes32 _key)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("removeCurrency", [keyTmp])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test removeCurrency."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractCurrencyRegistryP1.removeCurrency(keyTmp)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractCurrencyRegistryP1.removeCurrency(keyTmp)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            await expect(contractCurrencyRegistryP1.getKeyCrypto(person4)).to.revertedWith("currency not supported")
        })
        it("RideCurrencyRegistry - setupFiatWithFee", async function ()
        {
            tmpCurrency = "YEN"
            feeCancel = 5
            feeBase = 3
            feeMinute = 2
            feeMetre = [9, 8, 7, 6, 5, 4]
            tmpKey = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(["string"], [tmpCurrency]))
            await expect(contractCurrencyRegistryP1.getKeyFiat(tmpCurrency)).to.revertedWith("currency not supported")
            await expect(contractFeeP1.getCancellationFee(tmpKey)).to.revertedWith("currency not supported")
            await expect(contractFeeP1.getBaseFee(tmpKey)).to.revertedWith("currency not supported")
            await expect(contractFeeP1.getCostPerMinute(tmpKey)).to.revertedWith("currency not supported")
            await expect(contractFeeP1.getCostPerMetre(tmpKey, 3)).to.revertedWith("currency not supported")

            await expect(contractCurrencyRegistryP1.setupFiatWithFee(tmpCurrency, feeCancel, feeBase, feeMinute, feeMetre)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setupFiatWithFee(string memory _code, uint256 _cancellationFee, uint256 _baseFee, uint256 _costPerMinute, uint256[] memory _costPerMetre)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setupFiatWithFee", [tmpCurrency, feeCancel, feeBase, feeMinute, feeMetre])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setupFiatWithFee."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractCurrencyRegistryP1.setupFiatWithFee(tmpCurrency, feeCancel, feeBase, feeMinute, feeMetre)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractCurrencyRegistryP1.setupFiatWithFee(tmpCurrency, feeCancel, feeBase, feeMinute, feeMetre)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect(await contractCurrencyRegistryP1.getKeyFiat(tmpCurrency)).to.equal(tmpKey)
            expect(await contractFeeP1.getCancellationFee(tmpKey)).to.equal(feeCancel)
            expect(await contractFeeP1.getBaseFee(tmpKey)).to.equal(feeBase)
            expect(await contractFeeP1.getCostPerMinute(tmpKey)).to.equal(feeMinute)
            expect(await contractFeeP1.getCostPerMetre(tmpKey, 3)).to.equal(feeMetre[3])
        })
        it("RideCurrencyRegistry - setupCryptoWithFee", async function ()
        {
            tmpToken = person5
            feeCancel = 5
            feeBase = 3
            feeMinute = 2
            feeMetre = [9, 8, 7, 6, 5, 4]

            await expect(contractCurrencyRegistryP1.getKeyCrypto(tmpToken)).to.revertedWith("currency not supported")

            await expect(contractCurrencyRegistryP1.setupCryptoWithFee(tmpToken, feeCancel, feeBase, feeMinute, feeMetre)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setupCryptoWithFee(address _token, uint256 _cancellationFee, uint256 _baseFee, uint256 _costPerMinute, uint256[] memory _costPerMetre)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setupCryptoWithFee", [tmpToken, feeCancel, feeBase, feeMinute, feeMetre])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setupCryptoWithFee."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractCurrencyRegistryP1.setupCryptoWithFee(tmpToken, feeCancel, feeBase, feeMinute, feeMetre)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractCurrencyRegistryP1.setupCryptoWithFee(tmpToken, feeCancel, feeBase, feeMinute, feeMetre)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            key = await contractCurrencyRegistryP1.getKeyCrypto(tmpToken)
            keyToken = ethers.utils.hexlify(tmpToken)
            appendZerosLength = key.length - keyToken.length
            finalKey = keyToken.concat("0".repeat(appendZerosLength))
            expect(key).to.equal(finalKey)

            expect(await contractFeeP1.getCancellationFee(finalKey)).to.equal(feeCancel)
            expect(await contractFeeP1.getBaseFee(finalKey)).to.equal(feeBase)
            expect(await contractFeeP1.getCostPerMinute(finalKey)).to.equal(feeMinute)
            expect(await contractFeeP1.getCostPerMetre(finalKey, 3)).to.equal(feeMetre[3])
        })
        it("RideExchange - addXPerYPriceFeed", async function ()
        {
            priceFeed = person6
            await expect(contractExchangeP1.getXPerYPriceFeed(tmpKey, finalKey)).to.revertedWith("price feed not supported")
            await expect(contractExchangeP1.addXPerYPriceFeed(tmpKey, finalKey, priceFeed)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function addXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY, address _priceFeed)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("addXPerYPriceFeed", [tmpKey, finalKey, priceFeed])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test addXPerYPriceFeed."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractExchangeP1.addXPerYPriceFeed(tmpKey, finalKey, priceFeed)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractExchangeP1.addXPerYPriceFeed(tmpKey, finalKey, priceFeed)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect(await contractExchangeP1.getXPerYPriceFeed(tmpKey, finalKey)).to.equal(priceFeed)
        })
        it("RideExchange - removeXPerYPriceFeed", async function ()
        {
            await expect(contractExchangeP1.removeXPerYPriceFeed(tmpKey, finalKey)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function removeXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("removeXPerYPriceFeed", [tmpKey, finalKey])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test removeXPerYPriceFeed."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractExchangeP1.removeXPerYPriceFeed(tmpKey, finalKey)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractExchangeP1.removeXPerYPriceFeed(tmpKey, finalKey)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            await expect(contractExchangeP1.getXPerYPriceFeed(tmpKey, finalKey)).to.revertedWith("price feed not supported")
        })
        it("RideFee - setCancellationFee", async function ()
        {
            cancelFee = 5
            expect(await contractFeeP1.getCancellationFee(keyLocal)).to.equal(0)
            await expect(contractFeeP1.setCancellationFee(keyLocal, cancelFee)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setCancellationFee(bytes32 _key, uint256 _cancellationFee)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setCancellationFee", [keyLocal, cancelFee])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setCancellationFee."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractFeeP1.setCancellationFee(keyLocal, cancelFee)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractFeeP1.setCancellationFee(keyLocal, cancelFee)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect(await contractFeeP1.getCancellationFee(keyLocal)).to.equal(cancelFee)
        })
        it("RideFee - setBaseFee", async function ()
        {
            baseFee = 5
            expect(await contractFeeP1.getBaseFee(keyLocal)).to.equal(0)
            await expect(contractFeeP1.setBaseFee(keyLocal, baseFee)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setBaseFee(bytes32 _key, uint256 _baseFee)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setBaseFee", [keyLocal, baseFee])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setBaseFee."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractFeeP1.setBaseFee(keyLocal, baseFee)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractFeeP1.setBaseFee(keyLocal, baseFee)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect(await contractFeeP1.getBaseFee(keyLocal)).to.equal(baseFee)
        })
        it("RideFee - setCostPerMinute", async function ()
        {
            minuteFee = 5
            expect(await contractFeeP1.getCostPerMinute(keyLocal)).to.equal(0)
            await expect(contractFeeP1.setCostPerMinute(keyLocal, minuteFee)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setCostPerMinute(bytes32 _key, uint256 _costPerMinute)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setCostPerMinute", [keyLocal, minuteFee])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setCostPerMinute."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractFeeP1.setCostPerMinute(keyLocal, minuteFee)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractFeeP1.setCostPerMinute(keyLocal, minuteFee)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect(await contractFeeP1.getCostPerMinute(keyLocal)).to.equal(minuteFee)
        })
        it("RideFee - setCostPerMetre", async function ()
        {
            metreFee = [9, 8, 7, 6, 5, 4]
            expect(await contractFeeP1.getCostPerMetre(keyLocal, 3)).to.equal(0)
            await expect(contractFeeP1.setCostPerMetre(keyLocal, metreFee)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setCostPerMetre(bytes32 _key, uint256[] memory _costPerMetre)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setCostPerMetre", [keyLocal, metreFee])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setCostPerMetre."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractFeeP1.setCostPerMetre(keyLocal, metreFee)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractFeeP1.setCostPerMetre(keyLocal, metreFee)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect(await contractFeeP1.getCostPerMetre(keyLocal, 3)).to.equal(metreFee[3])
        })
        it("RidePenalty - setBanDuration", async function ()
        {
            banDuration = "604800"
            expect((await contractPenaltyP1.getBanDuration()).toString()).to.equal(banDuration)

            banDurationNew = "604801"
            await expect(contractPenaltyP1.setBanDuration(banDurationNew)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setBanDuration(uint256 _banDuration)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setBanDuration", [banDurationNew])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setBanDuration."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractPenaltyP1.setBanDuration(banDurationNew)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractPenaltyP1.setBanDuration(banDurationNew)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect((await contractPenaltyP1.getBanDuration()).toString()).to.equal(banDurationNew)
        })
        it("RideRater - setRatingBounds", async function ()
        {
            min = 1
            max = 5
            expect(await contractRaterP1.getRatingMin()).to.equal(min)
            expect(await contractRaterP1.getRatingMax()).to.equal(max)

            minNew = 2
            maxNew = 4
            await expect(contractRaterP1.setRatingBounds(minNew, maxNew)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function setRatingBounds(uint256 _min, uint256 _max)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("setRatingBounds", [minNew, maxNew])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test setRatingBounds."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractRaterP1.setRatingBounds(minNew, maxNew)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractRaterP1.setRatingBounds(minNew, maxNew)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect(await contractRaterP1.getRatingMin()).to.equal(minNew)
            expect(await contractRaterP1.getRatingMax()).to.equal(maxNew)
        })
        it("RideCut - rideCut: Add", async function ()
        {
            contractBox3 = await deploy(
                deployerAddress,
                chainId,
                "Box3",
                args = [],
                verify = true,
                test = true
            )
            selectorsBox3 = getSelectors(contractBox3)

            facetAddresses = await contractLoupeP1.facetAddresses()
            for (let i = 0; i < facetAddresses.length; i++)
            {
                expect((await contractLoupeP1.facetFunctionSelectors(facetAddresses[i])).length).to.be.above(0)
            }
            expect((await contractLoupeP1.facetFunctionSelectors(contractBox3.address)).length).to.equal(0)

            await expect(contractCutP1.rideCut(
                [{
                    facetAddress: contractBox3.address,
                    action: FacetCutAction.Add,
                    functionSelectors: selectorsBox3
                }],
                ethers.constants.AddressZero, '0x')).to.revertedWith("not contract owner")

            // governance process
            abi = ["function rideCut((address facetAddress, uint8 action, bytes4[] functionSelectors)[] calldata _rideCut, address _init, bytes calldata _calldata)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("rideCut",
                [
                    [{
                        facetAddress: contractBox3.address,
                        action: FacetCutAction.Add,
                        functionSelectors: selectorsBox3
                    }],
                    ethers.constants.AddressZero,
                    '0x'
                ])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test rideCut."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractCutP1.rideCut(
                    [{
                        facetAddress: contractBox3.address,
                        action: FacetCutAction.Add,
                        functionSelectors: selectorsBox3
                    }],
                    ethers.constants.AddressZero, '0x')).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractCutP1.rideCut(
                    [{
                        facetAddress: contractBox3.address,
                        action: FacetCutAction.Add,
                        functionSelectors: selectorsBox3
                    }],
                    ethers.constants.AddressZero, '0x')).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect((await contractLoupeP1.facetFunctionSelectors(contractBox3.address)).length).to.be.above(0)
        })
        it("RideCut - rideCut: Remove", async function ()
        {
            facetAddresses = await contractLoupeP1.facetAddresses()
            for (let i = 0; i < facetAddresses.length; i++)
            {
                expect((await contractLoupeP1.facetFunctionSelectors(facetAddresses[i])).length).to.be.above(0)
            }
            expect((await contractLoupeP1.facetFunctionSelectors(contractBox3.address)).length).to.be.above(0)

            await expect(contractCutP1.rideCut(
                [{
                    facetAddress: ethers.constants.AddressZero,
                    action: FacetCutAction.Remove,
                    functionSelectors: selectorsBox3
                }],
                ethers.constants.AddressZero, '0x')).to.revertedWith("not contract owner")

            // governance process
            abi = ["function rideCut((address facetAddress, uint8 action, bytes4[] functionSelectors)[] calldata _rideCut, address _init, bytes calldata _calldata)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("rideCut",
                [
                    [{
                        facetAddress: ethers.constants.AddressZero,
                        action: FacetCutAction.Remove,
                        functionSelectors: selectorsBox3
                    }],
                    ethers.constants.AddressZero,
                    '0x'
                ])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test rideCut."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractCutP1.rideCut(
                    [{
                        facetAddress: ethers.constants.AddressZero,
                        action: FacetCutAction.Remove,
                        functionSelectors: selectorsBox3
                    }],
                    ethers.constants.AddressZero, '0x')).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractCutP1.rideCut(
                    [{
                        facetAddress: ethers.constants.AddressZero,
                        action: FacetCutAction.Remove,
                        functionSelectors: selectorsBox3
                    }],
                    ethers.constants.AddressZero, '0x')).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect((await contractLoupeP1.facetFunctionSelectors(contractBox3.address)).length).to.equal(0)
        })
        it("RideOwnership - transferOwnership", async function ()
        {
            expect(await contractOwnershipP1.owner()).to.equal(addressRideTimelock)
            await expect(contractOwnershipP1.transferOwnership(person6)).to.revertedWith("not contract owner")

            // governance process
            abi = ["function transferOwnership(address _newOwner)"]
            iface = new ethers.utils.Interface(abi)
            encoded_fn = iface.encodeFunctionData("transferOwnership", [person6])

            targets = [addressRideHub]
            values = [0]
            calldatas = [encoded_fn]
            description = "Test transferOwnership."
            var tx = await contractRideGovernorP1.propose(targets, values, calldatas, description)

            votingDelay = parseInt((await contractRideGovernorP1.votingDelay()).toString())
            for (let i = 0; i < votingDelay; i++)
            {
                await expect(contractOwnershipP1.transferOwnership(person6)).to.revertedWith("not contract owner")
            } // move block

            var rcpt = await tx.wait(1 + votingDelay)

            proposalId = rcpt.events[0].args.proposalId.toString()

            var tx = await contractRideGovernorP2.castVote(proposalId, 1)
            var rcpt = tx.wait()

            votingPeriod = parseInt((await contractRideGovernorP1.votingPeriod()).toString())
            for (let i = 0; i < votingPeriod; i++)
            {
                await expect(contractOwnershipP1.transferOwnership(person6)).to.revertedWith("not contract owner")
            } // move block

            description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(description))

            var tx = await contractRideGovernorP1.queue(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            var tx = await contractRideGovernorP1.execute(targets, values, calldatas, description_hash)
            var rcpt = tx.wait()

            expect(await contractOwnershipP1.owner()).to.equal(person6)
        })
    })
}