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
      // This section assigns an external IP address to the instance
    }
  }

 metadata = {
  ssh-keys = "rocky:${file("/home/kranthikumarkattatech/.ssh/my_new_vm_key.pub")}"
}

  // Startup script
  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Avenue Code is the leading software consulting agency focused on delivering end-to-end development solutions for digital transformation across every vertical. We pride ourselves on our technical acumen, our collaborative problem-solving ability, and the warm professionalism of our teams.!</h1></body></html>' | sudo tee /var/www/html/index.html"

  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["http-server"]
}
