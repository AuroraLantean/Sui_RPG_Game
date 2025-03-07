# Sui RPG Game

## Installation and Setup
Install Sui: https://docs.sui.io/guides/developer/getting-started/sui-install

setup accounts
```
sui --version
make new_addr
make activate_addr
sui client switch --address YOUR_ADDRESS
make balance
make faucet
make activate_testnet
```

#### Set Network to Testnet
```
sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443
sui client switch --env testnet
sui client envs
```
#### Setup Account
```
sui client new-address ed25519
sui client active-address
```
#### Get Test Tokens
```
sui client balance
sui client faucet
sui client gas
```

#### Publish Crowdfunding_pricefeed
```
sui client publish --gas-budget 50000000
sui client publish --gas-budget 50000000  --skip-dependency-verification
```
published package: 
0x72bbc6d77698a5d5133bcd7496398f735e7ba5a7c4e8ad61b0c09035e3b234c6

UpgradeCap:
0xef9ab50c5d3cea4f7e8464337531a632f2709a549656c9f9ba26275c533d9f7f


Check the transaction digest in Suivision.xyz

Find the PackageID:


Go to SuiScan.xyz and find a list of modules under that package

#### Fungible Coin
