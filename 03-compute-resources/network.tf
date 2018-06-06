resource "google_compute_network" "kubernetes-the-soft-way" {
  name                    = "kubernetes-the-soft-way"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "kubernetes" {
  name          = "kubernetes"
  ip_cidr_range = "10.240.0.0/24"
  network       = "${google_compute_network.kubernetes-the-soft-way.self_link}"
  region        = "europe-west1"
}

# Create a firewall rule that allows internal communication across all protocols
resource "google_compute_firewall" "kubernetes-the-soft-way-allow-internal" {
  name    = "kubernetes-the-soft-way-allow-internal"
  network = "${google_compute_network.kubernetes-the-soft-way.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}

# Create a firewall rule that allows internal communication for calico
resource "google_compute_firewall" "kubernetes-the-soft-way-allow-calico" {
  name    = "kubernetes-the-soft-way-allow-calico"
  network = "${google_compute_network.kubernetes-the-soft-way.name}"

  allow {
    protocol = "ipip"
  }

  source_ranges = ["10.128.0.0/9"]
}

# Create a firewall rule that allows external SSH, ICMP, and HTTPS:
resource "google_compute_firewall" "kubernetes-the-soft-way-allow-external" {
  name    = "kubernetes-the-soft-way-allow-external"
  network = "${google_compute_network.kubernetes-the-soft-way.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [22, 6443]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Kubernetes Public IP Address
resource "google_compute_address" "kubernetes-the-soft-way" {
  name   = "kubernetes-the-soft-way"
  region = "europe-west1"
}
