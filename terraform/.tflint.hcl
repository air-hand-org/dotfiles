config {
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset = "recommended"
}

rule "terraform_unused_declarations" {
  enabled = false
}
