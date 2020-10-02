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

resource "random_string" "cluster_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_service_account" "cluster_service_account" {
  project      = var.project
  account_id   = format("kubernetes-%s", random_string.cluster_service_account_suffix.result)
  display_name = "Terraform-managed service account for GKE"
}

resource "google_project_iam_member" "cluster_service_account-log_writer" {
  for_each = var.sa_roles
  project  = var.project
  role     = each.value
  member   = format("serviceAccount:%s", google_service_account.cluster_service_account.email)
}
