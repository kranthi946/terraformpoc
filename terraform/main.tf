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

  // Add SSH key to VM metadata
  metadata = {
    ssh-keys = "your-username:${file("${path.module}/my_new_vm_key.pub")}"
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Avenue Code is the leading software consulting agency focused on delivering end-to-end development solutions for digital transformation across every vertical. We pride ourselves on our technical acumen, our collaborative problem-solving ability, and the warm professionalism of our teams.!</h1></body></html>' | sudo tee /var/www/html/index.html"

  tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
