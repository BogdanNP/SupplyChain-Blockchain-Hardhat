// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.8.0;

import "hardhat/console.sol";
import "./Types.sol";

contract Products {
    constructor() {
        Types.ProductTypeAddDTO[]
            memory predefinedProductTypes = new Types.ProductTypeAddDTO[](9);
        predefinedProductTypes[0] = Types.ProductTypeAddDTO(
            "Faina",
            "faina alba din GRAU, obtinuta din macinarea GRAULUI de panificatie (GRAU moale) cultivat in Romania"
        );
        predefinedProductTypes[1] = Types.ProductTypeAddDTO(
            "Drojdie",
            "drojdie uscata de panificatie, emulsifiant E 491"
        );
        predefinedProductTypes[2] = Types.ProductTypeAddDTO(
            "Sare",
            "sare iodata"
        );
        predefinedProductTypes[3] = Types.ProductTypeAddDTO(
            "Paine alba",
            "clasica paine romaneasca fabricata cu maia, care ii confera gustul unic, inconfundabil"
        );
        predefinedProductTypes[4] = Types.ProductTypeAddDTO(
            "Sunca de porc",
            "produs fiert in membrana artificiala necomestibila"
        );
        predefinedProductTypes[5] = Types.ProductTypeAddDTO(
            "Lapte de vaca",
            "lapte de vaca. Contine lactoza din lapte"
        );
        predefinedProductTypes[6] = Types.ProductTypeAddDTO(
            "Cascaval din lapte de vaca",
            ""
        );
        predefinedProductTypes[7] = Types.ProductTypeAddDTO(
            "Sandwich",
            "paine + alte ingrediente"
        );
        predefinedProductTypes[8] = Types.ProductTypeAddDTO(
            "Pulpa de porc",
            ""
        );
        _addProductTypeList(predefinedProductTypes);
        Types.Recepie[] memory predefinedRecepies = new Types.Recepie[](4);
        Types.RecepieIngredient[]
            memory predefinedRecepieIngredients = new Types.RecepieIngredient[](
                10
            );
        // recepie 0: Paine
        predefinedRecepieIngredients[0] = Types.RecepieIngredient(0, 0, 6);
        predefinedRecepieIngredients[1] = Types.RecepieIngredient(0, 1, 6);
        predefinedRecepieIngredients[2] = Types.RecepieIngredient(0, 2, 6);
        // recepie 1: Sunca
        predefinedRecepieIngredients[3] = Types.RecepieIngredient(1, 8, 10);
        predefinedRecepieIngredients[4] = Types.RecepieIngredient(1, 2, 1);
        // recepie 2: Cascaval
        predefinedRecepieIngredients[5] = Types.RecepieIngredient(2, 5, 6);
        predefinedRecepieIngredients[6] = Types.RecepieIngredient(2, 2, 1);
        // recepie 3: Sandwich
        predefinedRecepieIngredients[7] = Types.RecepieIngredient(3, 3, 1);
        predefinedRecepieIngredients[8] = Types.RecepieIngredient(3, 4, 1);
        predefinedRecepieIngredients[9] = Types.RecepieIngredient(3, 6, 1);
        // recepie 0
        recepieIngredients[0][0] = predefinedRecepieIngredients[0];
        recepieIngredients[0][1] = predefinedRecepieIngredients[1];
        recepieIngredients[0][2] = predefinedRecepieIngredients[2];
        predefinedRecepies[0] = Types.Recepie(0, 3, "Paine alba", 3, 6);
        // recepie 1
        recepieIngredients[1][0] = predefinedRecepieIngredients[3];
        recepieIngredients[1][1] = predefinedRecepieIngredients[4];
        predefinedRecepies[1] = Types.Recepie(1, 4, "Sunca de porc", 2, 10);
        // recepie 2
        recepieIngredients[2][0] = predefinedRecepieIngredients[5];
        recepieIngredients[2][1] = predefinedRecepieIngredients[6];
        predefinedRecepies[2] = Types.Recepie(
            2,
            6,
            "Cascaval din lapte de vaca",
            2,
            10
        );
        // recepie 3
        recepieIngredients[3][0] = predefinedRecepieIngredients[7];
        recepieIngredients[3][1] = predefinedRecepieIngredients[8];
        recepieIngredients[3][2] = predefinedRecepieIngredients[9];
        predefinedRecepies[3] = Types.Recepie(
            3,
            7,
            "Sandwich cu sunca si cascaval",
            3,
            10
        );

        _addRecepieList(predefinedRecepies);
    }

    // product type id => product type
    mapping(uint256 => Types.ProductType) public productTypes;
    uint256 public productTypeCounter = 0;
    // barcodeId => product
    mapping(string => Types.Product) public products;
    // address => list of stock item (barcodeId + quantity) for each user
    mapping(address => Types.StockItem[]) public userLinkedStockItems;
    // count product creation // only for manufacturers
    mapping(address => uint256) public productCounter;
    // count product creation, transfer // used by all users
    mapping(address => uint256) public stockItemCounter;

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

    // it's so strange that events can send lists, but functions can't ~.~
    event ComposedProduct(
        string name,
        string manufacturerName,
        string barcodeId,
        uint256 manDateEpoch,
        uint256 expDateEpoch,
        string[] parentProducts
    );

    event NewProductType(string name, uint256 id);
    event NewRecepie(uint256 id, uint256 resultTypeId, string resultTypeName);

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
        // TODO: Add manufacturer id + region association
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
            0,
            0
        );

        products[barcodeId] = product;
        productCounter[myAccount]++;

        Types.StockItem memory stockItem = Types.StockItem(
            barcodeId,
            product_.batchCount
        );
        userLinkedStockItems[myAccount].push(stockItem);
        stockItemCounter[myAccount]++;

        // console.log(myAccount);
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
        for (uint j = 0; j < userLinkedStockItems[user.id].length; ++j) {
            if (recepie_.ingredientsCount == ingredientsCount) {
                break;
            }
            for (uint i = 0; i < recepie_.ingredientsCount; ++i) {
                // iterate through user linked products
                // check if user product is in the recepie
                if (
                    (recepieIngredients[recepie_.id][i].productQuantity <=
                        userLinkedStockItems[user.id][j].quantity) &&
                    (recepieIngredients[recepie_.id][i].productTypeId ==
                        products[userLinkedStockItems[user.id][j].barcodeId]
                            .productTypeId)
                ) {
                    // check if the quantity is enough for the recepie
                    // require(
                    //     recepieIngredients[recepie_.id][i].productQuantity <=
                    //         products[userLinkedProducts[user.id][j]].batchCount,
                    //     "Recepie requires user to have more quantity of some product"
                    // );
                    // save the barcodeId of the used product
                    _parentProducts[ingredientsCount] = userLinkedStockItems[
                        user.id
                    ][j].barcodeId;

                    // count ingredient used
                    ingredientsCount++;

                    // update the quantity of used stock item
                    userLinkedStockItems[user.id][j]
                        .quantity -= recepieIngredients[recepie_.id][i]
                        .productQuantity;

                    // check if the quantity is 0 and delete the products
                    if (userLinkedStockItems[user.id][j].quantity == 0) {
                        // NEED TO THINK THIS FOR userLinkedStockItems
                        // OLD IMPLEMENTAION TODO: check this
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
            recepie_.id,
            recepie_.ingredientsCount
        );

        // register the product in parentProducts list
        // in order to keep track of its creation
        parentProducts[product_.barcodeId] = _parentProducts;

        // register the product in the products list
        products[product_.barcodeId] = product_;

        // increase the productCounter
        productCounter[user.id]++;

        // create stock item
        Types.StockItem memory stockItem = Types.StockItem(
            product_.barcodeId,
            recepie_.quantityResult
        );
        // link the stock item to the user
        userLinkedStockItems[user.id].push(stockItem);

        // increase the stockItemCounter
        stockItemCounter[user.id]++;

        // toString(userLinkedProducts[user.id].length),
        emit ComposedProduct(
            product_.name,
            product_.manufacturerName,
            product_.barcodeId,
            product_.manufacturingDate,
            product_.expirationDate,
            _parentProducts
        );
    }

    // Object Transfer

    mapping(uint256 => Types.Transfer) public transfers;
    uint256 public transferCount;
    mapping(address => uint256[]) public accountTransfers;
    mapping(address => uint256) public accountTransferCount;

    event ObjectTransferred(
        uint transferId,
        address sender,
        address receiver,
        string barcodeId,
        uint256 quantity,
        Types.ObjectStatus status
    );

    function requestTransfer(
        string memory _barcodeId,
        uint256 _quantity,
        address _receiver
    ) external {
        Types.Transfer memory newTransfer = Types.Transfer({
            id: transferCount,
            sender: msg.sender,
            receiver: _receiver,
            barcodeId: _barcodeId,
            quantity: _quantity,
            status: Types.ObjectStatus.Pending
        });

        transfers[transferCount] = (newTransfer);
        accountTransfers[_receiver].push(transferCount);
        accountTransferCount[_receiver]++;
        transferCount++;

        emit ObjectTransferred(
            transferCount - 1,
            msg.sender,
            _receiver,
            _barcodeId,
            _quantity,
            Types.ObjectStatus.Pending
        );
    }

    function acceptTransfer(uint _transferId) external {
        require(
            transfers[_transferId].receiver == msg.sender,
            "Only the intended receiver can accept the transfer"
        );
        require(
            transfers[_transferId].status == Types.ObjectStatus.Pending,
            "Transfer status must be Pending"
        );

        transferOwnership(
            transfers[_transferId].sender,
            transfers[_transferId].receiver,
            transfers[_transferId].barcodeId,
            transfers[_transferId].quantity
        );

        transfers[_transferId].status = Types.ObjectStatus.Accepted;

        emit ObjectTransferred(
            _transferId,
            transfers[_transferId].sender,
            msg.sender,
            transfers[_transferId].barcodeId,
            transfers[_transferId].quantity,
            Types.ObjectStatus.Accepted
        );
    }

    function refuseTransfer(uint _transferId) external {
        require(
            transfers[_transferId].receiver == msg.sender,
            "Only the intended receiver can refuse the transfer"
        );
        require(
            transfers[_transferId].status == Types.ObjectStatus.Pending,
            "Transfer status must be Pending"
        );

        transfers[_transferId].status = Types.ObjectStatus.Refused;

        emit ObjectTransferred(
            _transferId,
            transfers[_transferId].sender,
            msg.sender,
            transfers[_transferId].barcodeId,
            transfers[_transferId].quantity,
            Types.ObjectStatus.Refused
        );
    }

    function getTransferStatus(
        uint _transferId
    ) external view returns (Types.ObjectStatus) {
        return transfers[_transferId].status;
    }

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
        string memory barcodeId_,
        uint256 quantity_
    ) internal {
        console.log(sellerId_);
        console.log(buyerId_);
        console.log(barcodeId_);
        Types.StockItem[] memory sellerProducts_ = userLinkedStockItems[
            sellerId_
        ];
        uint256 matchIndex_ = (sellerProducts_.length + 1);
        for (uint256 i = 0; i < sellerProducts_.length; ++i) {
            if (compareStrings(sellerProducts_[i].barcodeId, barcodeId_)) {
                matchIndex_ = i;
                break;
            }
        }

        require(matchIndex_ < sellerProducts_.length, "Product not found");
        require(
            quantity_ <= userLinkedStockItems[sellerId_][matchIndex_].quantity,
            "Seller does not have the required quantity anymore"
        );
        userLinkedStockItems[sellerId_][matchIndex_].quantity -= quantity_;
        // TODO: only modify quantity

        // if (sellerProducts_.length == 1) {
        //     delete userLinkedProducts[sellerId_];
        // } else {
        //     userLinkedProducts[sellerId_][matchIndex_] = userLinkedProducts[
        //         sellerId_
        //     ][sellerProducts_.length - 1];
        //     delete userLinkedProducts[sellerId_][sellerProducts_.length - 1];
        //     userLinkedProducts[sellerId_].pop();
        // }

        // TODO: maybe create a new list for bought products
        // ISSUE: increase productCounter and lose the index
        // SOLUTION: keep 2 indexes, one for counting all products of
        // a user, one for counting the products created and which is
        // used for generating the barcodeId;

        // ISSUE: when having quantity, think about multiple
        // users having the same product with the same barcodeId
        // in that case batchCount is useless
        // userLinkedProducts -> barcodeId + quantity
        // (NEW ISSUE: what about serialNumber, just add it in userLinkedProducts)
        // this means changing the whole structure of Product and
        // the creation of a new object? BatchProduct:
        // quantity + barcodeId
        // + adding serialNumber to each Product object
        // how does this affect recepies?
        // how to change things with current data structure?
        // because barcodeId is the identifier for each product,
        // it is unique per product creation, and we save the product
        // by mapping barcodeId to the product, we can make the changes
        // just if we make userLinkedProducts a list of products, not
        // a list of barcodeId, but i think this would be too much data
        // to store :/
        // TODO: modify in order to accept quantity

        bool buyerAlreadyHasStockItem = false;
        // check if buyer has this type of stock item
        for (uint256 i = 0; i < userLinkedStockItems[buyerId_].length; ++i) {
            if (
                compareStrings(
                    userLinkedStockItems[buyerId_][i].barcodeId,
                    barcodeId_
                )
            ) {
                // only increase the quantity if we find the product
                userLinkedStockItems[buyerId_][i].quantity += quantity_;
                buyerAlreadyHasStockItem = true;
                break;
            }
        }
        // if it is the first time, then we can add the stock item to the list
        if (!buyerAlreadyHasStockItem) {
            Types.StockItem memory transferredItem = Types.StockItem(
                barcodeId_,
                quantity_
            );
            userLinkedStockItems[buyerId_].push(transferredItem);
            stockItemCounter[buyerId_]++;
        }
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
        uint256[] memory digits = new uint256[](13);
        // region
        digits[0] = 0;
        digits[1] = 0;
        for (uint256 i = 0; i < 5; ++i) {
            digits[i + 2] = manufacturerDigits[i];
            digits[i + 7] = productDigits[i];
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
        uint256[5] memory digits;
        for (uint256 index = 5; index > 0; index--) {
            digits[index - 1] = val % 10;
            val /= 10;
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
