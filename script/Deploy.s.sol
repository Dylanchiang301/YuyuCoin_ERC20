// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/YuyuCoin.sol";

contract Deploy is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); // 從環境變數讀取私鑰
        vm.startBroadcast(privateKey);

        // 設定初始值
        address owner = vm.addr(privateKey);
        address user = vm.addr(2);
        address taxCollector = address(
            0x1234567890123456789012345678901234567890
        ); // 測試用的稅收接收人

        // 部署合約
        YuYuCoin token = new YuYuCoin(owner, 1000, 5, taxCollector);
        token.mint(msg.sender, 500); // 自動 mint 500 個代幣
        token.setTaxRate(2); // 設定 2% 手續費
        token.transfer(user, 100); // 轉 100 給其他地址
        vm.stopBroadcast();
    }
}
