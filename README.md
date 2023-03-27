# terraform-bastionhost-gcp


Terraform Code for Creating a Bastion Host Instance and NGINX Instance
This Terraform codebase demonstrates how to create a Bastion host instance and an NGINX instance that connects to it. The Bastion host is a server that sits between your private network and the internet, providing a secure gateway for accessing your private instances.

The Bastion host allows you to access your private instances via SSH tunneling. You can set up SSH keys to authenticate with the Bastion host, and then use it to connect to your private instances.

Prerequisites
Before you begin, you'll need the following:

- A Google Cloud Platform account
- Terraform installed on your local machine
- Basic knowledge of Terraform and Google Cloud Platform


Usage

1. Clone this repository to your local machine: git clone https://github.com/username/repository-name.git
2. Navigate to the cloned repository directory: cd repository-name
3. Replace the values with the desired values for your setup in file variables.tf
4. Initialize the Terraform environment: terraform init
5. Plan the infrastructure: terraform plan
This command will show you the resources that will be created.
6. Apply the infrastructure: terraform apply
This command will create the Bastion host instance and the NGINX instance, and configure them to work together.

7. Once the infrastructure is created, you can use SSH to connect to the Bastion host and then to the NGINX instance. Here is an example command for connecting to the NGINX instance via the Bastion host: ssh -i path-to-ssh-key -J bastion-username@bastion-public-ip nginx-username@nginx-private-ip
  - Replace path-to-ssh-key, bastion-username, bastion-public-ip, nginx-username, and nginx-private-ip with the appropriate values for your setup.

8. To destroy the infrastructure, run: terraform destroy
This command will destroy all the resources created by Terraform.

Conclusion
This Terraform codebase demonstrates how to create a Bastion host instance and an NGINX instance that connects to it. The Bastion host provides a secure gateway for accessing your private instances, while the NGINX instance can be used to host a web server or reverse proxy. With this setup, you can securely access your private instances without exposing them to the internet.