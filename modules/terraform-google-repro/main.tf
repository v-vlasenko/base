variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

resource "google_compute_network" "repro" {
  name                    = "repro-network"
  project                 = var.project_id
  auto_create_subnetworks = false
}

output "network_id" {
  description = "The ID of the created network"
  value       = google_compute_network.repro.id
}
