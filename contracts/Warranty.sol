//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

//imports
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {Base64} from "./libraries/Base64.sol";

contract Warranty  is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor(string memory _name) payable ERC721("Product Warranty", "blockchian--based") {
    console.log("%s service deployed", _name);
    }

    struct Product{
        string title;
        string desc;
        address payable seller;
        uint productId;
        uint prodSerialNo;
        uint price;
        address buyer;
        bool delivered;
        //include warranty start and expiry
    }

    // Storing NFT images on chain as SVGs
    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#a)" d="M0 0h270v270H0z"/><defs><filter id="b" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949a4.382 4.382 0 0 0-4.394 0l-10.081 6.032-6.85 3.934-10.081 6.032a4.382 4.382 0 0 1-4.394 0l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616 4.54 4.54 0 0 1-.608-2.187v-9.31a4.27 4.27 0 0 1 .572-2.208 4.25 4.25 0 0 1 1.625-1.595l7.884-4.59a4.382 4.382 0 0 1 4.394 0l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616 4.54 4.54 0 0 1 .608 2.187v6.032l6.85-4.065v-6.032a4.27 4.27 0 0 0-.572-2.208 4.25 4.25 0 0 0-1.625-1.595L41.456 24.59a4.382 4.382 0 0 0-4.394 0l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595 4.273 4.273 0 0 0-.572 2.208v17.441a4.27 4.27 0 0 0 .572 2.208 4.25 4.25 0 0 0 1.625 1.595l14.864 8.655a4.382 4.382 0 0 0 4.394 0l10.081-5.901 6.85-4.065 10.081-5.901a4.382 4.382 0 0 1 4.394 0l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616 4.54 4.54 0 0 1 .608 2.187v9.311a4.27 4.27 0 0 1-.572 2.208 4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721a4.382 4.382 0 0 1-4.394 0l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616 4.53 4.53 0 0 1-.608-2.187v-6.032l-6.85 4.065v6.032a4.27 4.27 0 0 0 .572 2.208 4.25 4.25 0 0 0 1.625 1.595l14.864 8.655a4.382 4.382 0 0 0 4.394 0l14.864-8.655a4.545 4.545 0 0 0 2.198-3.803V55.538a4.27 4.27 0 0 0-.572-2.208 4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786z" fill="#fff"/><defs><linearGradient id="a" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#F59300"/><stop offset="1" stop-color="#00CCB4" stop-opacity=".99"/></linearGradient></defs><text x="32.5" y="231" font-size="15" fill="#fff" filter="url(#b)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">Product Serial No: ';
    string svgPartTwo = '</text></svg>';

    uint counter = 1;
    //array of product type named as products
    Product[] public products;

    event registered(string title, uint productId, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    function registerProduct(string memory _title, string memory _desc, uint _prodSerialNo, uint _price) public {
        require(_price > 0, "Price should be greater than zero!");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        tempProduct.price = _price * 10**17; //ether to Wei
        console.log("price:", tempProduct.price);
        tempProduct.prodSerialNo = _prodSerialNo;  
        tempProduct.seller = payable(msg.sender);
        tempProduct.productId = counter;
        products.push(tempProduct);
        

        counter++;
        console.log("Seller: ", msg.sender);
        emit registered(_title, tempProduct.productId, msg.sender);
    }

    function buyProduct(uint _productId) payable public {
        require(products[_productId - 1].price >= msg.value, "Please pay the exact amount!");
        require(products[_productId - 1].seller != msg.sender, "Seller cannot buy the product"); //later change == to !=
        products[_productId - 1].buyer = msg.sender;

        string memory _prodSerialNoInStr = Strings.toString(products[_productId - 1].prodSerialNo);
        // Creating the SVG (image) for the NFT with the product serial no
        string memory finalSvg = string(abi.encodePacked(svgPartOne, _prodSerialNoInStr, svgPartTwo));
        uint256 newRecordId = _tokenIds.current();
        console.log("Registering product with serial no %s on the contract with tokenID %d", _prodSerialNoInStr, newRecordId);

        

    // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
    string memory json = Base64.encode(
      abi.encodePacked(
        '{"title": "',
        products[_productId - 1].title,
        '", "description": "Blockchain-based-Warranty", "image": "data:image/svg+xml;base64,',
        Base64.encode(bytes(finalSvg)),
        '","serialno":"',
        _prodSerialNoInStr,
        '"}'
    )
    );

        string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

        console.log("\n--------------------------------------------------------");
        console.log("Final tokenURI: ", finalTokenUri);
        console.log("--------------------------------------------------------\n");

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        _tokenIds.increment(); 
        
        console.log("Buyer: ", msg.sender);
        emit bought(_productId, msg.sender);
    }

    function delivery(uint _productId) public {
        require(products[_productId - 1].buyer == msg.sender, "Only buyer van confirm");
        products[_productId - 1].delivered = true;
        products[_productId - 1].seller.transfer(products[_productId - 1].price);
        emit delivered(_productId);
    }

    
}