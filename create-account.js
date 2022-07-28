const {
  Client,
  PrivateKey,
  Hbar,
  TransferTransaction,
  AccountId,
} = require("@hashgraph/sdk");
const dotenv = require("dotenv");
const axios = require("axios");
dotenv.config();
const delay = (ms) => new Promise((res) => setTimeout(res, ms));

async function main() {
  //Grab your Hedera testnet account ID and private key from your .env file
  const myAccountId = process.env.ACCOUNT_ID;
  const myPrivateKey = process.env.PRIVATE_KEY;

  // If we weren't able to grab it, we should throw a new error
  if (myAccountId == null || myPrivateKey == null) {
    throw new Error(
      "Environment variables myAccountId and myPrivateKey must be present"
    );
  }

  // Create our connection to the Hedera network
  // The Hedera JS SDK makes this really easy!
  //Create your local client
  const client = Client.forTestnet();

  client.setOperator(myAccountId, myPrivateKey);

  // Create ECDSA keypair
  console.log("Generating a new keypair");
  const newAccountPrivateKey = await PrivateKey.generateECDSA();
  const publicKey = newAccountPrivateKey.publicKey;

  // Assuming that the target shard and realm are known.
  // For now they are virtually always 0 and 0.
  const aliasAccountId = publicKey.toAccountId(0, 0);
  console.log("Account alias", aliasAccountId.toString());

  // Sending Hbar to account alias to auto-create account
  const sendHbar = await new TransferTransaction()
    .addHbarTransfer(myAccountId, Hbar.from(-100)) //Sending account
    .addHbarTransfer(aliasAccountId, Hbar.from(100)) //Receiving account
    .execute(client);
  const transactionReceipt = await sendHbar.getReceipt(client);
  console.log(
    "The transfer transaction from my account to the new account was: " +
      transactionReceipt.status.toString()
  );

  await delay(10000); // wait for 10 seconds before querying account id
  const mirrorNodeUrl = "https://testnet.mirrornode.hedera.com/api/v1/";
  try {
    const account = await axios.get(
      mirrorNodeUrl +
        "accounts?account.publickey=" +
        newAccountPrivateKey.publicKey.toStringRaw()
    );
    console.log("New account id", account.data?.accounts[0].account);
  } catch (err) {
    console.log(err);
  }

  console.log(
    "New account private key (EVM)",
    "0x" + newAccountPrivateKey.toStringRaw()
  );
  console.log(
    "New account public key (EVM)",
    "0x" + newAccountPrivateKey.publicKey.toEthereumAddress()
  );

  console.log(
    "New account private key (Hedera)",
    newAccountPrivateKey.toString()
  );
  console.log(
    "New account public key (Hedera)",
    newAccountPrivateKey.publicKey.toString()
  );
}
main();
