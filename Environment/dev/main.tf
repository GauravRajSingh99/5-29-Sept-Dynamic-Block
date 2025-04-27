################resourcegroup module
module "resource" {
  source = "../../Modules/azurerm_Resource_Group" #C:\24 AUGUST\Modules\azurerm_Resource_Group
  rg_map = var.rg_details
}

# ###########storageaccount module
# module "storage" {
#   depends_on = [module.resource]
#   source     = "../../Modules/azurerm_Storage_Account" #C:\24 AUGUST\Modules\azurerm_Storage_Account
#   st_map     = var.st_details
# }

###########virtualnetwork module
module "network" {
  depends_on = [module.resource]
  source     = "../../Modules/azurerm_Virtual_Network" #C:\24 AUGUST\Modules\azurerm_Virtual_Network
  vnet_map   = var.vnet_details
}

###############subnet module
module "subnet" {
  depends_on = [module.network]
  source     = "../../Modules/azurerm_Subnet" #C:\24 AUGUST\Modules\azurerm_Subnet
  snet_map   = var.snet_details
}

##############VM module
module "vms" {
  depends_on = [module.subnet]
  source     = "../../Modules/azurerm_Virtual_Machine" #C:\31 Aug\Modules\azurerm_Virtual_Machine
  vms_map    = var.vms_details
}

###############Bastion module
# module "bastion" {
#   depends_on   = [module.subnet]
#   source       = "../../Modules/azurerm_bastion" #C:\31 Aug\Modules\azurerm_bastion
#   bastions_map = var.bastions_details
# }

################keyvault module
module "keyvault" {
  depends_on = [module.resource]
  source     = "../../Modules/azurerm_key_vault" #C:\5 September\Modules\azurerm_key_vault
  kv_map     = var.keyvault_details
}

