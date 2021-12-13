
# Please use terraform v12.29 to start with for all labs, I will use terraform v13 and v14 from lab 7.5 onwards

variable "env" {
  type    = string
  default = "test"
}
variable "location-name" {
  type    = string
  default = "westeurope"
}
variable "admin_password" {
  type    = string
  default = "Password1234!"
}

/*
"${var.env}-be-rg"
"${var.env}-web-vnet}"
"${var.env}-Web-subnet"
"${var.env}-Web"

"${var.env}-fe-rg"
"${var.env}-fe-vnet}"
"${var.env}-Jbox-subnet"
"${var.env}-Jbox"

"${var.env}-pub-ip01"
"${var.env}-FW-01"

"${var.env}-Jbox-rg"
*/
