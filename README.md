# jsonaxe

jsonaxe is a command-line JSON processor with an expressive python interface

jsonaxe is written in Python and can be installed by copying the
jsonaxe script into a location on your $PATH.

## Installation

First, clone the Git repository:

    $ git clone git://github.com/davvid/jsonaxe.git

Then choose an installation method that works best for you:

### Per-user installation

    $ cd jsonaxe
    $ make install

This will install `$HOME/bin/jsonaxe` and `$HOME/share/doc/jsonaxe`.

### System-wide installation

    $ cd sharness
    # make install prefix=/usr/local

This will install `/usr/local/bin/jsonaxe` and `/usr/local/share/doc/jsonaxe`.

You can change the _prefix_ parameter to any other location.

## Usage

    $ ./jsonaxe -h
    usage: jsonaxe [-h] [--raw] [--expand] <query> [<file>]
    
    positional arguments:
    <query>       query expression
    <file>        json file, defaults to "-" (stdin)
    
    optional arguments:
    -h, --help    show this help message and exit
    --raw, -r     output raw text
    --expand, -x  expand environment $variables in strings

## Examples

    $ ./jsonaxe 'objects' test/data.json
    {
      "a": {
        "b": {
          "c": "C value"
        }
      }
    }
    
    # nested objects can be traversed using dot "."
    $ ./jsonaxe 'objects.a.b.c' test/data.json
    "C value"
    
    # square-bracket object["key"] syntax works too
    $ ./jsonaxe 'objects["a"]["b"]["c"]' test/data.json
    "C value"
    
    # python-style string expressions can drill down to a specific character
    $ ./jsonaxe 'objects.a.b.c[0]' test/data.json
    "C"
    
    # the full slice syntax can be used, e.g. every 2nd character from 0-5
    $ ./jsonaxe 'objects.a.b.c[0:5:2]' test/data.json
    "Cvl"
    
    # manipulate object values in-place
    $ ./jsonaxe 'objects.a.b.put("d", 42)' test/data.json
    {
        "c": "C value",
        "d": 42
    }

## Expressions

jsonaxe expressions are written in Python, so all of the built-in
python operators and functions are available, including `lambda` expressions
for creating quick filters.

jsonaxe expressions operate on the json object directly.  The result of
evaluating the expression is what is printed to stdout.

The following methods are available on the implicit current object
when jsonaxe expressions are evaluated.

    append(<value>): Append to the current array
    capitalize(): Capitalize strings
    delete(<key>): Delete values from dictionaries
    filter(<fn>): Filter data with a filter function
    fnmatch(<glob>): Filter data using an fnmatch expression
    format(<string>): Format data using a format string
    insert(<index>, <value>): Insert <value> at <index>
    join(<string>): Combine string arrays with the specified delimeter
    keys(): Inspect the object's keys
    lower(): Downcase strings
    lstrip(<string>): Strip whitespace from the beginning of a string
    map(<fn>): Apply a function to the data
    match(<regex>): Filter data  with a regular expression
    partition(<delimeter>): Partition a string by delimiter
    put(<key>, <value>): Set data on the current object
    remove(<key>): Remove a specific entry
    replace(<old>, <new>): Replace values in a string
    reverse(): Reverse a list
    rstrip(): Strip whitespace from the end
    save(<filename>): save current state to <filename>
    sort(): sort data
    split(<string>): Split strings
    strip(): Strip whitespace
    title(): Title-case strings
    upper(): Upper-case strings
    values(): Inspect the object's values

See the [unit tests](test/jsonaxe.t) or the [source code](jsonaxe)
for the full list of supported functions.

## See also

jsonaxe was inspired by [jq](https://github.com/stedolan/jq),
the original JSON command-line processor.

## License

jsonquery is licensed under the terms of the GNU GPL version 2 or higher.
See the [COPYING](COPYING) file for the full license text.
