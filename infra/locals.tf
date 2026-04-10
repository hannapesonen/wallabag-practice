locals {
  # Standardized naming
  rg_name = "${var.project_name}-rg"
  acr_name = "${var.project_name}-acr1234"
  pg_name = "${var.project_name}-pg"
  cae_name = "${var.project_name}-cae"
  app_name = "${var.project_name}-app"

  # environment variables for the container
  wallabag_env = [
    {
        name = "SYMFONY__ENV__DATABASE_DRIVER"
        value = "pdo_pgsql"
    },
    {
        name = "SYMFONY_ENV__DATABASE_PORT"
        value = "5432"
    },
    {
        name = "SYMFONY__ENV__DOMAIN_NAME"
        value = "https://nettisivu.fi" # change later
    }
  ]
}