import pytest
from brownie import Box
import scripts.utils as utils


@pytest.fixture(scope="module", autouse=True)
def boxer():
    something = 123
    yield something


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_box1(box, boxer):
    assert box == 6
    assert boxer == 123
    box = 10
    boxer = 456
    assert box == 10
    assert boxer == 456


def test_box2(box, boxer):
    assert box == 6
    assert boxer == 123
