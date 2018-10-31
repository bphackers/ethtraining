# Hello, this is the Parity workshop on how to deploy ICO smart contracts

## 1. Software install 
----

Download the latest version of parity or geth
Install Metamask on Chrome or Firefox
Download the latest version of remix

## 2. Parity setup & infrastructure setup
----

Launch a terminal 

Sync the blockchain using parity:

    parity --chain=kovan --jsonrpc-apis=all --jsonrpc-hosts=all --jsonrpc-cors=all 

Launch remix

    remix-ide

Launch metamask and create 3 accounts

    one named CEO account
    
    one named Investor Account
    
    one named Faucet (this one will be used only to store your ether surplus)
    
Request Ethers from a faucet or from a token holder

## 3. ICO activity (Token deployment)
----

*One of the participant has a startup and wants to raise funds. This participant will deploy ICO smart contracts*

Deploy the token smart contract: token.sol

Press "compile" and then "deploy"
Be sure that the contract selected is "My_Token"
Give a name to your contract and press next

Choose your parameters and press create

Confirm the request by entering your password

## 4. ICO activity (Crowdsale deployment)
----

Following the same process, deploy this contract: crowdsale.sol

After deploying the contract we have to transfer the tokens to the crowdsale contract:
Go to "contracts", select the first contract you deployed and press "execute"

Select the amount of tokens you are willing to sell with the "transfer function", pointing to the adress of your crowdsale.

*go check on the token contract if the balance of the crowdsale contract has the good amount of token using "balanceOf"*

## 5. ICO activity (crowdsale)
----

*Investors will now be able to send ETH to the adress of your contract*

From an investor account, click on transfer
Enter the adress of the crowdsale contract and the amount you want to invest.

Investors can check if they have received their tokens:
Go to the token contract, use balanceOf to know the amount of tokens you have on your adress.

## 6. ICO activity (fund transfer)
----

*Now the ICO has ended, the Startup wants to retrieve the ETH raised during the crowdsale*

The startup account goes to the crowdsale contract and press execute. 
We want to check if the funding goal was reached, select this function and execute it. You should now see on the contract page "fundingGoalReached = true"

Execute the contract again but this time using the funtion "safeWithdrawal"
The startup account now has received the fund raised. 
