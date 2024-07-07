// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.8.0;

import "hardhat/console.sol";
import "./Types.sol";

contract Products {
    constructor() {
        Types.ProductTypeAddDTO[]
            memory predefinedProductTypes = new Types.ProductTypeAddDTO[](20);
        predefinedProductTypes[0] = Types.ProductTypeAddDTO(
            "Faina alba",
            "Faina alba din grau"
        );
        predefinedProductTypes[1] = Types.ProductTypeAddDTO(
            "Drojdie",
            "Drojdie uscata de panificatie"
        );
        predefinedProductTypes[2] = Types.ProductTypeAddDTO(
            "Sare",
            "Sare iodata"
        );
        predefinedProductTypes[3] = Types.ProductTypeAddDTO(
            "Paine alba",
            "Paine alba clasica formata din drojdie, faina si sare"
        );
        predefinedProductTypes[4] = Types.ProductTypeAddDTO(
            "Sunca de porc",
            "Produs fiert in membrana artificiala necomestibila"
        );
        predefinedProductTypes[5] = Types.ProductTypeAddDTO(
            "Lapte de vaca",
            "Lapte de vaca cu 3.5% grasime"
        );
        predefinedProductTypes[6] = Types.ProductTypeAddDTO(
            "Cascaval",
            "Cascaval din lapte de vaca"
        );
        predefinedProductTypes[7] = Types.ProductTypeAddDTO(
            "Sandwich",
            "Sandwich cu sunca si cascaval"
        );
        predefinedProductTypes[8] = Types.ProductTypeAddDTO(
            "Pulpa de porc",
            "Produs si ambalat in Romania"
        );
        predefinedProductTypes[9] = Types.ProductTypeAddDTO(
            "Frisca ",
            "Frisca obtinuta din lapte si zahar"
        );
        predefinedProductTypes[10] = Types.ProductTypeAddDTO(
            "Zahar",
            "Zahar alb din trestie de zahar"
        );
        predefinedProductTypes[11] = Types.ProductTypeAddDTO(
            "Vanilie",
            "Extract natural de vanile"
        );
        predefinedProductTypes[12] = Types.ProductTypeAddDTO(
            "Gheata",
            "Apa inghetata"
        );
        predefinedProductTypes[13] = Types.ProductTypeAddDTO(
            "Inghetata de vanilie",
            "Inghetata creamoasa cu aroma de vanilie"
        );
        predefinedProductTypes[14] = Types.ProductTypeAddDTO(
            "Unt",
            "Unt din lapte de vaca  cu 80% grasime"
        );
        predefinedProductTypes[15] = Types.ProductTypeAddDTO(
            "Oua",
            "Oua de casa"
        );
        predefinedProductTypes[16] = Types.ProductTypeAddDTO(
            "Cacao",
            "Praf de cacao"
        );
        predefinedProductTypes[17] = Types.ProductTypeAddDTO(
            "Ciocolata ",
            "Ciocolata de menaj"
        );
        predefinedProductTypes[18] = Types.ProductTypeAddDTO(
            "Bucatele de ciocolata",
            "Ciocolata in bucatele"
        );
        predefinedProductTypes[19] = Types.ProductTypeAddDTO(
            "Fursecuri cu ciocolata",
            "De nedescris"
        );
        _addProductTypeList(predefinedProductTypes);
        Types.RecepieIngredient[]
            memory predefinedRecepieIngredients = new Types.RecepieIngredient[](
                31
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
        // recepie 4: Inghetata
        predefinedRecepieIngredients[10] = Types.RecepieIngredient(4, 2, 1);
        predefinedRecepieIngredients[11] = Types.RecepieIngredient(4, 5, 1);
        predefinedRecepieIngredients[12] = Types.RecepieIngredient(4, 9, 1);
        predefinedRecepieIngredients[13] = Types.RecepieIngredient(4, 10, 1);
        predefinedRecepieIngredients[14] = Types.RecepieIngredient(4, 11, 1);
        predefinedRecepieIngredients[15] = Types.RecepieIngredient(4, 12, 1);
        // recepie 5: Fursecuri de ciocolata
        predefinedRecepieIngredients[16] = Types.RecepieIngredient(5, 0, 1);
        predefinedRecepieIngredients[17] = Types.RecepieIngredient(5, 2, 1);
        predefinedRecepieIngredients[18] = Types.RecepieIngredient(5, 10, 1);
        predefinedRecepieIngredients[19] = Types.RecepieIngredient(5, 11, 1);
        predefinedRecepieIngredients[20] = Types.RecepieIngredient(5, 14, 1);
        predefinedRecepieIngredients[21] = Types.RecepieIngredient(5, 15, 1);
        predefinedRecepieIngredients[22] = Types.RecepieIngredient(5, 16, 1);
        predefinedRecepieIngredients[23] = Types.RecepieIngredient(5, 18, 1);
        // recepie 6: Ciocolata
        predefinedRecepieIngredients[24] = Types.RecepieIngredient(6, 16, 1);
        predefinedRecepieIngredients[25] = Types.RecepieIngredient(6, 5, 1);
        predefinedRecepieIngredients[26] = Types.RecepieIngredient(6, 10, 1);
        // recepie 7: Bucatele de ciocolata
        predefinedRecepieIngredients[27] = Types.RecepieIngredient(7, 17, 1);
        // recepie 8: Unt
        predefinedRecepieIngredients[28] = Types.RecepieIngredient(8, 5, 1);
        // recepie 9: Frisca
        predefinedRecepieIngredients[29] = Types.RecepieIngredient(9, 5, 1);
        predefinedRecepieIngredients[30] = Types.RecepieIngredient(9, 10, 1);

        Types.Recepie[] memory predefinedRecepies = new Types.Recepie[](10);
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
        predefinedRecepies[2] = Types.Recepie(2, 6, "Cascaval", 2, 10);
        // recepie 3
        recepieIngredients[3][0] = predefinedRecepieIngredients[7];
        recepieIngredients[3][1] = predefinedRecepieIngredients[8];
        recepieIngredients[3][2] = predefinedRecepieIngredients[9];
        predefinedRecepies[3] = Types.Recepie(3, 7, "Sandwich", 3, 10);
        // recepie 4
        recepieIngredients[4][0] = predefinedRecepieIngredients[10];
        recepieIngredients[4][1] = predefinedRecepieIngredients[11];
        recepieIngredients[4][2] = predefinedRecepieIngredients[12];
        recepieIngredients[4][3] = predefinedRecepieIngredients[13];
        recepieIngredients[4][4] = predefinedRecepieIngredients[14];
        recepieIngredients[4][5] = predefinedRecepieIngredients[15];
        predefinedRecepies[4] = Types.Recepie(4, 13, "Inghetata", 6, 1);
        // recepie 5
        recepieIngredients[5][0] = predefinedRecepieIngredients[16];
        recepieIngredients[5][1] = predefinedRecepieIngredients[17];
        recepieIngredients[5][2] = predefinedRecepieIngredients[18];
        recepieIngredients[5][3] = predefinedRecepieIngredients[19];
        recepieIngredients[5][4] = predefinedRecepieIngredients[20];
        recepieIngredients[5][5] = predefinedRecepieIngredients[21];
        recepieIngredients[5][6] = predefinedRecepieIngredients[22];
        recepieIngredients[5][7] = predefinedRecepieIngredients[23];
        predefinedRecepies[5] = Types.Recepie(5, 19, "Fursecuri", 8, 1);
        // recepie 6
        recepieIngredients[6][0] = predefinedRecepieIngredients[24];
        recepieIngredients[6][1] = predefinedRecepieIngredients[25];
        recepieIngredients[6][2] = predefinedRecepieIngredients[26];
        predefinedRecepies[6] = Types.Recepie(6, 17, "Ciocolata", 3, 1);
        // recepie 7
        recepieIngredients[7][0] = predefinedRecepieIngredients[27];
        predefinedRecepies[7] = Types.Recepie(7, 18, "Bucati ciocolata", 1, 1);
        // recepie 8
        recepieIngredients[8][0] = predefinedRecepieIngredients[28];
        predefinedRecepies[8] = Types.Recepie(8, 14, "Unt ", 1, 1);
        // recepie 9
        recepieIngredients[9][0] = predefinedRecepieIngredients[29];
        recepieIngredients[9][1] = predefinedRecepieIngredients[30];
        predefinedRecepies[9] = Types.Recepie(9, 9, "Frisca ", 2, 1);

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

    mapping(string => bool) public blockedProducts;

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

    event BlockedProduct(string barcodeId, bool status);

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
        Types.ManufacturerDetails memory manufacturerDetails,
        string memory manufacturerName,
        address myAccount
    ) public {
        string memory barcodeId = generateBarcode(
            manufacturerDetails.region,
            manufacturerDetails.code,
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

    // think about typeId -> list of user linked stock items

    function _createProduct(
        uint256 recepieId,
        Types.ManufacturerDetails memory manufacturerDetails,
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
                // check quantity
                // check product type
                // check if product was not already used
                if (
                    (recepieIngredients[recepie_.id][i].productQuantity <=
                        userLinkedStockItems[user.id][j].quantity) &&
                    (recepieIngredients[recepie_.id][i].productTypeId ==
                        products[userLinkedStockItems[user.id][j].barcodeId]
                            .productTypeId) &&
                    (bytes(products[_parentProducts[i]].barcodeId).length ==
                        0) &&
                    (blockedProducts[
                        userLinkedStockItems[user.id][j].barcodeId
                    ] != true)
                ) {
                    // check if the quantity is enough for the recepie
                    // require(
                    //     recepieIngredients[recepie_.id][i].productQuantity <=
                    //         products[userLinkedProducts[user.id][j]].batchCount,
                    //     "Recepie requires user to have more quantity of some product"
                    // );
                    // save the barcodeId of the used product
                    _parentProducts[i] = userLinkedStockItems[user.id][j]
                        .barcodeId;

                    // count ingredient used
                    ingredientsCount++;

                    // update the quantity of used stock item
                    userLinkedStockItems[user.id][j]
                        .quantity -= recepieIngredients[recepie_.id][i]
                        .productQuantity;

                    // check if the quantity is 0 and delete the products
                    if (userLinkedStockItems[user.id][j].quantity == 0) {
                        // TODO: create a mechanism to delete the item
                        // and update the position of others
                        // delete userLinkedProducts[user.id][j];
                    }
                }
            }
        }

        // check if all ingredients were found and used
        require(
            ingredientsCount == recepie_.ingredientsCount,
            "There are not enough ingredients for this recepie, please check your stock"
        );

        // create the new product
        Types.Product memory product_ = Types.Product(
            recepie_.resultTypeName,
            recepie_.resultTypeId,
            generateBarcode(
                manufacturerDetails.region,
                manufacturerDetails.code,
                productCounter[user.id]
            ),
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

    function blockProduct(string memory barcodeId, bool status) external {
        require(
            compareStrings(products[barcodeId].barcodeId, "") == false,
            "Product does not exist"
        );
        blockedProducts[barcodeId] = status;
        emit BlockedProduct(barcodeId, status);
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
    ) external productIsNotBlocked(_barcodeId) {
        Types.Transfer memory newTransfer = Types.Transfer({
            id: transferCount,
            sender: msg.sender,
            receiver: _receiver,
            barcodeId: _barcodeId,
            quantity: _quantity,
            status: Types.ObjectStatus.Pending
        });

        transfers[transferCount] = (newTransfer);
        accountTransfers[msg.sender].push(transferCount);
        accountTransfers[_receiver].push(transferCount);
        accountTransferCount[_receiver]++;
        accountTransferCount[msg.sender]++;
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
            (transfers[_transferId].receiver == msg.sender) ||
                (transfers[_transferId].sender == msg.sender),
            "Only the receiver or the sender can refuse the transfer"
        );
        require(
            transfers[_transferId].status == Types.ObjectStatus.Pending,
            "Transfer status must be Pending"
        );

        transfers[_transferId].status = Types.ObjectStatus.Refused;

        emit ObjectTransferred(
            _transferId,
            transfers[_transferId].sender,
            transfers[_transferId].receiver,
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

    modifier productIsNotBlocked(string memory barcodeId) {
        require(blockedProducts[barcodeId] != true, "Product is blocked");
        _;
    }

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
        uint256 regionCode,
        uint256 manufacturerCode,
        uint256 productCode
    ) internal pure returns (string memory) {
        uint256[5] memory manufacturerDigits = getLast5Digits(manufacturerCode);
        uint256[5] memory productDigits = getLast5Digits(productCode);
        uint256[] memory digits = new uint256[](13);
        // region
        digits[0] = regionCode % 10;
        digits[1] = (regionCode / 10) % 10;
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
        uint256 remainder = (evenSum * 3 + oddSum) % 10;
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
