const {
    Client,
    PrivateKey,
    AccountId,
    TransferTransaction,
    Hbar,
} = require("@hashgraph/sdk");
require("dotenv").config();

const operatorId = AccountId.fromString(process.env.MY_ACCOUNT_ID);
const operatorKey = PrivateKey.fromStringECDSA(process.env.MY_PRIVATE_KEY);
const recipientId = AccountId.fromString(process.env.NEW_ACCOUNT_ID);

const client = Client.forTestnet().setOperator(operatorId, operatorKey);

async function transferHbar(recipientId, amount) {
    try {
        const transferTransaction = new TransferTransaction()
            .addHbarTransfer(operatorId, Hbar.fromTinybars(-amount))
            .addHbarTransfer(recipientId, Hbar.fromTinybars(amount));

        const response = await transferTransaction.execute(client);
        const receipt = await response.getReceipt(client);
        console.log(`Transaction status: ${receipt.status}`);
    } catch (error) {
        console.error(`Error executing transfer: ${error}`);
    }
}

transferHbar(recipientId, 1000000000); 
