# @version 0.3.x
# @dev storage slot override example implementing eip-1967 proxy

admin: public(address) @ keccak256("eip1967.proxy.admin") - 1
beacon: public(Beacon) @ keccak256("eip1967.proxy.beacon") - 1


interface Beacon:
    def implementation() -> address: view


event BeaconUpgraded:
    beacon: indexed(address)

event AdminChanged:
    previous_admin: indexed(address)
    new_admin: indexed(address)


@external
def __init__(beacon: address):
    self.beacon = Beacon(beacon)
    self.admin = msg.sender

    log BeaconUpgraded(beacon)
    log AdminChanged(empty(address), msg.sender)


@external
def __default__():
    implementation: address = self.beacon.implementation()
    return raw_call(implementation, msg.data, is_delegate_call=True, raw_return=True)


@external
def set_beacon(beacon: address):
    assert msg.sender == self.admin
    self.beacon = beacon
    log BeaconUpgraded(beacon)


@external
def change_admin(new_admin: address):
    current_admin: address = self.admin
    assert msg.sender == current_admin
    self.admin = new_admin
    log AdminChanged(current_admin, new_admin)
