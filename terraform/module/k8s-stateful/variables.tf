variable "env" {
  type = string
  validation {
    condition = length(var.env) == 3
    error_message = "Must be a 3 charactor long"
  }
}

variable "cluster_name" {
  type = string
  validation {
    condition = length(var.cluster_name) <= 9
    error_message = "Must be no more than 9 charactor long"
  }
}

variable "availability_zone" {
  type = string
}