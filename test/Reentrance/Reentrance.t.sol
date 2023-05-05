pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/Reentrance/ReentranceFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";
import "../../src/Reentrance/ThisIsNothing.sol";

contract ReentrancezTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    Reentrance reentrance;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testReent() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ReentranceFactory reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(reentranceFactory);
        Reentrance ethernautReentrance = Reentrance(payable(levelAddress));
        // attack
        // launch attack contract
        ThisIsNothing thisIsNothing = new ThisIsNothing(levelAddress);
        thisIsNothing.yoink{value: 0.4 ether}();
        // submit level instance
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
