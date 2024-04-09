# Sample code

## Description

This folder contains sample code for OPA based policy testing. It's organized in the following directories:

- `mars`: Helm chart
- `policies`: OPA policies

## How to use

Launch the following command from this directory to run the policy tests against the sample Helm chart:

`helm template mars | conftest test --policy policies -`
