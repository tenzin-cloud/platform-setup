terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }

  backend "s3" {
    bucket       = "tenzin-cloud"
    key          = "terraform/platform-setup/vm-deploy.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }

}

provider "libvirt" {
  uri = "qemu+ssh://${var.hypervisor_automation_user}@${var.hypervisor_hostname}/system?sshauth=privkey&no_verify=1"
}

resource "random_uuid" "instance" {}

resource "libvirt_pool" "datastore" {
  name = "datastore-${random_uuid.instance.id}"
  type = "dir"
  target {
    path = "/data/datastore-${random_uuid.instance.id}"
  }
}

resource "libvirt_pool" "cloud_images" {
  name = "cloud-images-${random_uuid.instance.id}"
  type = "dir"
  target {
    path = "/data/cloud-images-${random_uuid.instance.id}"
  }
}

resource "libvirt_volume" "ubuntu_cloud_image" {
  #source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  source = "noble-server-cloudimg-amd64.img"
  name   = "noble-server-cloudimg-amd64.img"
  pool   = libvirt_pool.cloud_images.name
  format = "qcow2"
}

module "virtual_machine" {

  count  = 1
  source = "./modules/virtual-machine"
  name   = "runner-1"

  automation_user        = var.vm_automation_user
  automation_user_pubkey = var.vm_automation_user_pubkey

  console_user     = var.vm_console_user
  console_password = var.vm_console_password

  # vm settings
  cpu_count       = 6
  memory_size_mib = 96 * 1024  // gib
  disk_size_mib   = 250 * 1024 // gib
  datastore_name  = libvirt_pool.datastore.name
  base_volume = {
    pool = libvirt_pool.cloud_images.name
    name = libvirt_volume.ubuntu_cloud_image.name
    id   = libvirt_volume.ubuntu_cloud_image.id
  }

  # gpu settings
  has_gpu_passthru = true
  gpu_pci_bus      = "01"

  launch_script = templatefile("${path.module}/templates/launch_script.sh", {})

}
