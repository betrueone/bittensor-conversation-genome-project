include $(ENV_FILE)
export

finney = wss://entrypoint-finney.opentensor.ai:443
testnet = wss://test.finney.opentensor.ai:443
localnet = $(LOCALNET)

ifeq ($(NETWORK),localnet)
   netuid = 33
else ifeq ($(NETWORK),testnet)
   netuid = 138
else ifeq ($(NETWORK),finney)
   netuid = 33
endif

metagraph:
	btcli subnet metagraph --netuid $(netuid) --subtensor.chain_endpoint $($(NETWORK))

register:
	{ \
		read -p 'Wallet name?: ' wallet_name ;\
		read -p 'Hotkey?: ' hotkey_name ;\
		btcli subnet register --netuid $(netuid) --wallet.name "$$wallet_name" --wallet.hotkey "$$hotkey_name" --subtensor.chain_endpoint $($(NETWORK)) ;\
	}

miner:
	pm2 start neurons/miner.py --name $(MINER_NAME) --interpreter .venv/bin/python -- \
		--neuron.name $(MINER_NAME) \
		--wallet.name $(COLDKEY) \
		--wallet.hotkey $(MINER_HOTKEY) \
		--subtensor.chain_endpoint $($(NETWORK)) \
		--axon.port $(MINER_PORT) \
		--netuid $(netuid) \
		--logging.debug \

miner_dev:
	uv run python neurons/miner.py \
		--neuron.name $(MINER_NAME) \
		--wallet.name $(COLDKEY) \
		--wallet.hotkey $(MINER_HOTKEY) \
		--subtensor.chain_endpoint $($(NETWORK)) \
		--axon.port $(MINER_PORT) \
		--netuid $(netuid) \
		--logging.debug \
