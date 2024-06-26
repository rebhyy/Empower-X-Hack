// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartIrrigationSystem {
    struct SensorData {
        uint256 timestamp;
        int256 ndvi;
    }

    struct IrrigationAction {
        uint256 timestamp;
        uint256 sector;
        uint256 amountWatered;
        bool success;
    }

    struct ScheduledIrrigation {
        uint256 scheduleTime;
        uint256 amountWatered;
        bool scheduled;
        string scheduleMessage; 
    }

    address public owner;
    mapping(uint256 => SensorData) public sensorDataLogs;
    mapping(uint256 => IrrigationAction) public irrigationLogs;
    mapping(uint256 => ScheduledIrrigation) public scheduledIrrigations;
    mapping(uint256 => bool) public valveStatus; 
    uint256 public dataCounter;
    uint256 public actionCounter;

    uint256 constant NDVI_LOW = 35;
    uint256 constant NDVI_HIGH = 70;

    event SensorDataRecorded(uint256 id, uint256 timestamp, int256 ndvi);
    event IrrigationActionExecuted(uint256 id, uint256 timestamp, uint256 sector, uint256 amountWatered, bool success);
    event IrrigationScheduled(uint256 sector, uint256 scheduleTime, uint256 amountWatered, string message);

    constructor() {
        owner = msg.sender;
        dataCounter = 0;
        actionCounter = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function recordSensorData(int256 _ndvi) public /* onlyOwner */ {
        sensorDataLogs[dataCounter] = SensorData(block.timestamp, _ndvi);
        emit SensorDataRecorded(dataCounter, block.timestamp, _ndvi);
        
        checkAndTriggerIrrigation(dataCounter, _ndvi, 100); // Call checkAndTriggerIrrigation here with an example amountWatered of 100
        dataCounter++;
    }



    function executeIrrigation(uint256 _sector) internal {
        ScheduledIrrigation memory schedule = scheduledIrrigations[_sector];
        require(schedule.scheduled, "Irrigation not scheduled");
        require(block.timestamp >= schedule.scheduleTime, "Irrigation scheduled for future");

        irrigationLogs[actionCounter] = IrrigationAction(block.timestamp, _sector, schedule.amountWatered, true);
        emit IrrigationActionExecuted(actionCounter, block.timestamp, _sector, schedule.amountWatered, true);
        actionCounter++;
        scheduledIrrigations[_sector].scheduled = false;
    }

    function checkAndTriggerIrrigation(uint256 _sector, int256 _ndvi, uint256 _amountWatered) internal {
        uint256 delay;
        string memory message;

        if (_ndvi < 35) {
            delay = 0;
            message = "Valves will open now";
            valveStatus[_sector] = true;
        } else if (_ndvi < 70) {
            delay = 1 days;
            message = "Valves will open tomorrow";
            valveStatus[_sector] = true;
        } else {
            valveStatus[_sector] = false;
            message = "NDVI is too high, no irrigation needed";
            scheduleIrrigation(_sector, 0, delay, message); 
            return;
        }

        scheduleIrrigation(_sector, _amountWatered, delay, message);
    }

    function scheduleIrrigation(uint256 _sector, uint256 _amountWatered, uint256 _delay, string memory _message) internal {
        uint256 scheduleTime = block.timestamp + _delay;
        scheduledIrrigations[_sector] = ScheduledIrrigation(scheduleTime, _amountWatered, true, _message);
        emit IrrigationScheduled(_sector, scheduleTime, _amountWatered, _message);
    }


    function getScheduledIrrigation(uint256 _sector) public view returns (uint256 scheduleTime, uint256 amountWatered, bool scheduled, string memory scheduleMessage) {
    ScheduledIrrigation memory irrigation = scheduledIrrigations[_sector];
    return (irrigation.scheduleTime, irrigation.amountWatered, irrigation.scheduled, irrigation.scheduleMessage);
    }

    function simulateSensorDataAndIrrigation(uint256 _iterations, uint256 _amountWatered) public onlyOwner {
        for (uint256 i = 0; i < _iterations; i++) {
            uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, i)));
            int256 simulatedNDVI = int256(rand % 151);

            recordSensorData(simulatedNDVI);
            checkAndTriggerIrrigation(dataCounter - 1, simulatedNDVI, _amountWatered);
        }
    }

    function executeScheduledIrrigation(uint256 _sector) public {
        executeIrrigation(_sector);
    }

    function getSensorData(uint256 _id) public view returns (SensorData memory) {
        return sensorDataLogs[_id];
    }

    function getFormattedSensorData(uint256 _id) public view returns (uint256 timestamp, int256 ndvi) {
        SensorData memory data = getSensorData(_id);
        return (data.timestamp, data.ndvi);
    }

    function getIrrigationAction(uint256 _id) public view returns (IrrigationAction memory) {
        return irrigationLogs[_id];
    }

    function getValveStatus(uint256 _sector) public view returns (bool) {
        return valveStatus[_sector];
    }
}
