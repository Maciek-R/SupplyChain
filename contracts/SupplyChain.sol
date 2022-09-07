pragma solidity >=0.4.22 <0.9.0;

contract SupplyChain {
    uint32 public product_id_counter = 0;
    uint32 public participant_id_counter = 0;
    uint32 public owner_id_counter = 0;

    struct Product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint32 mfgTimeStamp;
    }

    mapping (uint32 => Product) public products;

    struct Participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }

    mapping (uint32 => Participant) public participants;

    struct Ownership {
        uint32 productId;
        uint32 ownerId;
        uint32 trxTimeStamp;
        address productOwner;
    }

    mapping (uint32 => Ownership) public ownerships;
    mapping (uint32 => uint32[]) public productTrack;

    event TransferOwnership(uint32 productId);

    function addParticipant(string memory _userName, string memory _password, string memory _participantType, address _participantAddress) public returns (uint32) {
        uint32 participantId = participant_id_counter++;
        participants[participantId].userName = _userName;
        participants[participantId].password = _password;
        participants[participantId].participantType = _participantType;
        participants[participantId].participantAddress = _participantAddress;

        return participantId;
    }

    function getParticipant(uint32 participantId) public view returns (string memory, address, string memory) {
        Participant memory participant = participants[participantId];
        return (participant.userName, participant.participantAddress, participant.participantType);
    }

    function addProduct(uint32 ownerId, string memory modelNumber, string memory partNumber, string memory serialNumber, uint32 cost) public returns (uint32) {
        bool isManufacturer = compareStrings(participants[ownerId].participantType, "Manufacturer");
        require(isManufacturer, "Owner should be of Manufacturer type!");

        uint32 productId = product_id_counter++;

        products[productId].modelNumber = modelNumber;
        products[productId].partNumber = partNumber;
        products[productId].serialNumber = serialNumber;
        products[productId].mfgTimeStamp = uint32(now);
        products[productId].cost = cost;
        products[productId].productOwner = participants[ownerId].participantAddress;

        return productId;
    }

    function getProduct(uint32 productId) public view returns(string memory, string memory, string memory, address, uint32) {
        Product memory product = products[productId];
        return (product.modelNumber, product.partNumber, product.serialNumber, product.productOwner, product.cost);
    }

    modifier onlyOwnerOfProduct(uint32 productId) {
        require(msg.sender == products[productId].productOwner);
        _;
    }

    function newOwner(uint32 oldParticipantId, uint32 newParticipantId, uint32 productId) onlyOwnerOfProduct(productId) public returns (bool) {
        Participant memory oldParticipant = participants[oldParticipantId];
        Participant memory newParticipant = participants[newParticipantId];
        uint32 ownershipId = owner_id_counter++;

        //TODO
//        bool transferFromManufacturerToManufacturer = compareStrings(participants[oldParticipantId].participantType, "Manufacturer") && compareStrings(participants[newParticipantId].participantType, "Manufacturer");
//        if(transferFromManufacturerToManufacturer) {
        ownerships[ownershipId].productId = productId;
        ownerships[ownershipId].productOwner = newParticipant.participantAddress;
        ownerships[ownershipId].ownerId = newParticipantId;
        ownerships[ownershipId].trxTimeStamp = uint32(now);

        products[productId].productOwner = newParticipant.participantAddress;
        productTrack[productId].push(ownershipId);
        emit TransferOwnership(productId);

        return true;
    }

    function getProvenance(uint32 productId) external view returns (uint32[] memory){
        return productTrack[productId];
    }

    function getOwnership(uint32 ownershipId) public view returns (uint32, uint32, address, uint32) {
        Ownership memory ownership = ownerships[ownershipId];
        return (ownership.productId, ownership.ownerId, ownership.productOwner, ownership.trxTimeStamp);
    }

    function authenticateParticipant(uint32 participantId, string memory username, string memory password, string memory participantType) public view returns (bool) {
        Participant memory participant = participants[participantId];
        if(compareStrings(participant.participantType, participantType) && compareStrings(participant.password, password) && compareStrings(participant.userName, username))
            return true;
        else
            return false;
    }

    function compareStrings(string memory s1, string memory s2) private pure returns (bool) {
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}
