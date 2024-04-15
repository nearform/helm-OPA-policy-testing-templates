package main

import data.kubernetes

name = input.metadata.name

required_deployment_labels {
	input.metadata.labels["app.kubernetes.io/name"]
	input.metadata.labels["app.kubernetes.io/instance"]
	input.metadata.labels["app.kubernetes.io/version"]
	input.metadata.labels["app.kubernetes.io/managed-by"]
}

deny[msg] {
	kubernetes.is_deployment
	not required_deployment_labels
	msg = sprintf("%s must include Kubernetes recommended labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels", [name])
}

required_deployment_selectors {
	input.spec.selector.matchLabels["app.kubernetes.io/name"]
	input.spec.selector.matchLabels["app.kubernetes.io/instance"]
}

deny[msg] {
	kubernetes.is_deployment
	not required_deployment_selectors
	msg = sprintf("Deployment %s must provide app/release labels for pod selectors", [name])
}

deny[msg] {
	kubernetes.is_deployment
	not input.spec.template.spec.nodeSelector.agentpool = "user"
	msg = sprintf("Deployment %s must declare agentpool nodeSelector as 'user' for node pool selection", [name])
}

deny[msg] {
	kubernetes.is_deployment
	not input.spec.template.spec.securityContext.runAsNonRoot

	msg = sprintf("Containers must not run as root in Deployment %s", [name])
}