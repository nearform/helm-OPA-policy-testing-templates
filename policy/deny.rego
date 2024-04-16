package main

import data.kubernetes

name = input.metadata.name

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

## Optional, uncomment if required
# deny[msg] {
# 	kubernetes.is_deployment
# 	not input.spec.template.spec.securityContext.runAsNonRoot

# 	msg = sprintf("Containers must not run as root in Deployment %s", [name])
# }
