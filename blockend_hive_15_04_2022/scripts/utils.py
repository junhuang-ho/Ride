from brownie import accounts, network, config, convert
import brownie

ENV_LOCAL_BLOCKS = ["development", "ganache-local"]
ENV_LOCAL_FORKS = ["mainnet-ethereum-fork"]
FACET_CUT_ACTIONS = {"Add": 0, "Replace": 1, "Remove": 2}

ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"
ZERO_BYTES32 = "0x0000000000000000000000000000000000000000000000000000000000000000"
ZERO_CALLDATAS = b""

PROPOSAL_STATE = [
    "Pending",
    "Active",
    "Cancelled",
    "Defeated",
    "Succeeded",
    "Queued",
    "Expired",
    "Executed",
]


def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        # using real account registered in brownie (metamask_acc1): run to view: ~$ brownie accounts list
        return accounts.load(id)
    if (
        network.show_active() in ENV_LOCAL_BLOCKS
        or network.show_active() in ENV_LOCAL_FORKS
    ):
        return accounts[0]
    return accounts.add(config["wallets"]["from_key"])  # from_key


def get_function_selectors(contract):
    return list(contract.signatures.values())


def pad_address_right(address):
    address_padded = str(
        convert.datatypes.HexString(
            convert.to_bytes(address, type_str="bytes32"), "bytes32",
        )
    )
    pad_right_length = len(address_padded) - len(address)

    return address + "0" * pad_right_length


def diamond_bulk_deploy(facets, deployer):
    facets_to_cut = []
    for facet in facets:
        deployed_contract = getattr(brownie, facet).deploy(
            {"from": deployer},
            publish_source=config["networks"][network.show_active()].get(
                "verify", False
            ),
        )
        facets_to_cut.append(
            [
                deployed_contract.address,
                FACET_CUT_ACTIONS["Add"],
                get_function_selectors(deployed_contract),
            ]
        )

    return facets_to_cut


def hub_currency_registry(ride_hub):
    return brownie.Contract.from_abi(
        "CurrencyRegistry",
        ride_hub[0].address,
        brownie.CurrencyRegistry.abi,
        get_account(index=0),
    )


def hub_exchange(ride_hub):
    return brownie.Contract.from_abi(
        "Exchange", ride_hub[0].address, brownie.Exchange.abi, get_account(index=0),
    )


def hub_fee(ride_hub):
    return brownie.Contract.from_abi(
        "Fee", ride_hub[0].address, brownie.Fee.abi, get_account(index=0),
    )


def hub_hive_factory(ride_hub):
    return brownie.Contract.from_abi(
        "HiveFactory",
        ride_hub[0].address,
        brownie.HiveFactory.abi,
        get_account(index=0),
    )


def hub_honey_pot(ride_hub):
    return brownie.Contract.from_abi(
        "HoneyPot", ride_hub[0].address, brownie.HoneyPot.abi, get_account(index=0),
    )


def hub_holding(ride_hub):
    return brownie.Contract.from_abi(
        "Holding", ride_hub[0].address, brownie.Holding.abi, get_account(index=0),
    )


def hub_job_board(ride_hub):
    return brownie.Contract.from_abi(
        "JobBoard", ride_hub[0].address, brownie.JobBoard.abi, get_account(index=0),
    )


def hub_penalty(ride_hub):
    return brownie.Contract.from_abi(
        "Penalty", ride_hub[0].address, brownie.Penalty.abi, get_account(index=0),
    )


def hub_rater(ride_hub):
    return brownie.Contract.from_abi(
        "Rater", ride_hub[0].address, brownie.Rater.abi, get_account(index=0),
    )


def hub_requestor(ride_hub):
    return brownie.Contract.from_abi(
        "Requestor", ride_hub[0].address, brownie.Requestor.abi, get_account(index=0),
    )


def hub_requestor_detail(ride_hub):
    return brownie.Contract.from_abi(
        "RequestorDetail",
        ride_hub[0].address,
        brownie.RequestorDetail.abi,
        get_account(index=0),
    )


def hub_runner(ride_hub):
    return brownie.Contract.from_abi(
        "Runner", ride_hub[0].address, brownie.Runner.abi, get_account(index=0),
    )


def hub_runner_detail(ride_hub):
    return brownie.Contract.from_abi(
        "RunnerDetail",
        ride_hub[0].address,
        brownie.RunnerDetail.abi,
        get_account(index=0),
    )


def hub_runner_registry(ride_hub):
    return brownie.Contract.from_abi(
        "RunnerRegistry",
        ride_hub[0].address,
        brownie.RunnerRegistry.abi,
        get_account(index=0),
    )
