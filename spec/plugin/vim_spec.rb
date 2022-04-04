require 'spec_helper'

describe "Ruby" do
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
end
