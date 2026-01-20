variable "location" {
  default = "West US 2"
  type    = string
}
variable "rg_name" {
  default = "poorneshtf"
  type    = string
}
variable "address_space" {
  default = ["10.0.1.0/16"]
  type    = list(string)
}
variable "vnet" {
  default = "tfvnet"
  type    = string
}
variable "address_prefixes" {
  default = ["10.0.1.0/24"]
  type    = list(string)
}
variable "subnet_name" {
  default = "tf_subnetpoornesh"
  type    = string
}
variable "nsgname" {
  default = "poorneshnsg"
  type    = string
}
variable "nicname" {
  default = "poorneshnic"
  type    = string
}
variable "vmname" {
  default = "tflinuxb2"
  type    = string
}


