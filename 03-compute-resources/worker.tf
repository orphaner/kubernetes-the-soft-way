// Create three compute instances which will host the Kubernetes control plane:
resource "google_compute_disk" "gluster_disk" {
  name  = "gluster-disk-${count.index}"
  count = "${var.worker_instance_count}"
  type  = "pd-standard"
  zone  = "${var.zone}"
  size  = 300

}

resource "google_compute_instance" "worker" {
  name         = "worker${count.index}"
  count        = "${var.worker_instance_count}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["kubernetes-the-soft-way", "worker"]

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
      size  = 50
    }
  }

  attached_disk {
    source = "gluster-disk-${count.index}"
  }

  network_interface {
    subnetwork    = "kubernetes"
    access_config = {}
  }

  can_ip_forward = true

  metadata {
    pod-cidr = "10.200.${count.index}.0/24"
  }
}
