#Pull valid users from Azure with UPNs
data "azuread_user" "user" {
  for_each = { for user in local.users : user.UPN => user }
  user_principal_name = each.value.UPN
}

#Create group_1 group
resource "azuread_group" "${var.group_1.id}" {
  display_name = var.group_1.display_name
  security_enabled = true
}

#Add users to group_1 group
resource "azuread_group_member" "${var.group_1.id}" {
  for_each = { for user in azuread_user.existing_users: user.UPN => user if u.department == var.group_1.display_name }

  group_object_id  = "azuread_group.${var.group_1.id}"
  member_object_id = data.azuread_user.user[each.key].id
}

#Create group_2 group
resource "azuread_group" "${var.group_2.id}" {
  display_name = var.group_2.display_name
  security_enabled = true
}

#Add users to group_2 group
resource "azuread_group_member" "${var.group_2.id}" {
  for_each = { for user in azuread_user.existing_users: user.UPN => user if u.department == var.group_2.display_name }

  group_object_id  = "azuread_group.${var.group_2.id}"
  member_object_id = data.azuread_user.user[each.key].id
}

#Create group_3 group
resource "azuread_group" "${var.group_3.id}" {
  display_name = var.group_3.display_name
  security_enabled = true
}

#Add users to group_3 group
resource "azuread_group_member" "${var.group_3.id}" {
  for_each = { for user in azuread_user.existing_users: user.UPN => user if u.department == var.group_3.display_name }

  group_object_id  = "azuread_group.${var.group_3.id}"
  member_object_id = data.azuread_user.user[each.key].id
}