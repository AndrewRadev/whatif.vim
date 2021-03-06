require 'spec_helper'

describe "Rust" do
  let(:filename) { 'test.rs' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 4)
  end

  it "adds and removes println! statements in a simple case" do
    set_file_contents <<~EOF
      if condition {
          println!("foo");
      } else if other {
          println!("bar");
      } else {
          println!("baz");
      }
    EOF

    vim.command 'Whatif'
    vim.write

    assert_file_contents <<~EOF
      if condition {
          println!("Whatif 1: if condition");
          println!("foo");
      } else if other {
          println!("Whatif 2: else if other");
          println!("bar");
      } else {
          println!("Whatif 3: else");
          println!("baz");
      }
    EOF

    vim.command 'Whatif!'
    vim.write

    assert_file_contents <<~EOF
      if condition {
          println!("foo");
      } else if other {
          println!("bar");
      } else {
          println!("baz");
      }
    EOF
  end

  it "handles nested if-clauses" do
    set_file_contents <<~EOF
      if condition {
          println!("foo");
      } else {
          if other {
              println!("bar");
          } else {
              println!("baz");
          }
      }
    EOF

    vim.command 'Whatif'
    vim.write

    assert_file_contents <<~EOF
      if condition {
          println!("Whatif 1: if condition");
          println!("foo");
      } else {
          println!("Whatif 2: else");
          if other {
              println!("Whatif 3: if other");
              println!("bar");
          } else {
              println!("Whatif 4: else");
              println!("baz");
          }
      }
    EOF
  end

  it "handles block-form match statements" do
    set_file_contents <<~EOF
      match Some("foo") {
          Some(foo) => {
              println!("{}", foo);
          },
          None => println!("None"),
      }
    EOF

    vim.command 'Whatif'
    vim.write

    assert_file_contents <<~EOF
      match Some("foo") {
          Some(foo) => {
              println!("Whatif 1: Some(foo) =>");
              println!("{}", foo);
          },
          None => println!("None"),
      }
    EOF
  end
end
