# 🪙 YuYuCoin (YYC)

YuYuCoin (YYC) 是一個基於 **ERC-20 標準** 的智能合約，具有 **手續費機制**、**黑名單**、**鑄造 & 銷毀機制**，並且允許合約擁有者動態調整手續費及稅務收款地址。

![Solidity](https://img.shields.io/badge/Solidity-0.8.20-blue)  
![License](https://img.shields.io/badge/License-MIT-green)

---

## **📌 功能介紹**
### ✅ **基本功能**
- **ERC-20 代幣標準**
- **小數點支援 (`decimals() = 18`)**
- **代幣銷毀 (`burn()`)**
- **代幣鑄造 (`mint()`)**（僅合約擁有者可用）

### 💵 **手續費機制**
- 交易時會 **抽取一定比例的手續費 (`taxRate`)**，並將其轉入 **稅務地址 (`taxCollector`)**。
- 手續費上限為 **10%**。

### 🚫 **黑名單機制**
- 合約擁有者可以將特定地址列入 **黑名單 (`blacklisted`)**，防止其進行交易。

### 🛠 **可調整手續費與收款地址**
- **合約擁有者可調整手續費 (`setTaxRate()`)**
- **修改稅務收款地址 (`setTaxCollector()`)**

---

## 📬 聯絡方式
📧 Email: cmydylan@gmail.com

🌐 GitHub: [Dylanchiang301](https://github.com/Dylanchiang301)
