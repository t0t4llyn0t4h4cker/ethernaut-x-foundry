pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {usdcErc20} from "src/call-attacks/call-attacks-2/ERC20.sol";
import "../../../src/call-attacks/call-attacks-2/RentingLibrary.sol";
import {SecureStore} from "../../../src/call-attacks/call-attacks-2/SecureStore.sol";
import "../../../src/call-attacks/call-attacks-2/ThisIsNothing.sol";

contract Call2Test is Test {
    // Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    RentingLibrary rentingLibrary;
    SecureStore secureStore;
    usdcErc20 usdc;
    address deployerAddress = address(100);
    address userAddress = address(101); //65
    address attacker = address(102);
    address USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    // set constant price to 5 USDC; keep in mind that USDC has 6 decimals
    uint256 PRICE = 5 * 10 ** 18;
    uint256 USDC_AMOUNT = 1000 * 10 ** 18;

    function setUp() public {
        // vm.startPrank(deployerAddress);
        // Setup instance of the contract
        rentingLibrary = new RentingLibrary();
        // deploy an instance of USDC token contract using the IERC20 interface
        usdc = new usdcErc20("USDC", "USDC");
        // need usdc address so secureStore is last
        secureStore = new SecureStore(address(rentingLibrary),PRICE, address(usdc));
        // Deal EOA address some USDC
        // usdc.mint(deployerAddress, (USDC_AMOUNT * 2) + PRICE);
        deal(address(usdc), deployerAddress, USDC_AMOUNT);
        deal(address(usdc), userAddress, USDC_AMOUNT);
        deal(address(usdc), attacker, USDC_AMOUNT);
        // usdc.transfer(deployerAddress, USDC_AMOUNT);
        // usdc.transfer(userAddress, USDC_AMOUNT);
        // usdc.transfer(attacker, 5 * 10 ** 6);
        // emit log_named_uint("deployerAddress USDC balance", usdc.balanceOf(deployerAddress));
        // emit log_named_uint("userAddress USDC balance", usdc.balanceOf(userAddress));
        // emit log_named_uint("attacker USDC balance", usdc.balanceOf(attacker));
        // vm.stopPrank();
        // deal(address(usdc), deployerAddress, 1 ether, true);
        // Deal EOA address some ether
        // deal(deployerAddress, 1 ether);
        // deal(userAddress, 1 ether);
        // deal(attacker, 1 ether);
    }

    function testUserChanageUnrestrictOwner() public {
        // impersonate userAddress, and becomes owner of unrestrictedOwner
        vm.startPrank(userAddress);
        emit log_named_uint("test call", userAddress.balance);
        // aprove SecureStore to spend USDC for max uint256
        // usdc.approve(address(secureStore), type(uint256).max);
        // secureStore.rentWarehouse(USDC_AMOUNT / PRICE, 1);
        vm.stopPrank();
        // emit log_named_uint("test call after prank", usdc.balanceOf(userAddress));
        // emit
    }
}

// // write a test that we expect to fail
// function testFailUserChanageRestrictOwner() public {
//     // impersonate userAddress
//     vm.startPrank(userAddress);
//     // emit address of contract.owner()
//     emit log_named_address("FAIL: owner before userAddress", restrictedOwner.owner());
//     // call RestrictedOwner.updateSettings(); protected by owner should fail
//     restrictedOwner.updateSettings(userAddress, userAddress);
//     // emit address of contract.owner()
//     emit log_named_address("FAIL: owner after userAddress", restrictedOwner.owner());
//     vm.stopPrank();
// }

// // write attack test where attacker is able to become owner of  RestrictedOwner
// function testAttackerChangeRestrictOwner() public {
//     // impersonate attacker
//     vm.startPrank(attacker);
//     // emit address of contract.owner()
//     emit log_named_address("owner before attacker", restrictedOwner.owner());
//     // call RestrictedOwner
//     bytes memory payload = abi.encodeWithSignature("changeOwner(address)", attacker);
//     (bool milady, bytes memory result) = address(restrictedOwner).call(payload);
//     // emit the bytes result of the call after we decode the bytes
//     // result = abi.decode(result, (bytes));
//     // emit log_named_bytes("result", result);
//     // emit address of contract.owner()
//     emit log_named_address("owner after attacker", restrictedOwner.owner());
//     vm.stopPrank();
//     // assert that attacker is now owner of restrictedOwner
//     assertEq(restrictedOwner.owner(), attacker);
// }
