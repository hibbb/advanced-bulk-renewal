// SPDX-License-Identifier: MIT

// File: @openzeppelin/contracts/utils/Errors.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/Errors.sol)

pragma solidity ^0.8.32;

/**
 * @dev Collection of common custom errors used in multiple contracts
 *
 * IMPORTANT: Backwards compatibility is not guaranteed in future versions of the library.
 * It is recommended to avoid relying on the error API for critical functionality.
 *
 * _Available since v5.1._
 */
library Errors {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error InsufficientBalance(uint256 balance, uint256 needed);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedCall();

    /**
     * @dev The deployment failed.
     */
    error FailedDeployment();

    /**
     * @dev A necessary precompile is missing.
     */
    error MissingPrecompile(address);
}

// File: @openzeppelin/contracts/utils/Address.sol

// OpenZeppelin Contracts (last updated v5.4.0) (utils/Address.sol)

pragma solidity ^0.8.32;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev There's no code at `target` (it is not a contract).
     */
    error AddressEmptyCode(address target);

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.32/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        if (address(this).balance < amount) {
            revert Errors.InsufficientBalance(address(this).balance, amount);
        }

        (bool success, bytes memory returndata) = recipient.call{value: amount}(
            ""
        );
        if (!success) {
            _revert(returndata);
        }
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason or custom error, it is bubbled
     * up by this function (like regular Solidity function calls). However, if
     * the call reverted with no returned reason, this function reverts with a
     * {Errors.FailedCall} error.
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     */
    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     */
    function functionStaticCall(
        address target,
        bytes memory data
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     */
    function functionDelegateCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
     * was not a contract or bubbling up the revert reason (falling back to {Errors.FailedCall}) in case
     * of an unsuccessful call.
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata
    ) internal view returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            // only check if target is a contract if the call was successful and the return data is empty
            // otherwise we already know that it was a contract
            if (returndata.length == 0 && target.code.length == 0) {
                revert AddressEmptyCode(target);
            }
            return returndata;
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
     * revert reason or with a default {Errors.FailedCall} error.
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata
    ) internal pure returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            return returndata;
        }
    }

    /**
     * @dev Reverts with returndata if present. Otherwise reverts with {Errors.FailedCall}.
     */
    function _revert(bytes memory returndata) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            assembly ("memory-safe") {
                revert(add(returndata, 0x20), mload(returndata))
            }
        } else {
            revert Errors.FailedCall();
        }
    }
}

// File: contracts/interfaces/IETHRegistrarController.sol

pragma solidity ^0.8.32;

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

// File: contracts/AdvancedBulkRenewal.sol

pragma solidity ^0.8.32;

// Interface for the ENS Reverse Registrar
interface IReverseRegistrar {
    function setName(string memory name) external returns (bytes32);
}

/**
 * @title AdvancedBulkRenewal
 * @notice ENS bulk renewal contract supporting independent renewal durations and referrer attribution.
 */
contract AdvancedBulkRenewal {
    using Address for address payable;

    IETHRegistrarController public immutable controller;

    // Official ENS ReverseRegistrar contract on Mainnet
    address constant ADDR_REVERSE_REGISTRAR =
        0xa58E81fe9b61B5c3fE2AFD33CF304c454AbFc7Cb;

    // Custom error types (Gas optimization)
    error ArrayLengthMismatch();
    error NoFundsProvided();
    error ETHTransferFailed();

    /**
     * @notice Contract constructor.
     * @param _controller The address of the ENS ETHRegistrarController.
     * @param _name The ENS name to set for this contract. Pass empty string "" to skip.
     */
    constructor(address _controller, string memory _name) {
        controller = IETHRegistrarController(_controller);

        // Attempt to set the reverse record (Primary Name) if a name is provided
        if (bytes(_name).length > 0) {
            IReverseRegistrar(ADDR_REVERSE_REGISTRAR).setName(_name);
        }
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
