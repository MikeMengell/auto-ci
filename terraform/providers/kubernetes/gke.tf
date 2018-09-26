resource "google_container_cluster" "cluster" {
  name               = "infra-pipeline-${random_integer.suffix.result}"
  zone               = "australia-southeast1-a"
  initial_node_count = 1
  project            = "${google_project.auto-ci.id}"

  additional_zones = [
    "australia-southeast1-b",
    "australia-southeast1-c",
  ]

  master_auth {
    username = "mr.yoda"
    password = "P@ssword1P@ssword1P@ssword1"
  }

  node_config {
    machine_type = "f1-micro"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      foo = "bar"
    }

    tags = ["foo", "bar"]
  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.cluster.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.cluster.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}"
}

output "cluster_name" {
  value = "${google_container_cluster.cluster.name}"
}