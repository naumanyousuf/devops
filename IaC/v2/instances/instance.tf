### 1nd VM Instance ayaan-instance-1
resource "google_compute_instance" "ayaan-instance-1" {
  name         = "ayaan-instance-1"
  machine_type = "n1-standard-2"
  zone         = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = var.main-vpc
    subnetwork = var.subnet-01
  }
}


### 2nd VM Instance ayaan-instance-2
resource "google_compute_instance" "ayaan-instance-2" {
  name         = "ayaan-instance-2"
  machine_type = "n1-standard-2"
  zone         = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = var.main-vpc
    subnetwork = var.subnet-02
  }
}