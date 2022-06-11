[![Build Status](https://circleci.com/gh/AndrewRadev/whatif.vim/tree/main.svg?style=shield)](https://circleci.com/gh/AndrewRadev/whatif.vim?branch=main)

## Usage

The plugin has one entry point, the `:Whatif` command, which goes over all the lines in the buffer and attempts to add debug lines to if-clauses, and their branches. A javascript example:

``` javascript
if (condition) {
    console.log("foo")
} else {
    console.log("baz")
}
```

Executing `:Whatif` in the buffer will turn it into the following:

``` javascript
if (condition) {
    console.log("Whatif 1: if (condition)")
    console.log("foo")
} else {
    console.log("Whatif 2: else")
    console.log("baz")
}
```

Once the debugging session is done, you can execute `:Whatif!`, with a `!` at the end, to delete all of the debug statements in the buffer. Bear in mind that this command essentially just executes a `:global` operation that deletes all lines with this pattern, so if you copy a debug statement, or write one manually for some reason, it'll be deleted as well.

It's possible to execute the `:Whatif` command on a range of lines, instead of operating on the whole file. This could be particularly useful with a text object that selects the contents of a function or something like that. Likewise, the command with a bang is also applicable to a range.

If the command is re-run, it'll modify the buffer, but it shouldn't double the debug lines. The plugin checks if there's already one and whether it needs to update is numbering. For instance, the above example, post-whatif, could be changed with an if-else clause:

``` javascript
if (condition) {
    console.log("Whatif 1: if (condition)")
    console.log("foo");
} else if (other_condition) {
    console.log("bar");
} else {
    console.log("Whatif 2: else")
    console.log("baz");
}
```

Running another `:Whatif` at this point will add the missing one and renumber the ones afterwards:

``` javascript
if (condition) {
    console.log("Whatif 1: if (condition)")
    console.log("foo");
} else if (other_condition) {
    console.log("Whatif 2: else if (other_condi...")
    console.log("bar");
} else {
    console.log("Whatif 3: else")
    console.log("baz");
}
```

Also note that the second debug statement truncates the preview string to a maximum of 20 characters. You can disable this by setting `g:whatif_truncate` to 0 or by changing it to whatever value you find useful. As a side note, notice that the curly brackets around the if/else lines are also removed, since they don't seem useful to the preview.

## Extending

The plugin is fairly basic and only has support for a few filetypes. Currently, the list is:

- Javascript (and variants like typescript and JSX)
- Python
- Ruby
- Rust
- Vimscript

If you need support for a language with curly brackets, like Java, C++, etc, it should be enough to set the `b:whatif_command` variable to a template string like `"System.out.println(%s)"`. See `:help b:whatif_command` for more information.

If you'd like to have support for a different kind of filetype, please open an issue suggesting:

- Examples for if-clauses, match/switch statements etc. in this language
- What a "print statement" looks like (what `b:whatif_command` ought to default to)

I'd also be happy to add defaults for `b:whatif_command` for curly-bracket languages -- the only reason I don't have any is I don't write a lot of them other than Rust and Javascript.

## Contributing

Pull requests are welcome, but take a look at [CONTRIBUTING.md](https://github.com/AndrewRadev/whatif.vim/blob/main/CONTRIBUTING.md) first for some guidelines. Be sure to abide by the [CODE_OF_CONDUCT.md](https://github.com/AndrewRadev/whatif.vim/blob/master/CODE_OF_CONDUCT.md) as well.
