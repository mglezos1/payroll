// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundsDistribution {
    address public owner;
    address[] public recipients;

    constructor(address[] memory _recipients) {
        owner = msg.sender;
        recipients = _recipients;
    }

    receive() external payable {
        require(msg.value > 0, "No funds sent");
        require(recipients.length > 0, "No recipients specified");

        uint256 amountPerRecipient = msg.value / recipients.length;

        for (uint256 i = 0; i < recipients.length; i++) {
            payable(recipients[i]).transfer(amountPerRecipient);
        }
    }

    function updateRecipients(address[] memory _recipients) external {
        require(msg.sender == owner, "Only the owner can update recipients");
        recipients = _recipients;
    }

    function withdrawExcess() external {
        require(msg.sender == owner, "Only the owner can withdraw excess funds");
        uint256 contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
    }
}