variable "name" {
  type        = string
  description = "Envname"
  # default     = "statestreet"

}
variable "location" {
  type        = string
  description = "(optional) describe your variable"
  default     = "west us"
}

variable "storage_accountname" {
  type        = string
  description = "storage_accountname"
  default     = "test123"
}

variable "tag" {
  type        = map(string)
  description = "(optional) describe your variable"
  default = {
    tag1 = "val1"
    tag2 = "val2"
  }
}