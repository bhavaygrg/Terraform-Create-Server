```markdown
# Terraform AWS Infrastructure

This Terraform configuration deploys an AWS infrastructure that includes a VPC, internet gateway, routing table, subnet, security group, network interface, and an Elastic IP.

## Prerequisites

Before you can use this Terraform configuration, ensure you have the following prerequisites:

1. [Terraform](https://www.terraform.io/) installed on your local machine.
2. AWS account credentials with appropriate permissions to create the resources specified in the configuration.

## Usage

1. Clone this repository to your local machine:

   ```bash
   git clone <repository_url>
   cd terraform-aws-infrastructure
   ```

2. Initialize the Terraform configuration:

   ```bash
   terraform init
   ```

3. Modify the `main.tf` file with your desired settings. Ensure you provide valid AWS credentials in the `provider` block.

4. Optionally, you can modify the default CIDR blocks and other settings in the configuration to suit your requirements.

5. Plan the Terraform execution to preview the changes:

   ```bash
   terraform plan
   ```

6. Apply the changes to create the AWS infrastructure:

   ```bash
   terraform apply
   ```

7. After you are done with the resources, you can destroy them using:

   ```bash
   terraform destroy
   ```

## Configuration Details

### VPC

- The VPC is created with the CIDR block `10.0.0.0/16`.
- The VPC is tagged with `Name = production`.

### Internet Gateway

- An internet gateway is created and associated with the VPC.
- The internet gateway is tagged with `Name = main`.

### Routing Table

- A routing table is created and associated with the VPC.
- A default route is added to the routing table to enable internet access through the internet gateway.

### Subnet

- A subnet is created within the VPC with the CIDR block `10.0.1.0/24` in the `ap-south-1` availability zone.
- The subnet is tagged with `Name = prod-subnet`.

### Route Table Association

- The subnet is associated with the previously created routing table.

### Security Group

- A security group named `allow_web` is created to allow incoming traffic for SSH, HTTPS, and HTTP.
- The security group is associated with the VPC.
- Appropriate inbound and outbound rules are configured.

### Network Interface

- A network interface is created in the previously created subnet (`prod-subnet`) with a private IP address `10.0.0.50`.
- The network interface is attached to an EC2 instance (make sure to specify `aws_instance.test.id` before running the configuration).

### Elastic IP

- An Elastic IP is created and associated with the network interface.
- The Elastic IP is associated with the private IP `10.0.1.50`.

## Notes

- Make sure to review and modify the configuration according to your specific requirements before applying it.
- To apply the changes, use the `terraform apply` command. Before applying, always run `terraform plan` to preview the changes.
- Be cautious when destroying resources with `terraform destroy`, as it will delete all the resources created by this configuration.
- Remember to keep your AWS credentials secure and do not commit them to version control.

```

Please feel free to copy and use this `README.md` template for your Terraform AWS infrastructure configuration.
