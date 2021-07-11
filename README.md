# terraform-gcp-gke

Terraform module which configure a Kubernetes cluster on Google Cloud

## Usage

```hcl

module "kubernetes" {

  project  = var.project
  location = var.location

  network        = var.network
  subnet_network = var.subnet_network

  name                       = var.name
  release_channel            = var.release_channel
  network_config             = var.network_config
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  master_authorized_networks = var.master_authorized_networks

  maintenance_start_time = var.maintenance_start_time

  auto_scaling_max_cpu = var.auto_scaling_max_cpu
  auto_scaling_min_cpu = var.auto_scaling_min_cpu
  auto_scaling_max_mem = var.auto_scaling_max_mem
  auto_scaling_min_mem = var.auto_scaling_min_mem

  default_max_pods_per_node = var.default_max_pods_per_node
  max_pods_per_node         = var.max_pods_per_node

  labels = var.labels

  network_policy             = var.network_policy
  auto_scaling               = var.auto_scaling
  hpa                        = var.hpa
  pod_security_policy        = var.pod_security_policy
  monitoring_service         = var.monitoring_service
  logging_service            = var.logging_service
  binary_authorization       = var.binary_authorization
  google_cloud_load_balancer = var.google_cloud_load_balancer
  istio                      = var.istio
  cloudrun                   = var.cloudrun
  csi_driver                 = var.csi_driver

  node_pool_name          = var.node_pool_name
  default_service_account = var.default_service_account
  node_count              = var.node_count
  max_node_count          = var.max_node_count
  min_node_count          = var.min_node_count
  machine_type            = var.machine_type
  disk_size_gb            = var.disk_size_gb
  auto_upgrade            = var.auto_upgrade
  auto_repair             = var.auto_repair
  image_type              = var.image_type
  preemptible             = var.preemptible
  node_labels             = var.node_labels
  node_tags               = var.node_tags

  node_pools = var.node_pools
}
```

With variables :

```hcl
project = "foo"

location = "europe-west1"

#####################################################################""
# Kubernetes cluster

name = "mykube"

network        = "customer-prodnet"
subnet_network = "customer-prodsubnet-europe-west1"

release_channel = "REGULAR"

network_config = {
  enable_natgw   = true
  enable_ssh     = false
  private_master = false
  private_nodes  = true
  pods_cidr      = "customer-prodsubnet-gke-pods-europe-west1"
  services_cidr  = "customer-prodsubnet-gke-services-europe-west1"
}

master_authorized_networks = [
  {
    cidr_block   = "0.0.0.0/0"
    display_name = "internet"
  }
]

labels = {
  env      = "prod"
  service  = "kubernetes"
  made_by  = "terraform"
}

network_policy             = false
auto_scaling               = true
hpa                        = true
pod_security_policy        = false
monitoring_service         = true
logging_service            = true
binary_authorization       = false
google_cloud_load_balancer = true
istio                      = false
cloudrun                   = false
csi_driver                 = true

maintenance_start_time = "01:00"

default_max_pods_per_node = 110
max_pods_per_node = 110

#####################################################################""
# Kubernetes node pool

default_service_account = false

node_pool_name = "core"

node_count     = 1
min_node_count = 1
max_node_count = 2

machine_type = "n1-standard-4"
disk_size_gb = 100

auto_upgrade = true
auto_repair  = true

preemptible = false

node_labels = {
  env      = "prod"
  service  = "kubernetes"
  made_by  = "terraform"
}

node_tags = ["kubernetes", "nodes", "nat-europe-west1"]

```

