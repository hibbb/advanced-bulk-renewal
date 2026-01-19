# Advanced Bulk Renewal

一套更自由的 .eth 名称批量续费合约，相比于普通的续费合约，它支持：

1. 对 .eth 名称进行批量续费；
2. 通过 referrer 进行追溯；
3. 为每个名称设定不同的续费时长。

## 部署情况

### Mainnet

- 部署账户： liubenben.eth
- 部署参数： _controller: 0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547
- 部署参数： _name: "bulk.ensbook.eth"
- 部署地址： 0x0735086b17D590c19907E88B6915ecDf47Fe8D88
- [Advanced Bulk Renew](https://etherscan.io/address/0x0735086b17D590c19907E88B6915ecDf47Fe8D88), Named: bulk.ensbook.eth

### Sepolia

- 部署账户： 0x51FbA016F698CDB6117c3ddA96da6F8165eB5ecb
- 部署参数： _controller: 0xfb3ce5d01e0f33f41dbb39035db9745962f1f968
- 部署地址： 0xf7cc605da9777e92db06f9cd226c99d2f07ef566
- [Advanced Bulk Renew](https://sepolia.etherscan.io/address/0xf7cc605da9777e92db06f9cd226c99d2f07ef566)

## 参考资源

### Mainnet Resources

- (A): [ensdomains' ethregistrar: github](https://github.com/ensdomains/ens-contracts/tree/0eb24b9e830529bde769ef8f8ba60cda53f2d2e3/contracts/ethregistrar)
- (B): [ensdomains' ethregistrar controller: deployed contract](https://etherscan.io/address/0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547#code)
- (C): [ensdomains' bulk renewal: github](https://github.com/ensdomains/ens-contracts/blob/0eb24b9e830529bde769ef8f8ba60cda53f2d2e3/contracts/ethregistrar/BulkRenewal.sol)
- (D): [ensdomains' bulk renewal: deployed contract](https://etherscan.io/address/0xff252725f6122a92551a5fa9a6b6bf10eb0be035#code)
- (E): [Namehash's renewal with referrer: github](https://github.com/namehash/ens-referrals/blob/main/src/UniversalRegistrarRenewalWithReferrer.sol)
- (F): [Namehash's renewal with referrer: deployed contract](https://etherscan.io/address/0xf55575Bde5953ee4272d5CE7cdD924c74d8fA81A#code)

### Sepolia Resources

- (G): [ensdomains' ethregistrar controller: deployed contract](https://sepolia.etherscan.io/address/0xfb3ce5d01e0f33f41dbb39035db9745962f1f968#code)
