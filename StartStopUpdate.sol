// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

contract StartStopUpdate {
    address owner;
    bool paused;
    
    constructor() {
        owner = msg.sender;    
    }
    
    function sendMoney() public payable {
        
    }
    
    function setPaused(bool _paused) public isOwner {
        paused = _paused;
    }
    
    function contractOwner() public view returns(address) {
        return owner;
    }
    
    function withdrawAllMoney(address payable _to) public isOwner isPaused {
        _to.transfer(address(this).balance);
    }
    
     function getBalance() public view returns(uint) {
        //reference to contract address
        return address(this).balance;
    }
    
    
    function destroySmartContract(address payable _to) public isOwner {
        selfdestruct(_to);
    }
    
     modifier isOwner() {
        require (owner == msg.sender, "You are not the owner of the contract!") ;
        _;
    }
    
    modifier isPaused() {
        require (!paused, "The contract is paused!") ;
        _;
    }
}   