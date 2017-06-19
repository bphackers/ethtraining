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
(TODO: update the etherscan page with the remix link for auto deployment)

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

Adress of the Crowdsale contract : 0x87653df55fcd530fdb900f7d7065f319e0dd6d43


Next steps:

- Transfer the RLC tokens to the crowdsale contract

Open Remix in a web browser (chromium-browser)
https://ethereum.github.io/browser-solidity/?#gist=845a71bf89b5b496d47d1757ff75dde8&version=soljson-v0.4.8+commit.60cc1668.js&optimize=true

on the right side, click on "at adress" on the RLC contract compil and paste the address of the RLC contract you deployed before

0xB242745E8e35a2541355e4ecc550Abc7C41fF91E

Let's take a look at the RLC contract code

lock mecanism activated (true) when the contract is deployed
RLC() initialization function
3 variables are really important hes caact, 87000000000000000 are "created", and the initialSupply is the totalSupply, es ca


Transfer the ownership to the crowdsale contract (commented truffle console lines in the repo)
Call start in the crowdsale contract to begin the ICO

Don't hesitate to modify the variables pin order to finalize without waiting 30 days, or the maxcap...

## IEXEC crowdsale on Mist

launch Mist on the testnet netwoes cat to bob

Alice: 0x3b28F829Fcd70b94dfaF1dec2dFF8e332BD49e9A
Bob:   0x98b87e1dbd378BDBD949EF10B5DD9DA28402108C

Send ropsten ETH to alice (from metamask for example)


## On Kovan

parity --warp --chain=kovan
Create an account for alice and for bob (with password 'assethbox' if )

For me:
Alice 0x00987227A3DB77079697A2291d22EBCd3c00797c
Bob   0x009A8717e7B60F2F289D9Bd13dd4bAF11d0E1090

Get KETH (kovan testnet eth)
Here are a few methods: https://github.com/kovan-testnet/faucet

Go to contracts and click on develop/new
Copy paste the code of RLC.soles ca
Select the good compiler 0.4.8
Select RLC in the list of the contracts
click on deploy (Deploy it via Alice)

Get the adress of the deployed RLC contract
0xc351ba5dB692e00f48512efC785Dcd430EA0394C

Create an address on myetherwallet for BTC proxy
0xDbfe68d4625Cd69210Ebd22de4C697afA83289b3



Go to contracts and click on develop/new
Copy paste the code of Crowdsale.sol, and replace the initialization lines of rlc & BTCproxy:

Replace

    rlc = RLC(0x607F4C5BB672230e8672085532f7e901544a7375);

By the same line with the address of your RLC contract you deploy just before. Here it's:

    rlc = RLC(0xc351ba5dB692e00f48512efC785Dcd430EA0394C);

Create an address on https://www.myetherwallet.com/ to change the address of BTCProxy
Here I generated:

    public: 0xDbfe68d4625Cd69210Ebd22de4C697afA83289b3
    private: fa730b5eb91b7c576a4c6cae4b032bc0c86f855e6d7bb31c4edfdaf43f8df795  

Replace

    BTCproxy = 0x75c6cceb1a33f177369053f8a0e840de96b4ed0e;

By the generated address

    BTCproxy = 0xDbfe68d4625Cd69210Ebd22de4C697afA83289b3;


BTCProxy address is the adress from which receiveBTC is called, the address need some gas if this address has to be used. There are manual entries when payment in BTC is done, emission of RLC directly without using eth, a kind of oracle. We won't use it especially


Select the good compiler 0.4.8
Select Crowdsale in the list of the contracts
click on deploy (Deploy it via Alice)

Crowdsale:
0x8B796Cf1C11A13e2434c8ACF825E4d72de3CF616

Transfer the ownership of the RLC contract to the RLC-crowdsale contract
In parity, go to the RLC contract, click on execture and call the transferOwnership method
Give the address of the RLC-crowdsale contract as parameter

Then verify the owner of the RLC contract in the parity UI

Go to the crowdsale contract
Execute/start to start the ico


TODO : change multisig ETH dans crowdsale


Token tutorial https://www.ethereum.org/token#the-code
0x5628C3dF58a3680ef86AF1006e87de5ccEa0FC49


## Create and deploy your own simple token with Mist

This part is based on this tutorial https://www.ethereum.org/token#minimum-viable-token

Open Mist
You have 2 accounts, bob and alice. If not, create them

Go to contracts/deploy new contract
Paste the content of minimum_viable_token.sol in "solidity contract source code". Read the code quickly to understand it.

On the right side of the screen you could See "Select contract to deploy". Select 'My Token' and fill the requested parameters:
  - Initial supply: 10000
  - Token name:  MyBpHackersToken
  - Decimal units: 2
  - Token symbol: %

Then scroll down and click on 'deploy' (you can increase the fee to the maximum just before)

If you get the red message "Click here to increase the gas amount", click on it. Then type your password and click on send transaction (as Bob)

In your wallet, See the latest transactions, click on the deployment of the contract MyBpHackersToken (admin page) when it's deployed. Paste the adress of Bob in the empty field under "Balance of", to see how much token he has.
You can see he has 10000 (all the supply)

Then let's send some token to Alice. Go to send, from Bob to Alice, and select MyBpHackersToken instead of ether. Send 15% of MyBpHackersToken to Alice

Then if you click on Alice's wallet you can see her owning 15% of MyBpHackersToken

You can deploy this contract, chich is a minimum viable token. You can also deploy improved_token.sol, which is more complicated.

Then we'll focaus on the crowdsale, based on this tutorial: https://www.ethereum.org/crowdsale


Abstract :
- Set up a goal and a deadline
- If you miss your goal, the donations are returned
- no need for a centralized platform , the only fees are gas fees

Problems solved:
- how rewards are managed and kept
- how the money is spent after the funds are raised.
