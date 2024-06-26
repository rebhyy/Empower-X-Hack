// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AgriDataMarketplaceMock {
    struct DataListing {
        uint256 id;
        address seller;
        address buyer; // New field to store the buyer's address
        string dataType;
        string[] dataDescriptions;
        uint256 price;
        bool isSold;
    }

    DataListing[] public dataListings;
    uint256 public dataListingCounter;
    uint256 public fixedPrice; // Fixed price for purchasing all data listings

    event DataListingCreated(uint256 indexed id, address indexed seller, string dataType, uint256 price);
    event DataPurchased(uint256 indexed id, address indexed buyer);
    event PurchaseAllAttempt(address indexed buyer, uint256 valueSent, bool success);

    constructor(uint256 _fixedPrice) {
        require(_fixedPrice > 0, "Constructor: fixedPrice must be greater than zero");
        fixedPrice = _fixedPrice;
        generateMockData();
    }

    function generateMockData() private {
        string[10] memory dataTypes = [
            "Weed Detection", 
            "Topography Mapping", 
            "Pest Detection", 
            "Soil Moisture Levels", 
            "Yield Prediction", 
            "Climate Analysis", 
            "Soil pH Levels", 
            "Nutrient Content", 
            "Water Quality", 
            "Plant Health Indices"
        ];

        require(dataTypes.length > 0, "generateMockData: dataTypes array must not be empty");

        string[10][10] memory descriptions = [
            [
                unicode"High-resolution image data for detecting weed infestations. Coverage: 500 acres, Date: June 2024.",
                unicode"Detailed analysis of weed growth patterns. Detection Rate: 90%, Date: June 2024.",
                unicode"Impact assessment of weed infestation on crop yield. Estimated Loss: 5%, Date: June 2024.",
                unicode"Weed control recommendations based on current infestation. Recommended Herbicide: ABC, Date: June 2024.",
                unicode"Comparison with previous years' weed infestation data. Year-over-Year Change: +2%, Date: June 2024.",
                unicode"Forecast of future weed infestation based on current trends. Projected Increase: 3%, Date: June 2024.",
                unicode"Integration with local weed control policies. Compliance Level: 95%, Date: June 2024.",
                unicode"Impact of weather patterns on weed growth. Correlation: High, Date: June 2024.",
                unicode"Study on weed resistance to herbicides. Resistance Level: Low, Date: June 2024.",
                unicode"Effectiveness of various weed control methods. Best Method: Manual Removal, Date: June 2024."
            ],
            [
                unicode"Detailed 3D maps of field topography for optimal irrigation planning. Area: 300 acres, Date: May 2024.",
                unicode"Topographic contour maps for terrain analysis. Contour Interval: 1m, Date: May 2024.",
                unicode"Digital elevation models for slope analysis. Slope Range: 0-15 degrees, Date: May 2024.",
                unicode"Terrain classification for agricultural suitability. Classification: High, Date: May 2024.",
                unicode"Historical topography changes and analysis. Change: Minimal, Date: May 2024.",
                unicode"Impact of topography on water drainage patterns. Impact Level: Moderate, Date: May 2024.",
                unicode"Optimal locations for building terraces. Recommended Locations: 5, Date: May 2024.",
                unicode"Topography and its effect on soil erosion. Erosion Level: Low, Date: May 2024.",
                unicode"Comparison of topography with adjacent fields. Similarity: 80%, Date: May 2024.",
                unicode"Topographic influence on microclimates. Microclimate Zones: 3, Date: May 2024."
            ],
            [
                unicode"Infrared data for early detection of pests and diseases. Infestation Level: Moderate, Date: July 2024.",
                unicode"Pest population density maps. Density: 20 pests/sq.m, Date: July 2024.",
                unicode"Historical pest infestation data. Previous Year: High, Date: July 2023.",
                unicode"Pest resistance to common pesticides. Resistance: Low, Date: July 2024.",
                unicode"Pest movement patterns and predictions. Movement: North-East, Date: July 2024.",
                unicode"Integrated pest management recommendations. Recommended Actions: 3, Date: July 2024.",
                unicode"Comparison of pest infestation with neighboring fields. Infestation Level: Lower, Date: July 2024.",
                unicode"Pest impact on specific crops. Impact Level: Moderate, Date: July 2024.",
                unicode"Analysis of pest life cycle stages. Predominant Stage: Larvae, Date: July 2024.",
                unicode"Effectiveness of biological pest control methods. Effectiveness: High, Date: July 2024."
            ],
            [
                unicode"Soil moisture content data across different field zones. Moisture Level: 20% average, Date: August 2024.",
                unicode"High-resolution soil moisture maps. Coverage: 300 acres, Date: August 2024.",
                unicode"Soil moisture variability analysis. Variability: Low, Date: August 2024.",
                unicode"Historical soil moisture trends. Trend: Decreasing, Date: August 2024.",
                unicode"Impact of irrigation on soil moisture levels. Impact: High, Date: August 2024.",
                unicode"Soil moisture and its effect on crop yield. Correlation: 0.8, Date: August 2024.",
                unicode"Recommendations for optimal irrigation schedules. Recommended Schedule: Weekly, Date: August 2024.",
                unicode"Soil moisture sensors calibration data. Calibration Date: August 2024.",
                unicode"Comparison of soil moisture across different soil types. Comparison: Sand vs. Clay, Date: August 2024.",
                unicode"Soil moisture and its influence on soil health. Influence Level: High, Date: August 2024."
            ],
            [
                unicode"Predictive analysis data for expected crop yields. Projected Yield: 2000 bushels, Date: September 2024.",
                unicode"Yield prediction models based on historical data. Accuracy: 85%, Date: September 2024.",
                unicode"Impact of weather conditions on crop yield. Impact: Significant, Date: September 2024.",
                unicode"Yield variability analysis across different zones. Variability: Low, Date: September 2024.",
                unicode"Comparison with previous years' crop yields. Year-over-Year Change: +5%, Date: September 2024.",
                unicode"Impact of soil fertility on yield predictions. Fertility Level: High, Date: September 2024.",
                unicode"Effectiveness of different crop varieties on yield. Best Variety: XYZ, Date: September 2024.",
                unicode"Yield impact assessment due to pest and disease. Impact Level: Moderate, Date: September 2024.",
                unicode"Projected yield under different irrigation scenarios. Scenario: High, Date: September 2024.",
                unicode"Recommendations for maximizing crop yield. Recommendation: Increased Fertilization, Date: September 2024."
            ],
            [
                unicode"Comprehensive climate analysis data for last season. Temperature Range: 15-35°C, Humidity: 20-80%, Date: Year 2024.",
                unicode"Detailed weather patterns and trends analysis. Trend: Warmer, Date: Year 2024.",
                unicode"Historical climate data comparison. Past Average: 20-30°C, Date: Year 2024.",
                unicode"Impact of climate on crop growth cycles. Impact: High, Date: Year 2024.",
                unicode"Climate change projections for the next decade. Projection: +2°C, Date: Year 2024.",
                unicode"Seasonal climate variability and its effects. Variability: Moderate, Date: Year 2024.",
                unicode"Climate influence on pest and disease outbreaks. Influence: High, Date: Year 2024.",
                unicode"Optimal planting and harvesting times based on climate. Optimal Time: Early Spring, Date: Year 2024.",
                unicode"Climate risk assessment and mitigation strategies. Risk Level: Medium, Date: Year 2024.",
                unicode"Comparison of local climate with regional trends. Comparison: Similar, Date: Year 2024."
            ],
            [
                unicode"Soil pH level readings to determine soil acidity/alkalinity. pH Range: 5.5-7.5, Date: July 2024.",
                unicode"High-resolution soil pH maps. Coverage: 300 acres, Date: July 2024.",
                unicode"Historical soil pH data and trends. Trend: Stable, Date: July 2024.",
                unicode"Impact of soil pH on nutrient availability. Impact: Significant, Date: July 2024.",
                unicode"Soil pH recommendations for different crops. Recommended pH: 6.0-6.5, Date: July 2024.",
                unicode"Soil pH variability across different zones. Variability: Low, Date: July 2024.",
                unicode"Impact of soil amendments on pH levels. Amendment: Lime, Date: July 2024.",
                unicode"Correlation between soil pH and crop yield. Correlation: 0.7, Date: July 2024.",
                unicode"Comparison of soil pH with neighboring fields. Comparison: Similar, Date: July 2024.",
                unicode"Soil pH and its effect on soil microorganisms. Effect: Positive, Date: July 2024."
            ],
            [
                unicode"Nutrient content analysis to identify nutrient deficiencies. Nitrogen Level: 40ppm, Phosphorus Level: 30ppm, Potassium Level: 50ppm, Date: June 2024.",
                unicode"High-resolution nutrient maps. Coverage: 300 acres, Date: June 2024.",
                unicode"Historical nutrient content trends. Trend: Increasing, Date: June 2024.",
                unicode"Nutrient recommendations for optimal crop growth. Recommended Level: Nitrogen: 50ppm, Date: June 2024.",
                unicode"Nutrient variability analysis across different zones. Variability: Moderate, Date: June 2024.",
                unicode"Impact of fertilization on nutrient levels. Impact: High, Date: June 2024.",
                unicode"Comparison of nutrient content with neighboring fields. Comparison: Lower, Date: June 2024.",
                unicode"Nutrient content and its effect on soil health. Effect: Positive, Date: June 2024.",
                unicode"Analysis of nutrient uptake by different crops. Best Crop: Corn, Date: June 2024.",
                unicode"Nutrient deficiency diagnosis and corrective measures. Diagnosis: Nitrogen Deficient, Date: June 2024."
            ],
            [
                unicode"Water quality data to ensure optimal irrigation practices. pH: 6.8, Salinity: 0.5%, Date: May 2024.",
                unicode"High-resolution water quality maps. Coverage: 300 acres, Date: May 2024.",
                unicode"Historical water quality trends. Trend: Improving, Date: May 2024.",
                unicode"Impact of water quality on crop yield. Impact: Moderate, Date: May 2024.",
                unicode"Water quality variability across different zones. Variability: Low, Date: May 2024.",
                unicode"Recommendations for improving water quality. Recommendation: Filtration, Date: May 2024.",
                unicode"Comparison of water quality with regional standards. Compliance: 95%, Date: May 2024.",
                unicode"Effect of water quality on soil health. Effect: Positive, Date: May 2024.",
                unicode"Analysis of contaminants in water sources. Contaminants: Low, Date: May 2024.",
                unicode"Water quality and its influence on irrigation efficiency. Influence: High, Date: May 2024."
            ],
            [
                unicode"Plant health indices derived from multispectral imaging. Health Index: 0.85, Date: August 2024.",
                unicode"High-resolution plant health maps. Coverage: 300 acres, Date: August 2024.",
                unicode"Historical plant health trends. Trend: Stable, Date: August 2024.",
                unicode"Impact of plant health on crop yield. Impact: Significant, Date: August 2024.",
                unicode"Recommendations for improving plant health. Recommendation: Increased Fertilization, Date: August 2024.",
                unicode"Comparison of plant health with neighboring fields. Comparison: Higher, Date: August 2024.",
                unicode"Plant health variability across different zones. Variability: Moderate, Date: August 2024.",
                unicode"Correlation between plant health and soil conditions. Correlation: High, Date: August 2024.",
                unicode"Impact of pest and disease on plant health. Impact: Low, Date: August 2024.",
                unicode"Plant health monitoring using drone technology. Monitoring Date: August 2024."
            ]
        ];

        require(descriptions.length == dataTypes.length, "generateMockData: descriptions array length must match dataTypes length");

        for (uint i = 0; i < dataTypes.length; i++) {
            string[] memory desc = new string[](10);
            for (uint j = 0; j < 10; j++) {
                desc[j] = descriptions[i][j];
            }

            dataListings.push(DataListing({
                id: dataListingCounter++,
                seller: address(this),
                buyer: address(0), // Initialize with no buyer
                dataType: dataTypes[i],
                dataDescriptions: desc,
                price: fixedPrice / dataTypes.length, // Set individual prices based on fixed price
                isSold: false
            }));
        }
    }

    function retrieveAllData() public view returns (string[][] memory) {
        uint soldCount = 0;
        for (uint i = 0; i < dataListings.length; i++) {
            if (dataListings[i].isSold && dataListings[i].buyer == msg.sender) {
                soldCount++;
            }
        }
        
        require(soldCount > 0, "You need to purchase data to access it");

        string[][] memory allData = new string[][](soldCount);
        uint index = 0;
        
        for (uint i = 0; i < dataListings.length; i++) {
            if (dataListings[i].isSold && dataListings[i].buyer == msg.sender) {
                allData[index] = dataListings[i].dataDescriptions;
                index++;
            }
        }

        return allData;
    }

    function purchaseAllData() external payable {
        require(msg.value == fixedPrice, "Exact amount required");
        
        uint numItems = dataListings.length;
        for (uint i = 0; i < numItems; i++) {
            if (!dataListings[i].isSold) {
                dataListings[i].isSold = true;
                dataListings[i].buyer = msg.sender;
                emit DataPurchased(dataListings[i].id, msg.sender);
            }
        }
    }

    // Function to get the fixed price
    function getFixedPrice() public view returns (uint256) {
        return fixedPrice;
    }
}
