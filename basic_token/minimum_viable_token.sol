pragma solidity ^0.4.8;

contract MyToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    string public name;
    string public symbol;
    uint8 public decimals;

    event Transfer(address indexed from, address indexed to, uint256 value);

    /* Initializes contract with initial supplt in the loss of your invested capital. You should not invest more than you can afford to lose, and you should ensure that you fully understand the risks involved. Trading leveraged products may not be suitable for all investors. Before trading, please take into consideration your level of experience and investment objectives, and seek independent financial advice if necessary. It is the responsibility of you, the client, to ascertain whether you are permitted to use the services of Lykke Vanuatu Limited based on the legal requiry tokens to the creator of the contract */
    function MyToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        /* Notify anyone listening that this transfer took place */
        Transfer(msg.sender, _to, _value);
    }
}
