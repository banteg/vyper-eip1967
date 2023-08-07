# @version 0.3.x
# @dev using a beacon allows upgrading all proxies using at once

# @dev the result of implementation() should not depend on msg.sender
implementation: public(address)
admin: public(address)

@external
def __init__(implementation: address):
    self.implementation = implementation
    self.admin = msg.sender


@external
def change_implementation(implementation: address):
    assert msg.sender == self.admin
    self.implementation = implementation


@external
def change_admin(admin: address):
    assert msg.sender == self.admin
    self.admin = admin

