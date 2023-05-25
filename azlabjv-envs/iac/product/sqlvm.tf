# SQL Virtual Machine Network Interface
resource "azurerm_network_interface" "sql_vm01_nic" {
  name                 = "${var.sql_vm01.name}-nic01"
  location             = azurerm_resource_group.product_rg.location
  resource_group_name  = azurerm_resource_group.product_rg.name
  tags                 = var.default_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.main_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.sql_vm01.private_ip_address
  }
}

# SQL Virtual Machine
resource "azurerm_virtual_machine" "sql_vm01" {
  name                = var.sql_vm01.name
  location            = azurerm_resource_group.product_rg.location
  resource_group_name = azurerm_resource_group.product_rg.name
  vm_size             = var.sql_vm01.size
  tags                = var.default_tags

  network_interface_ids = [
    azurerm_network_interface.sql_vm01_nic.id
   ]

  storage_image_reference {
    publisher         = var.sql_vm01.publisher
    offer             = var.sql_vm01.offer
    sku               = var.sql_vm01.sku
    version           = var.sql_vm01.version
  }

  storage_os_disk {
    name              = "${var.sql_vm01.name}-osdisk"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "Premium_LRS"
    os_type           = "Windows"
  }

  storage_data_disk {
    name              = "${var.sql_vm01.name}-data"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = var.sql_vm01.data_disk_size_gb
    lun               = 0
    managed_disk_type = "Premium_LRS"
  }

  storage_data_disk {
    name              = "${var.sql_vm01.name}-log"
    caching           = "None"
    create_option     = "Empty"
    disk_size_gb      = var.sql_vm01.log_disk_size_gb
    lun               = 1
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name     = var.sql_vm01.name
    admin_username    = var.sql_vm01.admin_username
    admin_password    = random_password.sql_vm01_adminpw.result 
  }

  os_profile_windows_config {
    timezone           = "UTC"
    provision_vm_agent = true
  }
}

# SQL Virtual Machine Settings
resource "azurerm_mssql_virtual_machine" "sql_vm01" {
  virtual_machine_id               = azurerm_virtual_machine.sql_vm01.id
  sql_license_type                 = "PAYG"
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_username = var.sql_vm01.admin_username
  sql_connectivity_update_password = random_password.sql_vm01_adminpw.result 

  storage_configuration {
    disk_type             = "NEW"
    storage_workload_type = "GENERAL"

    # The storage_settings block supports the following:
    data_settings {
      default_file_path = var.sql_vm01.default_file_path_data
      luns              = [0]
    }

    log_settings {
      default_file_path = var.sql_vm01.default_file_path_log
      luns              = [1]
    }
  }
}

# SQL Virtual Machine Password
resource "random_password" "sql_vm01_adminpw" {
  length           = 32
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "@#&*()?"
}

resource "azurerm_key_vault_secret" "sql_vm01_adminuser" {
  name         = "${var.sql_vm01.name}-user"
  value        = var.sql_vm01.admin_username
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_key_vault_secret" "sql_vm01_adminpw" {
  name         = "${var.sql_vm01.name}-pw"
  value        = random_password.sql_vm01_adminpw.result
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}