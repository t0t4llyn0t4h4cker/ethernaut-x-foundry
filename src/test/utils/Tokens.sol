// pragma solidity ^0.8.0;

// // import "ds-test/test.sol";
// import "../../../../forge-std/Test.sol";

// import "../utils/vm.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// //broken

// abstract contract Tokens is DSTest {
//     Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));

//     /**
//      * @dev Wrapper function for vm.deal that takes IERC20 object
//      * @param token IERC20 token to manipulate
//      * @param to IERC20 to manipulate balance of
//      * @param amount Amount to set balance to
//      */
//     function deal(IERC20 token, address to, uint256 amount) internal {
//         if (address(token) == address(0x0)) {
//             vm.deal(to, amount);
//         } else {
//             // vm.deal(address(token), to, amount);
//         }
//     }
// }

// library EthereumTokens {
//     IERC20 public constant NATIVE_ASSET = IERC20(address(0x0));
//     IERC20 public constant ETH = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
//     // Top 50 tokens by market cap on etherscan
//     IERC20 public constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
//     IERC20 public constant USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
//     IERC20 public constant BNB = IERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);
//     IERC20 public constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
//     IERC20 public constant BUSD = IERC20(0x4Fabb145d64652a948d72533023f6E7A623C7C53);
//     IERC20 public constant MATIC = IERC20(0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0);
//     IERC20 public constant OKB = IERC20(0x75231F58b43240C9718Dd58B4967c5114342a86c);
//     IERC20 public constant stETH = IERC20(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84);
//     IERC20 public constant anyLTC = IERC20(0x0aBCFbfA8e3Fda8B7FBA18721Caf7d5cf55cF5f5);
//     IERC20 public constant THETA = IERC20(0x3883f5e181fccaF8410FA61e12b59BAd963fb645);
//     IERC20 public constant SHIB = IERC20(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE);
//     IERC20 public constant DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
//     IERC20 public constant HEX = IERC20(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39);
//     IERC20 public constant UNI = IERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
//     IERC20 public constant LEO = IERC20(0x2AF5D2aD76741191D15Dfe7bF6aC92d4Bd912Ca3);
//     IERC20 public constant WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
//     IERC20 public constant LINK = IERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA);
//     IERC20 public constant QNT = IERC20(0x4a220E6096B25EADb88358cb44068A3248254675);
//     IERC20 public constant APE = IERC20(0x4d224452801ACEd8B2F0aebE155379bb5D594381);
//     IERC20 public constant CRO = IERC20(0xA0b73E1Ff0B80914AB6fe0444E65848C4C34450b);
//     IERC20 public constant LDO = IERC20(0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32);
//     IERC20 public constant NEAR = IERC20(0x85F17Cf997934a597031b2E18a9aB6ebD4B9f6a4);
//     IERC20 public constant VEN = IERC20(0xD850942eF8811f2A866692A623011bDE52a462C1);
//     IERC20 public constant FRAX = IERC20(0x853d955aCEf822Db058eb8505911ED77F175b99e);
//     IERC20 public constant aAAVE = IERC20(0xba3D9687Cf50fE253cd2e1cFeEdE1d6787344Ed5);
//     IERC20 public constant stkAAVE = IERC20(0x4da27a545c0c5B758a6BA100e3a049001de870f5);
//     IERC20 public constant TUSD = IERC20(0x0000000000085d4780B73119b644AE5ecd22b376);
//     IERC20 public constant USDP = IERC20(0x8E870D67F660D95d5be530380D0eC0bd388289E1);
//     IERC20 public constant SAND = IERC20(0x3845badAde8e6dFF049820680d1F14bD3903a5d0);
//     IERC20 public constant HT = IERC20(0x6f259637dcD74C767781E37Bc6133cd6A68aa161);
//     IERC20 public constant wMANA = IERC20(0xFd09Cf7cFffa9932e33668311C4777Cb9db3c9Be);
//     IERC20 public constant USDD = IERC20(0x0C10bF8FcB7Bf5412187A595ab97a3609160b5c6);
//     IERC20 public constant KCS = IERC20(0xf34960d9d60be18cC1D5Afc1A6F012A723a28811);
//     IERC20 public constant BTT = IERC20(0xC669928185DbCE49d2230CC9B0979BE6DC797957);
//     IERC20 public constant CHZ = IERC20(0x3506424F91fD33084466F402d5D97f05F8e3b4AF);
//     IERC20 public constant FTM = IERC20(0x4E15361FD6b4BB609Fa63C81A2be19d873717870);
//     IERC20 public constant GUSD = IERC20(0x056Fd409E1d7A124BD7017459dFEa2F387b6d5Cd);
//     IERC20 public constant MKR = IERC20(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);
//     IERC20 public constant cUSDC = IERC20(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
//     IERC20 public constant GRT = IERC20(0xc944E90C64B2c07662A292be6244BDf05Cda44a7);
//     IERC20 public constant PAXG = IERC20(0x45804880De22913dAFE09f4980848ECE6EcbAf78);
//     IERC20 public constant BIT = IERC20(0x1A4b46696b2bB4794Eb3D4c26f1c55F9170fa4C5);
//     IERC20 public constant XAUt = IERC20(0x68749665FF8D2d112Fa859AA293F07A622782F38);
//     IERC20 public constant cDAI = IERC20(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
//     IERC20 public constant SNX = IERC20(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
//     IERC20 public constant FXS = IERC20(0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0);
//     IERC20 public constant NEXO = IERC20(0xB62132e35a6c13ee1EE0f84dC5d40bad8d815206);
//     IERC20 public constant cETH = IERC20(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
//     IERC20 public constant ZIL = IERC20(0x05f4a42e251f2d52b8ed15E9FEdAacFcEF1FAD27);
//     IERC20 public constant XDCE = IERC20(0x41AB1b6fcbB2fA9DCEd81aCbdeC13Ea6315F2Bf2);
//     IERC20 public constant ONEINCH = IERC20(0x111111111117dC0aa78b770fA6A738034120C302);
//     IERC20 public constant steCRV = IERC20(0x06325440D014e39736583c165C2963BA99fAf14E);
//     IERC20 public constant wstETH = IERC20(0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0);
// }
