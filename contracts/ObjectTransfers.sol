// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.8.0;

contract ObjectTransfers {
    enum ObjectStatus {
        Pending,
        Accepted,
        Refused
    }

    struct Transfer {
        uint256 id;
        address sender;
        address receiver;
        string barcodeId;
        uint256 quantity;
        ObjectStatus status;
    }

    mapping(uint256 => Transfer) public transfers;
    uint256 public transferCount;
    mapping(address => uint256[]) public accountTransfers;
    mapping(address => uint256) public accountTransferCount;

    event ObjectTransferred(
        uint transferId,
        address sender,
        address receiver,
        string barcodeId,
        uint256 quantity,
        ObjectStatus status
    );

    function requestTransfer(
        string memory _barcodeId,
        uint256 _quantity,
        address _receiver
    ) external {
        Transfer memory newTransfer = Transfer({
            id: transferCount,
            sender: msg.sender,
            receiver: _receiver,
            barcodeId: _barcodeId,
            quantity: _quantity,
            status: ObjectStatus.Pending
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
            ObjectStatus.Pending
        );
    }

    function acceptTransfer(uint _transferId) external {
        require(
            transfers[_transferId].receiver == msg.sender,
            "Only the intended receiver can accept the transfer"
        );
        require(
            transfers[_transferId].status == ObjectStatus.Pending,
            "Transfer status must be Pending"
        );

        transfers[_transferId].status = ObjectStatus.Accepted;

        emit ObjectTransferred(
            _transferId,
            transfers[_transferId].sender,
            msg.sender,
            transfers[_transferId].barcodeId,
            transfers[_transferId].quantity,
            ObjectStatus.Accepted
        );
    }

    function refuseTransfer(uint _transferId) external {
        require(
            transfers[_transferId].receiver == msg.sender,
            "Only the intended receiver can refuse the transfer"
        );
        require(
            transfers[_transferId].status == ObjectStatus.Pending,
            "Transfer status must be Pending"
        );

        transfers[_transferId].status = ObjectStatus.Refused;

        emit ObjectTransferred(
            _transferId,
            transfers[_transferId].sender,
            msg.sender,
            transfers[_transferId].barcodeId,
            transfers[_transferId].quantity,
            ObjectStatus.Refused
        );
    }

    function getTransferStatus(
        uint _transferId
    ) external view returns (ObjectStatus) {
        return transfers[_transferId].status;
    }
}
