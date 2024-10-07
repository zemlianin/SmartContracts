// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/Test.sol";
import "../src/ERC20Token.sol";
import "../src/ERC721Token.sol";
import "../src/ERC1155Token.sol";
import "../src/SoulBoundToken.sol";

contract AmoyTest is Script {
    ERC20TokenWithFeeAndPermit erc20Token;
    ERC721Token erc721Token;
    ERC1155Token erc1155Token;
    SoulBoundToken soulBoundToken;

     // Адреса контрактов
    address erc20Address = 0xdBdF8c47C566A2656bFAE5c06FbF928174c4F1bf;
    address erc721Address = 0x82AeECCa746271569f06c232c980ad4096a3bD4d;
    address erc1155Address = 0x33d63DF28F46dC37efbBA55AF25F734417Dd1Acb;
    address sbtAddress = 0xD576865FDF1A7D88168A5B6daA63A7BA51999450;
    address senderAddress = 0x3FDF7Fd35F4e16afB548a79AB5eE40E8C344982D;
    address recipientAddress = 0x8493a952bfD0EA51f30a2fE93994768e88505b48;

    function setUp() public {
        // Подключаемся к контрактам
        erc20Token = ERC20TokenWithFeeAndPermit(erc20Address);
        erc721Token = ERC721Token(erc721Address);
        erc1155Token = ERC1155Token(erc1155Address);
        soulBoundToken = SoulBoundToken(sbtAddress);
    }

    function run() public {
        // Получение приватного ключа из переменной окружения
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        // Начинаем трансляцию транзакций
        vm.startBroadcast(privateKey);

        // Вызываем функции контрактов
        console.log("\n========= test Mint ERC20 =========\n");
        testMintERC20();
        console.log("\n========= test Transfer ERC20 =========\n");
        testTransferERC20();
        console.log("\n========= test TransferFrom ERC20 =========\n");
        testTransferFromERC20();
        console.log("\n========= test Buy ERC1155 =========\n");
        testBuyERC1155();
        console.log("\n========= test SafeTransferFrom ERC1155 =========\n");
        testSafeTransferFromERC1155();
        console.log("\n========= test SafeMint ERC721 =========\n");
        testSafeMintERC721();

        // Обрабатываем события
        console.log("\n========= test check events by filter =========\n");
        testQueryAllAndFilterEvents();

        // Просматриваем storage
        console.log("\n========= view storage for balance =========\n");
        checkAllBalances();

        // Работа с SBT
        console.log("\n========= test Mint SBT =========\n");
        testMintSBT();
        vm.stopBroadcast();

        vm.startBroadcast(privateKey);
        console.log("\n========= test SafeTransfer SBT =========\n");
// ==================== Broken Action ====================
//       testSafeTransferSBT();

        vm.stopBroadcast();
    }


    function testMintERC20() internal {
        uint256 initialBalance = erc20Token.balanceOf(senderAddress);
        console.log("Initial ERC20 balance:", initialBalance);
        erc20Token.buyToken{value: 0.02 ether}();
        uint256 finalBalance = erc20Token.balanceOf(senderAddress);
        console.log("Final ERC20 balance after mint:", finalBalance);
    }

    function testMintSBT() internal {
        uint256 initialBalance = soulBoundToken.balanceOf(senderAddress);
        console.log("Initial SBT balance:", initialBalance);
        soulBoundToken.safeMint(senderAddress);

        uint256 finalBalance = soulBoundToken.balanceOf(senderAddress);
        console.log("Final SBT balance after mint:", finalBalance);
    }

    function testSafeTransferSBT() internal {
        try soulBoundToken.safeTransferFrom(senderAddress, recipientAddress, 1) {
            console.log("Transfer was successful (this should not happen for SBT).");
        } catch Error(string memory reason) {
            console.log("Expected revert occurred: SBT: transfer not allowed.");
        }
    }

    function testTransferERC20() internal {
        erc20Token.transfer(recipientAddress, 5 * 10**18);
        console.log("Transferred 5 ERC20 tokens");
    }

    function testTransferFromERC20() internal {
        erc20Token.approve(senderAddress, 5 * 10**18); // Одобряем
        erc20Token.transferFrom(senderAddress, recipientAddress, 2 * 10**18); // Переводим от себя
        console.log("Transferred 2 ERC20 tokens using transferFrom");
    }

    function testBuyERC1155() internal {
        erc1155Token.buyToken{value: 0.02 ether}(senderAddress, 1, 2); // Покупаем 2 токенов ID 1
        console.log("Bought 2 ERC1155 tokens");
    }

    function testSafeTransferFromERC1155() internal {
        erc1155Token.safeTransferFrom(senderAddress, recipientAddress, 1, 1, ""); // Безопасный перевод 1 токенов ID 1
        console.log("Safe transferred 5 ERC1155 tokens");
    }

    function testSafeMintERC721() internal {
        erc721Token.buyNFT{value: 0.01 ether}("https://gold-near-fox-74.mypinata.cloud/ipfs/QmQywF3utJ8apWRTR5YkzYFwpmE5SUZZRQMdrdzTMwJ8Yu");
        console.log("Minted new ERC721 NFT");
    }

    function emitLogTransfer(Vm.Log memory log) internal {
        console.log("Event Transfer detected at:");
        console.log(" - Address:", log.emitter);
        address from = address(uint160(uint256(log.topics[1])));
        address to = address(uint160(uint256(log.topics[2])));
        console.log(" - From:", from);
        console.log(" - To:", to);

        uint256 value = abi.decode(log.data, (uint256));
        console.log(" - Value:", value);
    }

    function emitLogTransferSingle(Vm.Log memory log) internal {
        address operator = address(uint160(uint256(log.topics[1])));
        address from = address(uint160(uint256(log.topics[2])));
        address to = address(uint160(uint256(log.topics[3])));
        (uint256 id, uint256 value) = abi.decode(log.data, (uint256, uint256));

        console.log("TransferSingle Event: Operator", operator);
        console.log("From", from, "To", to);
        console.log("ID", id, "Value", value);
    }

    function emitLogTransferBatch(Vm.Log memory log) internal {
        address operator = address(uint160(uint256(log.topics[1])));
        address from = address(uint160(uint256(log.topics[2])));
        address to = address(uint160(uint256(log.topics[3])));
        (uint256[] memory ids, uint256[] memory values) = abi.decode(log.data, (uint256[], uint256[]));

        console.log("TransferBatch Event: Operator", operator);
        console.log("From", from, "To", to);
        for (uint256 i = 0; i < ids.length; i++) {
            console.log(" - ID:", ids[i], "Value:", values[i]);
        }
    }

    function filterOfLogs(Vm.Log[] memory logs) internal {
        for (uint i = 0; i < logs.length; i++) {
            if (logs[i].topics[0] == keccak256("Transfer(address,address,uint256)")) {
                emitLogTransfer(logs[i]);
            } else if (logs[i].topics[0] == keccak256("TransferSingle(address,address,address,uint256,uint256)")) {
                emitLogTransferSingle(logs[i]);
            } else if (logs[i].topics[0] == keccak256("TransferBatch(address,address,address,uint256[],uint256[])")) {
                emitLogTransferBatch(logs[i]);
            }
        }
    }

    function testQueryAllAndFilterEvents() internal {
        vm.recordLogs();
        erc1155Token.buyToken{value: 0.02 ether}(senderAddress, 1, 2); // Покупаем 2 токенов ID 1
        erc20Token.transfer(senderAddress, 1 * 10**18);
        erc1155Token.safeTransferFrom(senderAddress, recipientAddress, 1, 1, "");

        uint256[] memory ids = new uint256[](1);
        ids[0] = 1;
        uint256[] memory amount = new uint256[](1);
        amount[0] = 1;

        erc1155Token.safeBatchTransferFrom(senderAddress, recipientAddress, ids, amount, "");
        Vm.Log[] memory logs = vm.getRecordedLogs();
        filterOfLogs(logs);
    }

    function getERC20BalanceSlot(address user) internal view returns (uint256) {
        bytes32 slot = keccak256(abi.encode(user, 0)); // слот 0 используется для mapping(address => uint256) balances
        bytes32 balanceSlot;
        assembly {
            balanceSlot := sload(slot)
        }
        return uint256(balanceSlot);
    }

    function getERC1155BalanceSlot(address user, uint256 tokenId) internal view returns (uint256) {
        bytes32 slot = keccak256(abi.encode(user, keccak256(abi.encode(tokenId, 1))));
        bytes32 balanceSlot;
        assembly {
            balanceSlot := sload(slot)
        }
        return uint256(balanceSlot);
    }

    function checkAllBalances() public view {
        console.log("ERC20 Balance:");
        uint256 erc20Balance = getERC20BalanceSlot(senderAddress);
        console.log("Balance in ERC20:", erc20Balance);

        console.log("ERC1155 Balance (Token ID 1):");
        uint256 erc1155Balance = getERC1155BalanceSlot(senderAddress, 1);
        console.log("Balance in ERC1155 (ID 1):", erc1155Balance);

        console.log("ERC721 Balance:");
        uint256 erc721Balance = erc721Token.balanceOf(senderAddress);
        console.log("Balance in ERC721:", erc721Balance);
    }
}
