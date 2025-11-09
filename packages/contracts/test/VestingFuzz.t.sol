// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/LinearVesting.sol";
import "./MockERC20.sol";

contract VestingFuzzTest is Test {
    LinearVesting vest;
    MockERC20 token;

    function setUp() public {
        token = new MockERC20();
    }

    function testFuzzVesting(uint64 start, uint64 duration, uint256 amount) public {
        vm.assume(duration > 0 && amount > 0);
        vm.assume(start < block.timestamp + 1e12); // avoid overflow

        address beneficiary = address(0xBEEF);

        vest = new LinearVesting(
            address(token),
            beneficiary,
            start,
            duration,
            amount
        );

        token.mint(address(vest), amount);

        // Pick random timestamp in the vesting window
        uint64 testTime = start + (uint64(bound(uint256(block.timestamp), 0, duration)));

        uint256 vested = vest.vestedAmount(testTime);

        assertLe(vested, amount);
    }
}
