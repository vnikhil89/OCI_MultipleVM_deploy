provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}  


data "oci_core_images" "compute_images"{
    compartment_id = var.compartment_ocid
    operating_system = var.image_operating_system
    operating_system_version = var.image_operating_system_version
    shape = var.instance_shape
}
resource "oci_core_instance" "web-01" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  #display_name        = "Web-Server-01"
  for_each = toset(var.vmnames)
  display_name = each.value
  shape               = var.instance_shape

  create_vnic_details {
    #subnet_id = var.net_id
    subnet_id = oci_core_subnet.public_subnet.id
    #display_name = "Web-Server-01"
    display_name = each.value
  }
  source_details {
    source_type             = "image"
    source_id               = lookup(data.oci_core_images.compute_images.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }
   metadata = {
     ssh_authorized_keys = var.ssh_public_key
   }
}