const express = require('express');
const { Client, AccountId, PrivateKey, ContractFunctionParameters, ContractExecuteTransaction, ContractCallQuery, Hbar } = require('@hashgraph/sdk');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());

const operatorId = AccountId.fromString(process.env.NEW_ACCOUNT_ID);
const operatorKey = PrivateKey.fromStringECDSA(process.env.NEW_PRIVATE_KEY);
const contractId = process.env.CONTRACT_ID;

const client = Client.forTestnet().setOperator(operatorId, operatorKey);

console.log(`Using Account ID: ${operatorId}`);
console.log(`Using Private Key: ${operatorKey.toString()}`);

// Endpoint to get sensor data by id
app.get('/sensorData/:id', async (req, res) => {
    const id = req.params.id;
    try {
        const contractCall = new ContractCallQuery()
            .setContractId(contractId)
            .setGas(100000)
            .setFunction('getSensorData', new ContractFunctionParameters().addUint256(id));
        const response = await contractCall.execute(client);

        const timestamp = response.getUint256(0);
        const ndvi = response.getInt256(1);

        res.json({ id, timestamp, ndvi });
    } catch (error) {
        console.error(error);
        res.status(500).send(error.toString());
    }
});

// Endpoint to record new sensor data
app.post('/recordSensorData', async (req, res) => {
    const { ndvi } = req.body;
    try {
        const contractExecuteTx = new ContractExecuteTransaction()
            .setContractId(contractId)
            .setGas(500000)
            .setFunction('recordSensorData', new ContractFunctionParameters().addInt256(ndvi))
            .setMaxTransactionFee(new Hbar(2));

        console.log(`Executing transaction with NDVI: ${ndvi}`);
        
        const submit = await contractExecuteTx.execute(client);
        const receipt = await submit.getReceipt(client);

        console.log(`Transaction status: ${receipt.status.toString()}`);
        res.json({ status: receipt.status.toString() });
    } catch (error) {
        console.error('Error executing contract:', error);
        res.status(500).send(error.toString());
    }
});


// Endpoint to get scheduled irrigation data by sector
app.get('/scheduledIrrigation/:sector', async (req, res) => {
    const sector = req.params.sector;
    try {
        const contractCall = new ContractCallQuery()
            .setContractId(contractId)
            .setGas(100000)
            .setFunction('getScheduledIrrigation', new ContractFunctionParameters().addUint256(sector));
        const response = await contractCall.execute(client);

        const scheduleTime = response.getUint256(0);
        const amountWatered = response.getUint256(1);
        const scheduled = response.getBool(2);
        const scheduleMessage = response.getString(3);

        res.json({ sector, scheduleTime, amountWatered, scheduled, scheduleMessage });
    } catch (error) {
        console.error(error);
        res.status(500).send(error.toString());
    }
});



// Endpoint to check and trigger irrigation based on NDVI value
app.post('/checkAndTriggerIrrigation', async (req, res) => {
    const { sector, ndvi, amountWatered } = req.body;
    try {
        const contractExecuteTx = new ContractExecuteTransaction()
            .setContractId(contractId)
            .setGas(300000) // Increase gas limit if necessary
            .setFunction('checkAndTriggerIrrigation', new ContractFunctionParameters()
                .addUint256(sector)
                .addInt256(ndvi)
                .addUint256(amountWatered))
            .setMaxTransactionFee(new Hbar(2));

        const submit = await contractExecuteTx.execute(client);
        const receipt = await submit.getReceipt(client);
        res.json({ status: receipt.status.toString() });
    } catch (error) {
        console.error(error);
        res.status(500).send(error.toString());
    }
});


// New Endpoint to check valve status by sector
app.get('/valveStatus/:sector', async (req, res) => {
    const sector = req.params.sector;
    try {
        const contractCall = new ContractCallQuery()
            .setContractId(contractId)
            .setGas(100000)
            .setFunction('getScheduledIrrigation', new ContractFunctionParameters().addUint256(sector));
        const response = await contractCall.execute(client);

        const scheduleTime = response.getUint256(0);
        const amountWatered = response.getUint256(1);
        let scheduled = response.getBool(2);
        const scheduleMessage = response.getString(3);

        const currentTime = Math.floor(Date.now() / 1000);

        let valveStatus; 
        
        if (scheduleMessage.includes("NDVI is too high")) {
            scheduled = false;
            valveStatus = "closed";
        } else if (scheduled && scheduleTime <= currentTime) {
            valveStatus = "open now";
        } else if (scheduled && scheduleTime > currentTime) {
            valveStatus = "will open tomorrow";
        } else {
            valveStatus = "closed";
        }

        res.json({ sector, valveStatus, scheduleTime, amountWatered, scheduled, scheduleMessage });
    } catch (error) {
        console.error(error);
        res.status(500).send(error.toString());
    }
});
// Endpoint to get irrigation action by id
app.get('/irrigationAction/:id', async (req, res) => {
    const id = req.params.id;
    try {
        const contractCall = new ContractCallQuery()
            .setContractId(contractId)
            .setGas(100000)
            .setFunction('getIrrigationAction', new ContractFunctionParameters().addUint256(id));
        const response = await contractCall.execute(client);

        const timestamp = response.getUint256(0);
        const sector = response.getUint256(1);
        const amountWatered = response.getUint256(2);
        const success = response.getBool(3);

        res.json({ id, timestamp, sector, amountWatered, success });
    } catch (error) {
        console.error(error);
        res.status(500).send(error.toString());
    }
});

app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ${process.env.PORT}`);
});
