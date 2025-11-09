// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

contract LinearVesting is ReentrancyGuard {
    IERC20 public token;
    address public beneficiary;
    uint64 public start;
    uint64 public duration; // seconds
    uint256 public totalAmount;
    uint256 public released;

    event Released(uint256 amount);

    constructor(
        address _token,
        address _beneficiary,
        uint64 _start,
        uint64 _duration,
        uint256 _totalAmount
    ) {
        require(_token != address(0), "token 0");
        require(_beneficiary != address(0), "beneficiary 0");
        require(_duration > 0, "duration 0");

        token = IERC20(_token);
        beneficiary = _beneficiary;
        start = _start;
        duration = _duration;
        totalAmount = _totalAmount;
        released = 0;
    }

    function vestedAmount(uint64 timestamp) public view returns (uint256) {
        if (timestamp < start) {
            return 0;
        }
        uint64 elapsed = timestamp - start;
        if (elapsed >= duration) {
            return totalAmount;
        }
        return (totalAmount * elapsed) / duration;
    }

    function releasable() public view returns (uint256) {
        return vestedAmount(uint64(block.timestamp)) - released;
    }

    function release() public nonReentrant {
        require(msg.sender == beneficiary, "not beneficiary");

        uint256 amount = releasable();
        require(amount > 0, "nothing to release");

        released += amount;
        require(token.transfer(beneficiary, amount), "transfer failed");

        emit Released(amount);
    }
}
