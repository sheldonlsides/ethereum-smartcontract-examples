// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "./Owner.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    
    mapping(address => uint) public allowance;
    
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
    
    function setAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }
    
    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }
    
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You can't perform this action!");
        _;
    }
    
    function renounceOwnership() public view override onlyOwner {
        revert("You can't renounceOwnership in this smart contract"); //not possible with this smart contract
    }
}

contract SharedWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough money");
        
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    receive() external payable {
        require (msg.value != 0, "You must send a value greater than zero!") ;
        emit MoneyReceived(msg.sender, msg.value);
    }
    
    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }
}