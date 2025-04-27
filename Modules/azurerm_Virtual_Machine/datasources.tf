###########datablock for keyvault
data "azurerm_key_vault" "kv" {
  for_each            = var.vms_map
  name                = each.value.kv_name  #Note - Use same name as we use in manually created kv in portal
  resource_group_name = each.value.resource_group_name
}

###########resourceblock for keyvault vm username
resource "azurerm_key_vault_secret" "username" {
  for_each     = var.vms_map  
  name         = "vm-username"
  value        = "azureuser"
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

###########resourceblock for random password of vm
resource "random_password" "random_pass" {
  for_each         = var.vms_map
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

###########resourceblock for keyvault vm password
resource "azurerm_key_vault_secret" "password" {
  for_each     = var.vms_map  
  name         = "${each.value.vm_name}-password"
  value        = random_password.random_pass[each.key].result
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

# ###########datablock for keyvaultsecretusername
# data "azurerm_key_vault_secret" "kvsecret_username" {
#   name         = "vmusername" #Note - Use same name as we use in manually created kv in portal     
#   key_vault_id = data.azurerm_key_vault.kv.id
# }

# ###########datablock for keyvaultsecretpassword
# data "azurerm_key_vault_secret" "kvsecret_password" {
#   name         = "vmpassword" #Note - Use same name as we use in manually created kv in portal     
#   key_vault_id = data.azurerm_key_vault.kv.id
# }