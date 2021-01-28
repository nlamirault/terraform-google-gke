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

locals {

  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]

  autoscalling_resource_limits = var.auto_scaling ? [{
    resource_type = "cpu"
    minimum       = var.auto_scaling_min_cpu
    maximum       = var.auto_scaling_max_cpu
    }, {
    resource_type = "memory"
    minimum       = var.auto_scaling_min_mem
    maximum       = var.auto_scaling_max_mem
  }] : []

  oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]

  node_pool_timeout_create = "60m"
  node_pool_timeout_update = "60m"
  node_pool_timeout_delete = "60m"

  cluster_timeout_create = "45m"
  cluster_timeout_update = "45m"
  cluster_timeout_delete = "45m"
}
