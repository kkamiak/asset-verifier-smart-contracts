pragma solidity ^0.4.11;


/**
 * @title Generic owned destroyable contract
 */
contract Object {
    address public owner;

    function Object() {
        owner = msg.sender;
    }

    /**
    * @dev Delegate contract to another person
    * @param _owner New owner address
    */
    function setOwner(address _owner) onlyOwner {
        owner = _owner;
    }

    /**
     * @dev Destroy contract and scrub a data
     * @notice Only hammer can call it
     */
    function destroy() onlyOwner {
        suicide(msg.sender);
    }

    /**
     * @dev Owner check modifier
     */
    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }
}

/**
*  TODO
*/
contract AssetStorage is Object {
    struct Asset {
        address owner;
        bytes32 checksum;
        bytes32 description;
        uint createDate;
    }

    uint constant OK = 1;
    uint constant ALREADY_EXISTS = 1001;
    uint constant DOES_NOT_EXIST = 1001;

    mapping (bytes32 => Asset) public assets;
    mapping (address => bytes32) public owners;

    event AssetCreated(address indexed owner, bytes32 indexed _checksum, uint _createDate);
    event Error(address indexed sender, uint errorCode);

    /**
    *  TODO
    */
    function createAsset(bytes32 _checksum, bytes32 _description, uint _createDate) returns (uint) {
        require(_checksum != 0x0);
        require(_description != 0x0);
        require(_createDate != 0x0);

        if (assets[_checksum].owner != 0x0) {
            Error(msg.sender, ALREADY_EXISTS);
            return ALREADY_EXISTS;
        }

        assets[_checksum] = Asset(msg.sender, _checksum, _description, _createDate);
        owners[msg.sender] = _checksum;
        AssetCreated(msg.sender, _checksum, _createDate);

        return OK;
    }

    /**
    *  TODO
    */
    function getAsset() constant returns (address, bytes32, bytes32, uint) {
        return getAssetFor(msg.sender);
    }

    /**
    *  TODO
    */
    function getAssetFor(address owner) constant returns (address, bytes32, bytes32, uint) {
        require(owner != 0x0);

        bytes32 checksum = owners[owner];
        if (checksum == 0x0) {
            return (0x0, 0x0, 0x0, 0);
        }

        Asset asset = assets[checksum];
        return (asset.owner, asset.checksum, asset.description, asset.createDate);
    }

    /**
    *  TODO
    */
    function deleteAsset() returns (uint) {
        if (owners[msg.sender] == 0x0) {
            Error(msg.sender, DOES_NOT_EXIST);
            return DOES_NOT_EXIST;
        }

        delete assets[owners[msg.sender]];
        delete owners[msg.sender];
    }

    /**
    *  @notice If ether is sent to this address, send it back.
    */
    function () {
        throw;
    }
}
