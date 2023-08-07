.PHONY: contract

contract:
	vyper --storage-layout-file=custom_storage.json contracts/Proxy.vy
