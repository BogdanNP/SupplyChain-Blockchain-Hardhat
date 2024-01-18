// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.3;

contract ObjectTransfers {
    enum ObjectStatus {
        Pending,
        Accepted,
        Refused
    }

    struct Transfer {
        address sender;
        address receiver;
        string objectDescription;
        ObjectStatus status;
    }

    Transfer[] public transfers;

    event ObjectTransferred(
        uint transferId,
        address sender,
        address receiver,
        string objectDescription,
        ObjectStatus status
    );

    function requestTransfer(
        string memory _objectDescription,
        address _receiver
    ) external {
        Transfer memory newTransfer = Transfer({
            sender: msg.sender,
            receiver: _receiver,
            objectDescription: _objectDescription,
            status: ObjectStatus.Pending
        });

        transfers.push(newTransfer);

        emit ObjectTransferred(
            transfers.length - 1,
            msg.sender,
            _receiver,
            _objectDescription,
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
            transfers[_transferId].objectDescription,
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
            transfers[_transferId].objectDescription,
            ObjectStatus.Refused
        );
    }

    function getTransferStatus(
        uint _transferId
    ) external view returns (ObjectStatus) {
        return transfers[_transferId].status;
    }

    function getPendingTransfers() external view returns (uint[] memory) {
        uint[] memory pendingTransfers;
        uint count = 0;

        for (uint i = 0; i < transfers.length; i++) {
            if (
                transfers[i].receiver == msg.sender &&
                transfers[i].status == ObjectStatus.Pending
            ) {
                pendingTransfers[count] = i;
                count++;
            }
        }

        return pendingTransfers;
    }
}
