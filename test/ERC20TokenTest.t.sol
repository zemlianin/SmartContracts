// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ERC20Token.sol";
import "forge-std/Test.sol";

contract ERC20TokenTest is Test {
    ERC20TokenWithFeeAndPermit token;
    address user1 = address(vm.addr(1));
    address user2 = address(0x456);

    function setUp() public {
        token = new ERC20TokenWithFeeAndPermit(); // 1% комиссия
    }

    function testInitialSupply() public {
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18);
    }

    function testTransferWithFee() public {
        token.transfer(user1, 100 * 10 ** 18);

          assertEq(token.balanceOf(user1), 99 * 10 ** 18); 
          assertEq(token.balanceOf(address(this)), 901 * 10 ** 18);
          assertEq(token.balanceOf(token.owner()), (901) * 10 ** 18);
    }


    function testTransferFromWithFee() public {
        token.transfer(user2, 1000 * 10 ** 18);

        vm.prank(user2);
        token.approve(address(this), 100 * 10 ** 18);

        token.transferFrom(user2, user1, 100 * 10 ** 18);

        assertEq(token.balanceOf(user2), 890 * 10 ** 18);  
        assertEq(token.balanceOf(user1), 99 * 10 ** 18); 
        assertEq(token.balanceOf(token.owner()), 11 * 10 ** 18);
    }


    function testBuyToken() public {
        // Проверяем покупку токенов
        token.buyToken{value: 1 ether}();
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18 + 100 ether); 
    }

function testPermit() public {
    uint256 nonce = token.nonces(user1); 
    uint256 deadline = block.timestamp + 1 hours; 

    // Формируем хеш EIP712 для подписи
    bytes32 structHash = keccak256(
        abi.encode(
            keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
            user1, 
            user2, 
            100 * 10 ** 18, 
            nonce, 
            deadline 
        )
    );

    bytes32 hash = keccak256(
        abi.encodePacked(
            "\x19\x01", 
            token.DOMAIN_SEPARATOR(),
            structHash
        )
    );


   (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash);

   token.permit(user1, user2, 100 * 10 ** 18, deadline, v, r, s);

    assertEq(token.allowance(user1, user2), 100 * 10 ** 18);


    token.transfer(user1, 1000 * 10 ** 18);
    uint256 initialBalanceUser1 = token.balanceOf(user1);
    address recipient = vm.addr(3);

    vm.prank(user2); 
    token.transferFrom(user1, recipient, 100 * 10 ** 18);

    assertEq(token.balanceOf(user1), initialBalanceUser1 - 100 * 10 ** 18); 
    assertEq(token.balanceOf(recipient), 99 * 10 ** 18);
}


//    function testWithdrawEther() public {
//        uint256 balanceBefore = address(this).balance;
//        token.buyToken{value: 1 ether}(); 
//        token.withdrawEther();
//        assertEq(address(this).balance, balanceBefore + 1 ether);
//    }
}
