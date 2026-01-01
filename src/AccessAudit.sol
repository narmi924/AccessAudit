// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AccessAudit is AccessControl {
    bytes32 public constant APPROVER_ROLE = keccak256("APPROVER_ROLE");

    struct Request {
        address requester;
        bytes32 payloadHash; // hash(datasetId || purpose || timestamp), do NOT store plaintext private data
        uint64 createdAt;
        bool decided;
        bool approved;
    }

    uint256 public nextId;
    mapping(uint256 => Request) public requests;

    event AccessRequested(uint256 indexed id, address indexed requester, bytes32 payloadHash);
    event AccessDecided(uint256 indexed id, address indexed approver, bool approved);

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    function requestAccess(bytes32 payloadHash) external returns (uint256 id) {
        id = nextId++;
        requests[id] = Request({
            requester: msg.sender,
            payloadHash: payloadHash,
            createdAt: uint64(block.timestamp),
            decided: false,
            approved: false
        });

        emit AccessRequested(id, msg.sender, payloadHash);
    }

    function decide(uint256 id, bool approved) external onlyRole(APPROVER_ROLE) {
        Request storage r = requests[id];
        require(!r.decided, "Already decided");

        r.decided = true;
        r.approved = approved;

        emit AccessDecided(id, msg.sender, approved);
    }
}
