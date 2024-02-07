terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

# resource "libvirt_pool" "manjaro" {
#   name = "manjaro"
#   type = "pool"
#   path = "/run/media/tuan/1948c593-e759-488b-bf8c-4d9459130b67/tuan/vm/"
# }


variable "vm_machines" {
  description = "Create machines with these names"
  type        = list(string)
  default     = ["worker01", "worker02"]
}

variable "disk_img" {
  default = "/home/tuan/Downloads/manjaro-xfce-23.1.3-240113-linux66.iso"
}
# We fetch the latest manjaro release image from their mirrors
resource "libvirt_volume" "manjaro-qcow2" {
  name   = "${var.vm_machines[count.index]}.qcow2"
  pool   = "default"
  source = var.disk_img
  format = "qcow2"
  count  = length(var.vm_machines)
}

resource "libvirt_volume" "test_manjaro" {
  name  = "test_${var.vm_machines[count.index]}.qcow2"
  size  = 10000000000
  count = length(var.vm_machines)
}

# data "template_file" "user_data" {
#   template = file("${path.module}/cloud_init.cfg")
# }

# data "template_file" "network_config" {
#   template = file("${path.module}/network_config.cfg")
# }

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
# resource "libvirt_cloudinit_disk" "commoninit" {
#   name           = "commoninit.iso"
#   user_data      = data.template_file.user_data.rendered
#   network_config = data.template_file.network_config.rendered
#   pool           = "pool"
# }

# Create the machine
resource "libvirt_domain" "domain-manjaro" {
  count   = length(var.vm_machines)
  name    = var.vm_machines[count.index]
  memory  = "2048"
  vcpu    = 2
  running = true
  #   cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name   = "default"
    hostname       = var.vm_machines[count.index]
    wait_for_lease = true
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.manjaro-qcow2[count.index].id
  }
  disk {
    volume_id = libvirt_volume.test_manjaro[count.index].id
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# output "disk_id" {
#   value = libvirt_volume.volume.*.id
# }

# output "network_id" {
#   value = libvirt_network.vm_network.id
# }

# output "ip_addresses" {
#   value = libvirt_domain.domain.*.network_interface.0.addresses
# }

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
