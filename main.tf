resource "google_compute_network" "vpc" {
  name                    = "${var.network}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "bastion_subnet" {
  name          = "${var.subnetwork}"
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = "${var.subnetwork_ip_range}"
  region        = "${var.region}"
}


resource "google_compute_firewall" "icmp" {
  name    = "${var.network}-firewall-icmp"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  target_tags   = ["${var.network}-firewall-icmp"]
  source_ranges = ["${google_compute_subnetwork.bastion_subnet.ip_cidr_range}"]
}

resource "google_compute_firewall" "bastion_allow_ssh" {
  name    = "${var.network}-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["${var.network}-allow-ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "nginx_allow_http" {
  name    = "${var.network}-allow-http"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["${var.network}-allow-http"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "bastion_ip" {
  name = "${var.instance_bastion_name}-ip"
}

resource "google_compute_address" "nginx_ip" {
  name = "${var.instance_name}-ip"
}

resource "google_compute_instance" "bastion_vm" {
  name         = "${var.instance_bastion_name}"
  machine_type = "${var.instance_machine_type}"
  zone         = "${var.zone}"

  tags = ["${var.network}-allow-ssh"]

  boot_disk {
    initialize_params {
      image = "${var.instance_image}"
    }
  }

  metadata = {
    ssh-keys  = "${var.ssh_user}:${file("${var.public_key_path}")}"
  }


  network_interface {
    network = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.bastion_subnet.self_link


  access_config {
      nat_ip = google_compute_address.bastion_ip.address
    }
  }

  provisioner "remote-exec" {
    inline = [
        "who",
        ]
    }

  connection {
        type = "ssh"
        host = "${google_compute_instance.bastion_vm.network_interface.0.access_config.0.nat_ip}"
        user = var.ssh_user
        private_key = file(var.private_key_path)
    }
}


resource "google_compute_firewall" "allow_internal_server" {
  name        = "${var.network}-internal-ssh"
  network     = google_compute_network.vpc.self_link



  source_ranges = ["${google_compute_subnetwork.bastion_subnet.ip_cidr_range}"]
  target_tags   = ["${var.network}-internal-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "nginx_vm" {
  name         = "${var.instance_name}"
  machine_type = "${var.instance_machine_type}"
  zone         = "${var.zone}"

  tags = ["${var.network}-internal-ssh", "${var.network}-allow-http"]

  boot_disk {
    initialize_params {
      image = "${var.instance_image}"
    }
  }

  network_interface {
    network = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.bastion_subnet.self_link

    access_config {
      nat_ip = google_compute_address.nginx_ip.address
    }
  }
  
  metadata = {
    ssh-keys  = "${var.ssh_user}:${file("${var.public_key_path}")}"
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt-get -y update",
        "sudo apt-get -y install nginx",
        "sudo service nginx start",
        "sudo systemctl enable nginx",
    ]
  }

  connection {
    host             = "${google_compute_instance.nginx_vm.network_interface.0.network_ip}"
    type             = "ssh"
    user             = var.ssh_user
    private_key      = file(var.private_key_path)
    bastion_host     = "${google_compute_instance.bastion_vm.network_interface.0.access_config.0.nat_ip}"
    bastion_private_key = file(var.private_key_path)

  }
}

