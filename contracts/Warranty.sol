//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract Warranty  {

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
        tempProduct.price = _price * 10**18; //ether to Wei
        tempProduct.prodSerialNo = _prodSerialNo;  
        tempProduct.seller = payable(msg.sender);
        tempProduct.productId = counter;
        products.push(tempProduct);
        counter++;
        emit registered(_title, tempProduct.productId, msg.sender);
    }

    function buyProduct(uint _productId) payable public {
        require(products[_productId - 1].price == msg.value, "Please pay the exact amount!");
        require(products[_productId - 1].seller == msg.sender, "Seller cannot buy the product");
        products[_productId - 1].buyer = msg.sender;
        emit bought(_productId, msg.sender);
    }

    function delivery(uint _productId) public {
        require(products[_productId - 1].buyer == msg.sender, "Only buyer van confirm");
        products[_productId - 1].delivered = true;
        products[_productId - 1].seller.transfer(products[_productId - 1].price);
        emit delivered(_productId);
        
    }
}