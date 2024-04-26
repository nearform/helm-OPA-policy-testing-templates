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

## Usage Guide

### Prerequisites

Before you begin, ensure you have the following installed:
- Helm 3.x: [Installation Guide](https://helm.sh/docs/intro/install/)
- Conftest: [Installation Guide](https://www.conftest.dev/install/)

You should also have:
- An understanding of how to write OPA policies in Rego: [Rego Documentation](https://www.openpolicyagent.org/docs/latest/#rego)
- Basic knowledge of Helm and Kubernetes.

### Repository Structure

This repository is organized into key directories:

- `mars`: Contains the sample Helm chart to deploy.
- `policy`: Includes the OPA policies for the Helm chart.

To integrate these policies into your workflow, copy the `policy` directory into your repository and customize the policies to fit your requirements.

### Policy Overview

The policies in this repository are designed to enforce security and best practices in Kubernetes deployments. They are divided into three levels of enforcement, each with a dedicated directory and documentation:

- **[Deny Policies](./policy/deny/README.md)**: These are mandatory rules that block deployments if non-compliant configurations are detected, ensuring strict adherence to defined standards.

- **[Violation Policies](./policy/violation/README.md)**: Similar to deny policies, these rules identify configurations that don't meet best practices but also provide structured error messages, offering insights into how to resolve the issues.

- **[Warning Policies](./policy/warn/README.md)**: These offer guidance on potential configuration problems with advisory warnings, helping you to proactively address issues that are not critical but could become significant.

To understand the specifics of each policy, please see the README.md files within the respective directories.

## How to Use

To use the policies:

1. **Customize the Policies**: Some policies are commented out as they may not apply to all scenarios. These optional policies should be reviewed and enabled if they align with your specific requirements. The active policies are set to enforce best practices and security standards and should be treated as mandatory.

2. **Place the Policies**: The default directory for policies is `policy`. If you wish to store them elsewhere, specify the location using the `--policy` flag when running tests.

3. **Naming Conventions**: Name policy files with a `.rego` extension, and prefix rule names according to their type (`deny`, `violation`, `warn`). For additional specificity, append an identifier, such as `deny_resource_limits`.

### Testing Your Helm Charts

Test the Helm charts with the following command:

```shell
helm template mars | conftest test -p policy/ -

```
## Helper Functions
The curated policies in this repo utilize helper functions to streamline policy logic and reduce complexity. These functions are central to our approach, ensuring that updates necessitated by changes in Kubernetes APIs or operational best practices can be integrated with minimal adjustments. For a detailed discussion on these helper functions, including examples, please see the documentation [here](./policy/helpers/README.md).