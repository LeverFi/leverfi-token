pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TokenSwap is ReentrancyGuard {
    using SafeERC20 for IERC20;
    address public immutable inTokenAddress;
    address public immutable outTokenAddress;
    address public immutable outTokenWallet;
    address public immutable burnAddress;
    uint256 public immutable exchangeRatio;

    event TokenSwapped(address indexed account, uint256 inAmount, uint256 outAmount);

    constructor(
        address _inTokenAddress,
        address _outTokenAddress,
        address _outTokenWallet,
        address _burnAddress,
        uint256 _exchangeRatio
    ) public {
        inTokenAddress = _inTokenAddress;
        outTokenAddress = _outTokenAddress;
        outTokenWallet = _outTokenWallet;
        burnAddress = _burnAddress;
        exchangeRatio = _exchangeRatio;
    }

    // @dev swap inToken to outToken with respected exchangeRatio
    function tokenSwap(uint256 inAmount) public nonReentrant() {
        require(inAmount > 0, "TokenSwap: inAmount cannot be zero");

        // Transfer the inToken from the caller to the burn address
        IERC20(inTokenAddress).safeTransferFrom(
            address(msg.sender),
            burnAddress,
            inAmount
        );

        // Calculate the amount to send to the caller
        uint256 outAmount = inAmount * exchangeRatio / 1e18;

        // Transfer the outToken from the wallet to the caller
        IERC20(outTokenAddress).safeTransferFrom(
            outTokenWallet,
            address(msg.sender),
            outAmount
        );

        // Emit an event
        emit TokenSwapped(msg.sender, inAmount, outAmount);
    }

}
