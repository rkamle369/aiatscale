# Azure Network Design

## Hub Network

- VNet CIDR: `10.1.0.0/16`
- Subnets:
  - `AzureFirewallSubnet`: `10.1.1.0/24`
  - `AppGatewaySubnet`: `10.1.2.0/24`
  - `AzureBastionSubnet`: `10.1.3.0/24`

## Spoke Network

Requested subnet sizing in spoke:

- AKS: `/25`
- DB: `/26`
- Private Endpoints: `/26`
- Jump Server: `/26`

These do not all fit inside a single `/24` range. To keep the requested start (`10.10.1.0`) and sizes, the spoke VNet is set to `10.10.0.0/22`.

Subnets used:

- `snet-aks`: `10.10.1.0/25`
- `snet-db`: `10.10.1.128/26`
- `snet-private-endpoints`: `10.10.1.192/26`
- `snet-jump`: `10.10.2.0/26`
