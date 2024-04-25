# OPA-based testing of Helm charts using the Conftest tool

This document provides a blueprint for integrating OPA-based testing into Helm chart deployments using Conftest. It outlines the setup, customization, and execution of policy tests aimed at ensuring that Kubernetes configurations comply with defined best practices, security standards, and organizational compliance requirements.


## Introduction
Conftest is a powerful tool that enables developers to write tests against structured configuration data using policies. It is particularly useful with Helm charts for applying and enforcing policies written in Rego, the policy language developed by the [Open Policy Agent](https://www.openpolicyagent.org/) project. Rego allows for expressive, declarative policies that can easily assert the configuration of Kubernetes resources. You can read more about Rego in [How do I write policies](https://www.openpolicyagent.org/docs/latest/policy-language/) in the Open Policy Agent documentation.


## Why Use OPA with Helm Charts?
[Open Policy Agent](https://www.openpolicyagent.org/) provides a high-level declarative language for expressing policies across different domains. For Kubernetes, OPA is particularly beneficial for:
-   Validating configurations during the CI/CD process, preventing non-compliant resources from being deployed.
-   Enforcing best practices and security policies that are crucial in maintaining regulatory compliance.
-   Providing flexibility with its context-aware policy execution which allows detailed control over resource deployments.

## How Conftest Helps
Conftest helps to integrate these policies within the deployment pipeline for Helm charts:
-   It parses the Helm chart templates and applies the Rego policies to the resulting Kubernetes manifests.
-   Errors and violations are flagged before the deployment, ensuring compliance and reducing the risk of deployment failures.
-   Conftest can be easily integrated into CI/CD pipelines, offering a seamless automation experience.

## Usage

### Prerequisites
- Helm 3.x installed - https://helm.sh/docs/intro/install/
- Conftest installed - https://www.conftest.dev/install/
- Familiarity with writing OPA policies in Rego - https://www.openpolicyagent.org/docs/latest/#rego
- Basic knowledge of Helm and Kubernetes

This repository is organised in the following directories:

- `mars`: Helm chart
- `policies`: OPA policies

The idea is that you copy the policies folder into your repository and customise as appropriate.
There are three categories of policies: `deny`, `violation`, and `warn`.
Some policies have been commented out as they would not be appropriate in some cases.

## Policies
The curated list of policies are categorized based on their enforcement actions - Deny, Violation, and Warning. Each category has its own folder containing the specific policies and their documentation.

### Policy Categories
- [Deny Policies](./policy/deny/README.md)
- [Violation Policies](./policy/violation/README.md)
- [Warning Policies](./policy/warn/README.md)

For detailed information on each policy, refer to the README.md within each directory.


## Policy Evaluation Guide

### Policy Location and Naming

The standard location for storing policies is within a directory named `policy`. If you want to place your policies in a different directory, you can use the `--policy` flag to specify the new location.

Each policy file should end with a `.rego` extension. This is the format Conftest expects for policy files.

### Policy Rules

Conftest specifically looks for rules named `deny`, `violation`, and `warn`. You can further customize these rule names by adding an identifier after an underscore, like so: `deny_resource_limits`.

`Violation` rules work similarly to `deny` rules but can return detailed error messages, not just simple text.

### Rule Namespaces

By default, Conftest searches for rules within the `main` namespace. To change this, use the `--namespace` flag. If you have policies spread across multiple namespaces and want to include them all during testing, the `--all-namespaces` flag will do that.

### How to Run Tests

To run tests on your Helm chart using Conftest, first create Kubernetes manifests with the `helm template` command. Then use Conftest to check these manifests against your Rego policies.

For example, to test the output of the `mars` chart, use the following commands:

```shell
helm template mars | conftest test -p policy/ -
```
## Helper Functions
Rego policies utilize helper functions to streamline policy logic and reduce complexity. These functions are central to our approach, ensuring that updates necessitated by changes in Kubernetes APIs or operational best practices can be integrated with minimal adjustments. For a detailed discussion on these helper functions, including examples, please see the documentation in the [kubernetes.rego](./policy/helpers/kubernetes.rego) file.