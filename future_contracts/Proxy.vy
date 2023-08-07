# @version 0.3.x
# @dev storage slot override example implementing eip-1967 proxy

implementation: public(address) @ keccak256("eip1967.proxy.implementation") - 1
admin: public(address) @ keccak256("eip1967.proxy.admin") - 1


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
