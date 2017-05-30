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


    pragma solidity ^0.4.8;

    contract ERC20 {
      uint public totalSupply;
      function balanceOf(address who) constant returns (uint);
      function allowance(address owner, address spender) constant returns (uint);

      function transfer(address to, uint value) returns (bool ok);
      function transferFrom(address from, address to, uint value) returns (bool ok);
      function approve(address spender, uint value) returns (bool ok);
      event Transfer(address indexed from, address indexed to, uint value);
      event Approval(address indexed owner, address indexed spender, uint value);
    }


    contract Ownable {
      address public owner;

      function Ownable() {
        owner = msg.sender;
      }

      modifier onlyOwner() {
        if (msg.sender == owner)
          _;
      }

      function transferOwnership(address newOwner) onlyOwner {
        if (newOwner != address(0)) owner = newOwner;
      }

    }


    contract TokenSpender {
        function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
    }

    contract SafeMath {
      function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
      }

      function safeDiv(uint a, uint b) internal returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
      }

      function safeSub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
      }

      function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
      }

      function max64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a >= b ? a : b;
      }

      function min64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a < b ? a : b;
      }

      function max256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a >= b ? a : b;
      }

      function min256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a < b ? a : b;
      }

      function assert(bool assertion) internal {
        if (!assertion) {
          throw;
        }
      }
    }


    contract RLC is ERC20, SafeMath, Ownable {

        /* Public variables of the token */
      string public name;       //fancy name
      string public symbol;
      uint8 public decimals;    //How many decimals to show.
      string public version = 'v0.1';
      uint public initialSupply;
      uint public totalSupply;
      bool public locked;
      //uint public unlockBlock;

      mapping(address => uint) balances;
      mapping (address => mapping (address => uint)) allowed;

      // lock transfer during the ICO
      modifier onlyUnlocked() {
        if (msg.sender != owner && locked) throw;
        _;
      }

      /*
       *  The RLC Token created with the time at which the crowdsale end
       */

      function RLC() {
        // lock the transfer function during the crowdsale
        locked = true;
        //unlockBlock=  now + 45 days; // (testnet) - for mainnet put the block number

        initialSupply = 87000000000000000;
        totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;// Give the creator all initial tokens                    
        name = 'iEx.ec Network Token';        // Set the name for display purposes     
        symbol = 'RLC';                       // Set the symbol for display purposes  
        decimals = 9;                        // Amount of decimals for display purposes
      }

      function unlock() onlyOwner {
        locked = false;
      }

      function burn(uint256 _value) returns (bool){
        balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
        totalSupply = safeSub(totalSupply, _value);
        Transfer(msg.sender, 0x0, _value);
        return true;
      }

      function transfer(address _to, uint _value) onlyUnlocked returns (bool) {
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
      }

      function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool) {
        var _allowance = allowed[_from][msg.sender];

        balances[_to] = safeAdd(balances[_to], _value);
        balances[_from] = safeSub(balances[_from], _value);
        allowed[_from][msg.sender] = safeSub(_allowance, _value);
        Transfer(_from, _to, _value);
        return true;
      }

      function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
      }

      function approve(address _spender, uint _value) returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
      }

        /* Approve and then comunicate the approved contract in a single tx */
      function approveAndCall(address _spender, uint256 _value, bytes _extraData){    
          TokenSpender spender = TokenSpender(_spender);
          if (approve(_spender, _value)) {
              spender.receiveApproval(msg.sender, _value, this, _extraData);
          }
      }

      function allowance(address _owner, address _spender) constant returns (uint remaining) {
        return allowed[_owner][_spender];
      }

    }


If you don't want to copy paste the code above go to     https://ethereum.github.io/browser-solidity/?#gist=845a71bf89b5b496d47d1757ff75dde8&version=soljson-v0.4.8+commit.60cc1668.js&optimize=true

Add a 0 to trasaction gas limit of remix  30000000

Here the tx to deploy
https://ropsten.etherscan.io/tx/0x97f52c2ccfaa74269591ff0fac5e32e7b0aae942e91f4315c9a3ecba4bd8bf7f
Here the deployed contract
https://ropsten.etherscan.io/address/0xb242745e8e35a2541355e4ecc550abc7c41ff91e

The bytecode is supposed to be the same 
