# helm-OPA-policy-testing-templates

The goal of this project is to provide a blueprint for OPA policy testing of Helm Charts using the Conftest tool.
This document outlines the process for implementing OPA-based testing using Conftest in Helm charts, including customization and configuration steps for specific needs, using a curated list of policies/rules. OPA is used here to enforce best practices, organizational security and compliance requirements.


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


### Policy Descriptions

#### Deny Rules
Find the policy definitions for the Deny rules here: [deny.rego](./policies/deny.rego)
- **Deny 1: App/Release Label Requirements**
  - **Description**: Ensures that each Deployment specifies app and release labels for pod selectors, as required.
  - **Purpose**: Facilitates proper labeling for better management and identification of deployments.
- **Deny 2: Node Selector Specification**
  - **Description**: Ensures that Deployments declare an agentpool nodeSelector set to 'user'.
  - **Purpose**: Guarantees that pods are scheduled on the intended nodes.
- **Deny 3: Kubernetes Recommended Labels**
  - **Description**: Enforces the inclusion of Kubernetes recommended labels on deployments.
  - **Purpose**: Improves observability and management of applications.
- **Deny 4: Service Account Specification**
  - **Description**: Requires that all workloads with a pod template specify a serviceAccountName.
  - **Purpose**: Enhances security by associating pods with specific service accounts.

#### Violation Rules
Find the policy definitions for the Violation rules here: [violation.rego](./policies/violation.rego)
- **Violation 1: Use of Latest Tag**
  - **Description**: Ensures no container in a deployment uses the latest tag for its images.
  - **Purpose**: Prevents using non-specific version tags that can lead to inconsistent environments.
- **Violation 2: Memory Limits for Containers**
  - **Description**: Requires that all containers in a deployment have memory limits set.
  - **Purpose**: Ensures containers do not consume excessive memory.
- **Violation 3: CPU Limits for Containers (Commented Out)**
  - **Description**: Requires that all containers in a deployment have CPU limits set.
  - **Purpose**: Helps manage CPU resources among containers.
- **Violation 4: Memory Request Limits**
  - **Description**: Ensures all containers in a deployment have memory request limits configured.
  - **Purpose**: Guarantees that containers have enough memory for their operation.
- **Violation 5: CPU Request Limits (Commented Out)**
  - **Description**: Ensures all containers have CPU request limits configured.
  - **Purpose**: Assists in proper scheduling and resource allocation.
- **Violation 6: SYS_ADMIN Capabilities**
  - **Description**: Prohibits containers from having SYS_ADMIN capabilities.
  - **Purpose**: Increases security by restricting access to critical system capabilities.
- **Violation 7: Drop All Capabilities (Commented Out)**
  - **Description**: Requires that containers drop all capabilities.
  - **Purpose**: Enforces the principle of least privilege.
- **Violation 8: Privileged Containers**
  - **Description**: Ensures no container runs in a privileged mode.
  - **Purpose**: Prevents containers from accessing host resources unnecessarily.
- **Additional Violations**:
  - List further violations as needed following the established format.
- **Violation 9: Read Only Root Filesystem (Commented Out)**
  - **Description**: Ensures containers use a read-only root filesystem.
  - **Purpose**: Increases container security by preventing modifications that could be exploited.
- **Violation 10: Privilege Escalation**
  - **Description**: Prohibits privilege escalation within containers.
  - **Purpose**: Protects the host environment from unauthorized changes.
- **Violation 11: Run as Non-Root (Commented Out)**
  - **Description**: Requires that containers must not run as the root user.
  - **Purpose**: Reduces the risk of exploiting host vulnerabilities.
- **Violation 12: User ID Restrictions**
  - **Description**: Ensures that containers are run with a User ID (UID) of 10000 or higher.
  - **Purpose**: Prevents potential conflicts with host system user IDs and enhances security.
- **Violation 13: Managing Host Aliases**
  - **Description**: Checks for unauthorized management of host aliases within pods.
  - **Purpose**: Prevents potential DNS rebinding attacks and other DNS-related security issues.
- **Violation 14: Sharing the Host IPC Namespace**
  - **Description**: Prohibits pods from sharing the host's IPC namespace.
  - **Purpose**: Isolates application processes, enhancing security.
- **Violation 15: Connected to the Host Network**
  - **Description**: Ensures that pods are not connected to the host's network.
  - **Purpose**: Maintains network isolation, reducing the risk of network-based attacks.
- **Violation 16: Sharing the Host PID**
  - **Description**: Prevents pods from sharing the host's PID namespace.
  - **Purpose**: Ensures process isolation to prevent access or interaction with host processes.
- **Violation 17: Mounting the Docker Socket**
  - **Description**: Prohibits volumes from mounting the Docker socket.
  - **Purpose**: Prevents containers from potentially gaining control over the Docker daemon.
- **Violation 18: Readiness Probes**
  - **Description**: Ensures every container within a deployment has a readiness probe configured.
  - **Purpose**: Increases the reliability of the service by managing traffic to ready containers.
- **Violation 19: Liveness Probes**
  - **Description**: Requires that all containers in a deployment have liveness probes.
  - **Purpose**: Allows Kubernetes to restart containers that are no longer healthy.
- **Violation 20: Distinctiveness of Liveness and Readiness Probes**
  - **Description**: Checks that liveness and readiness probes are not configured identically.
  - **Purpose**: Ensures probes effectively serve their purposes—readiness for traffic readiness and liveness for health checks.
- **Violation 21: Trusted Image Sources**
  - **Description**: Ensures that all container images come from a trusted registry.
  - **Purpose**: Prevents the use of potentially insecure or malicious images.
- **Violation 22: High Availability via Replicas**
  - **Description**: Ensures that deployments are configured with more than one replica.
  - **Purpose**: Guarantees that applications remain available during failures or maintenance.

#### Warning Rules
Find the policy definitions for the Warning rules here: [warn.rego](./policies/warn.rego)
- **Warning 1: Automatic Service Account Mounting**
  - **Description**: Warns if the default ServiceAccount is automatically mounted into the filesystem of all pods.
  - **Purpose**: Suggests disabling automatic mounting to enhance security.
- **Warning 2: Secret Management**
  - **Description**: Advises against passing secrets as environment variables in containers.
  - **Purpose**: Recommends mounting secrets as volumes to reduce exposure risks.
- **Warning 3: Autoscaling Configuration**
  - **Description**: Alerts when a deployment's containers do not have autoscaling enabled.
  - **Purpose**: Encourages the use of autoscalers for handling varying workloads efficiently.



