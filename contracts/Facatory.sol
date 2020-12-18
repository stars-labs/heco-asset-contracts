pragma solidity =0.6.6;

import './ERC20Sample.sol';



contract ERC20Factory {
    event ERC20Created(address tokenAddress,string symbol,uint id); 
    address[] public allTokens;
    address public superAdmin;
    //construct
    constructor(address admin) public{
        superAdmin = admin;
    }

    modifier onlySuperAdmin(){
        require(msg.sender == superAdmin,"not allowed");
        _;
    }

    function allTokensLength() external view returns (uint){
        return allTokens.length;
    }

    function createToken(address operator,address pauser,string memory name, string memory symbol,uint8 decimal)
        onlySuperAdmin public returns(address tokenAddress) {
        bytes32 salt = keccak256(abi.encodePacked(name, symbol,decimal));
        ERC20Template token = new ERC20Template{salt:salt}(operator,pauser,name,symbol,decimal);
        tokenAddress = address(token);
        allTokens.push(tokenAddress);
        emit ERC20Created(tokenAddress,symbol,allTokens.length);
        
    }
    function changeTokenUser(address token_address,address new_pauser, address new_operator) onlySuperAdmin public {
       ERC20Template token= ERC20Template(token_address);
       token.changeUser(new_operator,new_pauser);
    }

    function changeSuperAdmin(address new_admin) onlySuperAdmin public {
        superAdmin=new_admin;
    }

}