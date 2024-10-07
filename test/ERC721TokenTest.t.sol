// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ERC721Token.sol";

contract ERC721TokenTest is Test {
    ERC721Token token;

    function setUp() public {
        token = new ERC721Token();
    }

    function testBuyNFT() public {
        string memory tokenURI = "https://gold-near-fox-74.mypinata.cloud/ipfs/QmZmvFqtuGX8fYqXDdjEAd5BWLRp8nt6K9zMizcdYKAfUY";
        uint256 price = 0.01 ether;

        token.buyNFT{value: price}(tokenURI);

        assertEq(token.ownerOf(1), address(this));
        assertEq(token.tokenURI(1), tokenURI);
    }

    function testFailBuyNFTWithIncorrectValue() public {
        string memory tokenURI = "https://gold-near-fox-74.mypinata.cloud/ipfs/QmZmvFqtuGX8fYqXDdjEAd5BWLRp8nt6K9zMizcdYKAfUY";
        token.buyNFT{value: 0.005 ether}(tokenURI); // Недостаточно Ether
    }
}
