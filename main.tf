data "ibm_resource_group" "vpc_resource_group" {
    name = var.vpc_resource_group
}

locals {
#    ocp_01_name = "${var.environment}-cpd-01"
    ocp_01_name = var.cluster_name
    zone1       = "${var.region}-1"
    zone2       = "${var.region}-2"
    zone3       = "${var.region}-3"
}


##############################################################################
# Create VPC
##############################################################################
resource "ibm_is_vpc" "vpc1" {
    name                      = var.vpc_name
    resource_group            = data.ibm_resource_group.vpc_resource_group.id
    address_prefix_management = "manual"
    tags                      = [var.environment, "Schematics: ${var.schematics_workspace_name}"]

}

##############################################################################
# Create Rule in default security group to allow IKS Management traffic
#
# Note: this rule will deny all incoming traffic to the worker nodes but 
#       the cluster will be provisioned with its own security group that
#       will allow that traffic.
#
##############################################################################
resource "ibm_is_security_group_rule" "vpc_default_security_group_rule_iks_management" {
    group     = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    tcp {
        port_min = 30000
        port_max = 32767
    }

    depends_on = [ibm_is_vpc.vpc1]
 }

##############################################################################
# Create Address Prefixes
##############################################################################
resource "ibm_is_vpc_address_prefix" "address_prefix1" {
    name = "prefix1"
    zone = "${var.region}-1"
    vpc  = ibm_is_vpc.vpc1.id
    cidr = var.address_prefix_1

    depends_on = [ibm_is_vpc.vpc1]

}

resource "ibm_is_vpc_address_prefix" "address_prefix2" {
    name = "prefix2"
    zone = "${var.region}-2"
    vpc  = ibm_is_vpc.vpc1.id
    cidr = var.address_prefix_2

    depends_on = [ibm_is_vpc.vpc1]

}

resource "ibm_is_vpc_address_prefix" "address_prefix3" {
    name = "prefix3"
    zone = "${var.region}-3"
    vpc  = ibm_is_vpc.vpc1.id
    cidr = var.address_prefix_3

    depends_on = [ibm_is_vpc.vpc1]

}

##############################################################################
# Create Public Gateways
##############################################################################
resource "ibm_is_public_gateway" "zone1_gateway" {
    name           = "${var.vpc_name}-zone1-gateway"
    resource_group = data.ibm_resource_group.vpc_resource_group.id
    vpc            = ibm_is_vpc.vpc1.id
    zone           = "${var.region}-1"

}

resource "ibm_is_public_gateway" "zone2_gateway" {
    name           = "${var.vpc_name}-zone2-gateway"
    resource_group = data.ibm_resource_group.vpc_resource_group.id
    vpc            = ibm_is_vpc.vpc1.id
    zone           = "${var.region}-2"

}

resource "ibm_is_public_gateway" "zone3_gateway" {
    name           = "${var.vpc_name}-zone3-gateway"
    resource_group = data.ibm_resource_group.vpc_resource_group.id
    vpc            = ibm_is_vpc.vpc1.id
    zone           = "${var.region}-3"

}


##############################################################################
# Create application Subnets
##############################################################################
resource "ibm_is_subnet" "app_subnet1" {
    name            = "${var.vpc_name}-app-subnet1"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-1"
    ipv4_cidr_block = var.app_cidr_block_1
    public_gateway  = ibm_is_public_gateway.zone1_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix1]

}

resource "ibm_is_subnet" "app_subnet2" {
    name            = "${var.vpc_name}-app-subnet2"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-2"
    ipv4_cidr_block = var.app_cidr_block_2
    public_gateway  = ibm_is_public_gateway.zone2_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix2]

}

resource "ibm_is_subnet" "app_subnet3" {
    name            = "${var.vpc_name}-app-subnet3"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-3"
    ipv4_cidr_block = var.app_cidr_block_3
    public_gateway  = ibm_is_public_gateway.zone3_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix3]

}

/*
##############################################################################
# Create infrastructure Subnets
##############################################################################
resource "ibm_is_subnet" "infra_subnet1" {
    name            = "${var.vpc_name}-infra-subnet1"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-1"
    ipv4_cidr_block = var.infra_cidr_block_1
    public_gateway  = ibm_is_public_gateway.zone1_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix1]

}

resource "ibm_is_subnet" "infra_subnet2" {
    name            = "${var.vpc_name}-infra-subnet2"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-2"
    ipv4_cidr_block = var.infra_cidr_block_2
    public_gateway  = ibm_is_public_gateway.zone2_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix2]

}

resource "ibm_is_subnet" "infra_subnet3" {
    name            = "${var.vpc_name}-infra-subnet3"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-3"
    ipv4_cidr_block = var.infra_cidr_block_3
    public_gateway  = ibm_is_public_gateway.zone3_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix3]

}
*/
##############################################################################
# Create storage Subnets
##############################################################################
resource "ibm_is_subnet" "storage_subnet1" {
    name            = "${var.vpc_name}-storage-subnet1"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-1"
    ipv4_cidr_block = var.storage_cidr_block_1
    public_gateway  = ibm_is_public_gateway.zone1_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix1]

}

