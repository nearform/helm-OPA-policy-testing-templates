# helm-OPA-policy-testing-templates

The goal of this project is to provide a blueprint for OPA policy testing of Helm Charts using the Conftest tool.
This document putlines the process for implementing OPA-based testing using Conftest in Helm charts, including customization and configuration steps for specific needs. OPA is used here to enforce best practices, organizational security and compliance requirements.


## Introduction
Conftest is a utility that helps to write tests against structured configuration data. When used with Helm charts, Conftest allows you to enforce policies using Open Policy Agent (OPA) to ensure your Kubernetes configurations meet the required standards before deployment as well as to to enforce best practices, organizational security and compliance requirements.
Conftest uses the Rego language from [Open Policy Agent](https://www.openpolicyagent.org/) for writing the assertions. You can read more about Rego in [How do I write policies](https://www.openpolicyagent.org/docs/latest/policy-language/) in the Open Policy Agent documentation.

## Prerequisites
- Helm 3.x installed - https://helm.sh/docs/intro/install/
- Conftest installed - https://www.conftest.dev/install/
- Familiarity with writing OPA policies in Rego - https://www.openpolicyagent.org/docs/latest/#rego
- Basic knowledge of Helm and Kubernetes

## Usage

This repository is organised in the following directories:

- `mars`: Helm chart
- `policies`: OPA policies

The idea is that you copy the policies folder into your repository and customise as appropriate.
There are three categories of policies: `deny`, `violation`, and `warn`.
Some policies have been commented out as they would not be appropriate in some cases.

### Evaluating Policies
Policies by default should be placed in a directory called policy, but this can be overridden with the --policy flag.
In the Policies directory, test files should be saved with a `.rego` filename extension.

Conftest looks for `deny`, `violation`, and `warn` rules. Rules can optionally be suffixed with an underscore and an identifier, for example `deny_myrule`.

Violation rules evaluate the same way as deny rules, except they support returning structured data errors instead of just strings.

By default, Conftest looks for rules in the main namespace, but this can be overriden with the `--namespace` flag or provided in the configuration file. To look in all namespaces, use the `--all-namespaces` flag.

### Running tests
Launch the following command from the root directory to run the policy tests against the sample Helm chart:

``helm template mars | conftest test -``


## Policy Descriptions
### Find the policy definitions for the **Deny** rules here: [deny.rego](./policy/deny.rego)
### Deny 1: App/Release Label Requirements

- **Description**: Ensures that each Deployment specifies `app` and `release` labels for pod selectors, as required.
- **Purpose**: Facilitates proper labeling for better management and identification of deployments, preventing issues related to label selectors that could affect service discovery and load balancing.


### Deny 2: Node Selector Specification

- **Description**: Ensures that Deployments declare an `agentpool` nodeSelector set to 'user', which is necessary for directing pods to the appropriate node pool.
- **Purpose**: Guarantees that pods are scheduled on the intended nodes, which is crucial for resource allocation and maintaining operational boundaries within the cluster.


### Deny 3: Kubernetes Recommended Labels

- **Description**: Enforces the inclusion of Kubernetes recommended labels on deployments. These labels provide essential information about the application’s version, component, and part of the release.
- **Purpose**: Improves observability and management of applications by using standard labels that enhance the clarity and utility of resource metadata.


### Deny 4: Service Account Specification

- **Description**: Requires that all workloads with a pod template specify a `serviceAccountName`, ensuring that the pods run with the permissions granted to that service account.
- **Purpose**: Enhances security by associating pods with specific service accounts, thereby limiting privileges to what is necessary for their operation.



### Find the policy definitions for the **Violation** rules here: [violation.rego](./policy/violation.rego)
### Violation 1: Use of Latest Tag

- **Description**: Ensures that no container in a Kubernetes deployment uses the `latest` tag for its images.
- **Purpose**: Prevents deployments from using non-specific version tags that can lead to inconsistent environments and difficult-to-track bugs.


### Violation 2: Memory Limits for Containers

- **Description**: Requires that all containers in a deployment have memory limits set.
- **Purpose**: Ensures that containers do not consume an excessive amount of memory which could affect other processes on the same node.


### Violation 3: CPU Limits for Containers (Commented Out)

- **Description**: Requires that all containers in a deployment have CPU limits set.
- **Purpose**: Helps manage the CPU resources among containers and improves overall system stability.


### Violation 4: Memory Request Limits

- **Description**: Ensures that all containers in a deployment have memory request limits configured.
- **Purpose**: Guarantees that containers have enough memory for their operation, which is crucial for system performance and reliability.


### Violation 5: CPU Request Limits (Commented Out)

- **Description**: Ensures that all containers have CPU request limits configured.
- **Purpose**: Assists in proper scheduling and resource allocation by the Kubernetes scheduler to maintain operational efficiency.


### Violation 6: SYS_ADMIN Capabilities

- **Description**: Prohibits containers from having `SYS_ADMIN` capabilities.
- **Purpose**: Increases security by restricting access to critical system capabilities that can alter the host environment.


### Violation 7: Drop All Capabilities (Commented Out)

- **Description**: Requires that containers drop all capabilities.
- **Purpose**: Enforces the principle of least privilege by limiting the default capabilities granted to containers, thus enhancing security.


### Violation 8: Privileged Containers

- **Description**: Ensures no container runs in a privileged mode.
- **Purpose**: Prevents containers from accessing host resources beyond what is necessary, protecting the underlying infrastructure.


### Violation 9: Read Only Root Filesystem (Commented Out)

- **Description**: Ensures containers use a read-only root filesystem.
- **Purpose**: Increases container security by preventing modifications to the filesystem that could be exploited by malicious actors.


### Violation 10: Privilege Escalation

- **Description**: Prohibits privilege escalation within containers.
- **Purpose**: Protects the host environment from unauthorized changes by ensuring that processes within containers cannot gain additional privileges.


### Violation 11: Run as Non-Root (Commented Out)

- **Description**: Requires that containers must not run as the root user.
- **Purpose**: Enhances the security of containers by ensuring they operate with minimal privileges, reducing the risk of exploiting host vulnerabilities.


### Violation 12: User ID Restrictions

- **Description**: Ensures that containers are run with a User ID (UID) of 10000 or higher.
- **Purpose**: Prevents potential conflicts with host system user IDs and enhances security by avoiding default UIDs that might have more privileges.


### Violation 13: Managing Host Aliases

- **Description**: Checks for unauthorized management of host aliases within pods.
- **Purpose**: Prevents potential DNS rebinding attacks and other DNS-related security issues by controlling the modification of host aliases.


### Violation 14: Sharing the Host IPC Namespace

- **Description**: Prohibits pods from sharing the host's IPC namespace.
- **Purpose**: Isolates application processes, enhancing the security posture by preventing unwanted interactions between host and container processes.


### Violation 15: Connected to the Host Network

- **Description**: Ensures that pods are not connected to the host's network.
- **Purpose**: Maintains network isolation between the host and pods, reducing the risk of network-based attacks to the host.


### Violation 16: Sharing the Host PID

- **Description**: Prevents pods from sharing the host's PID namespace.
- **Purpose**: Ensures process isolation, preventing malicious processes within the pod from accessing or interacting with host processes.


### Violation 17: Mounting the Docker Socket

- **Description**: Prohibits volumes from mounting the Docker socket.
- **Purpose**: Prevents containers from potentially gaining control over the Docker daemon, which could lead to unauthorized container privileges or host code execution.


### Violation 18: Readiness Probes

- **Description**: Ensures every container within a deployment has a readiness probe configured.
- **Purpose**: Increases the reliability of the service by ensuring that traffic is not routed to a container that is not ready to handle requests.


### Violation 19: Liveness Probes

- **Description**: Requires that all containers in a deployment have liveness probes to check the health of applications periodically.
- **Purpose**: Enhances the resilience of the system by allowing Kubernetes to restart containers that are no longer healthy.


### Violation 20: Distinctiveness of Liveness and Readiness Probes

- **Description**: Checks that liveness and readiness probes are not configured identically in deployment containers.
- **Purpose**: Ensures that readiness and liveness probes serve their individual purposes effectively—readiness for traffic readiness and liveness for container health checks.


### Violation 21: Trusted Image Sources

- **Description**: Ensures that all container images come from a trusted registry.
- **Purpose**: Prevents the use of potentially insecure or malicious container images by enforcing the use of approved registries.


### Violation 22: High Availability via Replicas

- **Description**: Ensures that deployments are configured with more than one replica to meet high availability requirements.
- **Purpose**: Guarantees that applications remain available in the event of a failure or maintenance by running multiple instances.


### Find the policy definitions for the **Warn** rules here: [warn.rego](./policy/deny.rego)
### Warning 1: Automatic Service Account Mounting

- **Description**: Warns if the default Kubernetes ServiceAccount is automatically mounted into the file system of all pods within a deployment.
- **Purpose**: Suggests the need to disable automatic mounting and to provide more granular access controls to enhance security.


### Warning 2: Secret Management

- **Description**: Advises against passing sensitive information (secrets) as environment variables in container configurations.
- **Purpose**: Recommends mounting secrets as volumes instead, which is a safer method to handle sensitive configurations, thus enhancing security by reducing potential exposure in the container runtime environment.


### Warning 3: Autoscaling Configuration

- **Description**: Alerts when a deployment's containers do not have autoscaling enabled, particularly in environments expected to experience varying workloads.
- **Purpose**: Encourages the use of autoscalers to ensure that deployments can handle load dynamically, thereby improving resource efficiency and application responsiveness.


