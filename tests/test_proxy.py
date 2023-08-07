from ape import convert
from ape.contracts.base import ContractCall
from ape.types import AddressType
from eth_utils import keccak
from ape import reverts


def test_implementation(implementation):
    assert implementation.lucky() == 777


def test_proxy(proxy, implementation, project):
    assert project.Implementation.at(str(proxy)).lucky() == 777


def test_implementation_slot(proxy, implementation, chain):
    slot = int.from_bytes(keccak(text="eip1967.proxy.implementation"), "big") - 1
    value = chain.provider.get_storage_at(str(proxy), slot)
    assert convert(value[-20:], AddressType) == str(implementation)


def test_admin_slot(proxy, dev, chain):
    slot = int.from_bytes(keccak(text="eip1967.proxy.admin"), "big") - 1
    value = chain.provider.get_storage_at(str(proxy), slot)
    assert convert(value[-20:], AddressType) == str(dev)


def test_change_admin_ok(proxy, dev, eve):
    assert proxy.admin() == dev
    proxy.change_admin(eve, sender=dev)
    assert proxy.admin() == eve


def test_change_admin_fail(proxy, dev, eve):
    assert proxy.admin() == dev
    with reverts():
        proxy.change_admin(eve, sender=eve)


def test_upgrade_ok(proxy, implementation, implementation_v2, dev, project):
    assert proxy.implementation() == implementation
    with reverts():
        assert project.Implementation_v2.at(str(proxy)).version() == 2
    proxy.upgrade_to(implementation_v2, sender=dev)
    assert proxy.implementation() == implementation_v2
    assert project.Implementation_v2.at(str(proxy)).version() == 2


def test_upgrade_fail(proxy, implementation, implementation_v2, eve, project):
    assert proxy.implementation() == implementation
    with reverts():
        proxy.upgrade_to(implementation_v2, sender=eve)
