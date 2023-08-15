# @version 0.3.10
# @dev storage slot override example implementing eip-1967 proxy

_gap_0: uint256[24440054405305269366569402256811496959409073762505157381672968839269610695612]
implementation: public(address)# @ 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
_gap_1: uint256[57515418674210777583064340759886350581885744927316125368323712657003024561478]
admin: public(address)# @ 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103


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
