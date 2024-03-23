config {
  module = true
}

plugin "terraform" {
  enabled = true
  preset = "recommended"
}

rule "terraform_unused_declarations" {
  enabled = false
}
