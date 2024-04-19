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
	container.has_secret_env_var
    msg := kubernetes.format(sprintf("For %s in the %s %s, please ensure Secret resources are mounted into containers as volumes rather than passed in as environment variables.", [container.name, kubernetes.kind, kubernetes.name]))
}