resource "ibm_is_subnet" "storage_subnet2" {
    name            = "${var.vpc_name}-storage-subnet2"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-2"
    ipv4_cidr_block = var.storage_cidr_block_2
    public_gateway  = ibm_is_public_gateway.zone2_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix2]

}

resource "ibm_is_subnet" "storage_subnet3" {
    name            = "${var.vpc_name}-storage-subnet3"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-3"
    ipv4_cidr_block = var.storage_cidr_block_3
    public_gateway  = ibm_is_public_gateway.zone3_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix3]

}
/*
##############################################################################
# Create cloud pak Subnets
##############################################################################
resource "ibm_is_subnet" "cp_subnet1" {
    name            = "${var.vpc_name}-cp-subnet1"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-1"
    ipv4_cidr_block = var.cp_cidr_block_1
    public_gateway  = ibm_is_public_gateway.zone1_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix1]

}

resource "ibm_is_subnet" "cp_subnet2" {
    name            = "${var.vpc_name}-cp-subnet2"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-2"
    ipv4_cidr_block = var.cp_cidr_block_2
    public_gateway  = ibm_is_public_gateway.zone2_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix2]

}

resource "ibm_is_subnet" "cp_subnet3" {
    name            = "${var.vpc_name}-cp-subnet3"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-3"
    ipv4_cidr_block = var.cp_cidr_block_3
    public_gateway  = ibm_is_public_gateway.zone3_gateway.id
    depends_on = [ibm_is_vpc_address_prefix.address_prefix3]

}
*/
##############################################################################
# Create VPN Subnet
##############################################################################
resource "ibm_is_subnet" "vpn_subnet1" {
    name            = "${var.vpc_name}-vpn-subnet1"
    resource_group  = data.ibm_resource_group.vpc_resource_group.id
    vpc             = ibm_is_vpc.vpc1.id
    zone            = "${var.region}-1"
    ipv4_cidr_block = var.vpn_cidr_block_1

    depends_on = [ibm_is_vpc_address_prefix.address_prefix1]

}


##############################################################################
# Create VPN Gateway
##############################################################################
resource "ibm_is_vpn_gateway" "vpn_gateway1" {
  name            = "${var.vpc_name}-vpn-gateway1"
  resource_group  = data.ibm_resource_group.vpc_resource_group.id
  subnet          = ibm_is_subnet.vpn_subnet1.id
  mode            = "route"
}

##############################################################################
# Create VPN Gateway Connection
##############################################################################


/*
##############################################################################
# Create instance of Key Protect for use with the cluster
##############################################################################
resource "ibm_resource_instance" "key_protect" {
  name              = "${local.ocp_01_name}-keys"
  service           = "kms"
  plan              = "tiered-pricing"
  location          = "us-south"
  resource_group_id = data.ibm_resource_group.vpc_resource_group.id
  tags              = [var.environment, "Schematics: ${var.schematics_workspace_name}"]

  //User can increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################
# Create instance of COS - used for the OpenShift Registry in the cluster
##############################################################################
resource "ibm_resource_instance" "cos_instance" {
  name              = "${local.ocp_01_name}-registry"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = data.ibm_resource_group.vpc_resource_group.id
  tags              = [var.environment, "Schematics: ${var.schematics_workspace_name}"]

  //User can increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################
# Create OCP cluster and dependent resources
##############################################################################


##############################################################################
# Create a customer root key
##############################################################################
resource "ibm_kp_key" "ocp_01_kp_key" {
    key_protect_id = ibm_resource_instance.key_protect.guid
    key_name       = "kube-${local.ocp_01_name}-crk"
    standard_key   = false

    depends_on = [
      ibm_resource_instance.key_protect
    ]
}
*/

