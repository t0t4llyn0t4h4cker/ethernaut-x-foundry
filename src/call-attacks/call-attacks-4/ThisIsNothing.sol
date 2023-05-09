// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

// import Ownable from OpenZeppelin/Ownable
import "openzeppelin/access/Ownable.sol";

contract ThisIsNothing is Ownable {
    constructor() {}

    fallback() external {
        selfdestruct(payable(address(0)));
    }
}
