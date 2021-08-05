// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Mappings {
    using SafeMath for uint;
    
    //stores mapping of addresses
    mapping(address => uint) public balanceReceived;
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function sendMoney() public payable {
        //makes sure value being sent is greater than zero
        require (msg.value != 0, "You must send a value greater than zero!") ;
        
        //increments value of balanceReceived from current sender by the value the current address sent to contract
        balanceReceived[msg.sender] = balanceReceived[msg.sender].add(msg.value);
    }
    
    //remember amount should be passed in as wei
    function withdrawSomeMoney(address payable _to, uint _amount) public {
        //validates enough eth exist in address to send value
        require (balanceReceived[msg.sender] >= _amount, "You don't have enough ETH to send! Check your balance and try again.");
        
        //decrements the amount from current address total
        balanceReceived[msg.sender] = balanceReceived[msg.sender].sub(_amount);
        
        _to.transfer(_amount);
    }
    
    function withdrawAllMoney(address payable _to) public notZeroBalance {
        require (balanceReceived[msg.sender] > 0, "You have no ETH to withdraw!");
        
        //stores the balance that has been received by the contract from the current address
        uint balanceToSend = balanceReceived[msg.sender];
        
        //sets the balanceReceived by the contract to 0 for the current address
        balanceReceived[msg.sender] = 0;
        
        //sends by total eth to current address
        _to.transfer(balanceToSend);
    }
    
    modifier notZeroBalance() {
        require (getBalance() != 0, "You have no ETH to send!") ;
        _;
    }
}