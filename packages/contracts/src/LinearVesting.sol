// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Minimal linear vesting example — use OpenZeppelin in production
contract LinearVesting {
    address public beneficiary;
    uint64 public start;
    uint64 public duration; // seconds
    uint256 public totalAmount;
    uint256 public released;

    event Released(uint256 amount);

    constructor(address _beneficiary, uint64 _start, uint64 _duration, uint256 _totalAmount) {
        require(_beneficiary != address(0), "beneficiary 0");
        require(_duration > 0, "duration 0");
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
        // linear pro-rata
        return (totalAmount * elapsed) / duration;
    }

    function releasable() public view returns (uint256) {
        return vestedAmount(uint64(block.timestamp)) - released;
    }

    function release() public {
        uint256 amount = releasable();
        require(amount > 0, "nothing to release");
        released += amount;
        // NOTE: In production, transfer tokens via ERC20.transfer
        emit Released(amount);
    }
}