## Documentation

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| google | >= 3.74.0 |
| google-beta | >= 3.74.0 |
| random | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.74.0 |
| google-beta | >= 3.74.0 |
| random | >= 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [google-beta_google_container_cluster](https://registry.terraform.io/providers/hashicorp/google-beta/3.74.0/docs/resources/google_container_cluster) |
| [google-beta_google_container_node_pool](https://registry.terraform.io/providers/hashicorp/google-beta/3.74.0/docs/resources/google_container_node_pool) |
| [google_client_config](https://registry.terraform.io/providers/hashicorp/google/3.74.0/docs/data-sources/client_config) |
| [google_project_iam_member](https://registry.terraform.io/providers/hashicorp/google/3.74.0/docs/resources/project_iam_member) |
| [google_service_account](https://registry.terraform.io/providers/hashicorp/google/3.74.0/docs/resources/service_account) |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/string) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_repair | Whether the nodes will be automatically repaired | `bool` | n/a | yes |
| auto\_scaling | Enable cluster autoscaling | `bool` | n/a | yes |
| auto\_scaling\_max\_cpu | Maximum amount of CPU in the cluster | `number` | `10` | no |
| auto\_scaling\_max\_mem | Maximum amount of Memory in the cluster. | `number` | `20` | no |
| auto\_scaling\_min\_cpu | Minimum amount of CPU in the cluster | `number` | `5` | no |
| auto\_scaling\_min\_mem | Minimum amount of Memory in the cluster | `number` | `5` | no |
| auto\_upgrade | Whether the nodes will be automatically upgraded | `bool` | n/a | yes |
| binary\_authorization | Enable Binary Authorization | `bool` | `true` | no |
| cloudrun | Enable Cloud Run on GKE (requires istio) | `bool` | n/a | yes |
| config\_connector | Enable the ConfigConnector addon | `bool` | n/a | yes |
| csi\_driver | Enable Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver | `bool` | n/a | yes |
| datapath\_provider | The desired datapath provider for this cluster | `string` | n/a | yes |
| default\_max\_pods\_per\_node | The default maximum number of pods per node in this cluster. | `number` | n/a | yes |
| dns\_cache | Enable the NodeLocal DNSCache addon | `bool` | n/a | yes |
| google\_cloud\_load\_balancer | Enable Google load balancer | `bool` | n/a | yes |
| hpa | Enable Horizontal Pod Autoscaling | `bool` | n/a | yes |
| image\_type | The image type to use for the node(s) | `string` | `"COS_CONTAINERD"` | no |
| istio | Enable Istio | `bool` | n/a | yes |
| labels | List of labels to apply to the cluster | `map(any)` | n/a | yes |
| location | The location of the cluster | `string` | n/a | yes |
| logging\_service | Enable logging Service | `bool` | `true` | no |
| maintenance\_end\_time | Time window specified for recurring maintenance operations in RFC3339 format | `string` | `"10:00"` | no |
| maintenance\_exclusions | List of maintenance exclusions. A cluster can have up to three | <pre>list(object({<br>    name       = string,<br>    start_time = string,<br>    end_time   = string<br>  }))</pre> | <pre>[<br>  {<br>    "end_time": "2021-05-21T00:00:00Z",<br>    "name": "Data Job",<br>    "start_time": "2021-05-21T00:00:00Z"<br>  },<br>  {<br>    "end_time": "2022-01-02T00:00:00Z",<br>    "name": "Happy new year",<br>    "start_time": "2022-01-01T00:00:00Z"<br>  }<br>]</pre> | no |
| maintenance\_recurrence | Frequency of the recurring maintenance window in RFC5545 format. | `string` | `"FREQ=DAILY"` | no |
| maintenance\_start\_time | Time window specified for daily or recurring maintenance operations in RFC3339 format | `string` | `"05:00"` | no |
| master\_authorized\_networks | List of master authorized networks | `list(object({ cidr_block = string, display_name = string }))` | n/a | yes |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation to use for the hosted master network | `string` | n/a | yes |
| monitoring\_service | Enable monitoring Service | `bool` | `true` | no |
| name | Cluster name | `string` | n/a | yes |
| network | Name of the network to use | `string` | n/a | yes |
| network\_config | VPC network configuration for the cluster | `map(any)` | n/a | yes |
| network\_policy | Enable Network Policy | `bool` | `true` | no |
| node\_labels | Map of labels apply to nodes | `map(any)` | n/a | yes |
| node\_metadata | How to expose the node metadata to the workload running on the node. | `string` | `"GKE_METADATA_SERVER"` | no |
| node\_pools | Addons node pools | <pre>list(object({<br>    name                    = string<br>    default_service_account = string<br>    node_count              = number<br>    autoscaling             = bool<br>    min_node_count          = number<br>    max_node_count          = number<br>    machine_type            = string<br>    disk_size_gb            = number<br>    max_pods_per_node       = number<br>    preemptible             = bool<br>    taints                  = list(map(string))<br>  }))</pre> | `[]` | no |
| node\_tags | List of labels apply to nodes | `list(string)` | n/a | yes |
| oauth\_scopes | Other oauth scopes to add to the node pools | `list(string)` | `[]` | no |
| pod\_security\_policy | Enable Pod Security Policy | `bool` | `true` | no |
| project | Project associated with the Service Account | `string` | n/a | yes |
| release\_channel | Release cadence of the GKE cluster | `string` | n/a | yes |
| sa\_roles | Role(s) to bind to the service account set into the cluster | `set(string)` | <pre>[<br>  "roles/logging.logWriter",<br>  "roles/monitoring.metricWriter",<br>  "roles/monitoring.viewer",<br>  "roles/stackdriver.resourceMetadata.writer",<br>  "roles/storage.objectViewer"<br>]</pre> | no |
| shielded\_nodes | Enable Shielded Nodes features on all nodes in this cluster | `bool` | `false` | no |
| subnet\_network | Name of the subnet to use | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_endpoint | The IP address of the cluster master. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
