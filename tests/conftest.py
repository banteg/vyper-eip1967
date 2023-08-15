import pytest
from ethpm_types import Bytecode


@pytest.fixture
def dev(accounts):
    return accounts[0]


@pytest.fixture
def eve(accounts):
    return accounts[1]


@pytest.fixture
def implementation(project, dev):
    return project.Implementation.deploy(sender=dev)


@pytest.fixture
def implementation_v2(project, dev):
    return project.Implementation_v2.deploy(sender=dev)


@pytest.fixture
def proxy(project, implementation, dev):
    return project.Proxy.deploy(implementation, sender=dev)
