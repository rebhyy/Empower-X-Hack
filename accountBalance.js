const { Client, AccountId, PrivateKey, AccountBalanceQuery } = require('@hashgraph/sdk');
require('dotenv').config();

const operatorId = AccountId.fromString(process.env.MY_ACCOUNT_ID);
const operatorKey = PrivateKey.fromString(process.env.ETH_PRIVATE_KEY);

const client = Client.forTestnet().setOperator(operatorId, operatorKey);

async function checkAccountBalance() {
    try {
        const balanceCheckTx = await new AccountBalanceQuery()
            .setAccountId(operatorId)
            .execute(client);
        console.log(`Account balance: ${balanceCheckTx.hbars.toString()}`);
    } catch (error) {
        console.error(`Error checking balance: ${error}`);
    }
}

checkAccountBalance();
