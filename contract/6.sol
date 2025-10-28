// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AgriLedger: Crop-to-Consumer Traceability
 * @dev A blockchain-based system for tracking crops from farm to consumer.
 */

contract AgriLedger {
    struct CropBatch {
        uint256 batchId;
        string cropType;
        string originFarm;
        uint256 harvestDate;
        string currentOwner;
        string status; // e.g., Harvested, In Transit, Delivered
    }

    mapping(uint256 => CropBatch) public cropBatches;
    uint256 public batchCounter;

    event BatchRegistered(uint256 batchId, string cropType, string originFarm);
    event OwnershipTransferred(uint256 batchId, string newOwner);
    event StatusUpdated(uint256 batchId, string newStatus);

    /**
     * @dev Registers a new crop batch on the blockchain.
     * @param _cropType Type of the crop (e.g., Wheat, Rice, Maize).
     * @param _originFarm Name or ID of the farm.
     * @param _harvestDate UNIX timestamp of harvest.
     */
    function registerBatch(
        string memory _cropType,
        string memory _originFarm,
        uint256 _harvestDate
    ) public {
        batchCounter++;
        cropBatches[batchCounter] = CropBatch({
            batchId: batchCounter,
            cropType: _cropType,
            originFarm: _originFarm,
            harvestDate: _harvestDate,
            currentOwner: _originFarm,
            status: "Harvested"
        });

        emit BatchRegistered(batchCounter, _cropType, _originFarm);
    }

    /**
     * @dev Transfers ownership of a crop batch (e.g., from farmer to distributor).
     * @param _batchId ID of the crop batch.
     * @param _newOwner Name or ID of the new owner.
     */
    function transferOwnership(uint256 _batchId, string memory _newOwner) public {
        require(_batchId > 0 && _batchId <= batchCounter, "Invalid batch ID");

        cropBatches[_batchId].currentOwner = _newOwner;
        emit OwnershipTransferred(_batchId, _newOwner);
    }

    /**
     * @dev Updates the current status of the crop batch (e.g., In Transit, Delivered).
     * @param _batchId ID of the crop batch.
     * @param _newStatus New status description.
     */
    function updateStatus(uint256 _batchId, string memory _newStatus) public {
        require(_batchId > 0 && _batchId <= batchCounter, "Invalid batch ID");

        cropBatches[_batchId].status = _newStatus;
        emit StatusUpdated(_batchId, _newStatus);
    }

    /**
     * @dev Returns all details of a crop batch.
     * @param _batchId ID of the crop batch.
     */
    function getBatchDetails(uint256 _batchId)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            uint256,
            string memory,
            string memory
        )
    {
        CropBatch memory batch = cropBatches[_batchId];
        return (
            batch.batchId,
            batch.cropType,
            batch.originFarm,
            batch.harvestDate,
            batch.currentOwner,
            batch.status
        );
    }
}
