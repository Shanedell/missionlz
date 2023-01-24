locals {
  users = csvdecode(file("${path.module}/existing_users.csv"))
}