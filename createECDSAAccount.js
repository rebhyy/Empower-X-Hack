const { Client, AccountId, PrivateKey, AccountCreateTransaction, Hbar } = require('@hashgraph/sdk');
require('dotenv').config();

console.log(`Using Account ID: ${process.env.MY_ACCOUNT_ID}`);
console.log(`Using Private Key: ${process.env.MY_PRIVATE_KEY}`);

const operatorId = AccountId.fromString(process.env.MY_ACCOUNT_ID);
const operatorKey = PrivateKey.fromStringECDSA(process.env.MY_PRIVATE_KEY);

const client = Client.forTestnet().setOperator(operatorId, operatorKey);

async function createECDSAAccount() {
    const newPrivateKey = PrivateKey.generateECDSA();
    const newPublicKey = newPrivateKey.publicKey;

    console.log(`New ECDSA Private Key: ${newPrivateKey.toString()}`);
    console.log(`New ECDSA Public Key: ${newPublicKey.toString()}`);

    try {
        const accountCreateTx = new AccountCreateTransaction()
            .setKey(newPublicKey)
            .setInitialBalance(new Hbar(10)); // Adjust the initial balance as needed

        const submit = await accountCreateTx.execute(client);
        const receipt = await submit.getReceipt(client);
        const newAccountId = receipt.accountId;

        console.log(`New ECDSA Account ID: ${newAccountId}`);
        return { newAccountId, newPrivateKey };
    } catch (error) {
        console.error(`Error executing transaction: ${JSON.stringify(error)}`);
    }
}

createECDSAAccount();
