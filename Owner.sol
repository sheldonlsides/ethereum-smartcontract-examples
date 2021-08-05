// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;

contract Owner {
    address owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier isOwner() {
        require (msg.sender == owner, "Only the contract owner can perform this operation!") ;
        _;
    }
}