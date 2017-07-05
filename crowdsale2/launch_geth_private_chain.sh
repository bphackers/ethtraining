geth --datadir ~/.ethereum/bnp999 init ./genesis999.json
geth --datadir ~/.ethereum/bnp999 --networkid 999 console


In another terminal ('CTRL + Shift + o' with terminator to split horizontally your terminal)

    geth attach ~/.ethereum/bnp999/geth.ipc

You are in the geth console, you can type command after '>' letter

    personal.newAccount()

Verify your coinbase
    eth.coinbase

Start mining
    miner.start(1)

In another terminal ('CTRL + Shift + e' with terminator to split vertically your terminal)

    mist --rpc ~/.ethereum/bnp999/geth.ipc
