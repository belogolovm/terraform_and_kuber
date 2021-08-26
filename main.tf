terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.token
}

resource "yandex_compute_instance" "vm1" {
  name = "terraform1"
  hostname = "kmaster"
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
	  type = "network-hdd"
      size = 32
    }
  }

  network_interface {
    subnet_id = "e2ldg96s510gpg6pr1pr"
	nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("D:\\.ssh\\id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "default" {
  name = "terraform2"
  hostname = "kworker"
  zone = "ru-central1-b"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
	  type = "network-hdd"
      size = 32
    }
  }

  network_interface {
    subnet_id = "e2ldg96s510gpg6pr1pr"
	nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("D:\\.ssh\\id_rsa.pub")}"
  }
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm1.network_interface.0.ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.default.network_interface.0.ip_address
}


output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.default.network_interface.0.nat_ip_address
}

