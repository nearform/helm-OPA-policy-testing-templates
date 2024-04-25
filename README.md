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

### Evaluating Policies
Policies by default should be placed in a directory called policy, but this can be overridden with the --policy flag.
In the Policies directory, test files should be saved with a `.rego` filename extension.

Conftest looks for `deny`, `violation`, and `warn` rules. Rules can optionally be suffixed with an underscore and an identifier, for example `deny_myrule`.

Violation rules evaluate the same way as deny rules, except they support returning structured data errors instead of just strings.

By default, Conftest looks for rules in the main namespace, but this can be overriden with the `--namespace` flag or provided in the configuration file. To look in all namespaces, use the `--all-namespaces` flag.

### Running tests
Use Conftest to test your Helm chart outputs against the defined Rego policies. This can be done by generating Kubernetes manifests with helm template and then running Conftest to evaluate these manifests.

``helm template mars | conftest test -``

## Policies
The curated list of policies are categorized based on their enforcement actions - Deny, Violation, and Warning. Each category has its own folder containing the specific policies and their documentation.

### Policy Categories
- [Deny Policies](./policy/deny/README.md)
- [Violation Policies](./policy/violation/README.md)
- [Warning Policies](./policy/warn/README.md)

For detailed information on each policy, refer to the README.md within each directory.


## Helper Functions
Rego policies utilize helper functions to streamline policy logic and reduce complexity. These functions are central to our approach, ensuring that updates necessitated by changes in Kubernetes APIs or operational best practices can be integrated with minimal adjustments. For a detailed discussion on these helper functions, including examples, please see the documentation in the [kubernetes.rego](./policy/helpers/kubernetes.rego) file.
