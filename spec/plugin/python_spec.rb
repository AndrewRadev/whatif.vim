require 'spec_helper'

describe "Python" do
  let(:filename) { 'test.py' }

  after :each do
    vim.command 'let g:whatif_truncate = 20'
  end

  it "adds and removes puts statements in a simple case" do
    set_file_contents <<~EOF
      if condition:
          print("foo")
      elif other_condition:
          print("bar")
      else:
          print("baz")
    EOF

    vim.command 'Whatif'
    vim.write

    assert_file_contents <<~EOF
      if condition:
          print("Whatif 1: if condition")
          print("foo")
      elif other_condition:
          print("Whatif 2: elif other_condition")
          print("bar")
      else:
          print("Whatif 3: else")
          print("baz")
    EOF

    vim.command 'Whatif!'
    vim.write

    assert_file_contents <<~EOF
      if condition:
          print("foo")
      elif other_condition:
          print("bar")
      else:
          print("baz")
    EOF
  end

  it "ignores one-line ifs" do
    set_file_contents <<~EOF
      if condition:
          if other_condition: print("bar")
          print("foo")
    EOF

    vim.command 'Whatif'
    vim.write

    assert_file_contents <<~EOF
      if condition:
          print("Whatif 1: if condition")
          if other_condition: print("bar")
          print("foo")
    EOF
  end
end
