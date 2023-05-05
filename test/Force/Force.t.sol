pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/Force/ForceFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";
import "../../src/Force/ThisIsNothing.sol";

contract ForceTestz is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    Force force;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testForceSend() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force ethernautForce = Force(payable(levelAddress));
        // attack
        // launch attack contract
        emit log_named_uint("contract balance before: ", address(ethernautForce).balance);
        ThisIsNothing thisIsNothing = new ThisIsNothing{value: 1 wei}(address(ethernautForce));
        emit log_named_uint("contract balance after: ", address(ethernautForce).balance);
        // submit level instance
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
