// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @title ERC1155 Token with metadata and purchase functionality
contract ERC1155Token is ERC1155 {
    uint256 public pricePerToken = 0.01 ether;
    
    constructor() ERC1155("https://gold-near-fox-74.mypinata.cloud/ipfs/QmZmvFqtuGX8fYqXDdjEAd5BWLRp8nt6K9zMizcdYKAfUY") {}

    /// @notice Allows users to buy a specific token by sending Ether
    /// @param id ID of the token to purchase
    /// @param amount Number of tokens to purchase
    function buyToken(address to, uint256 id, uint256 amount) external payable {
        require(msg.value == pricePerToken * amount, "Incorrect Ether value sent");
        _mint(to, id, amount, "");
    }

    /// @notice Allows the contract owner to withdraw collected Ether
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
