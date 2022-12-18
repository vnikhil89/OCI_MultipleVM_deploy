output "Public_subnet" {
  value = [oci_core_subnet.public_subnet.display_name]
}
output "Instance_Public_IP"{
  value = [oci_core_instance.web-01["alpha"].public_ip,oci_core_instance.web-01["beta"].public_ip,oci_core_instance.web-01["delta"].public_ip,oci_core_instance.web-01["gamma"].public_ip]
}
