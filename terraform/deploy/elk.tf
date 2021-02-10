 
 resource "azurerm_public_ip" "elk_public_ip" {
  name                = "pip-mgmt-elk"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   # Static is required due to the use of the Standard sku
  tags = {
    Name   = "pip-mgmt-elk"
    source = "terraform"
  }
}

resource "azurerm_network_interface" "elkvm-ext-nic" {
  name               = "${local.student_id}-elkvm-ext-nic"
  location           = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     =  data.azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.1.125"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.elk_public_ip.id
  }

  tags = {
    Name        = "${local.student_id}-elkvm-ext-int"
    application = "elkserver"
    tag_name    = "Env"
    value       = "elk"
  }
}

resource "azurerm_virtual_machine" "elkvm" {
  name                  = "elkvm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.elkvm-ext-nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "elkvmOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "bitnami"
    offer     = "elk"
    sku       = "4-6"
    version   = "latest"
  }
  
  plan {
    name = "4-6"
    publisher = "bitnami"
    product = "elk"
  }

  os_profile {
    computer_name  = "elkvm"
    admin_username = "elkuser"
    admin_password = var.upassword
    #custom_data    = file("elk.sh")

  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Name                = "${local.student_id}-elkvm"
    tag_name            = "Env"
    value               = "elk"
    propagate_at_launch = true
  }
}

resource "azurerm_virtual_machine_extension" "elkvm" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_virtual_machine.elkvm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": ""
    }
SETTINGS

  tags = {
    environment = "Production"
  }
}
