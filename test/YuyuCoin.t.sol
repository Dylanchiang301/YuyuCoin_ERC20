// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/YuyuCoin.sol"; // 確保這個路徑正確;

contract YuYuCoinTest is Test {
    YuYuCoin token;
    address owner = vm.addr(1);
    address user1 = vm.addr(2);
    address user2 = vm.addr(3);
    address taxCollector = vm.addr(4);

    function setUp() public {
        vm.prank(owner); // 設定 `owner` 作為部署者
        token = new YuYuCoin(owner, 1000, 5, taxCollector);
    }

    function testInitialSupply() public view {
        assertEq(token.balanceOf(owner), 1000 * 10 ** 18);
    }

    function testTransferWithTax() public {
        vm.startPrank(owner);
        token.transfer(user1, 100 * 10 ** 18);
        vm.stopPrank();

        // 應該收 5% 手續費，實際轉帳 95
        assertEq(token.balanceOf(user1), 95 * 10 ** 18);
        assertEq(token.balanceOf(taxCollector), 5 * 10 ** 18);
    }

    function testApproveAndTransferFrom() public {
        vm.startPrank(owner);
        token.approve(user1, 100 * 10 ** 18);
        vm.stopPrank();

        vm.startPrank(user1);
        token.transferFrom(owner, user2, 50 * 10 ** 18);
        vm.stopPrank();

        // 應該收 5% 手續費，實際轉帳 95
        assertEq(token.balanceOf(user2), 47.5 * 10 ** 18);
        assertEq(token.balanceOf(taxCollector), 2.5 * 10 ** 18);
        console.log(token.allowance(owner, user1));
        assertEq(token.allowance(owner, user1), 50 * 10 ** 18); // 授權應該被扣除
    }

    function testBlacklist() public {
        vm.prank(owner);
        token.addToBlacklist(user1);

        vm.prank(owner);
        vm.expectRevert("Recipient is blacklisted");
        token.transfer(user1, 100 * 10 ** 18);
    }

    function testMint() public {
        vm.prank(owner);
        token.mint(user1, 500 * 10 ** 18);
        assertEq(token.balanceOf(user1), 500 * 10 ** 18);
    }

    function testBurn() public {
        vm.startPrank(owner);
        token.burn(200 * 10 ** 18);
        vm.stopPrank();

        assertEq(token.balanceOf(owner), 800 * 10 ** 18); // 原本 1000，燒毀 200
    }
}
