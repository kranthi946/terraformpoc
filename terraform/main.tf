provider "google" {
  project = "ma-cicd"
  region  = "us-west1"
}

# Generate a random ID suffix to ensure unique VM names
resource "random_id" "vm_suffix" {
  byte_length = 4
}

# Google Compute Instance with dynamic name
resource "google_compute_instance" "default" {
  name         = "terraform-vm-${random_id.vm_suffix.hex}"  # Unique name using random suffix
  machine_type = "e2-small"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Allocate a public IP for the instance
    }
  }

  metadata_startup_script = <<-EOT
    sudo apt-get update && sudo apt-get install apache2 -y
    echo '<!doctype html><html><body><h1>Avenue Code is the leading software consulting agency focused on delivering end-to-end development solutions for digital transformation across every vertical. We pride ourselves on our technical acumen, our collaborative problem-solving ability, and the warm professionalism of our teams.!</h1></body></html>' \
    | sudo tee /var/www/html/index.html
  EOT

  tags = ["http-server"]
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Output the external IP address of the VM
output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
