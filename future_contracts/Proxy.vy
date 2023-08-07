# @version 0.3.x
# @dev storage slot override example implementing eip-1967 proxy

implementation: public(address) @ 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
admin: public(address) @ 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103


event Upgraded:
    implementation: indexed(address)

event AdminChanged:
    previous_admin: indexed(address)
    new_admin: indexed(address)


@external
def __init__(implementation: address):
    self.implementation = implementation
    self.admin = msg.sender


@external
def __default__():
    return raw_call(self.implementation, msg.data, is_delegate_call=True, raw_return=True)


@external
def upgrade_to(new_implementation: address):
    assert msg.sender == self.admin
    self.implementation = new_implementation
    log Upgraded(new_implementation)


@external
def change_admin(new_admin: address):
    current_admin: address = self.admin
    assert msg.sender == current_admin
    self.admin = new_admin
    log AdminChanged(current_admin, new_admin)
