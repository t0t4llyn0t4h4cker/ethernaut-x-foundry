pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/CoinFlip/CoinFlipFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";
import "../../src/CoinFlip/ThisIsFun.sol";

contract CoinflipsTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    ThisIsFun thisIsFun;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testCoinflip() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        CoinFlipFactory coinflipFactory = new CoinFlipFactory();
        ethernaut.registerLevel(coinflipFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(coinflipFactory);
        CoinFlip ethernautCoinflip = CoinFlip(payable(levelAddress));
        // attack
        // launch attack contract
        thisIsFun = new ThisIsFun(address(ethernautCoinflip));
        emit log_named_uint("consecutiveWins before attack", ethernautCoinflip.consecutiveWins());
        // for loop to call yoink() 10 times
        uint256 winz;
        for (uint256 i = 0; i < 10; i++) {
            vm.roll(1 + i);
            thisIsFun.yoink();
            winz = ethernautCoinflip.consecutiveWins();
            emit log_named_uint("consecutiveWins", winz);
        }
        // query CoinconsecutiveWins on ethernautCoinflip to verify it is 5
        // assertEq(ethernautCoinflip.consecutiveWins(), winz);

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
