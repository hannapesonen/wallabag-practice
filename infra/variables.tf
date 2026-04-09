variable "location" {
  type = string
  description = "Azure region"
  default = "northeurope"
}

variable "project_name" {
  type = string
  description = "Short name for this project"
  default = "wallabag-test"
}

variable "postgres_admin_password" {
  type = string
  description = "PostgreSQL admin password"
  sensitive = true
}