// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;

contract FunctionExample {
    address payable public owner;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    mapping(address =>  uint) public balanceReceived;
    
    function getContractBalance() public view returns(uint) {
        return address(this).balance / 1 ether;     
    }
    
    function receiveMoney() public payable {
        //makes sure value being sent is greater than zero
        require (msg.value != 0, "You must send a value greater than zero!") ;
        
        assert(balanceReceived[msg.sender] + uint64(msg.value) >= balanceReceived[msg.sender]);
        
        balanceReceived[msg.sender] += msg.value;
    }
    
    
    function withdrawMoney(address payable _to, uint _amount) public {
        //validates enough eth exist in address to send value
        require (balanceReceived[msg.sender] >= _amount, "You don't have enough ETH to send! Check your balance and try again.");
        
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        
        //decrements the amount from current address total
        balanceReceived[msg.sender] -= _amount;
        
        _to.transfer(_amount);
    }
    
    function destroyContract() public {
        require(msg.sender == owner, "Only the owner can call this function!");
        selfdestruct(owner);
    }
    
    //a function that can be called by anyone to send ETH to the contract
    receive() external payable {
        receiveMoney();
    }
    
    //a function that can be called by anyone to send ETH to the contract
    fallback() external payable {
        receiveMoney();
    }
}