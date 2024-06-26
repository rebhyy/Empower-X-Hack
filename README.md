# قطرة: Smart Water Irrigation System

![Logo](https://cdn.imgchest.com/files/my2pcekv3k7.png)

## Overview

قطرة aims to create a Smart Water Irrigation System that leverages drone technology, smart contracts on the Hedera blockchain, and renewable energy sources to optimize water usage in agriculture. The system ensures that water is supplied precisely to the areas that need it based on real-time data, thus promoting sustainable agriculture practices.

## Project Features

1. **Drone Technology**: Drones equipped with thermal cameras are used to scan fields and collect real-time data.
2. **Smart Contracts**: Smart contracts deployed on the Hedera blockchain automate the irrigation process based on the data collected by drones.
3. **Renewable Energy**: The system uses solar panels to power the irrigation system, and any excess energy is tokenized and traded on the blockchain.
4. **Data-Driven Irrigation**: The system monitors various parameters such as NDVI (Normalized Difference Vegetation Index), humidity, soil moisture, and temperature to determine the irrigation needs.
5. **Water and Energy Trading**: The system enables the tokenization and trading of water supplies and solar energy, providing a new avenue for resource management.

## Goals

- **Optimize Water Usage**: Reduce water wastage by ensuring that only the areas that need water are irrigated.
- **Promote Sustainability**: Utilize renewable energy to power the irrigation system, reducing the carbon footprint.
- **Enhance Crop Yield**: Improve crop yield by ensuring optimal irrigation based on precise data.

## How It Works

![How It Works](https://cdn.imgchest.com/files/my8xc5novb4.png)

1. **Data Collection**:
    - Drones fly over the fields and collect data on NDVI, soil moisture, temperature, and humidity.
    - This data is transmitted to a central server where it is processed and analyzed.

2. **Smart Contract Execution**:
    - Based on the analyzed data, smart contracts on the Hedera blockchain are triggered.
    - If certain thresholds (e.g., low NDVI or soil moisture) are met, the smart contract opens the irrigation valves for the specific sectors that need water.

3. **Renewable Energy Utilization**:
    - Solar panels provide the necessary energy for the irrigation system.
    - Excess energy generated is tokenized and can be traded on the Hedera blockchain.

4. **Data Marketplace**:
    - Farmers can buy valuable data collected via our drones, ensuring efficient resource management and creating a new revenue stream.

## Technology Stack

- **Drone Technology**: Drones equipped with thermal cameras.
- **Blockchain**: Hedera Hashgraph for deploying smart contracts and managing tokenization.
- **Smart Contracts**: Solidity for writing the irrigation control contracts.
- **Data Analysis**: Python for processing and analyzing the data collected by drones.
- **Renewable Energy**: Solar panels for generating renewable energy.
- **Mobile App**: Kotlin for developing the mobile application to interact with the system.

## Installation

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/rebhyy/Empower-X-Hack.git
    cd Empower-X-Hack
    ```

2. **Install Dependencies**:
    - Ensure you have Node.js and npm installed.
    - Install Truffle globally if you haven't already:
      ```bash
      npm install -g truffle
      ```
    - Install project dependencies:
      ```bash
      npm install
      ```

3. **Set Up Environment Variables**:
    - Create a `.env` file in the root directory and add your Hedera account details:
      ```plaintext
      MY_ACCOUNT_ID=<your-hedera-account-id>
      MY_PRIVATE_KEY=<your-hedera-private-key>
      NETWORK_ID=296
      JSON_RPC_RELAY_URL=https://testnet.hashio.io/api
      ```

4. **Deploy Smart Contracts**:
    ```bash
    truffle migrate --reset
    ```

## Usage

- **Run the Application**:
    - Start the development server:
      ```bash
      node index.js
      ```
    - Open the mobile app to interact with the smart irrigation system.

## Contributing

1. Fork the repository.
2. Create a new feature branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

For more information, please contact:

- **Name**: Ahmed Aziz Rebhi
- **Email**: [ahmedaziz.Rebhi@esprit.tn](mailto:ahmedaziz.Rebhi@esprit.tn)
- **LinkedIn**: [Ahmed Aziz Rebhi](https://www.linkedin.com/in/ahmed-rebhi-726530202/)
