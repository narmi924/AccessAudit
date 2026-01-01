// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AccessAudit.sol";

contract AccessAuditTest is Test {
    AccessAudit audit;

    address admin = address(0xA11CE);
    address approver = address(0xB0B);
    address user = address(0xCAFE);

    function setUp() public {
    audit = new AccessAudit(admin);

    // sanity check: admin must be DEFAULT_ADMIN_ROLE
    assertTrue(audit.hasRole(audit.DEFAULT_ADMIN_ROLE(), admin));

    // admin grants APPROVER_ROLE to approver
    vm.startPrank(admin);
    audit.grantRole(audit.APPROVER_ROLE(), approver);
    vm.stopPrank();

    // sanity check: approver has role
    assertTrue(audit.hasRole(audit.APPROVER_ROLE(), approver));
}


    // Test 1: user can create a request; nextId increments and request is stored
    function testRequestAccessStoresRequest() public {
        bytes32 payload = keccak256(abi.encodePacked("dataset-1", "training", block.timestamp));

        vm.prank(user);
        uint256 id = audit.requestAccess(payload);

        (address requester, bytes32 payloadHash, uint64 createdAt, bool decided, bool approved) = audit.requests(id);

        assertEq(id, 0);
        assertEq(requester, user);
        assertEq(payloadHash, payload);
        assertEq(decided, false);
        assertEq(approved, false);
        assertTrue(createdAt > 0);
        assertEq(audit.nextId(), 1);
    }

    // Test 2: only approver can decide
    function testOnlyApproverCanDecide() public {
        vm.prank(user);
        uint256 id = audit.requestAccess(bytes32(uint256(123)));

        vm.prank(user);
        vm.expectRevert(); // AccessControl revert
        audit.decide(id, true);
    }

    // Test 3: cannot decide twice
    function testCannotDecideTwice() public {
        vm.prank(user);
        uint256 id = audit.requestAccess(bytes32(uint256(456)));

        vm.prank(approver);
        audit.decide(id, true);

        vm.prank(approver);
        vm.expectRevert(bytes("Already decided"));
        audit.decide(id, false);
    }
}
