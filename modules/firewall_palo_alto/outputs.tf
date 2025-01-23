output "password" {
  description = "The password of the firewall."
  value       = try(random_password.this[0].result, "")
}