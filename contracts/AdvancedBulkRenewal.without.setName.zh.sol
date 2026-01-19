// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import "./interfaces/IETHRegistrarController.sol";

/**
 * @title AdvancedBulkRenewal
 * @notice ENS 批量续费合约，支持独立的续费时长和 Referrer 归因
 */
contract AdvancedBulkRenewal {
    using Address for address payable;

    IETHRegistrarController public immutable controller;

    // 自定义错误类型 (Gas 优化)
    error ArrayLengthMismatch();
    error NoFundsProvided();
    error ETHTransferFailed();

    constructor(address _controller) {
        controller = IETHRegistrarController(_controller);
    }

    /**
     * @notice 批量续费核心函数
     * @dev 采用“全额透传”策略：将余额全部发给 Controller，利用 Controller 的自动退款机制。
     * @param labels 不包含 .eth 的名称标签数组 (例如 "vitalik")
     * @param durations 对应的续费时长数组 (秒)
     * @param referrer 推荐人标识 (bytes32)
     */
    function renewAll(
        string[] calldata labels,
        uint256[] calldata durations,
        bytes32 referrer
    ) external payable {
        uint256 length = labels.length;

        // 检查数组长度是否一致
        if (length != durations.length) {
            revert ArrayLengthMismatch();
        }

        // 检查是否携带了 ETH
        if (address(this).balance == 0) {
            revert NoFundsProvided();
        }

        for (uint256 i = 0; i < length; ) {
            // [关键策略]
            // 每次循环读取当前合约的所有余额。
            // 由于 Controller.renew 会在执行完毕后立即退还多余的 ETH 到 msg.sender (即本合约)，
            // 所以下一次循环时，address(this).balance 又是准确的剩余资金。
            uint256 currentBalance = address(this).balance;

            // 调用 Controller 的 renew。
            // 只要 ABI 匹配，Controller 会扣除 base + premium，剩下的退回来。
            controller.renew{value: currentBalance}(
                labels[i],
                durations[i],
                referrer
            );

            unchecked {
                ++i;
            }
        }

        // 批量操作结束后，将最终剩余的 ETH 退还给用户
        uint256 remaining = address(this).balance;
        if (remaining > 0) {
            Address.sendValue(payable(msg.sender), remaining);
        }
    }

    /**
     * @notice 价格估算 (View Only)
     * @dev 前端调用此函数来决定用户需要发送多少 ETH。
     * 建议前端在此结果基础上 +5% buffer 以防止价格波动。
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

    // 必须存在，用于接收 Controller 的退款
    receive() external payable {}

    // 紧急救援函数：任何人都可以调用，将卡在合约里的 ETH 退给调用者
    // 既然没有 owner，这是一个博弈论上安全的“公共清理”函数
    function recoverStuckETH() external {
        uint256 balance = address(this).balance;
        if (balance > 0) {
            Address.sendValue(payable(msg.sender), balance);
        }
    }
}
