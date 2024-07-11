// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.8.0;

import "hardhat/console.sol";
import "./Types.sol";

contract Products {
    constructor() {
        // Definire tipuri de produse si retete pentru utilizare
        Types.ProductTypeAddDTO[]
            memory predefinedProductTypes = new Types.ProductTypeAddDTO[](20);
        predefinedProductTypes[0] = Types.ProductTypeAddDTO(
            "Faina alba",
            "Faina alba din grau 5kg"
        );
        predefinedProductTypes[1] = Types.ProductTypeAddDTO(
            "Drojdie",
            "Drojdie uscata de panificatie 100g"
        );
        predefinedProductTypes[2] = Types.ProductTypeAddDTO(
            "Sare",
            "Sare iodata 1kg"
        );
        predefinedProductTypes[3] = Types.ProductTypeAddDTO(
            "Paine alba",
            "Paine alba clasica formata din drojdie, faina si sare"
        );
        predefinedProductTypes[4] = Types.ProductTypeAddDTO(
            "Sunca de porc",
            "Sunca de porc 500g - Produs fiert in membrana artificiala necomestibila"
        );
        predefinedProductTypes[5] = Types.ProductTypeAddDTO(
            "Lapte de vaca",
            "Lapte de vaca - 10L"
        );
        predefinedProductTypes[6] = Types.ProductTypeAddDTO(
            "Cascaval",
            "Cascaval 500g din lapte de vaca"
        );
        predefinedProductTypes[7] = Types.ProductTypeAddDTO(
            "Sandwich",
            "Sandwich cu sunca si cascaval"
        );
        predefinedProductTypes[8] = Types.ProductTypeAddDTO(
            "Pulpa de porc",
            "Pulpa de porc 10kg - Produs si ambalat in Romania"
        );
        predefinedProductTypes[9] = Types.ProductTypeAddDTO(
            "Frisca ",
            "Frisca 500ml - obtinuta din lapte si zahar"
        );
        predefinedProductTypes[10] = Types.ProductTypeAddDTO(
            "Zahar",
            "Zahar alb 500g - din trestie de zahar"
        );
        predefinedProductTypes[11] = Types.ProductTypeAddDTO(
            "Esenta de vanilie",
            "Esenta de vanilie 50ml - Din extract natural de vanile"
        );
        predefinedProductTypes[12] = Types.ProductTypeAddDTO(
            "Gheata",
            "Gheata - 10kg"
        );
        predefinedProductTypes[13] = Types.ProductTypeAddDTO(
            "Inghetata de vanilie",
            "Inghetata creamoasa cu aroma de vanilie - 500g"
        );
        predefinedProductTypes[14] = Types.ProductTypeAddDTO("Unt", "Unt 1kg");
        predefinedProductTypes[15] = Types.ProductTypeAddDTO(
            "Oua",
            "10 oua de casa"
        );
        predefinedProductTypes[16] = Types.ProductTypeAddDTO(
            "Cacao",
            "Praf de cacao - 500g"
        );
        predefinedProductTypes[17] = Types.ProductTypeAddDTO(
            "Ciocolata ",
            "Ciocolata de menaj - 1kg"
        );
        predefinedProductTypes[18] = Types.ProductTypeAddDTO(
            "Bucatele de ciocolata",
            "Bucatele de ciocolata - 500g"
        );
        predefinedProductTypes[19] = Types.ProductTypeAddDTO(
            "Fursecuri cu ciocolata",
            "Fursecuri cu ciocolata - 10"
        );
        _addProductTypeList(predefinedProductTypes);
        Types.RecipeIngredient[]
            memory predefinedRecipeIngredients = new Types.RecipeIngredient[](
                31
            );
        // recipe 0: Paine
        predefinedRecipeIngredients[0] = Types.RecipeIngredient(0, 0, 10);
        predefinedRecipeIngredients[1] = Types.RecipeIngredient(0, 1, 10);
        predefinedRecipeIngredients[2] = Types.RecipeIngredient(0, 2, 1);
        // recipe 1: Sunca
        predefinedRecipeIngredients[3] = Types.RecipeIngredient(1, 8, 5);
        predefinedRecipeIngredients[4] = Types.RecipeIngredient(1, 2, 1);
        // recipe 2: Cascaval
        predefinedRecipeIngredients[5] = Types.RecipeIngredient(2, 5, 10);
        predefinedRecipeIngredients[6] = Types.RecipeIngredient(2, 2, 1);
        // recipe 3: Sandwich
        predefinedRecipeIngredients[7] = Types.RecipeIngredient(3, 3, 1);
        predefinedRecipeIngredients[8] = Types.RecipeIngredient(3, 4, 1);
        predefinedRecipeIngredients[9] = Types.RecipeIngredient(3, 6, 1);
        // recipe 4: Inghetata
        predefinedRecipeIngredients[10] = Types.RecipeIngredient(4, 2, 1);
        predefinedRecipeIngredients[11] = Types.RecipeIngredient(4, 5, 1);
        predefinedRecipeIngredients[12] = Types.RecipeIngredient(4, 9, 10);
        predefinedRecipeIngredients[13] = Types.RecipeIngredient(4, 10, 4);
        predefinedRecipeIngredients[14] = Types.RecipeIngredient(4, 11, 2);
        predefinedRecipeIngredients[15] = Types.RecipeIngredient(4, 15, 2);
        // recipe 5: Fursecuri de ciocolata
        predefinedRecipeIngredients[16] = Types.RecipeIngredient(5, 0, 30);
        predefinedRecipeIngredients[17] = Types.RecipeIngredient(5, 2, 1);
        predefinedRecipeIngredients[18] = Types.RecipeIngredient(5, 10, 200);
        predefinedRecipeIngredients[19] = Types.RecipeIngredient(5, 11, 4);
        predefinedRecipeIngredients[20] = Types.RecipeIngredient(5, 14, 100);
        predefinedRecipeIngredients[21] = Types.RecipeIngredient(5, 15, 80);
        predefinedRecipeIngredients[22] = Types.RecipeIngredient(5, 16, 40);
        predefinedRecipeIngredients[23] = Types.RecipeIngredient(5, 18, 200);
        // recipe 6: Ciocolata
        predefinedRecipeIngredients[24] = Types.RecipeIngredient(6, 16, 40);
        predefinedRecipeIngredients[25] = Types.RecipeIngredient(6, 5, 10);
        predefinedRecipeIngredients[26] = Types.RecipeIngredient(6, 10, 80);
        // recipe 7: Bucatele de ciocolata
        predefinedRecipeIngredients[27] = Types.RecipeIngredient(7, 17, 100);
        // recipe 8: Unt
        predefinedRecipeIngredients[28] = Types.RecipeIngredient(8, 5, 100);
        // recipe 9: Frisca
        predefinedRecipeIngredients[29] = Types.RecipeIngredient(9, 5, 6);
        predefinedRecipeIngredients[30] = Types.RecipeIngredient(9, 10, 1);

        Types.Recipe[] memory predefinedRecipes = new Types.Recipe[](10);
        // recipe 0
        recipeIngredients[0][0] = predefinedRecipeIngredients[0];
        recipeIngredients[0][1] = predefinedRecipeIngredients[1];
        recipeIngredients[0][2] = predefinedRecipeIngredients[2];
        predefinedRecipes[0] = Types.Recipe(0, 3, "Paine alba", 3, 100);
        // recipe 1
        recipeIngredients[1][0] = predefinedRecipeIngredients[3];
        recipeIngredients[1][1] = predefinedRecipeIngredients[4];
        predefinedRecipes[1] = Types.Recipe(1, 4, "Sunca de porc", 2, 70);
        // recipe 2
        recipeIngredients[2][0] = predefinedRecipeIngredients[5];
        recipeIngredients[2][1] = predefinedRecipeIngredients[6];
        predefinedRecipes[2] = Types.Recipe(2, 6, "Cascaval", 2, 20);
        // recipe 3
        recipeIngredients[3][0] = predefinedRecipeIngredients[7];
        recipeIngredients[3][1] = predefinedRecipeIngredients[8];
        recipeIngredients[3][2] = predefinedRecipeIngredients[9];
        predefinedRecipes[3] = Types.Recipe(3, 7, "Sandwich", 3, 10);
        // recipe 4
        recipeIngredients[4][0] = predefinedRecipeIngredients[10];
        recipeIngredients[4][1] = predefinedRecipeIngredients[11];
        recipeIngredients[4][2] = predefinedRecipeIngredients[12];
        recipeIngredients[4][3] = predefinedRecipeIngredients[13];
        recipeIngredients[4][4] = predefinedRecipeIngredients[14];
        recipeIngredients[4][5] = predefinedRecipeIngredients[15];
        predefinedRecipes[4] = Types.Recipe(4, 13, "Inghetata", 6, 1);
        // recipe 5
        recipeIngredients[5][0] = predefinedRecipeIngredients[16];
        recipeIngredients[5][1] = predefinedRecipeIngredients[17];
        recipeIngredients[5][2] = predefinedRecipeIngredients[18];
        recipeIngredients[5][3] = predefinedRecipeIngredients[19];
        recipeIngredients[5][4] = predefinedRecipeIngredients[20];
        recipeIngredients[5][5] = predefinedRecipeIngredients[21];
        recipeIngredients[5][6] = predefinedRecipeIngredients[22];
        recipeIngredients[5][7] = predefinedRecipeIngredients[23];
        predefinedRecipes[5] = Types.Recipe(5, 19, "Fursecuri", 8, 1000);
        // recipe 6
        recipeIngredients[6][0] = predefinedRecipeIngredients[24];
        recipeIngredients[6][1] = predefinedRecipeIngredients[25];
        recipeIngredients[6][2] = predefinedRecipeIngredients[26];
        predefinedRecipes[6] = Types.Recipe(6, 17, "Ciocolata", 3, 100);
        // recipe 7
        recipeIngredients[7][0] = predefinedRecipeIngredients[27];
        predefinedRecipes[7] = Types.Recipe(7, 18, "Bucati ciocolata", 1, 200);
        // recipe 8
        recipeIngredients[8][0] = predefinedRecipeIngredients[28];
        predefinedRecipes[8] = Types.Recipe(8, 14, "Unt ", 1, 100);
        // recipe 9
        recipeIngredients[9][0] = predefinedRecipeIngredients[29];
        recipeIngredients[9][1] = predefinedRecipeIngredients[30];
        predefinedRecipes[9] = Types.Recipe(9, 9, "Frisca ", 2, 200);

        _addRecipeList(predefinedRecipes);
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

    mapping(uint256 => mapping(uint256 => Types.RecipeIngredient))
        public recipeIngredients;
    mapping(uint256 => Types.Recipe) public recipes;
    uint256 public recipeCounter = 0;

    // links one product barcodeId to it's parents barcodeId,
    // the number of parents is stored in the recipe, number of ingredients
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

    event ComposedProduct(
        string name,
        string manufacturerName,
        string barcodeId,
        uint256 manDateEpoch,
        uint256 expDateEpoch,
        string[] parentProducts
    );

    event NewProductType(string name, uint256 id);
    event NewRecipe(uint256 id, uint256 resultTypeId, string resultTypeName);

    event BlockedProduct(string barcodeId, bool status);

    // Contract Methods

    function _addRecipeList(Types.Recipe[] memory recipeList) public {
        for (uint i = 0; i < recipeList.length; i++) {
            _addRecipe(recipeList[i]);
        }
    }

    function _addRecipe(Types.Recipe memory recipe) public {
        recipes[recipeCounter] = recipe;
        emit NewRecipe(recipe.id, recipe.resultTypeId, recipe.resultTypeName);
        recipeCounter++;
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

        emit NewProduct(
            product.name,
            product.manufacturerName,
            product.barcodeId,
            product.manufacturingDate,
            product.expirationDate
        );
    }

    function _createProduct(
        uint256 recipeId,
        Types.ManufacturerDetails memory manufacturerDetails,
        Types.UserDetails memory user
    ) public {
        Types.Recipe memory recipe_ = recipes[recipeId];
        string[] memory _parentProducts = new string[](
            recipe_.ingredientsCount
        );
        uint256 ingredientsCount = 0;
        // iterate through required products by the recipe
        for (uint j = 0; j < userLinkedStockItems[user.id].length; ++j) {
            if (recipe_.ingredientsCount == ingredientsCount) {
                break;
            }
            for (uint i = 0; i < recipe_.ingredientsCount; ++i) {
                // iterate through user linked products
                // check if user product is in the recipe
                // check quantity
                // check product type
                // check if product was not already used
                if (
                    (recipeIngredients[recipe_.id][i].productQuantity <=
                        userLinkedStockItems[user.id][j].quantity) &&
                    (recipeIngredients[recipe_.id][i].productTypeId ==
                        products[userLinkedStockItems[user.id][j].barcodeId]
                            .productTypeId) &&
                    (bytes(products[_parentProducts[i]].barcodeId).length ==
                        0) &&
                    (blockedProducts[
                        userLinkedStockItems[user.id][j].barcodeId
                    ] != true)
                ) {
                    // save the barcodeId of the used product
                    _parentProducts[i] = userLinkedStockItems[user.id][j]
                        .barcodeId;

                    // count ingredient used
                    ingredientsCount++;

                    // update the quantity of used stock item
                    userLinkedStockItems[user.id][j]
                        .quantity -= recipeIngredients[recipe_.id][i]
                        .productQuantity;
                }
            }
        }

        // check if all ingredients were found and used
        require(
            ingredientsCount == recipe_.ingredientsCount,
            "There are not enough ingredients for this recipe, please check your stock"
        );

        // create the new product
        Types.Product memory product_ = Types.Product(
            recipe_.resultTypeName,
            recipe_.resultTypeId,
            generateBarcode(
                manufacturerDetails.region,
                manufacturerDetails.code,
                productCounter[user.id]
            ),
            user.name,
            user.id,
            (block.timestamp / 100) * 100,
            (block.timestamp / 100) * 100 + 30 * 86400, // 86400=1day in timestamp
            recipe_.id,
            recipe_.ingredientsCount
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
            recipe_.quantityResult
        );
        // link the stock item to the user
        userLinkedStockItems[user.id].push(stockItem);

        // increase the stockItemCounter
        stockItemCounter[user.id]++;

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
