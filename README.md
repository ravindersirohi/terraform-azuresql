# Terraform-azuresql
Terraform template for azure SQL server with auditing configuraiton.

# Version
version = "=2.15.0"

# Configuration (terraform.tfvars)
Add terraform.tfvars file and update below configurations
subscriptionId   = "<Your Subscription Id>"
tenantId         = "<Your Tenant Id>"
clientId         = "<Service Principal Client Id>"
clientSecret     = "<Service Principal Secret>"

# App Service
region="uksouth"
env = "test"
prefix = "SQL"
