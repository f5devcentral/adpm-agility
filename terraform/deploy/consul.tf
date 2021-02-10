 
 resource "azurerm_public_ip" "mgmt_public_ip" {
  name                = "pip-mgmt-consul"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   # Static is required due to the use of the Standard sku
  tags = {
    Name   = "pip-mgmt-consul"
    source = "terraform"
  }
}

resource "azurerm_network_interface" "consulvm-ext-nic" {
  name               = "${local.student_id}-consulvm-ext-nic"
  location           = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     =  data.azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.1.100"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.mgmt_public_ip.id
  }

  tags = {
    Name        = "${local.student_id}-consulvm-ext-int"
    application = "consulserver"
    tag_name    = "Env"
    value       = "consul"
  }
}

resource "azurerm_virtual_machine" "consulvm" {
  name                  = "consulvm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.consulvm-ext-nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "consulvmOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "consulvm"
    admin_username = "azureuser"
    admin_password = var.upassword
    custom_data    = file("consul.sh")

  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Name                = "${local.student_id}-consulvm"
    tag_name            = "Env"
    value               = "consul"
    propagate_at_launch = true
  }
}
