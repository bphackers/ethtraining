Download the latest version of the assethbox (download the .ova file) [here](https://github.com/asseth/assethbox), then open Virtualbox, File/import a new virtual machine


Login into the VM

    user: vagrant
    password: vagrant

Launch Terminator (Alt+F2 then type terminator, then enter)

Clone the bphackers ethtraining repo by typing these commands into the terminal:

    git clone https://github.com/bphackers/ethtraining.git
    cd ethtraining/crowdsale2 (TODO:change)
    sudo chmod +x launch_geth_private_chain.sh

Launch geth (private chain)

    ./launch_geth_private_chain.sh



In another terminal ('CTRL + Shift + o' with terminator to split horizontally your terminal)

    geth attach ~/.ethereum/bnp9991/geth.ipc

You are in the geth console, you can type command after '>' letter

    personal.newAccount()

Verify your coinbase

    eth.coinbase

Start mining

    miner.start(1)

In another terminal ('CTRL + Shift + e' with terminator to split vertically your terminal)

    /opt/Mist/mist --rpc ~/.ethereum/bnp9991/geth.ipc
