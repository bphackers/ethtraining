Download the latest version of the assethbox (download the .ova file) [here](https://github.com/asseth/assethbox), then open Virtualbox, File/import a new virtual machine

## Mining with geth

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


## Begin with Parity

    sudo apt-get install ethminer
    parity --warp --chain ropsten

At the time of the workshop (end May 2017), warp mode seems to be broken and confirmed on parity gitter by the team, only fast mode works, takes ? hours

Open a browser and go to localhost:8081
Create an account, password 'assethbox' if you have no ideas (only for testing purpose of course)

Go to settings on parity UI, and check everything


## Deploy your the Iexec ICO

Open chromium-browser, click on the top right/more tools/extensions
Install "Metamask"
In Metamask, create your account, and switch to the ropsten testnet
Click on buy and go to the metamask ropsten faucet
Ask for some eths


Clone the Iexec repo

    git clone https://github.com/iExecBlockchainComputing/rlc-token


Browse the repo. There are 2 main contracts : RLC and crowdsale. First, deploy the RLC contract. RLC contract depends of other contracts we paste with
Original contract has been deployed here : https://etherscan.io/address/0x607F4C5BB672230e8672085532f7e901544a7375#code

The code is the file RLC.sol

If you don't want to copy paste the code go to     https://ethereum.github.io/browser-solidity/?#gist=845a71bf89b5b496d47d1757ff75dde8&version=soljson-v0.4.8+commit.60cc1668.js&optimize=true

Add a 0 to trasaction gas limit of remix  30000000


Here the tx to deploy
https://ropsten.etherscan.io/tx/0x97f52c2ccfaa74269591ff0fac5e32e7b0aae942e91f4315c9a3ecba4bd8bf7f
Here the deployed contract
https://ropsten.etherscan.io/address/0xb242745e8e35a2541355e4ecc550abc7c41ff91e

the address of the RLC contract is : 0xB242745E8e35a2541355e4ecc550Abc7C41fF91E


Deploy the crowdsale contract

Original contract has been deployed here:
https://etherscan.io/address/0xec33fb8d7c781f6feaf2dd46d521d4f292320200


Paste the code of Crowdsale.sol in remix and replace the initialization lines of rlc & BTCproxy:

Replace

    rlc = RLC(0x607F4C5BB672230e8672085532f7e901544a7375);

By the same line with the address of your RLC contract you deploy just before. Here it's:

    rlc = RLC(0xB242745E8e35a2541355e4ecc550Abc7C41fF91E);

Create an address on https://www.myetherwallet.com/ to change the address of BTCProxy
Here I generated:

    public: 0xDbfe68d4625Cd69210Ebd22de4C697afA83289b3
    private: fa730b5eb91b7c576a4c6cae4b032bc0c86f855e6d7bb31c4edfdaf43f8df795  

Replace

    BTCproxy = 0x75c6cceb1a33f177369053f8a0e840de96b4ed0e;

By the generated address

    BTCproxy = 0xDbfe68d4625Cd69210Ebd22de4C697afA83289b3;


BTCProxy address is the adress from which receiveBTC is called, the address need some gas if this address has to be used. There are manual entries when payment in BTC is done, emission of RLC directly without using eth, a kind of oracle. We won't use it especially

Deploy the contract crowdsale by adding a 0 to trasaction gas limit of remix  30000000

Here the deployed contract
https://ropsten.etherscan.io/tx/0xa037b87be681ce60f76057f2c3742bbbe73e5f2a4fbd0ee9cf6da6944a3af774


Next steps:

Transfer the RLC tokens to the crowdsale contract
Transfer the ownership to the crowdsale contract (commented truffle console lines in the repo)
Call start in the crowdsale contract to begin the ICO
