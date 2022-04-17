import pytest
import math
import brownie
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def test_1(Test1, deployer):
    yield Test1.deploy(
        {"from": deployer},
        publish_source=brownie.config["networks"][brownie.network.show_active()].get(
            "verify", False
        ),
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


@pytest.mark.skip(reason="dont fully understand the bug yet - refer cacheBugTest.js")
def test_test_1(test_1):
    ownerSel = "0x8da5cb5b"

    sel0 = "0x19e3b533"
    sel1 = "0x0716c2ae"
    sel2 = "0x11046047"
    sel3 = "0xcf3bbe18"
    sel4 = "0x24c1d5a7"
    sel5 = "0xcbb835f6"
    sel6 = "0xcbb835f7"
    sel7 = "0xcbb835f8"
    sel8 = "0xcbb835f9"
    sel9 = "0xcbb835fa"
    sel10 = "0xcbb835fb"

    sel = [ownerSel, sel0, sel1, sel2, sel3, sel4, sel5, sel6, sel7, sel8, sel9, sel10]

    selectors = utils.get_function_selectors(test_1)
    for s in sel:
        if s not in selectors:
            print(s)
