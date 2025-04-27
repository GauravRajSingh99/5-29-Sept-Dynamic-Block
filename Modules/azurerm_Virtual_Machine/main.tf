###########datablock for subnet
data "azurerm_subnet" "subnets" {
  for_each             = var.vms_map
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

#############nic
resource "azurerm_network_interface" "nic" {
  for_each            = var.vms_map
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "nic_ip1"
    subnet_id                     = data.azurerm_subnet.subnets[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

############Virtualmachine
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vms_map
  name                            = each.value.vm_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = "azureuser"
  admin_password                  = azurerm_key_vault_secret.password[each.key].value
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
