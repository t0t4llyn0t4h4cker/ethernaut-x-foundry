// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.6;

// import ERC20 from OpenZeppelin/ERC20
import "openzeppelin/token/ERC20/ERC20.sol";

contract usdcErc20 is ERC20 {
    constructor() ERC20("USDC", "USDC") {
        // _mint(msg.sender, amount);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
