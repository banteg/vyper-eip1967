# @version 0.3.9
# @dev storage slot override example implementing eip-1967 proxy

implementation: public(address)
admin: public(address)
beacon: public(address)


event Upgraded:
    implementation: indexed(address)

event AdminChanged:
    previous_admin: indexed(address)
    new_admin: indexed(address)


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
