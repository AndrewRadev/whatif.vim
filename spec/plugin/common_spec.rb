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

    vim.command 'Whatif'
    vim.write

    assert_file_contents <<~EOF
      if (condition) {
        console.log("Whatif 1: if (condition)")
        console.log("foo")
      } else if (other1) {
        console.log("Whatif 2: else if (other1)")
        console.log("bar")
      } else if (other2) {
        console.log("Whatif 3: else if (other2)")
        console.log("bar")
      } else {
        console.log("Whatif 4: else")
        console.log("baz")
      }
    EOF
  end

  it "doesn't double up print statements, fills in the gaps and renumbers" do
    set_file_contents <<~EOF
      if (condition) {
        console.log("Whatif 1: if (condition)")
        console.log("foo")
      } else if (other) {
        console.log("bar")
      } else {
        console.log("Whatif 2: else")
        console.log("baz")
      }
    EOF

    vim.command 'Whatif'
    vim.write

    assert_file_contents <<~EOF
      if (condition) {
        console.log("Whatif 1: if (condition)")
        console.log("foo")
      } else if (other) {
        console.log("Whatif 2: else if (other)")
        console.log("bar")
      } else {
        console.log("Whatif 3: else")
        console.log("baz")
      }
    EOF
  end

  it "works with limited ranges" do
    set_file_contents <<~EOF
      if (condition) {
        console.log("foo")
      } else if (other) {
        console.log("bar")
      } else {
        console.log("baz")
      }
    EOF

    vim.command '3,4Whatif'
    vim.write

    assert_file_contents <<~EOF
      if (condition) {
        console.log("foo")
      } else if (other) {
        console.log("Whatif 1: else if (other)")
        console.log("bar")
      } else {
        console.log("baz")
      }
    EOF
  end

  it "can undo limited ranges" do
    set_file_contents <<~EOF
      if (condition) {
        console.log("Whatif 1: if (condition)")
        console.log("foo")
      } else if (other) {
        console.log("Whatif 2: else if (other)")
        console.log("bar")
      } else {
        console.log("Whatif 3: else")
        console.log("baz")
      }
    EOF

    vim.command '1,7Whatif!'
    vim.write

    assert_file_contents <<~EOF
      if (condition) {
        console.log("foo")
      } else if (other) {
        console.log("bar")
      } else {
        console.log("Whatif 3: else")
        console.log("baz")
      }
    EOF
  end
end
