const { Client, AccountId, PrivateKey, ContractExecuteTransaction, ContractFunctionParameters, Hbar } = require('@hashgraph/sdk');
require('dotenv').config();

const operatorId = AccountId.fromString(process.env.MY_ACCOUNT_ID);
const operatorKey = PrivateKey.fromString(process.env.ETH_PRIVATE_KEY);
const contractId = process.env.CONTRACT_ID;

console.log(`Using Account ID: ${operatorId}`);
console.log(`Using Private Key: ${operatorKey.toString()}`);
console.log(`Using Contract ID: ${contractId}`);

const client = Client.forTestnet().setOperator(operatorId, operatorKey);

async function main() {
    try {
        const contractExecuteTx = new ContractExecuteTransaction()
            .setContractId(contractId)
            .setGas(100000)
            .setFunction('recordSensorData', new ContractFunctionParameters().addInt256(50))
            .setMaxTransactionFee(new Hbar(2));

        const submit = await contractExecuteTx.execute(client);
        const receipt = await submit.getReceipt(client);
        console.log(`Transaction Status: ${receipt.status.toString()}`);
    } catch (error) {
        console.error(`Error executing transaction: ${error}`);
    }
}

main();
