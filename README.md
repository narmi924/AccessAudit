# AccessAudit — 最小化权限审批 + 链上审计日志 
# AccessAudit — Minimal Access Approval + On-chain Audit Logging 

本仓库实现了一个用于 AI 场景的数据访问审批与审计的最小合约：  
- 链上只保存 `payloadHash(bytes32)`（不上传原始数据），避免隐私泄露  
- 通过事件 `AccessRequested` / `AccessDecided` 形成可公开核验的审计轨迹  
- 通过角色权限（`APPROVER_ROLE`）限制审批者，保证流程可控、可测试、可复现  

This repo implements a minimal on-chain **access approval + audit logging** layer for privacy-sensitive AI systems:  
- Store only `payloadHash(bytes32)` on-chain (no raw data)  
- Emit events (`AccessRequested`, `AccessDecided`) as verifiable audit trails  
- Use role-based permissions (`APPROVER_ROLE`) to restrict approvers  

## 产出与证据（Sepolia — 可公开核验）  
## Evidence (Sepolia — Publicly Verifiable)

### 合约信息 / Contract
- 网络 / Network: Sepolia（chainId = 11155111）  
- 合约 / Contract: `AccessAudit`  
- 合约地址 / Address: `0xaED732B1F4Dcc0DD062434F0dE4ec1Cf61a3c60E`  
- 状态 / Status: **Etherscan Verified（已验证）**

