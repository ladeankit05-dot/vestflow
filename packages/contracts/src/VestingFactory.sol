// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./LinearVesting.sol";

contract VestingFactory {
    event VestingCreated(
        address indexed creator,
        address indexed vestingContract,
        address token,
        address beneficiary,
        uint256 amount,
        uint64 start,
        uint64 duration
    );

    address[] public allVestingContracts;
    mapping(address => address[]) public vestingsByCreator;

    function createVesting(
        address token,
        address beneficiary,
        uint64 start,
        uint64 duration,
        uint256 amount
    ) external returns (address) {
        LinearVesting vest = new LinearVesting(
            token,
            beneficiary,
            start,
            duration,
            amount
        );

        allVestingContracts.push(address(vest));
        vestingsByCreator[msg.sender].push(address(vest));

        emit VestingCreated(
            msg.sender,
            address(vest),
            token,
            beneficiary,
            amount,
            start,
            duration
        );

        return address(vest);
    }

    function getVestings(address creator) external view returns (address[] memory) {
        return vestingsByCreator[creator];
    }
}
