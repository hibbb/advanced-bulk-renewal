// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IETHRegistrarController {
    struct Price {
        uint256 base;
        uint256 premium;
    }

    function rentPrice(
        string memory label,
        uint256 duration
    ) external view returns (Price memory);

    function renew(
        string calldata label,
        uint256 duration,
        bytes32 referrer
    ) external payable;

    function available(string memory label) external view returns (bool);
}
