// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YuYuCoin is ERC20, Ownable {
    uint256 public taxRate;
    address public taxCollector;
    mapping(address => bool) public blacklisted;

    constructor(
        address initialOwner,
        uint256 initialSupply,
        uint256 _taxRate,
        address _taxCollector
    ) ERC20("YuYuCoin", "YYC") Ownable(initialOwner) {
        require(_taxRate <= 10, "Tax rate too high");
        require(_taxCollector != address(0), "Invalid tax collector");

        taxRate = _taxRate;
        taxCollector = _taxCollector;
        _mint(initialOwner, initialSupply * 10 ** decimals());
    }

    event TaxRateUpdated(uint256 newTaxRate);
    event TaxCollectorUpdated(address newCollector);
    event Minted(address indexed to, uint256 amount);
    event Blacklisted(address indexed user, bool status);

    function addToBlacklist(address user) external onlyOwner {
        blacklisted[user] = true;
        emit Blacklisted(user, true);
    }

    function removeFromBlacklist(address user) external onlyOwner {
        blacklisted[user] = false;
        emit Blacklisted(user, false);
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(!blacklisted[msg.sender], "Sender is blacklisted");
        require(!blacklisted[recipient], "Recipient is blacklisted");

        uint256 taxAmount = (amount * taxRate) / 100;
        uint256 transferAmount = amount - taxAmount; //是扣掉手續費後，真正給 recipient 的數量

        _transfer(msg.sender, taxCollector, taxAmount);
        _transfer(msg.sender, recipient, transferAmount);

        return true;
    }

    /*
     * 授權另一個帳戶轉帳
     * 如果要使用這個，授權人必須先執行 approve()
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(!blacklisted[sender], "Sender is blacklisted");
        require(!blacklisted[recipient], "Recipient is blacklisted");

        uint256 taxAmount = (amount * taxRate) / 100;
        uint256 transferAmount = amount - taxAmount;

        require(
            allowance(sender, msg.sender) >= amount + taxAmount,
            "Allowance too low. Approve (amount + tax)"
        );

        _transfer(sender, taxCollector, taxAmount);
        _transfer(sender, recipient, transferAmount);

        _approve(
            sender,
            msg.sender,
            allowance(sender, msg.sender) - (amount + taxAmount)
        );

        return true;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function setTaxRate(uint256 _taxRate) external onlyOwner {
        require(_taxRate <= 10, "Tax rate too high");
        taxRate = _taxRate;
        emit TaxRateUpdated(_taxRate);
    }

    function setTaxCollector(address _taxCollector) external onlyOwner {
        require(_taxCollector != address(0), "Invalid tax collector");
        taxCollector = _taxCollector;
        emit TaxCollectorUpdated(_taxCollector);
    }
}
