require 'spec_helper'

describe "Common behaviour/issues" do
  let(:filename) { 'test.js' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  it "updates its internal line numbers" do
    set_file_contents <<~EOF
      if (condition) {
        console.log("foo")
      } else if (other1) {
        console.log("bar")
      } else if (other2) {
        console.log("bar")
      } else {
        console.log("baz")
      }
    EOF

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if (condition) {
        console.log("WhatIf 1: if (condition)")
        console.log("foo")
      } else if (other1) {
        console.log("WhatIf 2: else if (other1)")
        console.log("bar")
      } else if (other2) {
        console.log("WhatIf 3: else if (other2)")
        console.log("bar")
      } else {
        console.log("WhatIf 4: else")
        console.log("baz")
      }
    EOF
  end
end