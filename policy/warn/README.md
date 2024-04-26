# Warning Policies Documentation

## Overview

This document details the warning policies designed to alert users about potential security or configuration issues in Kubernetes deployments. These warnings guide adjustments that enhance the system's security and operational effectiveness.

## Warning Rules

Find the policy definitions for the Warning rules in the accompanying Rego file: [warn.rego](../warn//warn.rego)

### Warning 1: Automatic Service Account Mounting
- **Description**: Alerts if the default ServiceAccount is automatically mounted into the filesystem of all pods.
- **Purpose**: Recommends disabling automatic mounting to increase security by reducing unnecessary access to sensitive information.

### Warning 2: Secret Management
- **Description**: Advises against using environment variables to manage secrets within containers.
- **Purpose**: Recommends mounting secrets as volumes instead of using environment variables, to minimize the risk of exposure in the container's runtime environment.

### Warning 3: Autoscaling Configuration
- **Description**: Notifies when a deployment's containers do not utilize autoscaling.
- **Purpose**: Encourages enabling autoscaling to ensure deployments can efficiently handle varying workloads, improving resource usage and responsiveness.
