Download the latest version of the assethbox (download the .ova file) [here](https://github.com/asseth/assethbox), then open Virtualbox, File/import a new virtual machine

Click the bottom left of the screen to open software list, then go to System tools/terminator

Sync the ropsten testnet blockchain . It is 1 hour 40 minutes long (23th May 2017)

    geth init ropsten.json
    geth --testnet --networkid 3

In another terminal

    geth account --testnet new
    password 'assethbox' if you have no ideas (only for testing purpose of course)
    geth attach ~/.ethereum/testnet/geth.ipc
    miner.setEtherbase(eth.accounts[0])
    miner.setExtra("BPHACKERS")
    miner.start(2)


Wait a few minutes, then check if you got testnet ethers

    web3.fromWei(eth.getBalance(eth.accounts[0]), "ether")

--------------------------------------------------------------------------

sudo apt-get install ethminer
parity --chain ropsten


---------------------------------------------------------------------------
git clone https://github.com/iExecBlockchainComputing/rlc-token