Etherscan（合约页面 / contract page）  
```text
https://sepolia.etherscan.io/address/0xaED732B1F4Dcc0DD062434F0dE4ec1Cf61a3c60E
````

---

### 交易清单（链上证据）/ Transactions (On-chain Proof)

#### 1) 部署合约 / Deploy

* Deploy Tx: `0xfc087487f78bb9b3ea2a4772cbd4f87dd7786550078798789ab32515d88691ef`

#### 2) 授权审批者角色 / Grant `APPROVER_ROLE`

* `APPROVER_ROLE = keccak256("APPROVER_ROLE")`
  `0x408a36151f841709116a4e8aca4e0202874f7f54687dcb863b1ea4672dc9d8cf`
* Tx（grantRole）: `0xb39fe35d1f87c441dd0c8f2122ce0f184b948ba0b2a080edfad3658ac0e9d53d`

#### 3) 用户发起访问请求（产生事件）/ User requests access (emits event)

* payloadHash = `keccak256("dataset-1|training|v1|sepolia")`
  `0xec44bd0df4f89fb4439b46ca01bfbc2d5a54ffc0c9472e906491597717b7009f`
* Tx（requestAccess）: `0x582f145eaac9e031e47c202ae883aa0f5e6b5560250132fa04d540c18fd9f622`

#### 4) 审批者做出决定（产生事件）/ Approver decides (emits event)

* approved: `true`
* Tx（decide）: `0x7ec60b25d033f73da15d044b22b733770cd482105bcc7d92ab4d5987f6a119b5`

说明 / Note:
在合约 **未验证** 时，Etherscan等区块浏览器中只会显示函数选择器（method id）而非函数名。
例如 `decide(uint256,bool)` 的 selector 为：`0x224f3d1a`。
验证完成后，Etherscan 会使用 ABI 将其解码为可读方法名与参数。

Before verification, explorers show only the 4-byte function selector (method id).
For example, `decide(uint256,bool)` has selector `0x224f3d1a`. After verification, Etherscan decodes it using ABI.

---

### 证据截图 / Proof Screenshots

* `01_contract_address / 合约地址页面`
![01_contract_address](https://github.com/narmi924/AccessAudit/blob/adc56656d6c8f1d74728bba1e7b74b013b3425e4/proof/01_contract_address.png?raw=true)
* `02_deploy_tx / 部署交易页面`
![02_deploy_tx](https://github.com/narmi924/AccessAudit/blob/adc56656d6c8f1d74728bba1e7b74b013b3425e4/proof/01_contract_address.png?raw=true)
* `03_request_tx_logs / requestAccess 交易页面`
![03_request_tx_logs](https://github.com/narmi924/AccessAudit/blob/adc56656d6c8f1d74728bba1e7b74b013b3425e4/proof/01_contract_address.png?raw=true)
* `04_decide_tx_logs / decide 交易页面`
![04_decide_tx_logs](https://github.com/narmi924/AccessAudit/blob/adc56656d6c8f1d74728bba1e7b74b013b3425e4/proof/01_contract_address.png?raw=true)

---

## 快速本地复现

## Quickstart (Local Reproducible)

### 环境要求 / Requirements

* Foundry（forge / cast / anvil）

### 编译 / Build

```bash
forge build
```

### 单元测试 / Unit tests

```bash
forge test -vv
```

### 启动本地区块链 / Run a local node

```bash
anvil
```

---

## 本地证据（Anvil Demo — 完全可复现）

## Evidence (Local Anvil Demo — Fully Reproducible)

本节用于在本地完全复现实验流程（不依赖外部 RPC、无需测试币）。
This section reproduces the full flow locally (no external RPC, no test ETH needed).

### 合约 / Contract

* 网络 / Network: Local Anvil（chainId = 31337）
* 合约 / Contract: `AccessAudit`
* 地址 / Address: `0x5FbDB2315678afecb367f032d93F642f64180aa3`

### 交易 / Transactions

#### 1) 部署 / Deploy

* Tx: `0xa8fb7706e7d37b1550aeb9482d0677f5cb6d5f0aa574e1008cb1df776850c158`

#### 2) 授权审批者 / Grant role

* `APPROVER_ROLE = keccak256("APPROVER_ROLE")`
  `0x408a36151f841709116a4e8aca4e0202874f7f54687dcb863b1ea4672dc9d8cf`
* Tx（grantRole）: `0x1a9aa50730e7adb665e924c86a285caf0949f93a691b9862f5f2cccdd4c0b8a7`

#### 3) 请求访问（事件）/ Request access (event)

* payloadHash = `keccak256("dataset-1|training|v1")`
  `0x94d62e349023744bd9aa4cb617679aa9555f778415f37ebf00bed0da3f5fc4ba`
* Tx（requestAccess）: `0x58b6b097aaaf795163f91d967f7debde4a2cbe5062bf4162deb72886763b17c8`

#### 4) 审批决定（事件）/ Decide (event)

* approved: `true`
* Tx（decide）: `0x22b592e5b162b5564a14d4147cb4c3faf7e755869ad8bd2a2713fe1cd5777146`

## Resources / 使用的资源

### Learning resources / 学习资源
- Bilibili Tutorial Vids/ 学习的视频
  - 【智能合约｜PKUBA北大区块链协会Web3新人公开课（第4讲）】https://www.bilibili.com/video/BV12v4y1R77o?vd_source=0db291edfed22838b24ac30293ce8db5
  - 【Web3的审计与安全｜PKUBA北大区块链协会Web3进阶公开课（第2讲）】https://www.bilibili.com/video/BV19vBjYqEYn?vd_source=0db291edfed22838b24ac30293ce8db5
  - 【【零基础】Solidity快速入门 | 智能合约开发 | Web3案例入门 | 区块链开发 | 加密鲸拓】https://www.bilibili.com/video/BV1S5pqeBEfp?vd_source=0db291edfed22838b24ac30293ce8db5
  - 【【原创教程】Foundry 入门实战 | 智能合约测试 | Web3单元测试 | 加密鲸拓】https://www.bilibili.com/video/BV1wS1WYoEan?vd_source=0db291edfed22838b24ac30293ce8db5

- Tutorial website / 教程网站：
  - https://leapwhale.com/article/8r581039
  - https://leapwhale.com/tag/foundry
  - https://www.useweb3.xyz
  - https://cryptozombies.io

- Community forums / 参考的论坛
  - https://ethereum.stackexchange.com
  - https://ethresear.ch

### Official docs（官方资料）
- Foundry (install / forge / cast / deploy & verify)
  - https://getfoundry.sh/
  - https://book.getfoundry.sh/
  - https://getfoundry.sh/introduction/installation/
  - https://getfoundry.sh/forge/deploying/
- OpenZeppelin Contracts (AccessControl / role-based access control)
  - https://docs.openzeppelin.com/contracts/5.x/access-control
- MetaMask (wallet basics + developer docs)
  - https://docs.metamask.io/
- Alchemy (Sepolia RPC / JSON-RPC basics)
  - https://www.alchemy.com/docs
  - https://www.alchemy.com/chain-connect/chain/sepolia


## Tooling used 工具与服务

- Wallet: MetaMask (testnet accounts only)
- RPC provider: Alchemy (Sepolia)
- Block explorer / verification: Etherscan (Sepolia)
- Language/toolchain: Solidity + Foundry (forge/cast/anvil)
- Libraries: OpenZeppelin Contracts (AccessControl)

