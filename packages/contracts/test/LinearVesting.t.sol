// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/LinearVesting.sol";
import "./MockERC20.sol";

contract LinearVestingERC20Test is Test {
    LinearVesting vest;
    MockERC20 token;

    address beneficiary = address(0xBEEF);
    uint64 start = 1000;
    uint64 duration = 1000; 
    uint256 amount = 100 ether;

    function setUp() public {
        token = new MockERC20();

        vest = new LinearVesting(
            address(token),
            beneficiary,
            start,
            duration,
            amount
        );

        token.mint(address(vest), amount);
    }

    function testNoReleaseBeforeStart() public {
        vm.warp(start - 1);
        vm.prank(beneficiary);
        vm.expectRevert("nothing to release");
        vest.release();
    }

    function testPartialReleaseHalfway() public {
        vm.warp(start + duration / 2);
        vm.prank(beneficiary);
        vest.release();

        assertEq(token.balanceOf(beneficiary), amount / 2);
    }

    function testFullReleaseAfterEnd() public {
        vm.warp(start + duration + 1);
        vm.prank(beneficiary);
        vest.release();

        assertEq(token.balanceOf(beneficiary), amount);
    }
}
