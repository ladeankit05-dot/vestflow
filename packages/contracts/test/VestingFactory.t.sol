// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VestingFactory.sol";
import "./MockERC20.sol";

contract VestingFactoryTest is Test {
    VestingFactory factory;
    MockERC20 token;

    address creator = address(this);
    address beneficiary = address(0xBEEF);
    uint64 start = 1000;
    uint64 duration = 1000;
    uint256 amount = 50 ether;

    function setUp() public {
        factory = new VestingFactory();
        token = new MockERC20();
    }

    function testCreateVesting() public {
        address vestAddr = factory.createVesting(
            address(token),
            beneficiary,
            start,
            duration,
            amount
        );

        address[] memory creatorVestings = factory.getVestings(creator);
        assertEq(creatorVestings.length, 1);
        assertEq(creatorVestings[0], vestAddr);

        // Verify vesting contract is valid
        LinearVesting vest = LinearVesting(vestAddr);
        assertEq(address(vest.token()), address(token));
        assertEq(vest.beneficiary(), beneficiary);
        assertEq(vest.totalAmount(), amount);
    }
}
