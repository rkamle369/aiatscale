# Architecture Overview

## Goals

- Keep Terraform code modular and reusable.
- Keep environment configurations explicit and simple.
- Support Azure, AWS, and GCP from one repository.
- Use Terragrunt for environment orchestration and var-file wiring.

## Current Scope

Implemented Azure foundational network stack:

- Resource Group module
- Virtual Network module
- Subnet module

## Environment Strategy

Each environment (for example `dev`, `prod`) has:

- Its own Terragrunt stack folders at the repository root (for example `dev/`, `prod/`)
- Its own tfvars under `tfvars/`
- A single root `terragrunt.hcl` (peer to those folders) for shared remote state and provider generation

No complex condition trees are used; each environment is explicit.
