terraform {
  before_hook "echo_on_show" {
    commands = ["show"]
    execute  = ["echo", "hello"]
  }
}
