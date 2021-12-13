variable "rgname" {
  type = string
  description = "Enter rg name"
  #default = "defaultrg"
}

variable "rglocation" {
  type = string
  description = "Enter rg location "
  #default = "eastus"
}

variable "rglocationlist" {
    type = list
    description = "(optional) describe your variable"
    default = ["eastus","eastus2","westus"]
}

variable "locmap" {
    type = map
    description = "(optional) describe your variable"
    default = {
        "IN" = "southindia",
        "US" = "eastus"
    }
}