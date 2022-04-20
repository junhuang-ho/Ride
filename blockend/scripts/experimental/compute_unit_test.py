from brownie import config, accounts
import brownie
from web3 import Web3
import eth_abi
import scripts.utils as utils
import time

# try:
#     network.connect("mumbai-alchemy")
# except Exception as e:
#     print(e)

location_package = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["package location"]).hex()]
    )
)

location_destination = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"],
        ["0x" + eth_abi.encode_abi(["string"], ["destination location"]).hex()],
    )
)


# def handle_event(event):
#     print(event)
#     print(Web3.toJSON(event))
#     print(event["RequestRunner"]["jobId"])
#     return event["RequestRunner"]["jobId"]


# async def log_loop(event_filter, poll_interval):
#     while True:
#         for event in event_filter.get_new_entries():
#             job_id = handle_event(event)
#         await asyncio.sleep(poll_interval)


def main():
    use_hub_address = "0x9bA5BE2BDb62Cd80769A874CB9298767948dd41b"
    use_gov_token_address = "0xe0622c203E66893C998606f565f439d393B60f21"
    use_timelock_address = "0x4e52BeFD0f6862F1D42b3e114F6922B8C7e3ac21"
    use_gov_address = "0x4C973a99e52295F1416170689D83013e454F4b45"
    wETH_address = "0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa"

    runner = accounts.add(config["wallets"]["from_key_0"])
    requester = accounts.add(config["wallets"]["from_key_1"])
    neutral = accounts.add(config["wallets"]["from_key_2"])

    ride_runner_detail = brownie.Contract.from_abi(
        "RunnerDetail", use_hub_address, brownie.RunnerDetail.abi, neutral,
    )

    assert ride_runner_detail.getRunnerToRunnerDetail(runner)[0] != 0

    # deposit #
    deposit_amount = "0.001 ether"

    wETH_contract = brownie.Contract.from_abi(
        "WETH9", wETH_address, brownie.WETH9.abi, neutral,
    )

    assert wETH_contract.balanceOf(runner) > deposit_amount
    assert wETH_contract.balanceOf(requester) > deposit_amount

    assert wETH_contract.allowance(runner, use_hub_address) == 0
    assert wETH_contract.allowance(requester, use_hub_address) == 0

    tx = wETH_contract.approve(use_hub_address, deposit_amount, {"from": runner})
    tx.wait(1)

    tx = wETH_contract.approve(use_hub_address, deposit_amount, {"from": requester})
    tx.wait(1)

    assert wETH_contract.allowance(runner, use_hub_address) == deposit_amount
    assert wETH_contract.allowance(requester, use_hub_address) == deposit_amount

    ride_currency_registry = brownie.Contract.from_abi(
        "CurrencyRegistry", use_hub_address, brownie.CurrencyRegistry.abi, neutral,
    )

    key_wETH = ride_currency_registry.getKeyCrypto(wETH_contract.address)

    ride_holding = brownie.Contract.from_abi(
        "Holding", use_hub_address, brownie.Holding.abi, neutral,
    )

    # assert ride_holding.getHolding(runner, key_wETH) == 0
    # assert ride_holding.getHolding(requester, key_wETH) == 0

    tx = ride_holding.depositTokens(key_wETH, deposit_amount, {"from": runner})
    tx.wait(1)
    tx = ride_holding.depositTokens(key_wETH, deposit_amount, {"from": requester})
    tx.wait(1)

    holding_runner = ride_holding.getHolding(runner, key_wETH)
    holding_requester = ride_holding.getHolding(requester, key_wETH)
    # assert holding_runner == deposit_amount
    # assert holding_requester == deposit_amount

    assert wETH_contract.allowance(runner, use_hub_address) == 0
    assert wETH_contract.allowance(requester, use_hub_address) == 0

    # remaining_amount_runner = wETH_contract.balanceOf(runner)
    # remaining_amount_requester = wETH_contract.balanceOf(requester)

    # start #
    ride_requester = brownie.Contract.from_abi(
        "Requester", use_hub_address, brownie.Requester.abi, neutral,
    )
    ride_runner = brownie.Contract.from_abi(
        "Runner", use_hub_address, brownie.Runner.abi, neutral,
    )
    ride_job_board = brownie.Contract.from_abi(
        "JobBoard", use_hub_address, brownie.JobBoard.abi, neutral,
    )

    package = requester
    key_USD = ride_currency_registry.getKeyFiat("USD")
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_requester.requestRunner(
        use_timelock_address,
        package,
        location_package,
        location_destination,
        key_USD,
        key_wETH,
        estimated_minutes,
        estimated_metres,
        {"from": requester},
    )
    tx.wait(1)

    # web3 = Web3(Web3.HTTPProvider(os.getenv("ALCHEMY_PROVIDER")))
    # contract = web3.eth.contract(address=use_hub_address, abi=brownie.Requester.abi)
    # event_filter = contract.events.RequestRunner.createFilter(fromBlock="latest")
    # loop = asyncio.get_event_loop()
    # try:
    #     loop.run_until_complete(asyncio.gather(log_loop(event_filter, 2)))
    # finally:
    #     loop.close()

    # job_ID = tx.events["RequestRunner"]["jobId"]
    job_ID = "0x3c8a75d718cbd81494ea3e6b521a7260af9987ad25d04b35d0c81830bfad210e"

    value = ride_job_board.getJobIdToJobDetail(job_ID)[9]  # (fare)
    cancellation_fee = ride_job_board.getJobIdToJobDetail(job_ID)[
        10
    ]  # (cancellation fee)

    # assert ride_holding.getHolding(requester, key_wETH) == holding_requester - (
    #     value + cancellation_fee
    # )
    # assert ride_holding.getVault(requester, key_wETH) == (value + cancellation_fee)

    tx = ride_runner.acceptRequest(key_USD, key_wETH, job_ID, {"from": runner},)
    tx.wait(1)

    # assert ride_holding.getHolding(runner, key_wETH) == holding_runner - (
    #     value + cancellation_fee
    # )
    # assert ride_holding.getVault(runner, key_wETH) == (value + cancellation_fee)

    package_zero = utils.ZERO_ADDRESS  # pass zero address == no verify
    tx = ride_runner.collectPackage(job_ID, package_zero, {"from": runner},)
    tx.wait(1)

    tx.wait(30)  # wait for dispute period to pass

    tx = ride_runner.deliverPackage(job_ID, {"from": runner},)
    tx.wait(1)

    tx.wait(30)  # wait for dispute period to pass

    tx = ride_runner.completeJob(job_ID, True, {"from": runner},)
    tx.wait(1)

    # assert ride_holding.getHolding(requester, key_wETH) == holding_requester - value
    # assert ride_holding.getHolding(runner, key_wETH) == holding_runner + value

    # end #

    # withdraw #
    # assert wETH_contract.balanceOf(runner) == remaining_amount_runner
    # assert wETH_contract.balanceOf(requester) == remaining_amount_requester

    amount_runner = ride_holding.getHolding(runner, key_wETH)
    amount_requester = ride_holding.getHolding(requester, key_wETH)

    tx = ride_holding.withdrawTokens(key_wETH, amount_runner, {"from": runner})
    tx.wait(1)
    tx = ride_holding.withdrawTokens(key_wETH, amount_requester, {"from": requester})
    tx.wait(1)

    assert ride_holding.getHolding(runner, key_wETH) == 0
    assert ride_holding.getHolding(requester, key_wETH) == 0

    # assert wETH_contract.balanceOf(runner) == remaining_amount_runner + amount_runner
    # assert (
    #     wETH_contract.balanceOf(requester)
    #     == remaining_amount_requester + amount_requester
    # )
