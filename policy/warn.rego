package main

import data.kubernetes

name := input.metadata.name

warn[msg] {
	msg = sprintf("", [name])
}

# https://learnk8s.io/production-best-practices#application-development
warn[msg] {
	kubernetes.is_deployment
    kubernetes.containers[container]
	container.serviceAccount.automount == true
    msg := kubernetes.format(sprintf("Please note that %s in the %s %s has the default ServiceAccount is automatically mounted into the file system of all Pods. You might want to disable that and provide more granular policies.", [container.name, kubernetes.kind, kubernetes.name]))
}