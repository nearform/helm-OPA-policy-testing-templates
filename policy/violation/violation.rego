package main

import data.kubernetes

violation[msg] {
	kubernetes.containers[container]
	[image_name, "latest"] = kubernetes.split_image(container.image)
	msg = kubernetes.format(sprintf("%s in the %s %s has an image, %s, using the latest tag", [container.name, kubernetes.kind, image_name, kubernetes.name]))
}

# https://kubesec.io/basics/containers-resources-limits-memory
violation[msg] {
	kubernetes.containers[container]
	not container.resources.limits.memory
	msg = kubernetes.format(sprintf("%s in the %s %s does not have a memory limit set", [container.name, kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/containers-resources-limits-cpu/
# violation[msg] {
# 	kubernetes.containers[container]
# 	not container.resources.limits.cpu
# 	msg = kubernetes.format(sprintf("%s in the %s %s does not have a CPU limit set", [container.name, kubernetes.kind, kubernetes.name]))
# }

# https://kubesec.io/basics/containers-requests-limits-memory
violation[msg] {
	kubernetes.containers[container]
	not container.requests.limits.memory
	msg = kubernetes.format(sprintf("%s in the %s %s does not have requests memory limit set", [container.name, kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/containers-requests-limits-cpu/
# violation[msg] {
# 	kubernetes.containers[container]
# 	not container.requests.limits.cpu
# 	msg = kubernetes.format(sprintf("%s in the %s %s does not have requests CPU limit set", [container.name, kubernetes.kind, kubernetes.name]))
# }

# https://kubesec.io/basics/containers-securitycontext-capabilities-add-index-sys-admin/
violation[msg] {
	kubernetes.containers[container]
	kubernetes.added_capability(container, "CAP_SYS_ADMIN")
	msg = kubernetes.format(sprintf("%s in the %s %s has SYS_ADMIN capabilties", [container.name, kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/containers-securitycontext-capabilities-drop-index-all/
# violation[msg] {
# 	kubernetes.containers[container]
# 	not kubernetes.dropped_capability(container, "all")
# 	msg = kubernetes.format(sprintf("%s in the %s %s doesn't drop all capabilities", [container.name, kubernetes.kind, kubernetes.name]))
# }

# https://kubesec.io/basics/containers-securitycontext-privileged-true/
violation[msg] {
	kubernetes.containers[container]
	container.securityContext.privileged
	msg = kubernetes.format(sprintf("%s in the %s %s is privileged", [container.name, kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/containers-securitycontext-readonlyrootfilesystem-true/
# violation[msg] {
# 	kubernetes.containers[container]
# 	kubernetes.no_read_only_filesystem(container)
# 	msg = kubernetes.format(sprintf("%s in the %s %s is not using a read only root filesystem", [container.name, kubernetes.kind, kubernetes.name]))
# }

violation[msg] {
	kubernetes.containers[container]
	kubernetes.priviledge_escalation_allowed(container)
	msg = kubernetes.format(sprintf("%s in the %s %s allows priviledge escalation", [container.name, kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/containers-securitycontext-runasnonroot-true/
# violation[msg] {
# 	kubernetes.containers[container]
# 	not container.securityContext.runAsNonRoot = true
# 	msg = kubernetes.format(sprintf("%s in the %s %s is running as root", [container.name, kubernetes.kind, kubernetes.name]))
# }

# https://kubesec.io/basics/containers-securitycontext-runasuser/
violation[msg] {
	kubernetes.containers[container]
	container.securityContext.runAsUser < 10000
	msg = kubernetes.format(sprintf("%s in the %s %s has a UID of less than 10000", [container.name, kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/spec-hostaliases/
violation[msg] {
	kubernetes.pods[pod]
	pod.spec.hostAliases
	msg = kubernetes.format(sprintf("The %s %s is managing host aliases", [kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/spec-hostipc/
violation[msg] {
	kubernetes.pods[pod]
	pod.spec.hostIPC
	msg = kubernetes.format(sprintf("%s %s is sharing the host IPC namespace", [kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/spec-hostnetwork/
violation[msg] {
	kubernetes.pods[pod]
	pod.spec.hostNetwork
	msg = kubernetes.format(sprintf("The %s %s is connected to the host network", [kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/spec-hostpid/
violation[msg] {
	kubernetes.pods[pod]
	pod.spec.hostPID
	msg = kubernetes.format(sprintf("The %s %s is sharing the host PID", [kubernetes.kind, kubernetes.name]))
}

# https://kubesec.io/basics/spec-volumes-hostpath-path-var-run-docker-sock/
violation[msg] {
	kubernetes.volumes[volume]
	volume.hostpath.path = "/var/run/docker.sock"
	msg = kubernetes.format(sprintf("The %s %s is mounting the Docker socket", [kubernetes.kind, kubernetes.name]))
}

# https://learnk8s.io/production-best-practices#application-development
violation[msg] {
    kubernetes.is_deployment  # Ensure the resource is a Deployment
    kubernetes.containers[container] # Iterate over each container
    not kubernetes.has_readiness_probe(container)  # Check if the readiness probe is missing
    msg := kubernetes.format(sprintf("The '%s' has container '%s' missing a readinessProbe block configuration", [kubernetes.kind, container.name]))
}

# https://learnk8s.io/production-best-practices#application-development
violation[msg] {
    kubernetes.is_deployment
    kubernetes.containers[container]
    not kubernetes.has_liveness_probe(container)
    msg := kubernetes.format(sprintf("%s in the %s %s is missing a livenessProbe block configuration", [container.name, kubernetes.kind, kubernetes.name]))
}

# https://learnk8s.io/production-best-practices#application-development
violation[msg] {
    kubernetes.is_deployment
    kubernetes.containers[container]
    container.readinessProbe == container.livenessProbe
    msg := kubernetes.format(sprintf("%s in the %s %s has identical readinessProbe and livenessProbe block configurations", [container.name, kubernetes.kind, kubernetes.name]))
}

violation[msg] {
	kubernetes.is_deployment
	kubernetes.containers[container]
	registry = kubernetes.resolve_registry(container.image)
	not kubernetes.known_registry(registry)
	msg := kubernetes.format(sprintf("Container '%s' in %s '%s' uses an untrusted image source: %s from registry: %s", [container.name, kubernetes.kind, input.metadata.name, container.image, registry]))
}

# https://learnk8s.io/production-best-practices#application-development
violation[msg] {
	kubernetes.is_deployment
	replicas := input.spec.replicas
	kubernetes.pod_replicas_lt_or_equal_one(replicas)
	msg := kubernetes.format(sprintf("Deployment %s: replicas is %d. Replicas need to be more than 1 for High Availability guarantees", [kubernetes.name, replicas]))
}
