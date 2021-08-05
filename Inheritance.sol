// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;

import "./Owner.sol";

contract InheritanceExample is Owner {
    mapping(address => uint) public tokenBalance;
    
    uint tokenPrice = 1 ether;
    
    constructor() {
        owner = msg.sender;
        tokenBalance[owner] = 100;
    }
    
    function createNewToken() public isOwner {
        tokenBalance[owner]++;
    }
    
    function burnToken() public isOwner {
        tokenBalance[owner]--;
    }
    
    function purchaseToken() public payable {
        require((tokenBalance[owner] * tokenPrice) / msg.value > 0, "There are not enough tokens to make a purchase!");
        
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }
    
    function sendToken(address _to, uint _amount) public {
         require(tokenBalance[msg.sender] >= _amount, "Not enough token to send");
         assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
         assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
         
         tokenBalance[msg.sender] -= _amount;
         tokenBalance[_to] += _amount;
    }
    
    function destroyContract() public isOwner {
        selfdestruct(payable(owner));
        
    }
}