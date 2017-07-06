# Hello, this is the Parity workshop on how to deploy ICO smart contracts

## 1. Environment setup (assethbox)
----

Download the latest version of the assethbox (download the .ova file) [here](https://github.com/asseth/assethbox)
Download the latest version of Virtual Box [here](https://www.virtualbox.org/)

Then open Virtualbox, File/import a new virtual machine with the assethbox.ova file

Login into the VM

    user: vagrant
    password: vagrant

## 2. Parity setup
----

Launch Terminator (Alt+F2 then type terminator, then enter)

Clone the bphackers ethtraining repo by typing these commands into the terminal:

    git clone https://github.com/bphackers/ethtraining.git

Sync the blockchain using parity:

    parity --warp --chain=kovan

Launch Chromium and go to 

    localhost:8080

Create your user account following the instructions

*In order to get ETH on your account, copy your adress and paste it on this file: [https://frama.link/bnp](https://frama.link/bnp), we will send you some

>If later you want to get KETH (kovan testnet eth)
Here are a few methods: https://github.com/kovan-testnet/faucet

## 3. ICO activity (Token deployment)
----

*One of the participant has a startup and wants to raise funds. This participant will deploy ICO smart contracts*

Deploy the token smart contract:

Go to "Contracts" on parity and then "Develop"
Copy this code on the left part of the screen:

    pragma solidity ^0.4.8;
    contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }

    contract MyToken {
        /* Public variables of the token */
        string public standard = 'Token 0.1';
        string public name;
        string public symbol;
        uint8 public decimals;
        uint256 public totalSupply;

        /* This creates an array with all balances */
        mapping (address => uint256) public balanceOf;
        mapping (address => mapping (address => uint256)) public allowance;

        /* This generates a public event on the blockchain that will notify clients */
        event Transfer(address indexed from, address indexed to, uint256 value);

        /* This notifies clients about the amount burnt */
        event Burn(address indexed from, uint256 value);

        /* Initializes contract with initial supply tokens to the creator of the contract */
        function MyToken(
            uint256 initialSupply,
            string tokenName,
            uint8 decimalUnits,
            string tokenSymbol
            ) {
            balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
            totalSupply = initialSupply;                        // Update total supply
            name = tokenName;                                   // Set the name for display purposes
            symbol = tokenSymbol;                               // Set the symbol for display purposes
            decimals = decimalUnits;                            // Amount of decimals for display purposes
        }

        /* Send coins */
        function transfer(address _to, uint256 _value) {
            if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
            if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
            if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
            balanceOf[msg.sender] -= _value;                     // Subtract from the sender
            balanceOf[_to] += _value;                            // Add the same to the recipient
            Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
        }

        /* Allow another contract to spend some tokens in your behalf */
        function approve(address _spender, uint256 _value)
            returns (bool success) {
            allowance[msg.sender][_spender] = _value;
            return true;
        }

        /* Approve and then communicate the approved contract in a single tx */
        function approveAndCall(address _spender, uint256 _value, bytes _extraData)
            returns (bool success) {
            tokenRecipient spender = tokenRecipient(_spender);
            if (approve(_spender, _value)) {
                spender.receiveApproval(msg.sender, _value, this, _extraData);
                return true;
            }
        }

        /* A contract attempts to get the coins */
        function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
            if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
            if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
            if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
            if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
            balanceOf[_from] -= _value;                           // Subtract from the sender
            balanceOf[_to] += _value;                             // Add the same to the recipient
            allowance[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        }

        function burn(uint256 _value) returns (bool success) {
            if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
            balanceOf[msg.sender] -= _value;                      // Subtract from the sender
            totalSupply -= _value;                                // Updates totalSupply
            Burn(msg.sender, _value);
            return true;
        }

        function burnFrom(address _from, uint256 _value) returns (bool success) {
            if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
            if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
            balanceOf[_from] -= _value;                          // Subtract from the sender
            totalSupply -= _value;                               // Updates totalSupply
            Burn(_from, _value);
            return true;
        }
    }

Press "compile" and then "deploy"
Be sure that the contract selected is "My_Token"
Give a name to your contract and press next

Choose your parameters and press create

Confirm the request by entering your password

## 4. ICO activity (Crowdsale deployment)
----

Following the same process, deploy this contract: 

    pragma solidity ^0.4.2;
    contract token { function transfer(address receiver, uint amount); }

    contract Crowdsale {
        address public beneficiary;
        uint public fundingGoal; uint public amountRaised;
        //uint public deadline;
        uint public price;
        token public tokenReward;
        mapping(address => uint256) public balanceOf;
        bool public fundingGoalReached = false; // rajout pub
        event GoalReached(address beneficiary, uint amountRaised);
        event FundTransfer(address backer, uint amount, bool isContribution);
        bool public crowdsaleClosed = false; // rajout public

        /* data structure to hold information about campaign contributors */

        /*  at initialization, setup the owner */
        function Crowdsale(
            address ifSuccessfulSendTo,
            uint fundingGoalInEthers,
            //uint durationInMinutes,
            uint etherCostOfEachToken,
            token addressOfTokenUsedAsReward
        ) {
            beneficiary = ifSuccessfulSendTo;
            fundingGoal = fundingGoalInEthers * 1 ether;
            //deadline = now + durationInMinutes * 1 minutes;
            price = etherCostOfEachToken * 1 ether;
            tokenReward = token(addressOfTokenUsedAsReward);
        }

        /* The function without name is the default function that is called whenever anyone sends funds to a contract */
        function () payable {
            if (crowdsaleClosed) throw;
            uint amount = msg.value;
            balanceOf[msg.sender] += amount;
            amountRaised += amount;
            tokenReward.transfer(msg.sender, amount / price);
            FundTransfer(msg.sender, amount, true);
        }

        //modifier afterDeadline() { if (now >= deadline) _; }

        /* checks if the goal or time limit has been reached and ends the campaign */
        function checkGoalReached() { //afterDeadline {
            if (amountRaised >= fundingGoal){
                fundingGoalReached = true;
                GoalReached(beneficiary, amountRaised);
            }
            crowdsaleClosed = true;
        }


        function safeWithdrawal() { //afterDeadline {
            if (!fundingGoalReached) {
                uint amount = balanceOf[msg.sender];
                balanceOf[msg.sender] = 0;
                if (amount > 0) {
                    if (msg.sender.send(amount)) {
                        FundTransfer(msg.sender, amount, false);
                    } else {
                        balanceOf[msg.sender] = amount;
                    }
                }
            }

            if (fundingGoalReached && beneficiary == msg.sender) {
                if (beneficiary.send(amountRaised)) {
                    FundTransfer(beneficiary, amountRaised, false);
                } else {
                    //If we fail to send the funds to beneficiary, unlock funders balance
                    fundingGoalReached = false;
                }
            }
        }
    }

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