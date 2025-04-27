variable "vnets" {}
variable "subnets" {}

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnets
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space

 dynamic "subnet" {
  for_each = var.subnets
  content {
    name             = subnet.value.name #subnet put as per syntax in doc
    address_prefixes = subnet.value.address_prefixes
  }
 }
}


