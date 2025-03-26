# Upgrading

## Prerequisite

- Access to LeverFi Deployer (AWS KMS)
    - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
        - `export AWS_ACCESS_KEY_ID=<access_key_id>`
        - `export AWS_SECRET_ACCESS_KEY=<secret_access_key>`
        - `export AWS_REGION=ap-southeast-1`
        - `export AWS_KMS_KEY_ID=ae2031f5-be1e-40a7-8e1d-97cb33d721b3`
- Access to LeverFi Operator (Gnosis MultiSig)

## Deployer Required Cost

| Step                         | Gas Used (gwei) | Cost                        |
|------------------------------|-----------------|-----------------------------|
| Deploy Lever2 Implementation | 0.003848103     | 0.000005643115677290699 ETH |

## Upgrade Lever

### Steps Part 1

- [ ] Compile `Lever2` contract
    - run `forge compile`
    - run `./flatten.sh`
- [ ] Using `scripts/deploy-lever.sol`, deploy `Lever2.sol` implementation
    - `forge script scripts/deploy-lever.s.sol --aws --broadcast --slow --rpc-url=<RPC_URL>`
- [ ] Store/keep `Lever2` implementation address
    - Update [Inventory - LeverFi v3 Contracts](https://leverfi.atlassian.net/wiki/spaces/LF/pages/169869325/Inventory+-+LeverFi+v3+Contracts)
- [ ] Verify `Lever2` contract
- [ ] In Gnosis, upgrade `Lever` with `TimelockController.schedule()` transaction
    - address: `0xf29900Bb8F0f12726d4Ec5F7D511ebC44be06E09`
    - method: `schedule(address,uint256,bytes,bytes32,bytes32,uint256)`
        - address: `0x4B5f49487ea7B3609b1aD05459BE420548789f1f` (Lever)
        - value: `0`
        - data: `0x3659cfe6000000000000000000000000<lever2-implementation-address>`
        - predecessor: `0`
        - salt: `0`
        - delay: `86400`
    - value: `0`
- [ ] In Gnosis, let other signers sign the transaction
- [ ] Wait for defined schedule delay and proceed to [Part 2](./Upgrade.md#steps-part-2)

> Tip: You can run `scripts/simulate-upgrade-lever.s.sol` and modify the parameters to make sure that `data` is correct

### Steps Part 2

- [ ] In Gnosis, upgrade `Lever` with `TimelockController.execute()` transaction
    - address: `0xf29900Bb8F0f12726d4Ec5F7D511ebC44be06E09`
    - method: `execute(address,uint256,bytes,bytes32,bytes32)`
        - address: `0x4B5f49487ea7B3609b1aD05459BE420548789f1f` (Lever)
        - value: `0`
        - data: `0x3659cfe6000000000000000000000000<lever2-implementation-address>`
        - predecessor: `0`
        - salt: `0`
    - value: `0`
- [ ] In Gnosis, let other signers sign the transaction

> Tip: You can run `scripts/simulate-upgrade-lever.s.sol` and modify the parameters to make sure that `data` is correct

## Minting

### Steps Part 1

- [ ] In Gnosis, mint in `Lever` with `TimelockController.schedule()` transaction
    - address: `0xf29900Bb8F0f12726d4Ec5F7D511ebC44be06E09`
    - method: `schedule(address,uint256,bytes,bytes32,bytes32,uint256)`
        - address: `0x4B5f49487ea7B3609b1aD05459BE420548789f1f` (Lever)
        - value: `0`
        - data: `0x40c10f19000000000000000000000000<account-address><mint-amount-hex>`
        - predecessor: `0`
        - salt: `0`
        - delay: `86400`
    - value: `0`
- [ ] In Gnosis, let other signers sign the transaction
- [ ] Wait for defined schedule delay and proceed to [Part 2](./Upgrade.md#steps-part-2)

### Steps Part 2

- [ ] In Gnosis, mint in `Lever` with `TimelockController.execute()` transaction
    - address: `0xf29900Bb8F0f12726d4Ec5F7D511ebC44be06E09`
    - method: `execute(address,uint256,bytes,bytes32,bytes32)`
        - address: `0x4B5f49487ea7B3609b1aD05459BE420548789f1f` (Lever)
        - value: `0`
        - data: `0x40c10f19000000000000000000000000<account-address><mint-amount-hex>`
        - predecessor: `0`
        - salt: `0`
    - value: `0`
- [ ] In Gnosis, let other signers sign the transaction
