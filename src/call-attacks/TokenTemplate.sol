pragma solidity ^0.8.0;

import "src/call-attacks/Tokens.sol";

contract TokenTemplate is Tokens {
    function initiateAttack() external {
        deal(EthereumTokens.USDC, address(this), 1 ether);
        // TODO: Modify the attack here
    }
}
