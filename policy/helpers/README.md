# Helper Functions in Rego Policies

## Overview

Helper functions significantly enhance the readability and maintainability of our Rego policies by abstracting complex queries. Centralizing common logic in functions such as `kubernetes.known_registry`, stored in [kubernetes.rego](../helpers//kubernetes.rego), allows our policies to be more streamlined and adaptable. This approach ensures that updates necessitated by changes in Kubernetes APIs or best practices can be made with minimal adjustments, maintaining consistency and reducing the risk of errors.

### Example: Ensuring Use of Known Registries

Consider a policy requirement that all container images within Kubernetes deployments must originate from trusted, known registries. Instead of embedding complex checks within each policy, we use the `kubernetes.known_registry` helper function:

```rego
# File: kubernetes.rego
# Helper function to check if a registry is known and trusted
known_registry(registry) {
  registry == "docker.io"  # Example of a known registry
  # Additional known registries can be added here
}

# File: violation.rego
# Rule to enforce the use of images from known registries
violation[msg] {
  kubernetes.is_deployment  # Ensure the resource is a Deployment
  kubernetes.containers[container]  # Iterate over each container
  registry = kubernetes.resolve_registry(container.image)  # Resolve the registry of the image
  not kubernetes.known_registry(registry)  # Check if the registry is not known
  msg := kubernetes.format(sprintf("Container '%s' in Deployment '%s' uses an untrusted image source from registry: '%s'", [container.name, kubernetes.name, registry]))
}
```

In this setup, kubernetes.resolve_registry extracts the registry part of the image path, and kubernetes.known_registry checks if this registry is in a list of approved registries. This separation of concerns makes the policies clearer and more focused on their specific roles—resolve_registry handles data extraction, while known_registry handles validation.

By structuring our Rego files this way, we can easily manage and update lists of trusted registries in one place (kubernetes.rego) without altering the enforcement logic in violation.rego. This example highlights how helper functions promote cleaner, more efficient policy management and ensure that our Kubernetes deployments adhere tobest practices and organizational standards.