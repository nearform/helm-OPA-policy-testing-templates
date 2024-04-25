# Violation Policies Documentation

## Overview

This document outlines various rules (violation policies) that check Kubernetes deployments to make sure they meet certain standards before being applied. These rules help keep our systems reliable, secure, and efficient.

## Violation Rules

You can find the detailed policy definitions here: [violation.rego](../violation/violation.rego)

### Violation 1: Image Tag Usage
- **Description**: Checks that no deployment uses the 'latest' tag for images.
- **Purpose**: Helps avoid unexpected changes and ensures environments are consistent and stable.

### Violation 2: Memory Limits
- **Description**: Makes sure all containers in a deployment have set memory limits.
- **Purpose**: Keeps containers from using too much memory, which could slow down or disrupt other services.

### Violation 3: CPU Limits (Commented Out)
- **Description**: Requires that containers have a limit on the CPU resources they can use.
- **Purpose**: Helps balance CPU usage among containers to keep the system stable.

### Violation 4: Memory Request Limits
- **Description**: Checks that all containers request a certain amount of memory needed for their operation.
- **Purpose**: Ensures each container has enough memory to function properly without overusing resources.

### Violation 5: CPU Request Limits (Commented Out)
- **Description**: Ensures containers specify how much CPU they expect to use.
- **Purpose**: Assists in planning and allocating CPU resources efficiently.

### Violation 6: SYS_ADMIN Capabilities
- **Description**: Prevents containers from having SYS_ADMIN abilities.
- **Purpose**: Increases security by limiting access to critical system capabilities.

### Violation 7: Drop All Capabilities (Commented Out)
- **Description**: Requires containers to drop all predefined capabilities.
- **Purpose**: Applies the principle of least privilege to improve security.

### Violation 8: Privileged Mode
- **Description**: Ensures no container runs with privileged system access.
- **Purpose**: Prevents containers from making unauthorized changes to the host system.

### Violation 9: Read Only Root Filesystem (Commented Out)
- **Description**: Ensures containers use a read-only root filesystem.
- **Purpose**: Increases container security by preventing modifications that could be exploited.

### Violation 10: Privilege Escalation
- **Description**: Prohibits privilege escalation within containers.
- **Purpose**: Protects the host environment from unauthorized changes.

### Violation 11: Run as Non-Root (Commented Out)
- **Description**: Requires that containers must not run as the root user.
- **Purpose**: Reduces the risk of exploiting host vulnerabilities.

### Violation 12: User ID Restrictions
- **Description**: Ensures that containers are run with a User ID (UID) of 10000 or higher.
- **Purpose**: Prevents potential conflicts with host system user IDs and enhances security.

### Violation 13: Managing Host Aliases
- **Description**: Checks for unauthorized management of host aliases within pods.
- **Purpose**: Prevents potential DNS rebinding attacks and other DNS-related security issues.

### Violation 14: Sharing the Host IPC Namespace
- **Description**: Prohibits pods from sharing the host's IPC namespace.
- **Purpose**: Isolates application processes, enhancing security.

### Violation 15: Connected to the Host Network
- **Description**: Ensures that pods are not connected to the host's network.
- **Purpose**: Maintains network isolation, reducing the risk of network-based attacks.

### Violation 16: Sharing the Host PID
- **Description**: Prevents pods from sharing the host's PID namespace.
- **Purpose**: Ensures process isolation to prevent access or interaction with host processes.

### Violation 17: Mounting the Docker Socket
- **Description**: Prohibits volumes from mounting the Docker socket.
- **Purpose**: Prevents containers from potentially gaining control over the Docker daemon.

### Violation 18: Readiness Probes
- **Description**: Ensures every container within a deployment has a readiness probe configured.
- **Purpose**: Increases the reliability of the service by managing traffic to ready containers.

### Violation 19: Liveness Probes
- **Description**: Requires that all containers in a deployment have liveness probes.
- **Purpose**: Allows Kubernetes to restart containers that are no longer healthy.

### Violation 20: Distinctiveness of Liveness and Readiness Probes
- **Description**: Checks that liveness and readiness probes are not configured identically.
- **Purpose**: Ensures probes effectively serve their purposes—readiness for traffic readiness and liveness for health checks.

### Violation 21: Trusted Image Sources
- **Description**: Ensures that all container images come from a trusted registry.
- **Purpose**: Prevents the use of potentially insecure or malicious images.

### Violation 22: High Availability via Replicas
- **Description**: Ensures that deployments are configured with more than one replica.
- **Purpose**: Guarantees that applications remain available during failures or maintenance.


