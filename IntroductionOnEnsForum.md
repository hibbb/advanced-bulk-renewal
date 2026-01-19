# 论坛帖子草稿 (English Version)

**Title:**
[Show & Tell] AdvancedBulkRenewal: A stateless contract for flexible duration bulk renewals

**Category:**
Show & Tell / Ecosystem (根据论坛版块选择)

**Body:**

Hi everyone,

I’m a developer working on **enscribe.xyz**. While building our project, we encountered a specific friction point with existing bulk renewal tools: they often require renewing all names for the same duration.

As an ENS user, I often find myself wanting to renew my "forever name" for 5 years but my "experimental names" for just 1 year—all in a single transaction to save gas.

To solve this, I developed **`AdvancedBulkRenewal`**. After deploying it on Mainnet and finding it useful, I thought I’d share it here as an open-source primitive for anyone who might need it.

#### 💡 Why I built this

The primary goal was **flexibility**. I wanted a lightweight tool that allows users to pass an array of names and a corresponding array of *independent* durations.

#### ✨ Key Features & Architecture

1. **Independent Durations**: You can renew `["nameA", "nameB"]` for `[1 year, 5 years]` in one go.
2. **Stateless & Trustless**:
* The contract has **no owner**, **no admin**, and **no pausing mechanism**. It is immutable.
* It uses a **"Full Balance Pass-Through"** strategy. It holds no funds. It simply forwards `address(this).balance` to the official ENS Controller and relies on the Controller’s automatic refund mechanism to return excess ETH to the user immediately.


3. **Referrer Support**: It exposes the `referrer` field (bytes32) from the ETHRegistrarController, making it integration-friendly for other frontends.
4. **Gas Optimized**: We used custom errors and unchecked loops (where safe) to keep overhead low.
5. **Clean & Verified**: The code is verified on Etherscan (Compiler v0.8.26) with zero warnings.

#### 🔒 Security

We prioritized simplicity to reduce attack surfaces. The contract logic is strictly atomic:
`User ETH -> Contract -> ENS Controller -> Refund to Contract -> Refund to User`.
There are no storage arrays or complex state changes.

#### 🔗 Links

* **Contract Address (Mainnet):** [你的主网合约地址]
* **Etherscan:** [Etherscan 链接]
* **Repo / Gist:** [如果你有开源 GitHub 链接，放这里]

This is a small contribution, but I hope it helps other builders or power users who need more granular control over bulk renewals.

Feedback and code reviews are always welcome!

Best,
[Your Name / handle]

---

### 中文对照与发布建议 (仅供参考)

为了让你确信上面的英文表达符合你的原意，以下是对应的中文逻辑（**不要直接发中文，ENS 论坛主要用英文**）：

**标题：** [展示与分享] AdvancedBulkRenewal：一个支持灵活时长的无状态批量续费合约

**正文：**

大家好，

我是 **enscribe.xyz** 的一名开发者。在构建项目的过程中，我们遇到了现有批量续费工具的一个痛点：它们通常强制要求所有域名续费相同的时长。

作为 ENS 用户，我经常想在一个交易里把我的“主域名”续费 5 年，而把“测试域名”只续费 1 年。为了解决这个问题并节省 Gas，我开发了 **`AdvancedBulkRenewal`**。

我觉得这对社区可能也有用，所以将其作为开源组件分享出来。

**为什么开发它：**
核心目标是**灵活性**。允许用户传入一组域名和一组**独立对应**的时长。

**主要特点：**

1. **独立时长**：可以在一次交易中为不同域名设定不同年份。
2. **无状态 & 免信任**：合约**无 Owner、无管理员、不可暂停**。采用“余额全额透传”策略，合约不持有资金，依赖 ENS Controller 的自动退款机制，非常安全。
3. **支持 Referrer**：保留了 ENS 原生的推荐人参数，方便集成。
4. **Gas 优化**：使用了自定义错误和 unchecked 循环。
5. **代码洁癖**：Etherscan 验证通过（v0.8.26），无任何编译器警告。

这是一个小工具，希望能帮助到有类似需求的朋友。欢迎反馈！

---

### 🚀 发布前的最后检查

1. **填空**：请务必把 `[你的主网合约地址]` 和 `[Etherscan 链接]` 替换成真实的。
2. **头像**：确保你在 ENS 论坛的账号有一个正常的头像（最好就是你的 ENS 头像），这能增加可信度。
3. **互动**：发布后如果有人提问（比如关于 Gas 消耗的具体对比），请保持耐心和友善地回复。

祝你的帖子在社区获得好评！这不仅是推广合约，也是为 enscribe.xyz 项目建立技术声誉的绝佳机会。
