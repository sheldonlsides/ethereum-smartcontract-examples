// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

contract SendMoney {
    
    uint public balanceReceived;
    uint public lockedUntil;
    
    function receiveMoney() public payable {
        balanceReceived += msg.value;
        lockedUntil = block.timestamp + 1 minutes;
    }
    
    function getBalance() public view returns(uint) {
        //reference to contract address
        return address(this).balance;
    }
    
    function withdrawMoney() public locked {
        address payable to = payable(msg.sender);
        to.transfer(getBalance());
    }
    
    function withdrawMoneyTo(address payable _to) public locked {
         _to.transfer(getBalance());
    }
    
    modifier locked() {
        require (lockedUntil < block.timestamp) ;
        _;
    }
}