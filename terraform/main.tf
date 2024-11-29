resource "google_compute_instance" "default" {
  name         = "terraform-vm"
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
      // Include this section to give the VM an external IP address
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update && sudo apt-get install apache2 -y
    echo '<!doctype html><html><body><h1>Avenue Code is the leading software consulting agency focused on delivering end-to-end development solutions for digital transformation across every vertical. We pride ourselves on our technical acumen, our collaborative problem-solving ability, and the warm professionalism of our teams.!</h1></body></html>' | sudo tee /var/www/html/index.html

    # Create a new user and set the password
    sudo useradd -m -s /bin/bash myuser
    echo 'myuser:kkkranthi' | sudo chpasswd
    EOT

  tags = ["http-server"]
}

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

output "ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
