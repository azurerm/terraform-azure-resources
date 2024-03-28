run "basic-hub_and_spoke" {
  command = plan

  module {
    source = "./tests/setup"
  }
}