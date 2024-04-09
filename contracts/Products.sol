// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "hardhat/console.sol";
import "./Types.sol";

contract Products {
    constructor() {
        Types.ProductTypeAddDTO[]
            memory predefinedProductTypes = new Types.ProductTypeAddDTO[](3);
        predefinedProductTypes[0] = Types.ProductTypeAddDTO("PT0", "D0");
        predefinedProductTypes[1] = Types.ProductTypeAddDTO("PT1", "D1");
        predefinedProductTypes[2] = Types.ProductTypeAddDTO("PT2", "D2");
        _addProductTypeList(predefinedProductTypes);
        Types.Recepie[] memory predefinedRecepies = new Types.Recepie[](1);
        Types.RecepieIngredient[]
            memory predefinedRecepieIngredients = new Types.RecepieIngredient[](
                2
            );
        predefinedRecepieIngredients[0] = Types.RecepieIngredient(0, 0, 6);
        predefinedRecepieIngredients[1] = Types.RecepieIngredient(0, 1, 6);
        recepieIngredients[0][0] = predefinedRecepieIngredients[0];
        recepieIngredients[0][1] = predefinedRecepieIngredients[1];
        predefinedRecepies[0] = Types.Recepie(0, 2, "PT2", 2, 6);
        _addRecepieList(predefinedRecepies);
    }

    // product type id => product type
    mapping(uint256 => Types.ProductType) public productTypes;
    uint256 public productTypeCounter = 0;
    // barcodeId => product
    mapping(string => Types.Product) public products;
    // address => list of product barcodeIds
    mapping(address => string[]) public userLinkedProducts;
    mapping(address => uint256) public productCounter;
    mapping(address => mapping(string => Types.Product))
        internal waitingProducts;

    mapping(uint256 => mapping(uint256 => Types.RecepieIngredient))
        public recepieIngredients;
    mapping(uint256 => Types.Recepie) public recepies;
    uint256 public recepieCounter = 0;

    // links one product barcodeId to it's parents barcodeId,
    // the number of parents is stored in the recepie, number of ingredients
    mapping(string => string[]) public parentProducts;

    // Events

    event NewProduct(
        string name,
        string manufacturerName,
        string barcodeId,
        uint256 manDateEpoch,
        uint256 expDateEpoch
    );

    event NewProductType(string name, uint256 id);
    event NewRecepie(uint256 id, uint256 resultTypeId, string resultTypeName);

    event ProductOwnershipTransferRequest(
        string name,
        string manufacurerName,
        string barcodeId,
        string buyerName,
        string buyerEmail,
        string sellerName,
        string sellerEmail,
        uint256 requestTime
    );

    event ProductOwnershipTransferResponse(
        string name,
        string manufacurerName,
        string barcodeId,
        string buyerName,
        string buyerEmail,
        string sellerName,
        string sellerEmail,
        uint256 responseTime,
        string status
    );

    // Contract Methods

    function _addRecepieList(Types.Recepie[] memory recepieList) public {
        for (uint i = 0; i < recepieList.length; i++) {
            _addRecepie(recepieList[i]);
        }
    }

    function _addRecepie(Types.Recepie memory recepie) public {
        recepies[recepieCounter] = recepie;
        emit NewRecepie(
            recepie.id,
            recepie.resultTypeId,
            recepie.resultTypeName
        );
        recepieCounter++;
    }

    function _addProductTypeList(
        Types.ProductTypeAddDTO[] memory productTypeList
    ) public {
        for (uint i = 0; i < productTypeList.length; i++) {
            _addProductType(productTypeList[i]);
        }
    }

    function _addProductType(
        Types.ProductTypeAddDTO memory productType
    ) public {
        productTypes[productTypeCounter] = Types.ProductType(
            productTypeCounter,
            productType.name,
            productType.details
        );
        emit NewProductType(productType.name, productTypeCounter);
        productTypeCounter++;
    }

    function _addProduct(
        Types.ProductAddDTO memory product_,
        string memory manufacturerName,
        address myAccount
    ) public {
        // require(
        //     product_.manufacturerId == myAccount,
        //     "Only manufacturer can add products"
        // );
        string memory barcodeId = generateBarcode(
            99,
            productCounter[myAccount]
        );
        Types.Product memory product = Types.Product(
            productTypes[product_.productTypeId].name,
            product_.productTypeId,
            barcodeId,
            manufacturerName,
            myAccount,
            product_.manufacturingDate,
            product_.expirationDate,
            product_.isBatch,
            product_.batchCount
        );
        products[barcodeId] = product;
        productCounter[myAccount]++;
        userLinkedProducts[myAccount].push(barcodeId);

        // console.log(myAccount);
        // console.log(productCounter[myAccount]);
        emit NewProduct(
            product.name,
            product.manufacturerName,
            product.barcodeId,
            product.manufacturingDate,
            product.expirationDate
        );
    }

    function _createProduct(
        uint256 recepieId,
        Types.UserDetails memory user
    ) public {
        Types.Recepie memory recepie_ = recepies[recepieId];
        string[] memory _parentProducts = new string[](
            recepie_.ingredientsCount
        );
        uint256 ingredientsCount = 0;
        // iterate through required products by the recepie
        for (uint j = 0; j < userLinkedProducts[user.id].length; ++j) {
            if (recepie_.ingredientsCount == ingredientsCount) {
                break;
            }
            for (uint i = 0; i < recepie_.ingredientsCount; ++i) {
                // iterate through user linked products
                // check if user product is in the recepie
                if (
                    (recepieIngredients[recepie_.id][i].productQuantity <=
                        products[userLinkedProducts[user.id][j]].batchCount) &&
                    (recepieIngredients[recepie_.id][i].productTypeId ==
                        products[userLinkedProducts[user.id][j]].productTypeId)
                ) {
                    // check if the quantity is enough for the recepie
                    // require(
                    //     recepieIngredients[recepie_.id][i].productQuantity <=
                    //         products[userLinkedProducts[user.id][j]].batchCount,
                    //     "Recepie requires user to have more quantity of some product"
                    // );
                    // save the barcodeId of the used product
                    _parentProducts[ingredientsCount] = products[
                        userLinkedProducts[user.id][j]
                    ].barcodeId;

                    // count ingredient used
                    ingredientsCount++;

                    // update the quantity of used products
                    products[userLinkedProducts[user.id][j]]
                        .batchCount -= recepieIngredients[recepie_.id][i]
                        .productQuantity;

                    // check if the quantity is 0 and delete the products
                    if (
                        products[userLinkedProducts[user.id][j]].batchCount == 0
                    ) {
                        // TODO: check this
                        // maybe dont delete this...
                        // delete products[userLinkedProducts[user.id][j]];
                        // delete userLinkedProducts[user.id][j];
                    }
                }
            }
        }

        // check if all ingredients were found and used
        require(
            ingredientsCount == recepie_.ingredientsCount,
            "There are some products missing"
        );

        // create the new product
        Types.Product memory product_ = Types.Product(
            recepie_.resultTypeName,
            recepie_.resultTypeId,
            generateBarcode(99, productCounter[user.id]), //TODO: add manufacturer code
            user.name,
            user.id,
            (block.timestamp / 100) * 100,
            (block.timestamp / 100) * 100 + 86400, //TODO: 86400=1day in timestamp
            true,
            recepie_.quantityResult
        );

        // register the product in parentProducts list
        // in order to keep track of its creation
        parentProducts[product_.barcodeId] = _parentProducts;

        // register the product in the products list
        products[product_.barcodeId] = product_;

        // increase the productCounter
        productCounter[user.id]++;

        // link the product to the user
        userLinkedProducts[user.id].push(product_.barcodeId);

        // toString(userLinkedProducts[user.id].length),
        emit NewProduct(
            product_.name,
            product_.manufacturerName,
            product_.barcodeId,
            product_.manufacturingDate,
            product_.expirationDate
        );
    }

    // function _trackProduct(
    //     string memory barcodeId
    // ) public returns (Types.Product[] memory) {
    //     products[barcodeId];
    // }

    function _createSellRequest(
        string memory barcodeId_,
        Types.UserDetails memory buyer_,
        Types.UserDetails memory seller_,
        uint256 currentTime_,
        uint256 quantity_
    ) public {
        Types.Product memory product_ = products[barcodeId_];
        require(product_.batchCount > quantity_, "Unavailable quantity");
        product_.batchCount = quantity_;
        // store sell request
        waitingProducts[buyer_.id][product_.barcodeId] = product_;
        emit ProductOwnershipTransferRequest(
            product_.name,
            product_.manufacturerName,
            product_.barcodeId,
            buyer_.name,
            buyer_.email,
            seller_.name,
            seller_.email,
            currentTime_
        );
    }

    function _acceptSellRequest(
        string memory barcodeId_,
        Types.UserDetails memory buyer_,
        Types.UserDetails memory seller_,
        uint256 currentTime_,
        bool acceptSell
    ) public {
        Types.Product memory product_ = products[barcodeId_];
        delete waitingProducts[buyer_.id][product_.barcodeId];

        if (acceptSell) {
            transferOwnership(seller_.id, buyer_.id, barcodeId_);
        }
        emit ProductOwnershipTransferResponse(
            product_.name,
            product_.manufacturerName,
            product_.barcodeId,
            buyer_.name,
            buyer_.email,
            seller_.name,
            seller_.email,
            currentTime_,
            acceptSell ? "ACCEPTED" : "REJECTED"
        );
    }

    // function _sellProduct(
    //     address buyerId_,
    //     string memory barcodeId_,
    //     Types.UserDetails memory buyer_,
    //     uint256 currentTime_
    // ) internal {
    //     Types.Product memory product_ = products[barcodeId_];
    //     //creaza cerere
    //     //cumparatorul confirma/refuza cererea
    //     transferOwnership(msg.sender, buyerId_, barcodeId_);
    //     // emit ProductOwnershipTransfer(
    //     //     product_.name,
    //     //     product_.manufacturerName,
    //     //     product_.barcodeId,
    //     //     buyer_.name,
    //     //     buyer_.email,
    //     //     currentTime_
    //     // );
    // }

    // Modifiers

    modifier productTypeIsValid(uint256 id_) {
        require(
            compareStrings(productTypes[id_].name, ""),
            "Product type already exists"
        );
        _;
    }

    modifier productIsValid(string memory barcodeId) {
        require(
            compareStrings(products[barcodeId].barcodeId, ""),
            "Product already exists"
        );
        _;
    }

    // Internal functions

    function transferOwnership(
        address sellerId_,
        address buyerId_,
        string memory barcodeId_
    ) public {
        string[] memory sellerProducts_ = userLinkedProducts[sellerId_];
        uint256 matchIndex_ = (sellerProducts_.length + 1);
        for (uint256 i = 0; i < sellerProducts_.length; ++i) {
            if (compareStrings(sellerProducts_[i], barcodeId_)) {
                matchIndex_ = i;
                break;
            }
        }

        require(matchIndex_ < sellerProducts_.length, "Product not found");

        if (sellerProducts_.length == 1) {
            delete userLinkedProducts[sellerId_];
        } else {
            userLinkedProducts[sellerId_][matchIndex_] = userLinkedProducts[
                sellerId_
            ][sellerProducts_.length - 1];
            delete userLinkedProducts[sellerId_][sellerProducts_.length - 1];
            userLinkedProducts[sellerId_].pop();
        }
        userLinkedProducts[buyerId_].push(barcodeId_);
    }

    function compareStrings(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    function generateBarcode(
        uint256 manufacturerCode,
        uint256 productCode
    ) internal pure returns (string memory) {
        uint256[5] memory manufacturerDigits = getLast5Digits(manufacturerCode);
        uint256[5] memory productDigits = getLast5Digits(productCode);
        uint256[] memory digits;
        // region
        digits[0] = 0;
        digits[1] = 0;
        for (uint256 i = 0; i < 12; ++i) {
            if (i < 7) {
                // manufacturer code
                digits[i + 2] = manufacturerDigits[i];
            } else {
                // product code
                digits[i + 2] = productDigits[i];
            }
        }
        // check digit
        digits[12] = checkDigit(digits);
        // convert to string
        return digitListToString(digits, 13);
    }

    function getLast5Digits(
        uint256 number
    ) internal pure returns (uint256[5] memory) {
        uint256 val = number;
        uint256 index = 4;
        uint256[5] memory digits;
        while (index >= 0) {
            digits[index] = val % 10;
            val /= 10;
            index--;
        }
        return digits;
    }

    function checkDigit(
        uint256[] memory digits
    ) internal pure returns (uint256) {
        uint256 evenSum = 0;
        uint256 oddSum = 0;
        for (uint i = 0; i < 12; ++i) {
            if (i % 2 == 0) {
                evenSum += digits[i];
            } else {
                oddSum += digits[i];
            }
        }
        uint256 evenSum3 = evenSum * 3;
        uint256 total = evenSum3 + oddSum;
        uint256 remainder = total % 10;
        if (remainder == 0) {
            return remainder;
        }
        return 10 - remainder;
    }

    function digitListToString(
        uint256[] memory digits,
        uint256 length
    ) internal pure returns (string memory) {
        bytes memory buffer = new bytes(length);

        for (uint256 i = 0; i < length; i++) {
            buffer[i] = bytes1(uint8(48 + digits[i]));
        }

        return string(buffer);
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);

        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + (value % 10)));
            value /= 10;
        }

        return string(buffer);
    }
}
