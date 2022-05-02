require 'spec_helper'

describe "Vim" do
  let(:filename) { 'test.vim' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  it "adds and removes echomsg statements in a simple case" do
    set_file_contents <<~EOF
      if condition
        echo "foo"
      elseif other_condition
        echo "bar"
      else
        echo "baz"
      endif
    EOF

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if condition
        echomsg "WhatIf 1: if condition"
        echo "foo"
      elseif other_condition
        echomsg "WhatIf 2: elseif other_condition"
        echo "bar"
      else
        echomsg "WhatIf 3: else"
        echo "baz"
      endif
    EOF

    vim.search 'condition'
    vim.command 'WhatIf!'
    vim.write

    assert_file_contents <<~EOF
      if condition
        echo "foo"
      elseif other_condition
        echo "bar"
      else
        echo "baz"
      endif
    EOF
  end

  it "handles nested if-clauses" do
    set_file_contents <<~EOF
      if condition
        echomsg "foo"
      else
        " Something else
        if other_condition
          echomsg "bar"
        else
          echomsg "baz"
        endif
      endif
    EOF

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if condition
        echomsg "WhatIf 1: if condition"
        echomsg "foo"
      else
        echomsg "WhatIf 2: else"
        " Something else
        if other_condition
          echomsg "WhatIf 3: if other_condition"
          echomsg "bar"
        else
          echomsg "WhatIf 4: else"
          echomsg "baz"
        endif
      endif
    EOF
  end

  it "handles line continuations" do
    set_file_contents <<~EOF
      if condition
        echomsg "foo"
      elseif 1 + 1 == 2 &&
            \\ 2 + 2 == 4
        echomsg "bar"
      endif
    EOF

    vim.search 'condition'
    vim.command 'WhatIf'
    vim.write

    assert_file_contents <<~EOF
      if condition
        echomsg "WhatIf 1: if condition"
        echomsg "foo"
      elseif 1 + 1 == 2 &&
            \\ 2 + 2 == 4
        echomsg "WhatIf 2: elseif 1 + 1 == 2 &&"
        echomsg "bar"
      endif
    EOF
  end
end
