// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AccessAudit.sol";

contract DeployAccessAudit is Script {
    function run() external returns (AccessAudit audit) {
        // Deployer is the EOA corresponding to --private-key when broadcasting
        address admin = vm.envAddress("ADMIN_ADDRESS");

        vm.startBroadcast();
        audit = new AccessAudit(admin);
        vm.stopBroadcast();

        console2.log("AccessAudit deployed at:", address(audit));
        console2.log("Admin:", admin);
    }
}
