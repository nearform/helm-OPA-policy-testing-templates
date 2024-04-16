package main

import data.kubernetes

name = input.metadata.name
kind = input.metadata.kind



deny[msg] {
	kubernetes.is_deployment
	not kubernetes.required_deployment_selectors
	msg = sprintf("Deployment %s must provide app/release labels for pod selectors", [name])
}

deny[msg] {
	kubernetes.is_deployment
	not input.spec.template.spec.nodeSelector.agentpool = "user"
	msg = sprintf("Deployment %s must declare agentpool nodeSelector as 'user' for node pool selection", [name])
}

deny[msg] {
	kubernetes.is_deployment
	not kubernetes.required_deployment_labels
	msg = sprintf("%s must include Kubernetes recommended labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels", [name])
}

# Deny rule to enforce service account specification
deny[msg] {
    kubernetes.workload_with_pod_template
    not input.spec.template.spec.serviceAccountName
    msg = sprintf("%s must specify a serviceAccountName in the template", [kind])
}

## Optional, uncomment if required
# deny[msg] {
# 	kubernetes.is_deployment
# 	not input.spec.template.spec.securityContext.runAsNonRoot

# 	msg = sprintf("Containers must not run as root in Deployment %s", [name])
# }