##############################################################################
# Create OCP Cluster
##############################################################################
resource "ibm_container_vpc_cluster" "app_ocp_cluster_01" {
    name                            = local.ocp_01_name
    vpc_id                          = ibm_is_vpc.vpc1.id
    flavor                          = var.default_pool_flavor
    kube_version                    = var.ocp_version
    worker_count                    = var.default_pool_worker_count 
    entitlement                     = "cloud_pak"
    wait_till                       = "MasterNodeReady"
    disable_public_service_endpoint = false
    cos_instance_crn                = ibm_resource_instance.cos_instance.id
    resource_group_id               = data.ibm_resource_group.vpc_resource_group.id
    tags                            = ["env:${var.environment}","vpc:${var.vpc_name}","schematics:${var.schematics_workspace_id}"]
    zones {
        subnet_id = ibm_is_subnet.app_subnet1.id
        name      = local.zone1
    }
    zones {
        subnet_id = ibm_is_subnet.app_subnet2.id
        name      = local.zone2
    }
    zones {
        subnet_id = ibm_is_subnet.app_subnet3.id
        name      = local.zone3
    }

    kms_config {
        instance_id = ibm_resource_instance.key_protect.guid
        crk_id = ibm_kp_key.ocp_01_kp_key.key_id
        private_endpoint = true
    }

    depends_on = [
      ibm_kp_key.ocp_01_kp_key,
      ibm_resource_instance.cos_instance
      ]


}
/*

##############################################################################
# Create Worker Pool for infrastructure  
##############################################################################
resource "ibm_container_vpc_worker_pool" "infra_pool" {
    cluster           = ibm_container_vpc_cluster.app_ocp_cluster_01.name
    worker_pool_name  = "infrastructure"
    flavor            = var.infrastructure_pool_flavor
    vpc_id            = ibm_is_vpc.vpc1.id
    worker_count      = 1
    resource_group_id = data.ibm_resource_group.vpc_resource_group.id

    labels = {
      "node-role.kubernetes.io/infra" = ""
    }

    zones {
        subnet_id = ibm_is_subnet.infra_subnet1.id
        name      = local.zone1
    }
    zones {
        subnet_id = ibm_is_subnet.infra_subnet2.id
        name      = local.zone2
    }
    zones {
        subnet_id = ibm_is_subnet.infra_subnet3.id
        name      = local.zone3
    }

    taints {
      key = "node-role.kubernetes.io/infra"
      value = "true"
      effect = "NoSchedule"
    }

    timeouts {
        create = "60m"
        delete = "30m"
    }

    depends_on = [ibm_container_vpc_cluster.app_ocp_cluster_01]
}

##############################################################################
# Create Worker Pool for storage such as Openshift Container Storage (SDS) 
#
# Note: If you replace the workers the labels and taints might not persist
##############################################################################
resource "ibm_container_vpc_worker_pool" "storage_pool" {
    cluster           = ibm_container_vpc_cluster.app_ocp_cluster_01.name
    worker_pool_name  = "storage"
    flavor            = var.storage_pool_flavor
    vpc_id            = ibm_is_vpc.vpc1.id
    worker_count      = var.storage_pool_worker_count
    resource_group_id = data.ibm_resource_group.vpc_resource_group.id

#   This does not seem to work with the IBM terraform provider
    labels = {
      "cluster.ocs.openshift.io/openshift-storage" = ""
    }

    zones {
        subnet_id = ibm_is_subnet.storage_subnet1.id
        name      = local.zone1
    }
    zones {
        subnet_id = ibm_is_subnet.storage_subnet2.id
        name      = local.zone2
    }
    zones {
        subnet_id = ibm_is_subnet.storage_subnet3.id
        name      = local.zone3
    }

    taints {
      key = "node.ocs.openshift.io/storage"
      value = "true"
      effect = "NoSchedule"
    }

    timeouts {
        create = "60m"
        delete = "30m"
    }

    depends_on = [ibm_container_vpc_cluster.app_ocp_cluster_01]
}

##############################################################################
# Create Worker Pool for cloud pak  
#
# Note: Cloud Pak for Data does NOT support node-role label and taint
##############################################################################
resource "ibm_container_vpc_worker_pool" "cloud_pak_pool" {
    cluster           = ibm_container_vpc_cluster.app_ocp_cluster_01.name
    worker_pool_name  = "cloud-pak"
    flavor            = var.cloud_pak_pool_flavor
    vpc_id            = ibm_is_vpc.vpc1.id
    worker_count      = 1
    resource_group_id = data.ibm_resource_group.vpc_resource_group.id

    labels = {
      "node-role.kubernetes.io/cloud-paks" = true
    }

    zones {
        subnet_id = ibm_is_subnet.cp_subnet1.id
        name      = local.zone1
    }
    zones {
        subnet_id = ibm_is_subnet.cp_subnet2.id
        name      = local.zone2
    }
    zones {
        subnet_id = ibm_is_subnet.cp_subnet3.id
        name      = local.zone3
    }

    taints {
      key = "node-role.kubernetes.io/cloud-paks"
      value = "true"
      effect = "NoSchedule"
    }

    timeouts {
        create = "60m"
        delete = "30m"
    }

    depends_on = [ibm_container_vpc_cluster.app_ocp_cluster_01]
}
*/
