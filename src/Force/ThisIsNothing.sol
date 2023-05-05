// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "../../src/Force/Force.sol";

contract ThisIsNothing {
    Force public force;

    constructor(address _force) payable {
        force = Force(_force);
        selfdestruct(payable(address(force)));
    }
}
