// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import "./interfaces/IETHRegistrarController.sol";

/**
 * @title AdvancedBulkRenewal
 * @notice ENS bulk renewal contract supporting independent renewal durations and referrer attribution.
 */
contract AdvancedBulkRenewal {
    using Address for address payable;

    IETHRegistrarController public immutable controller;

    // Custom error types (Gas optimization)
    error ArrayLengthMismatch();
    error NoFundsProvided();
    error ETHTransferFailed();

    constructor(address _controller) {
        controller = IETHRegistrarController(_controller);
    }

    /**
     * @notice Core bulk renewal function.
     * @dev Uses a "full balance pass-through" strategy: sends the entire balance to the Controller,
     * leveraging the Controller's automatic refund mechanism.
     * @param labels Array of name labels without .eth (e.g., "vitalik").
     * @param durations Array of corresponding renewal durations (in seconds).
     * @param referrer Referrer identifier (bytes32).
     */
    function renewAll(
        string[] calldata labels,
        uint256[] calldata durations,
        bytes32 referrer
    ) external payable {
        uint256 length = labels.length;

        // Check if array lengths match
        if (length != durations.length) {
            revert ArrayLengthMismatch();
        }

        // Check if ETH was provided
        if (address(this).balance == 0) {
            revert NoFundsProvided();
        }

        for (uint256 i = 0; i < length; ) {
            // [Key Strategy]
            // Read the entire balance of the contract in each iteration.
            // Since Controller.renew immediately refunds excess ETH to msg.sender (this contract) after execution,
            // address(this).balance represents the accurate remaining funds for the next iteration.
            uint256 currentBalance = address(this).balance;

            // Call the Controller's renew function.
            // Assuming ABI matching, the Controller deducts the base + premium fees and refunds the remainder.
            controller.renew{value: currentBalance}(
                labels[i],
                durations[i],
                referrer
            );

            unchecked {
                ++i;
            }
        }

        // After bulk operations, refund the final remaining ETH to the user
        uint256 remaining = address(this).balance;
        if (remaining > 0) {
            Address.sendValue(payable(msg.sender), remaining);
        }
    }

    /**
     * @notice Price estimation (View Only).
     * @dev Frontend calls this function to determine the ETH amount the user needs to send.
     * It is recommended to add a +5% buffer to this result to account for price fluctuations.
     */
    function rentPrice(
        string[] calldata labels,
        uint256[] calldata durations
    ) external view returns (uint256 total) {
        uint256 length = labels.length;
        if (length != durations.length) {
            revert ArrayLengthMismatch();
        }

        for (uint256 i = 0; i < length; ) {
            IETHRegistrarController.Price memory price = controller.rentPrice(
                labels[i],
                durations[i]
            );
            total += (price.base + price.premium);

            unchecked {
                ++i;
            }
        }
    }

    // Required to receive refunds from the Controller
    receive() external payable {}

    // Emergency recovery function: callable by anyone to refund stuck ETH to the caller.
    // Since there is no owner, this is a game-theoretically safe "public cleanup" function.
    function recoverStuckETH() external {
        uint256 balance = address(this).balance;
        if (balance > 0) {
            Address.sendValue(payable(msg.sender), balance);
        }
    }
}
