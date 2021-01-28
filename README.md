# terraform-gcp-gke

Terraform module which configure a Kubernetes cluster on Google Cloud

## Versions

Use Terraform `0.13+` and Terraform Provider Google `3.5+` and Google Beta `3.5+`.

These types of resources are supported:

* [google_container_cluster](https://www.terraform.io/docs/providers/google/r/container_cluster.html)
* [google_container_node_pool](https://www.terraform.io/docs/providers/google/r/container_node_pool.html)

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

This module creates :

* a Kubernetes cluster
* a service account
* node pool(s)

## Documentation

### Providers

| Name | Version |
|------|---------|
| google | >= 3.41.0 |
| google-beta | >= 3.41.0 |
| random | n/a |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| auto\_repair | Whether the nodes will be automatically repaired | `bool` | n/a | yes |
| auto\_scaling | Enable cluster autoscaling | `bool` | n/a | yes |
| auto\_scaling\_max\_cpu | n/a | `number` | `10` | no |
| auto\_scaling\_max\_mem | n/a | `number` | `20` | no |
| auto\_scaling\_min\_cpu | n/a | `number` | `5` | no |
| auto\_scaling\_min\_mem | n/a | `number` | `5` | no |
| auto\_upgrade | Whether the nodes will be automatically upgraded | `bool` | n/a | yes |
| binary\_authorization | Enable Binary Authorization | `bool` | `true` | no |
| cloudrun | Enable Cloud Run on GKE (requires istio) | `bool` | n/a | yes |
| config\_connector | Enable the ConfigConnector addon | `bool` | n/a | yes |
| csi\_driver | Enable Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver | `bool` | n/a | yes |
| datapath\_provider | The desired datapath provider for this cluster | `string` | n/a | yes |
| default\_max\_pods\_per\_node | The default maximum number of pods per node in this cluster. | `number` | n/a | yes |
| google\_cloud\_load\_balancer | Enable Google load balancer | `bool` | n/a | yes |
| hpa | Enable Horizontal Pod Autoscaling | `bool` | n/a | yes |
| image\_type | n/a | `string` | `"COS"` | no |
| istio | Enable Istio | `bool` | n/a | yes |
| labels | List of Kubernetes labels to apply to the nodes | `map` | n/a | yes |
| location | The location of the cluster | `string` | n/a | yes |
| logging\_service | Enable logging Service | `bool` | `true` | no |
| maintenance\_start\_time | n/a | `string` | `"03:00"` | no |
| master\_authorized\_networks | List of master authorized networks | `list(object({ cidr_block = string, display_name = string }))` | n/a | yes |
| master\_ipv4\_cidr\_block | n/a | `string` | n/a | yes |
| monitoring\_service | Enable monitoring Service | `bool` | `true` | no |
| name | Cluster name | `string` | n/a | yes |
| network | Name of the network to use | `string` | n/a | yes |
| network\_config | VPC network configuration for the cluster | `map` | n/a | yes |
| network\_policy | Enable Network Policy | `bool` | `true` | no |
| node\_labels | n/a | `map` | n/a | yes |
| node\_metadata | How to expose the node metadata to the workload running on the node. | `string` | `"GKE_METADATA_SERVER"` | no |
| node\_pools | Addons node pools | <pre>list(object({<br>    name                    = string<br>    default_service_account = string<br>    node_count              = number<br>    min_node_count          = number<br>    max_node_count          = number<br>    machine_type            = string<br>    disk_size_gb            = number<br>    max_pods_per_node       = number<br>    preemptible             = bool<br>  }))</pre> | `[]` | no |
| node\_tags | n/a | `list(string)` | n/a | yes |
| oauth\_scopes | Other oauth scopes to add to the node pools | `list(string)` | `[]` | no |
| pod\_security\_policy | Enable Pod Security Policy | `bool` | `true` | no |
| project | Project associated with the Service Account | `string` | n/a | yes |
| rbac\_group\_domain | Google Groups for RBAC requires a G Suite domain | `string` | `"skale-5.com"` | no |
| release\_channel | Release cadence of the GKE cluster | `string` | n/a | yes |
| sa\_roles | Role(s) to bind to the service account set into the cluster | `set(string)` | <pre>[<br>  "roles/logging.logWriter",<br>  "roles/monitoring.metricWriter",<br>  "roles/monitoring.viewer",<br>  "roles/stackdriver.resourceMetadata.writer",<br>  "roles/storage.objectViewer"<br>]</pre> | no |
| subnet\_network | Name of the subnet to use | `string` | n/a | yes |
| tags | The list of instance tags applied to all nodes. | `list` | `[]` | no |

### Outputs

| Name | Description |
|------|-------------|
| cluster\_endpoint | The IP address of the cluster master. |

