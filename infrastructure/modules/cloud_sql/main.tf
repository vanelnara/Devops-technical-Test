resource "google_sql_database_instance" "vanel_mysql" {
  name             = "vanel-mysql-${var.environment}"
  database_version = "MYSQL_8_0"
  region           = var.region
  settings {
    tier = "db-g1-small"
    availability_type = "REGIONAL"
    disk_size = 50
    backup_configuration {
      enabled = true
      start_time = "04:00"
    }
    ip_configuration {
      ipv4_enabled = false
      private_network = "projects/${var.project_id}/global/networks/default"
    }
  }
  deletion_protection = true
}
resource "google_sql_database" "vanel_app_db" {
  name = var.db_name
  instance = google_sql_database_instance.vanel_mysql.name
}
resource "google_sql_user" "vanel_db_user" {
  name = var.db_user
  instance = google_sql_database_instance.vanel_mysql.name
  password = var.db_pass
}
