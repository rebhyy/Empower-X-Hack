// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Listing {
        uint256 id;
        address seller;
        string contractType; // "Selling Water" or "Energy"
        uint256 amount; // Amount of water or energy
        uint256 price; // Price in Wei
        bool isSold;
    }

    Listing[] public listings;
    uint256 public listingCounter;

    event ListingCreated(
        uint256 listingId,
        address indexed seller,
        string contractType,
        uint256 amount,
        uint256 price
    );

    event ListingSold(
        uint256 listingId,
        address indexed seller,
        address indexed buyer,
        string contractType,
        uint256 amount,
        uint256 price
    );

    function createListing(string memory _contractType, uint256 _amount, uint256 _price) public {
        require(_amount > 0, "Amount must be greater than zero");
        require(bytes(_contractType).length > 0, "Contract type must be a non-empty string");
        require(_price > 0, "Price must be greater than zero");

        listingCounter++;
        listings.push(Listing({
            id: listingCounter,
            seller: msg.sender,
            contractType: _contractType,
            amount: _amount,
            price: _price,
            isSold: false
        }));

        emit ListingCreated(listingCounter, msg.sender, _contractType, _amount, _price);
    }

    function buyListing(uint256 _listingId) public payable {
        require(_listingId > 0 && _listingId <= listingCounter, "Listing does not exist");
        Listing storage listing = listings[_listingId - 1];  // Adjusting for zero-indexed array
        require(!listing.isSold, "Listing already sold");
        require(msg.value >= listing.price, "Insufficient funds to purchase listing");

        listing.isSold = true;

        // Transfer funds to the seller
        payable(listing.seller).transfer(listing.price);

        emit ListingSold(_listingId, listing.seller, msg.sender, listing.contractType, listing.amount, listing.price);
    }

    function getListing(uint256 _listingId) public view returns (address, string memory, uint256, uint256, bool) {
        require(_listingId > 0 && _listingId <= listingCounter, "Listing does not exist");

        Listing storage listing = listings[_listingId - 1];  // Adjusting for zero-indexed array
        return (listing.seller, listing.contractType, listing.amount, listing.price, listing.isSold);
    }

    function getAllListings() public view returns (Listing[] memory) {
        return listings;
    }

    function getListingDetails(uint256 _listingId) public view returns (string memory) {
        require(_listingId > 0 && _listingId <= listingCounter, "Listing does not exist");

        Listing storage listing = listings[_listingId - 1];  // Adjusting for zero-indexed array
        return string(abi.encodePacked(
            "ID: ", uintToString(listing.id),
            ", Seller: ", addressToString(listing.seller),
            ", Contract Type: ", listing.contractType,
            ", Amount: ", uintToString(listing.amount),
            ", Price: ", uintToString(listing.price / 1 ether), " ETH",
            ", Is Sold: ", listing.isSold ? "Yes" : "No"
        ));
    }

    function uintToString(uint v) internal pure returns (string memory) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - j - 1];
        }
        return string(s);
    }

    function addressToString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
