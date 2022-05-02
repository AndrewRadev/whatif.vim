require 'spec_helper'

describe "Ruby" do
  let(:filename) { 'test.rb' }

  after :each do
    vim.command 'let g:whatif_truncate = 20'
  end

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

  it "allows customizing the truncation limit" do
    set_file_contents <<~EOF
      if condition(one, two, three, four, five)
        puts "foo"
      end
    EOF

    vim.command "let g:whatif_truncate = #{"if cond".length}"

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if condition(one, two, three, four, five)
        puts "WhatIf 1: if cond..."
        puts "foo"
      end
    EOF
  end

  it "handles nested if-clauses" do
    set_file_contents <<~EOF
      if condition
        puts "foo"
      else
        # Something else
        if other_condition
          puts "bar"
        else
          puts "baz"
        end
      end
    EOF

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if condition
        puts "WhatIf 1: if condition"
        puts "foo"
      else
        puts "WhatIf 2: else"
        # Something else
        if other_condition
          puts "WhatIf 3: if other_condition"
          puts "bar"
        else
          puts "WhatIf 4: else"
          puts "baz"
        end
      end
    EOF
  end

  it "handles line continuations" do
    set_file_contents <<~EOF
      if condition
        puts "foo"
      elsif 1 + 1 == 2 &&
        2 + 2 == 4
        puts "bar"
      end
    EOF

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if condition
        puts "WhatIf 1: if condition"
        puts "foo"
      elsif 1 + 1 == 2 &&
        2 + 2 == 4
        puts "WhatIf 2: elsif 1 + 1 == 2 &&"
        puts "bar"
      end
    EOF
  end
end
