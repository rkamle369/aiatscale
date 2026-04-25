# AKS -> Key Vault (Workload Identity)

If you see this error:

- `AADSTS70025 ... azurekeyvaultsecretsprovider-<cluster> has no configured federated identity credentials`

it means the pod is asking a token for the wrong client ID (the AKS add-on identity), not your configured UAMI.

## Correct identity to use

This stack creates a dedicated UAMI for Key Vault workload identity:

- tfvars key: `aks_keyvault_uami_name`
- Terraform output: `key_vault_workload_identity_client_id`

Use that **client ID** in both:

1. ServiceAccount annotation
2. SecretProviderClass `clientID`

## Multiple namespaces

Federated credentials are **one per Kubernetes service account subject**. Configure them in tfvars:

- `aks_keyvault_workload_identity_bindings` — list of `{ namespace, service_account }`.

Add a row for each namespace + SA pair that should call Key Vault with this UAMI. Example:

```hcl
aks_keyvault_workload_identity_bindings = [
  { namespace = "istio-system", service_account = "istio-keyvault-sa" },
  { namespace = "argocd", service_account = "keyvault-sa" },
]
```

Each entry becomes subject:

- `system:serviceaccount:<namespace>:<service_account>`

## ServiceAccount example (per namespace)

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: keyvault-sa
  namespace: argocd
  annotations:
    azure.workload.identity/client-id: "<key_vault_workload_identity_client_id>"
```

## SecretProviderClass example

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: kv-spc
  namespace: argocd
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "false"
    clientID: "<key_vault_workload_identity_client_id>"
    keyvaultName: "kv-dev-apps-uaen"
    tenantId: "<tenant-id>"
    objects: |
      array:
        - |
          objectName: postgres-admin-password
          objectType: secret
```

## Pod requirement

Pods must set `serviceAccountName` to the SA that matches a binding row.

## Notes

- Do **not** use the add-on identity client ID (`azurekeyvaultsecretsprovider-...`) for workload identity unless you also create federated credentials on that exact identity.
- After role assignment or FIC changes, allow a few minutes for propagation.
