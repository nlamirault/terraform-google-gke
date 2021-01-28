# Copyright (C) 2020 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Pull information from current gcloud client config
data "google_client_config" "current" {}

resource "google_container_cluster" "cluster" {
  provider = google-beta

  name        = var.name
  description = format("%s GKE cluster", var.name)
  location    = var.location

  network    = var.network
  subnetwork = var.subnet_network

  # google groups for rbac
  # authenticator_groups_config {
  #   security_group = (var.rbac_group_domain != "" ? join(
  #   "@", ["gke-security-groups", var.rbac_group_domain]) : var.rbac_group_domain)
  # }

  release_channel {
    channel = var.release_channel
  }

  resource_labels = var.labels

  # GKE node pool
  initial_node_count       = 1
  remove_default_node_pool = true

  default_max_pods_per_node = var.default_max_pods_per_node

  ip_allocation_policy {
    cluster_secondary_range_name  = var.network_config["pods_cidr"]
    services_secondary_range_name = var.network_config["services_cidr"]
  }

  private_cluster_config {
    enable_private_endpoint = var.network_config["private_master"]
    enable_private_nodes    = var.network_config["private_nodes"]
    # master_ipv4_cidr_block  = var.network_config["private_nodes"] == true ? "10.30.64.0/28" : "" #var.network_config["master_cidr"] : ""
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  # enable_shielded_nodes = var.shielded_nodes

  cluster_autoscaling {
    enabled = var.auto_scaling
    dynamic "resource_limits" {
      for_each = local.autoscalling_resource_limits
      content {
        resource_type = lookup(resource_limits.value, "resource_type")
        minimum       = lookup(resource_limits.value, "minimum")
        maximum       = lookup(resource_limits.value, "maximum")
      }
    }
  }

  master_auth {
	    username = ""
	    password = ""
	}

  # Stackdriver
  logging_service    = var.logging_service ? "logging.googleapis.com/kubernetes" : "none"
  monitoring_service = var.monitoring_service ? "monitoring.googleapis.com/kubernetes" : "none"

  # NetworkPolicy
  network_policy {
    enabled  = var.network_policy
    provider = var.network_policy ? "CALICO" : "PROVIDER_UNSPECIFIED"
  }

  /* Set the dataplane */
  datapath_provider = var.datapath_provider

  /* enable PodSecurityPolicy */
  pod_security_policy_config {
    enabled = var.pod_security_policy
  }

  /* enable binauthz */
  enable_binary_authorization = var.binary_authorization

  /* workload identity */
  workload_identity_config {
    identity_namespace = join(".", [data.google_client_config.current.project, "svc.id.goog"])
  }

  addons_config {
    http_load_balancing {
      disabled = ! var.google_cloud_load_balancer
    }

    horizontal_pod_autoscaling {
      disabled = ! var.hpa
    }

    network_policy_config {
      disabled = ! var.network_policy
    }

    istio_config {
      disabled = ! var.istio
      auth     = var.istio ? "AUTH_MUTUAL_TLS" : "AUTH_NONE"
    }

    cloudrun_config {
      disabled = ! var.cloudrun
    }

    gce_persistent_disk_csi_driver_config {
      enabled = var.csi_driver
    }

    config_connector_config {
      enabled =  var.config_connector
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = local.cluster_timeout_create
    update = local.cluster_timeout_update
    delete = local.cluster_timeout_delete
  }
}
