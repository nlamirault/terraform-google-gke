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

resource "google_container_node_pool" "core" {
  provider = google-beta

  count = length(var.node_pools)

  name       = var.node_pools[count.index].name
  location   = var.location
  cluster    = google_container_cluster.cluster.name
  node_count = var.node_pools[count.index].node_count

  autoscaling {
    min_node_count = var.node_pools[count.index].min_node_count
    max_node_count = var.node_pools[count.index].max_node_count
  }

  management {
    auto_upgrade = var.auto_upgrade
    auto_repair  = var.auto_repair
  }

  max_pods_per_node = var.node_pools[count.index].max_pods_per_node

  node_config {
    image_type   = var.image_type
    machine_type = var.node_pools[count.index].machine_type
    disk_size_gb = var.node_pools[count.index].disk_size_gb
    preemptible  = var.node_pools[count.index].preemptible

    labels = var.node_labels
    tags   = var.node_tags

    workload_metadata_config {
      node_metadata = var.node_metadata
    }

    # metadata = (var.image_type == "UBUNTU" ? var.metadata_ubuntu : var.metadata_cos)

    # shielded_instance_config {
    #   enable_secure_boot          = var.shielded
    #   enable_integrity_monitoring = var.shielded
    # }

    service_account = var.node_pools[count.index].default_service_account ? "default" : google_service_account.cluster_service_account.email

    oauth_scopes = concat(local.oauth_scopes, var.oauth_scopes)

    dynamic "taint" {
      for_each = var.node_pools[count.index].taints
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
  }

  timeouts {
    create = local.node_pool_timeout_create
    update = local.node_pool_timeout_update
    delete = local.node_pool_timeout_delete
  }
}
