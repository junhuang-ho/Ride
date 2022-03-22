import pytest
from brownie import Box
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def box(module_isolation):
    something = 6
    yield something
