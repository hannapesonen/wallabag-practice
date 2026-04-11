variable "location" {
  type = string
  description = "Azure region"
  default = "northeurope"
}

variable "project_name" {
  type = string
  description = "Short name for this project"
  default = "wallabag"
}

variable "postgres_admin_password" {
  type = string
  description = "PostgreSQL admin password"
  sensitive = true
}

variable "db_name" {
  type = string
  description = "Name of the PostgreSQL DB"
}