# Deny Policies Documentation

## Overview

This document provides detailed descriptions and purposes for the deny policies. These policies are crucial for maintaining the security, management, and observability of applications within our Kubernetes environment.

## Deny Rules

Find the policy definitions for the Deny rules in the accompanying Rego file: [deny.rego](../deny/deny.rego)

### Deny 1: App/Release Label Requirements
- **Description**: Ensures that each deployment has mandatory `app` and `release` labels for pod selectors.
- **Purpose**: Improves management and identification of deployments by ensuring proper labeling practices.

### Deny 2: Node Selector Specification
- **Description**: Ensures that deployments specify a `user` nodeSelector under the `agentpool` field.
- **Purpose**: Ensures pods are scheduled on the intended, user-specific nodes to maintain resource boundaries and efficiency.

### Deny 3: Kubernetes Recommended Labels
- **Description**: Requires the use of Kubernetes recommended labels on all deployments, as outlined in [Kubernetes Label and Selector Documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).
- **Purpose**: Enhances the observability and manageability of applications by utilizing standardized metadata labels.

### Deny 4: Service Account Specification
- **Description**: Mandates that all workloads define a `serviceAccountName` within their pod templates.
- **Purpose**: Strengthens security by ensuring pods operate with appropriate permissions provided by specific service accounts.

