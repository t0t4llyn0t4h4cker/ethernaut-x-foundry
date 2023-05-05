pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/Telephone/TelephoneFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";
import "../../src/Telephone/Yoink.sol";

contract TelephonesTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    Yoink yoink;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testTelephone() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone ethernautTelephone = Telephone(payable(levelAddress));
        // attack
        // launch attack contract
        yoink = new Yoink(address(ethernautTelephone));
        emit log_named_address("owner before attack", ethernautTelephone.owner());
        yoink.yoink();
        emit log_named_address("owner after attack", ethernautTelephone.owner());
        // assert that owner is now the EOA address
        assertEq(ethernautTelephone.owner(), eoaAddress);
        // submit level instance
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
