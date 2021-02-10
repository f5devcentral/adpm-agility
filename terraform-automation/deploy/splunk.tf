
resource "azurerm_public_ip" "splunkip" {
  name                = "splunk-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "splunknic" {
 name                = "splunk_nic"
 location            = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name

 ip_configuration {
   name                          = "splunkConfiguration"
   subnet_id                     = data.azurerm_subnet.external-public.id
   private_ip_address_allocation = "static"
   private_ip_address            = "10.2.2.100"
   public_ip_address_id          = azurerm_public_ip.splunkip.id
 }
}

resource "azurerm_managed_disk" "splunkdisk" {
 name                 = "splunk_datadisk_existing"
 location             = azurerm_resource_group.rg.location
 resource_group_name  = azurerm_resource_group.rg.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

resource "azurerm_availability_set" "splunkavset" {
 name                         = "splunkavset"
 location                     = azurerm_resource_group.rg.location
 resource_group_name          = azurerm_resource_group.rg.name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
}


resource "azurerm_virtual_machine" "splunk" {
 name                  = "splunk_vm"
 location              = azurerm_resource_group.rg.location
 availability_set_id   = azurerm_availability_set.splunkavset.id
 resource_group_name   = azurerm_resource_group.rg.name
 network_interface_ids = [azurerm_network_interface.splunknic.id]
 vm_size               = "Standard_DS1_v2"


 # Uncomment this line to delete the OS disk automatically when deleting the VM
 # delete_os_disk_on_termination = true

 # Uncomment this line to delete the data disks automatically when deleting the VM
 # delete_data_disks_on_termination = true

 storage_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_os_disk {
   name              = "mysplunkosdisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 # Optional data disks
 storage_data_disk {
   name              = "splunkdatadisk_new"
   managed_disk_type = "Standard_LRS"
   create_option     = "Empty"
   lun               = 0
   disk_size_gb      = "1023"
 }

 storage_data_disk {
   name            = azurerm_managed_disk.splunkdisk.name
   managed_disk_id = azurerm_managed_disk.splunkdisk.id
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = azurerm_managed_disk.splunkdisk.disk_size_gb
 }

 os_profile {
   computer_name  = "splunkserver"
   admin_username = "splunkuser"
   admin_password = "F5labnet!"
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }
}

resource "azurerm_virtual_machine_extension" "splunkext" {

 name                  = "splunk_ext"
  virtual_machine_id   = azurerm_virtual_machine.splunk.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute":  "cd /tmp && wget https://download.splunk.com/products/splunk/releases/7.1.1/linux/splunk-7.1.1-8f0ead9ec3db-linux-2.6-amd64.deb && sudo dpkg -i splunk-7.1.1-8f0ead9ec3db-linux-2.6-amd64.deb"
    }
SETTINGS


}