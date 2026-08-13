[![ci](https://github.com/OKDP/helm-charts-miscellaneous/actions/workflows/ci.yml/badge.svg)](https://github.com/OKDP/helm-charts-miscellaneous/actions/workflows/ci.yml)
[![Kubernetes](https://img.shields.io/badge/kubernetes-1.28+-blue.svg)](https://kubernetes.io/)
[![Kind](https://img.shields.io/badge/kind-latest-orange.svg)](https://kind.sigs.k8s.io/)
[![License Apache2](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)
<a href="https://okdp.io">
  <img src="https://okdp.io/logos/okdp-notext.svg" height="20px" style="margin: 0 2px;" />
</a>

`helm-charts-utilities` contains standalone Helm charts used by OKDP for platform support, local development, bootstrap configuration, and small Kubernetes integration tasks.

## Charts

| Chart | Version | Description |
| --- | --- | --- |
| [`cert-issuers`](charts/cert-issuers) | `0.2.0` | cert-manager ClusterIssuers and Certificate bundles |
| [`cnpg-postgresql`](charts/cnpg-postgresql) | `0.1.0` | CloudNativePG PostgreSQL cluster, database, and credential resources |
| [`coredns-patch`](charts/coredns-patch) | `0.1.0` | CoreDNS configuration patch for local domain resolution |
| [`dns-server`](charts/dns-server) | `1.0.0` | Lightweight DNS server for local development |
| [`local-secrets-provider`](charts/local-secrets-provider) | `0.1.0` | Shared local testing secrets, configuration, services, and environment values |
| [`polaris-admin`](charts/polaris-admin) | `1.0.0` | Apache Polaris realm, principal, and role bootstrap jobs |
| [`seaweedfs-auth-config`](charts/seaweedfs-auth-config) | `1.1.0` | SeaweedFS Auth and IAM/STS configuration |
| [`seaweedfs-provisioning`](charts/seaweedfs-provisioning) | `1.0.0` | Seeds object prefixes inside existing SeaweedFS buckets |
| [`spark-defaults`](charts/spark-defaults) | `1.0.1` | Spark default properties ConfigMap |
| [`spark-rbac`](charts/spark-rbac) | `1.0.1` | ServiceAccount, Role, and RoleBinding resources for Spark on Kubernetes |

Each chart has its own `README.md`, `Chart.yaml`, `values.yaml`, and templates under `charts/<chart-name>/`.

## Install A Chart

Charts are published as OCI artifacts under the repository owner namespace:

```bash
helm pull oci://quay.io/okdp/charts/<chart-name> --version <version>
helm install <release-name> oci://quay.io/okdp/charts/<chart-name> --version <version>
```

For forks or organization copies, replace `okdp` with the lowercased GitHub repository owner.

You can also install directly from a local checkout:

```bash
helm install <release-name> charts/<chart-name> -f charts/<chart-name>/values.yaml
```

## Development

Run Helm lint for a single chart:

```bash
helm lint charts/<chart-name>
```

Run chart-testing for all charts:

```bash
ct lint --config .ct.yml --all --check-version-increment=false
```

Run install tests with chart-testing and a local Kubernetes cluster:

```bash
kind create cluster
ct install --config .ct.yml --namespace default
```

Generate chart documentation:

```bash
helm-docs -c .
```

## CI

The CI workflow:

- detects changed charts with chart-testing;
- lints charts with `ct lint`;
- tests chart installation on Kind with `ct install`;
- generates Helm README documentation with `helm-docs`;
- commits generated chart README changes when the workflow has write permission;
- packages every chart under `charts/`;
- pushes CI packages to `oci://ghcr.io/<owner>/charts`.

## Publishing

Publishing is done by `publish.yml`, which packages every chart under `charts/` and pushes release packages to `oci://quay.io/<owner>/charts`.

The publish workflow is triggered in two ways:

- `publish-on-merge` runs after a successful `ci` workflow on `main`;
- `release-please` runs after release PRs are merged and then triggers `publish.yml`.

Existing chart versions are skipped so unchanged charts do not fail the publish job.

The owner portion is derived from the GitHub repository owner in lowercase, so forks and organization copies publish under their own namespace.
