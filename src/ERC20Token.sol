// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

/// @title ERC20 Token with transfer fee and Permit functionality
/// @notice This contract implements an ERC20 token with a transfer fee and allows gasless approvals using ERC2612 Permit
/// @dev The fee is collected and transferred to the owner
contract ERC20TokenWithFeeAndPermit is ERC20, ERC20Permit {
    address public owner;

    /// @notice Constructor that mints the initial supply and sets the fee percent
    constructor()
        ERC20("MyToken", "MTK")
        ERC20Permit("MyToken")
    {
        _mint(msg.sender, 1000* 10**18);
        owner = msg.sender;
    }

    /// @notice Transfers tokens with fee
    /// @dev Overrides the ERC20 transfer function to include a fee mechanism
    /// @param recipient Address of the recipient
    /// @param amount Amount of tokens to transfer
    /// @return Returns true if transfer was successful
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = (amount * 1) / 100;
        uint256 amountAfterFee = amount - fee;
        _transfer(_msgSender(), owner, fee);
        _transfer(_msgSender(), recipient, amountAfterFee);
        return true;
    }

    /// @notice Transfers tokens with fee using the transferFrom method
    /// @dev Overrides the ERC20 transferFrom function to include a fee mechanism
    /// @param sender Address of the sender
    /// @param recipient Address of the recipient
    /// @param amount Amount of tokens to transfer
    /// @return Returns true if transfer was successful
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        uint256 fee = (amount * 1) / 100;
        uint256 amountAfterFee = amount - fee;
        _transfer(sender, owner, fee);
        _transfer(sender, recipient, amountAfterFee);

        uint256 currentAllowance = allowance(sender, _msgSender());
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /// @notice Allows users to buy tokens by sending Ether to the contract
    /// @dev Tokens are minted based on the sent msg.value
    function buyToken() external payable {
        uint256 tokensToBuy = msg.value * 100; 
        _mint(msg.sender, tokensToBuy);
    }

    /// @notice Allows the owner to withdraw the Ether collected in the contract
    /// @dev Only the owner can withdraw the Ether
    function withdrawEther() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
