# OCI_MultipleVM_deploy
In this Repo we are going to deploy multiple VM's 
Here i have created two .tf files one for Network deployment and second one for  multiple VM deployment.
Network deployment includes VCN , Public & Private subnet creation , security lists , Internet Gateway and VPN gateway.

VM deployment includes VM details , for each loop to iterate from VM name set(Alpha,beta,delta and Gamma)  , subnet ID and attach Public IP  Network adaptor to VM's.

niks@niks-mac OCI_Multiple-linux_vm % terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/oci from the dependency lock file
- Using previously-installed hashicorp/oci v4.101.0

╷
│ Warning: Additional provider information from registry
│ 
│ The remote registry returned warnings for registry.terraform.io/hashicorp/oci:
│ - For users on Terraform 0.13 or greater, this provider has moved to oracle/oci. Please update your source in required_providers.
╵

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

niks@niks-mac OCI_Multiple-linux_vm % terraform plan
data.oci_identity_availability_domains.ads: Reading...
data.oci_core_images.compute_images: Reading...
data.oci_identity_availability_domains.ads: Read complete after 2s [id=IdentityAvailabilityDomainsDataSource-1748731426]
data.oci_core_images.compute_images: Read complete after 2s [id=CoreImagesDataSource-3008116136]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # oci_core_instance.web-01["alpha"] will be created
  + resource "oci_core_instance" "web-01" {
      + availability_domain                 = "GqIF:US-ASHBURN-AD-1"
      + boot_volume_id                      = (known after apply)
      + capacity_reservation_id             = (known after apply)
Plan: 13 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + Instance_Public_IP = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
  + Public_subnet      = [
      + "public-subnet",
    ]
    
  niks@niks-mac OCI_Multiple-linux_vm % terraform apply -auto-approve
  oci_core_instance.web-01["alpha"]: Still creating... [10s elapsed]
oci_core_instance.web-01["alpha"]: Still creating... [20s elapsed]
oci_core_instance.web-01["beta"]: Still creating... [20s elapsed]
oci_core_instance.web-01["delta"]: Still creating... [20s elapsed]
oci_core_instance.web-01["gamma"]: Still creating... [20s elapsed]
oci_core_instance.web-01["delta"]: Still creating... [30s elapsed]
oci_core_instance.web-01["beta"]: Still creating... [30s elapsed]
oci_core_instance.web-01["gamma"]: Still creating... [30s elapsed]
oci_core_instance.web-01["alpha"]: Still creating... [30s elapsed]
oci_core_instance.web-01["alpha"]: Still creating... [40s elapsed]
oci_core_instance.web-01["gamma"]: Still creating... [40s elapsed]
oci_core_instance.web-01["delta"]: Still creating... [40s elapsed]
oci_core_instance.web-01["beta"]: Still creating... [40s elapsed]
oci_core_instance.web-01["gamma"]: Creation complete after 41s [id=ocid1.instance.oc1.iad.anuwcljtwe6j4fqcsbyievbwhttt7y4w7zbn7inyjyoravy4ktlvq5s76kma]
oci_core_instance.web-01["alpha"]: Creation complete after 42s [id=ocid1.instance.oc1.iad.anuwcljtwe6j4fqc2dbxvqt2bkb5yy7meiv3vmr4xecfp5twn4hei2cqbeqq]
oci_core_instance.web-01["beta"]: Still creating... [50s elapsed]
oci_core_instance.web-01["delta"]: Still creating... [50s elapsed]
oci_core_instance.web-01["delta"]: Creation complete after 51s [id=ocid1.instance.oc1.iad.anuwcljtwe6j4fqczyfjgxfwaggy4tis2fwyahvjbs372rv5ticu2n2ozrvq]
oci_core_instance.web-01["beta"]: Creation complete after 52s [id=ocid1.instance.oc1.iad.anuwcljtwe6j4fqcx7xrq4zfqyvtwzrhajz4clkf4wwfy3fcs5bfuddy7l7q]

Apply complete! Resources: 13 added, 0 changed, 0 destroyed.
