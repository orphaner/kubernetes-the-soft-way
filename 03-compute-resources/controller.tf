// Create three compute instances which will host the Kubernetes control plane:
resource "google_compute_instance" "controller" {
  name         = "controller${count.index}"
  count        = "${var.controller_instance_count}"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"
  tags         = ["kubernetes-the-soft-way", "controller"]

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
      size  = 200
    }
  }

  network_interface {
    subnetwork    = "kubernetes"
    access_config = {}
  }

  can_ip_forward = true
}
