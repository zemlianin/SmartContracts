// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../src/SoulBoundToken.sol"; 

contract SoulBoundTokenTest is Test {
    SoulBoundToken public token;
    address public owner = address(0x123);
    address public addr1 = address(0x456);
    address public addr2 = address(0x789);

    function setUp() public {
        // Разворачиваем контракт от лица владельца
        vm.prank(owner);
        token = new SoulBoundToken();
    }

    function testSafeMint() public {
        vm.prank(owner);
        token.safeMint(addr1);
        assertEq(token.tokenCounter(), 1); 
        assertEq(token.ownerOf(1), addr1); 
    }

    function testMint() public {
        vm.prank(owner);
        token.mint(addr2, 2);
        assertEq(token.ownerOf(2), addr2); 
    }

    function testCannotTransfer() public {
        vm.prank(owner);
        token.safeMint(addr1);

        vm.prank(addr1);
        vm.expectRevert("SBT: transfer not allowed");
        token.transferFrom(addr1, addr2, 1);
    }

    function testCannotApprove() public {
        vm.prank(owner);
        token.safeMint(addr1);

        vm.prank(addr1);
        vm.expectRevert("SBT: approval not allowed");
        token.approve(addr2, 1);
    }

    function testCannotSetApprovalForAll() public {
        vm.prank(owner);
        token.safeMint(addr1);

        vm.prank(addr1);
        vm.expectRevert("SBT: approval not allowed");
        token.setApprovalForAll(addr2, true);
    }
}
