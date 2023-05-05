pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/King/KingFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";
import "../../src/King/NothingIsHere.sol";

contract KingzTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    King king;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testKingz() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);
        King ethernautKing = King(payable(levelAddress));
        // attack
        // launch attack contract
        NothingIsHere nothingIsHere = new NothingIsHere{value: 1.1 ether}(address(ethernautKing));
        // submit level instance
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
