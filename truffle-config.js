const dotenv = require("dotenv");
dotenv.config();
const privKey = process.env.MY_PRIVATE_KEY;
const HDWalletProvider = require("@truffle/hdwallet-provider");

// Helper function to safely create a provider with error logging
function createProvider(url) {
    try {
        return new HDWalletProvider(privKey, url);
    } catch (error) {
        console.error(`Failed to create provider for URL: ${url}`, error);
        return null;
    }
}

module.exports = {
    networks: {
        development: {
            provider: () => createProvider(process.env.JSON_RPC_RELAY_URL),
            network_id: process.env.NETWORK_ID, // Network ID from .env
            gas: 4000000, // Gas limit
            gasPrice: 2000000000000, // 2000 gwei (in wei)
        },
        hedera: {
            provider: () => createProvider("https://testnet.hashio.io/api"),
            network_id: 296, // Hedera Testnet Network ID
            gas: 15000000, // Gas limit for Hedera
        }
    },
    mocha: {
        // timeout: 100000
    },
    compilers: {
        solc: {
            version: "0.8.14", // Fetch exact version from solc-bin (default: truffle's version)
        },
    },
    db: {
        enabled: false,
    },
};
