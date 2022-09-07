pragma solidity >=0.4.22 <0.9.0;

import "./ERC20Interface.sol";

contract ERC20Token is ERC20Interface {

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    uint256 public totSupply;
    string public name;
    uint8 public decimals;
    string public symbol;

    constructor(uint256 _initialAmount, string memory _tokenName, uint8 _decimals, string memory _symbol) public {
        balances[msg.sender] = _initialAmount;
        totSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimals;
        symbol = _symbol;
    }

    function transfer(address to, uint value) public returns (bool success) {
        require(balances[msg.sender] >= value, "Insufficient funds");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        uint256 allowance = allowed[from][msg.sender];
        require(balances[from] >= tokens && allowance >= tokens);
        balances[from] -= tokens;
        balances[to] += tokens;
        if(allowance < MAX_UINT256) {
            allowed[from][msg.sender] -= tokens;
        }
        emit Transfer(from, to, tokens);
        return true;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function approve(address spender, uint tokens) public returns (bool success){
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function totalSupply() public view returns (uint) {
        return totSupply;
    }
}
