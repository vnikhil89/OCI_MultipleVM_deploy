resource "oci_core_virtual_network" "terraform-vcn" {
  cidr_block     = var.vcn_cidr
  dns_label      = var.vcn_dns_label
  compartment_id = var.compartment_ocid
  display_name   = "terraform-vcn"
}
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.vcn_dns_label}igw"
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
}
resource "oci_core_nat_gateway" "ngw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.vcn_dns_label}ngw"
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
}
# Public Route Table
resource "oci_core_route_table" "PublicRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
  display_name   = "${var.vcn_dns_label}pubrt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}
# Private Route Table
resource "oci_core_route_table" "PvtRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
  display_name   = "${var.vcn_dns_label}pvtrt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.ngw.id
  }
}

resource "oci_core_subnet" "public_subnet" {
  availability_domain = ""
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.terraform-vcn.id
  cidr_block          = var.public_cidr
  display_name        = var.public_subnet_dns_label
  #dns_label           = var.public_subnet_dns_label
  route_table_id      = oci_core_route_table.PublicRT.id
  security_list_ids   = [oci_core_security_list.public-securitylist.id]
}
resource "oci_core_subnet" "private-subnet" {
  availability_domain = ""
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.terraform-vcn.id
  cidr_block          = var.private_cidr
  display_name        = var.private_subnet_dns_label
  #dns_label           = var.private_subnet_dns_label
  route_table_id      = oci_core_route_table.PvtRT.id
  security_list_ids   = [oci_core_security_list.private-securitylist.id]
  prohibit_internet_ingress = true
  prohibit_public_ip_on_vnic = true
}
resource "oci_core_security_list" "public-securitylist" {
  display_name   = "SL_public"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.terraform-vcn.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }
}
resource "oci_core_security_list" "private-securitylist" {
  display_name   = "SL_private"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.terraform-vcn.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }
}  