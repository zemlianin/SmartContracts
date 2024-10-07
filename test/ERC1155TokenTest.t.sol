// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ERC1155Token.sol";

contract ERC1155TokenTest is Test {
    ERC1155Token token;
    address user1 = address(0x123);

    function setUp() public {
        token = new ERC1155Token();
    }

    function testBuyToken() public {
        uint256 tokenId = 1;
        uint256 amount = 10;
        uint256 price = 0.01 ether * amount;

        token.buyToken{value: price}(user1, tokenId, amount);

        assertEq(token.balanceOf(user1, tokenId), amount);
    }

    function testFailBuyTokenWithIncorrectValue() public {
        uint256 tokenId = 1;
        uint256 amount = 10;
        
        token.buyToken{value: 0.005 ether}(user1, tokenId, amount); // Ошибка
    }
}
