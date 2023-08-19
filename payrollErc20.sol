// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenDistribution {
    address public owner;          // Owner of the contract
    ERC20 public token;            // The ERC20 token being distributed (I used a fake usdc I minted so maybe the token is the problem: 0x63516F1595A99dc6068cf75A7256A98aBDDbC369)

    mapping(address => bool) public approvedAddresses;

    constructor(address _tokenAddress) {
        token = ERC20(_tokenAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyApprovedAddresses() {
        require(approvedAddresses[msg.sender], "Address not valid");
        _;
    }

    function addApprovedAddress(address newAddress) external onlyOwner {
        approvedAddresses[newAddress] = true;
    }

    function removeApprovedAddress(address addressToRemove) external onlyOwner {
        approvedAddresses[addressToRemove] = false;
    }

    function distributeTokens(address[] calldata recipients, uint256[] calldata amounts) external onlyApprovedAddresses {
        require(recipients.length == amounts.length, "Arrays must have equal length");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            require(amounts[i] > 0, "Amount must be greater than 0");

            require(token.transfer(recipients[i], amounts[i]), "Transfer failed");
        }
    }
}