# helm-OPA-based-testing-templates
Blueprint for OPA-based testing of Helm charts using the Conftest tool.

Conftest uses the Rego language from [Open Policy Agent](https://www.openpolicyagent.org/) for writing the assertions. You can read more about Rego in [How do I write policies](https://www.openpolicyagent.org/docs/latest/policy-language/) in the Open Policy Agent documentation.

## Usage

### Evaluating Policies
Policies by default should be placed in a directory called policy, but this can be overridden with the --policy flag.
In the Policies directory, test files should be saved with a `.rego` filename extension.

Conftest looks for deny, violation, and warn rules. Rules can optionally be suffixed with an underscore and an identifier, for example deny_myrule.

violation rules evaluates the same as deny rules, except they support returning structured data errors instead of just strings. See this issue.

By default, Conftest looks for these rules in the main namespace, but this can be overriden with the --namespace flag or provided in the configuration file. To look in all namespaces, use the --all-namespaces flag.

### Running tests
helm template `chart name` --set fullnameOverride=`repo_name/path_to_chart` | conftest test -