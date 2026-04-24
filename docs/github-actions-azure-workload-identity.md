# GitHub Actions with Azure Workload Identity (OIDC)

This guide configures GitHub Actions to run Terragrunt against Azure **without client secrets**.

## What was added

- Workflow: `.github/workflows/terragrunt-plan.yml`
- Workflow: `.github/workflows/terragrunt-apply.yml`
- Terragrunt backend updated to Azure Storage in `terragrunt.hcl` with OIDC auth.

## 1) Create Terraform state resources (Azure Portal)

Create these resources in your target subscription:

1. Resource Group for Terraform state, for example `rg-tfstate-global`.
2. Storage Account (globally unique name), for example `sttfstateglobal001`.
3. Blob Container, for example `tfstate`.

Use these names later as GitHub repository variables:

- `TFSTATE_RESOURCE_GROUP`
- `TFSTATE_STORAGE_ACCOUNT`
- `TFSTATE_CONTAINER`

### State file layout inside the container

This repo writes separate state files per environment automatically by key prefix:

- `dev/azure/.../terraform.tfstate`
- `prod/azure/.../terraform.tfstate`

Examples:

- `dev/azure/hub-network/resource-group/terraform.tfstate`
- `prod/azure/spoke-network/subnet-aks/terraform.tfstate`

## 2) Create App Registration (Azure Portal)

1. Go to **Azure Portal** -> **Microsoft Entra ID** -> **App registrations**.
2. Click **New registration**.
3. Name example: `gha-terragrunt-oidc`.
4. Register.
5. Copy these values:
   - **Application (client) ID** -> `AZURE_CLIENT_ID`
   - **Directory (tenant) ID** -> `AZURE_TENANT_ID`

## 3) Add Federated Credential (Azure Portal)

In the same app registration:

1. Open **Certificates & secrets** -> **Federated credentials**.
2. Click **Add credential**.
3. Choose scenario **GitHub Actions deploying Azure resources**.
4. Fill:
   - Organization: your GitHub org/user
   - Repository: this repo name
   - Entity type: choose based on workflow strategy
     - `Branch` for broad branch-based trust (example `main`)
     - `Environment` for protected environments (`dev`, `prod`) recommended for apply
5. Add credential.

Recommended subjects:

- Plan on PR/main branch:
  - `repo:<org>/<repo>:ref:refs/heads/main`
- Apply with environment protection:
  - `repo:<org>/<repo>:environment:dev`
  - `repo:<org>/<repo>:environment:prod`

## 4) Assign Azure RBAC roles

Grant the App Registration service principal access:

1. Go to subscription (or target resource group) -> **Access control (IAM)**.
2. Add role assignment for deployment scope:
   - `Contributor` (or a least-privilege custom role).
3. Grant state storage data-plane role on the state storage account:
   - `Storage Blob Data Contributor`.

Optional but common:

- If reading role assignments in plans, add `Reader` at subscription scope.

## 5) Configure GitHub repository settings

In GitHub -> **Settings** -> **Secrets and variables** -> **Actions**:

### Repository secrets

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

### Repository variables

- `TFSTATE_RESOURCE_GROUP`
- `TFSTATE_STORAGE_ACCOUNT`
- `TFSTATE_CONTAINER`

If using protected environments (`dev`, `prod`), move these to **Environment secrets/variables**.

## 6) Configure environment protection (recommended)

In GitHub -> **Settings** -> **Environments**:

1. Create `dev` and `prod` environments.
2. For `prod`, configure required reviewers.
3. (Optional) Move Azure secrets/vars to each environment.

The apply workflow already targets the selected environment via:

- `environment: ${{ inputs.environment }}`

## 7) Run workflows

### Plan

- Automatic on PR to `main`.
- Manual: run **Terragrunt Plan (Azure OIDC)** and choose `dev` or `prod`.

### Apply

- Manual only: run **Terragrunt Apply (Azure OIDC)** and choose `dev` or `prod`.

## Troubleshooting

- `No matching federated identity record found`:
  - Subject in federated credential does not match workflow context (branch/environment).
- `AuthorizationFailed`:
  - Missing `Contributor` or scope is too narrow.
- Blob backend auth/permission errors:
  - Missing `Storage Blob Data Contributor` on state storage account.
- Backend init errors with empty values:
  - Missing GitHub variables for state (`TFSTATE_*`).
