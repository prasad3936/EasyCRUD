terraform {
    required_version = ">= 1.0.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "~> 2.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

variable "aws_region" {
    type    = string
    default = "us-west-2"
}

variable "cluster_name" {
    type    = string
    default = "example-eks-cluster"
}

variable "cluster_version" {
    type    = string
    default = "1.28"
}

variable "node_group_name" {
    type    = string
    default = "example-ng"
}

variable "node_instance_type" {
    type    = string
    default = "t3.medium"
}

variable "node_desired_capacity" {
    type    = number
    default = 2
}

variable "ebs_size_gb" {
    type    = number
    default = 20
}

# Create an EKS cluster with a managed node group using the community module.
module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"

    cluster_name    = var.cluster_name
    cluster_version = var.cluster_version

    # Let the module create a new VPC
    vpc_id     = null
    create_vpc = true

    # Node group(s)
    node_groups = {
        default = {
            desired_capacity = var.node_desired_capacity
            max_capacity     = var.node_desired_capacity + 1
            min_capacity     = 1

            instance_types = [var.node_instance_type]

            # do not manage key pair here; use SSH or AWS Systems Manager if needed
            additional_tags = {
                Name = "${var.cluster_name}-node"
            }
        }
    }

    tags = {
        Environment = "dev"
        Terraform   = "true"
    }
}

# Get one of the private subnet IDs created by the module and its AZ
data "aws_subnet" "first_private" {
    id = module.eks.private_subnets[0]
}

# Create an EBS volume in the same AZ as one of the node subnets
resource "aws_ebs_volume" "data" {
    availability_zone = data.aws_subnet.first_private.availability_zone
    size              = var.ebs_size_gb
    type              = "gp3"

    tags = {
        Name = "${var.cluster_name}-pv-volume"
    }
}

# Read EKS cluster info for Kubernetes provider configuration
data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}

# Configure Kubernetes provider to create a PersistentVolume backed by the EBS volume
provider "kubernetes" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
}

# Create a Kubernetes PersistentVolume that uses the created EBS volume
resource "kubernetes_persistent_volume" "ebs_pv" {
    metadata {
        name = "${var.cluster_name}-ebs-pv"
        labels = {
            type = "ebs"
        }
    }

    spec {
        capacity = {
            storage = "${var.ebs_size_gb}Gi"
        }

        access_modes = ["ReadWriteOnce"]

        persistent_volume_reclaim_policy = "Retain"

        aws_elastic_block_store {
            volume_id = aws_ebs_volume.data.id
            fs_type   = "ext4"
        }
    }
}

output "cluster_name" {
    value = module.eks.cluster_id
}

output "kubeconfig" {
    description = "Kubeconfig content (base64 CA removed); use with kubectl after writing to a file or use the aws eks get-token approach."
    value       = module.eks.kubeconfig
    sensitive   = true
}

output "ebs_volume_id" {
    value = aws_ebs_volume.data.id
}

output "pv_name" {
    value = kubernetes_persistent_volume.ebs_pv.metadata[0].name
}