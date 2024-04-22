# helm-OPA-policy-testing-templates

The goal of this project is to provide a blueprint for OPA policy testing of Helm Charts using the Conftest tool.
This repository is organised in the following directories:

- `mars`: Helm chart
- `policies`: OPA policies

Conftest uses the Rego language from [Open Policy Agent](https://www.openpolicyagent.org/) for writing the assertions. You can read more about Rego in [How do I write policies](https://www.openpolicyagent.org/docs/latest/policy-language/) in the Open Policy Agent documentation.

## Usage

### Evaluating Policies
Policies by default should be placed in a directory called policy, but this can be overridden with the --policy flag.
In the Policies directory, test files should be saved with a `.rego` filename extension.

Conftest looks for `deny`, `violation`, and `warn` rules. Rules can optionally be suffixed with an underscore and an identifier, for example `deny_myrule`.

Violation rules evaluate the same way as deny rules, except they support returning structured data errors instead of just strings.

By default, Conftest looks for rules in the main namespace, but this can be overriden with the `--namespace` flag or provided in the configuration file. To look in all namespaces, use the `--all-namespaces` flag.

### Running testsa\'
Launch the following command from the root directory to run the policy tests against the sample Helm chart:

``helm template mars | conftest test -``