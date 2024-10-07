// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SoulBoundToken is ERC721, Ownable {
    
    uint256 public tokenCounter;


    constructor() ERC721("SoulBoundToken", "SBT") Ownable(_msgSender()) {
        tokenCounter = 0;
    }

    function safeMint(address to) public onlyOwner {
        tokenCounter++;
        uint256 newItemId = tokenCounter;
        _safeMint(to, newItemId);
    }

        // Минтинг токенов только для владельца
    function mint(address to, uint256 tokenId) public onlyOwner {
        _mint(to, tokenId);
    }

    // Отключаем возможность одобрения передачи токенов
    function approve(address to, uint256 tokenId) public override {
        revert("SBT: approval not allowed");
    }

    function setApprovalForAll(address operator, bool approved) public override {
        revert("SBT: approval not allowed");
    }

    // Отключаем все открыте трансферы
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        revert("SBT: transfer not allowed");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override {
        revert("SBT: transfer not allowed");
    }
}