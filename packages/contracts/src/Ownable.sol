// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Minimal Ownable (simplified OpenZeppelin)
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previous, address indexed current);

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
