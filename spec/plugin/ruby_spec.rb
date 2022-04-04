require 'spec_helper'

describe "Ruby" do
  let(:filename) { 'test.rb' }

  it "adds and removes puts statements in a simple case" do
    set_file_contents <<~EOF
      if condition
        puts "foo"
      elsif other_condition
        puts "bar"
      else
        puts "baz"
      end
    EOF

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if condition
        puts "WhatIf 1: if condition"
        puts "foo"
      elsif other_condition
        puts "WhatIf 2: elsif other_condition"
        puts "bar"
      else
        puts "WhatIf 3: else"
        puts "baz"
      end
    EOF

    vim.search 'condition'
    vim.command 'WhatIf!'
    vim.write

    assert_file_contents <<~EOF
      if condition
        puts "foo"
      elsif other_condition
        puts "bar"
      else
        puts "baz"
      end
    EOF
  end
end
