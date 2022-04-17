import pytest
from brownie import Box
import scripts.utils as utils


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_box1(box):
    assert box == 6
    box = 10
    assert box == 10


def test_box2(box):
    assert box == 6
