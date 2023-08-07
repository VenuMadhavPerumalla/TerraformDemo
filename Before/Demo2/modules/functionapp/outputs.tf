output "ids" {
  value = azurerm_function_app.example.*.id
}