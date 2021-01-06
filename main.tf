// Configure the Google Cloud provider
provider "google" {
    credentials = file(var.creds_path)
    project     = var.project
    region      = var.region
}

resource "random_id" "instance_id" {
    byte_length = 8
}

// Bucket
resource "google_storage_bucket" "bucket" {
  name = var.bucket_name
  force_destroy = true
}

// VM mounting GCS
resource "google_compute_instance" "vm" {
    name         = "vm-${random_id.instance_id.hex}"
    machine_type = var.size
    zone         = var.zone_ase

    boot_disk {
        initialize_params {
            image = var.image
        }
    }

    metadata_startup_script = "${file("init.sh")}"

    metadata = {
        ssh-keys = "chris:${file("~/.ssh/id_rsa.pub")}"
    }

    network_interface {
        network = var.net

        access_config {}
    }

    depends_on = [google_storage_bucket.bucket]
}

// External IP outputs
output "vm-ip" {
    value = google_compute_instance.vm.network_interface.0.access_config.0.nat_ip
}