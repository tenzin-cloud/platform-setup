# README
A workspace to deply my homelab virtual machines.

## Pre-requiste packages for Terraform execution host
```
# The packages needed by Terraform's libvirt provider to build a cloud-init ISO file and transform XML files
sudo apt-get update 
sudo apt-get install -y mkisofs xsltproc 

# Get the cloud image local to the Terraform runner host
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```
