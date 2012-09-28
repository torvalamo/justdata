justdata
========

The file contains _just data_ (see below). Plus minimal indentation to indicate a hierarchy.
Exactly like most hierarchies are actually displayed on computers today.
But for some reason we feel the need to make really complicated config files
that take longer to learn than the actual product, _and are hard to read_.

If you're a clever person, please try to optimize the parser, and send me a pull request.
At the moment it's a quick and dirty hack that doesn't look pretty, but it works like it should.

Definition
----------

    justdata.parse(file, levels = -1)

Example
-------

    jd = require 'justdata'
    tree = jd.parse fs.readFileSync('./config', 'utf-8')

Source file syntax
------------------

    field
      value
    some_field
      some_value
      some_other_value
    
    field2 
      nested_field
        nested_value
      some, value, with, commas
      nested_field
        nested_value2
      value2
      another_nested_field
        hey_yo
          bro
        wazzup
      another value with spaces

The indentation can be either tabs or spaces of any length and combination, 
as long as it is consistent within a block.

Blank or whitespace-only lines are ignored, as is trailing whitespace.

Parsed
------

Using the above script to parse this will result in the following tree,
with `levels` set to 0 (parse only root level)

    tree = [ 
      field: 'value',
      some_field: 'some_value\nsome_other_value',
      field2: 'nested_field\n  nested_value\nsome, value, with, commas\nnested_field\n  nested_value2\nvalue2\nanother_nested_field\n  hey_yo\n   bro\n  wazzup\nanother value with spaces' 
    ]

Or with levels set to default (-1, unlimited)

    tree = [ 
      field: [ 'value' ],
      some_field: [ 'some_value', 'some_other_value' ],
      field2: [ 
        'some, value, with, commas',
        'value2',
        'another value with spaces',
        nested_field: [ 'nested_value2' ],
        another_nested_field: [ 
          'wazzup', 
          hey_yo: [ 
            'bro' 
          ] 
        ] 
      ] 
    ]

Caveats and good to know
------------------------

The structure is a javascript array object, which also exploits the fact that arrays 
are obects like much else, so it can have properties with names.

All the default array prototype functions have been removed from these objects in
order to prevent name crashes. If you want to modify the array (e.g. using shift 
to retreive the next item) you will have to use `Array.prototype.shift.call(tree.field2)`
or `[].shift.call(tree.field2)`. Thus, the only reserved word is 'length' (because 
it is required for array functionality), and it can only be used as a value, not as
a key.

Note that names that are identical on the same level (`field2.nested_field`) will 
overwrite each other, in the order they appear.

There will come an option which lets you specify whether to parse 'some, value, with, commas'
as if they were elements separated by commas instead of newlines, and siblings to 'value2'
and 'another value with spaces'.

Simplified BSD License
----------------------

Copyright (c) 2012, Tor Valamo All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation and/or 
other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
