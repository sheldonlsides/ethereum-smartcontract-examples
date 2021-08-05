// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract Mappings {
    struct Payment {
        uint amount;
        uint timestamps;
    }
    
    struct Balance {
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }
    
    //stores mapping of addresses
    mapping(address => Balance) public balanceReceived;
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function sendMoney() public payable {
        //makes sure value being sent is greater than zero
        require (msg.value != 0, "You must send a value greater than zero!") ;
    
        assert(balanceReceived[msg.sender].totalBalance + uint64(msg.value) >= balanceReceived[msg.sender].totalBalance);
        //increments value of balanceReceived from current sender by the value the current address sent to contract
        balanceReceived[msg.sender].totalBalance += msg.value;
        
        Payment memory payment = Payment(msg.value, block.timestamp);
        
        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numPayments] = payment;
        balanceReceived[msg.sender].numPayments++;
    }
    
    //remember amount should be passed in as wei
    function withdrawSomeMoney(address payable _to, uint _amount) public {
        //validates enough eth exist in address to send value
        require (balanceReceived[msg.sender].totalBalance >= _amount, "You don't have enough ETH to send! Check your balance and try again.");
        
        assert(balanceReceived[msg.sender].totalBalance >= balanceReceived[msg.sender].totalBalance - _amount);
        
        //decrements the amount from current address total
        balanceReceived[msg.sender].totalBalance -= _amount;
        
        _to.transfer(_amount);
    }
    
    function withdrawAllMoney(address payable _to) public payable notZeroBalance {
        require (balanceReceived[msg.sender].totalBalance > 0, "You have no ETH to withdraw!");
        assert(balanceReceived[msg.sender].totalBalance >= balanceReceived[msg.sender].totalBalance - msg.value);
         
        //stores the balance that has been received by the contract from the current address
        uint balanceToSend = balanceReceived[msg.sender].totalBalance;
        
        reset();
        
        //sends by total eth to current address
        _to.transfer(balanceToSend);
    }
    
    function reset() private {
        balanceReceived[msg.sender].numPayments = 0;
        balanceReceived[msg.sender].totalBalance = 0;
    }
    
    modifier notZeroBalance() {
        require (getBalance() != 0, "You have no ETH to send!") ;
        _;
    }
}