# helm-OPA-policy-testing-templates

The goal of this project is to provide a blueprint for OPA policy testing of Helm Charts using the Conftest tool.
This repository is organised in the following directories:

- `mars`: Helm chart
- `policies`: OPA policies

The idea is that you copy the policies folder into your repository and customise as appropriate.
There are three categories of policies: `deny`, `violation`, and `warn`.
Some policies have been commented out as they would not be appropriate in some cases.

Conftest uses the Rego language from [Open Policy Agent](https://www.openpolicyagent.org/) for writing the assertions. You can read more about Rego in [How do I write policies](https://www.openpolicyagent.org/docs/latest/policy-language/) in the Open Policy Agent documentation.

## Usage

### Evaluating Policies
Policies by default should be placed in a directory called policy, but this can be overridden with the --policy flag.
In the Policies directory, test files should be saved with a `.rego` filename extension.

Conftest looks for `deny`, `violation`, and `warn` rules. Rules can optionally be suffixed with an underscore and an identifier, for example `deny_myrule`.

Violation rules evaluate the same way as deny rules, except they support returning structured data errors instead of just strings.

By default, Conftest looks for rules in the main namespace, but this can be overriden with the `--namespace` flag or provided in the configuration file. To look in all namespaces, use the `--all-namespaces` flag.

### Running tests
Launch the following command from the root directory to run the policy tests against the sample Helm chart:

``helm template mars | conftest test -``

### Policies

**Deny**

1) Deployment %s must provide app/release labels for pod selectors

2) Deployment %s must declare agentpool nodeSelector as 'user' for node pool selection

3) Helm Chart must include Kubernetes recommended labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels

4) Deployment must specify a serviceAccountName in the template

5) Containers must not run as root in Deployment %s

**Violation**




**Warn**
1) Default ServiceAccount automatically mounting into the file system of all Pods. 

2) Secret resources are mounted into containers as volumes rather than passed in as environment variables

3) Consider using an autoscaler for varying workloads