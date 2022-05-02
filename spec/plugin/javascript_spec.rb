require 'spec_helper'

describe "Javascript" do
  let(:filename) { 'test.js' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  it "adds and removes console.log statements in a simple case" do
    set_file_contents <<~EOF
      if (condition) {
        console.log("foo")
      } else if (other) {
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
      } else if (other) {
        console.log("WhatIf 2: else if (other)")
        console.log("bar")
      } else {
        console.log("WhatIf 3: else")
        console.log("baz")
      }
    EOF

    vim.search 'condition'
    vim.command 'WhatIf!'
    vim.write

    assert_file_contents <<~EOF
      if (condition) {
        console.log("foo")
      } else if (other) {
        console.log("bar")
      } else {
        console.log("baz")
      }
    EOF
  end

  it "handles nested if-clauses" do
    set_file_contents <<~EOF
      if (condition) {
        console.log("foo")
      } else {
        if (other) {
          console.log("bar")
        } else {
          console.log("baz")
        }
      }
    EOF

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if (condition) {
        console.log("WhatIf 1: if (condition)")
        console.log("foo")
      } else {
        console.log("WhatIf 2: else")
        if (other) {
          console.log("WhatIf 3: if (other)")
          console.log("bar")
        } else {
          console.log("WhatIf 4: else")
          console.log("baz")
        }
      }
    EOF
  end
end
