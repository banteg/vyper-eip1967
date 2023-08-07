# @version 0.3.9
# @dev storage slot override example implementing eip-1967 proxy

implementation: public(address)
admin: public(address)


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
def __default__() -> uint256:
    """
    FIXME vyper needs a way to pass verbatim buffer for this to work universally
    """
    result: uint256 = convert(raw_call(self.implementation, msg.data, max_outsize=32, is_delegate_call=True), uint256)
    return result


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
