justdata
========

The file contains _just data_ (see below). Plus minimal indentation to indicate a hierarchy.
Exactly like most hierarchies are actually displayed on computers today.
But for some reason we feel the need to make really complicated config files
that take longer to learn than the actual product, _and are hard to read_.

I'm surprised this format isn't more common in config files, or even other key-value storage.

If you're a clever person, please try to optimize the parser, and send me a pull request.
At the moment it's a quick and dirty hack that doesn't look pretty, but it works like it should.

Usage
-----

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
      nested_field
        nested_value2
      value2
      another_nested_field
        hey_yo
          bro
        wazzup

The indentation can be either tabs or spaces of any length and combination, 
as long as it is consistent within a block.

Blank or whitespace-only lines are ignored, as is trailing whitespace.

Using the above script to parse this will result in the following tree,
with `levels` set to 0 (parse only root level)

    tree = {
      field: 'value',
      some_field: 'some_value\nsome_other_value',
      field2: 'nested_field\n  nested_value\nnested_field\n  nested_value2\nvalue2\nanother_nested_field\n  hey_yo\n   bro\n  wazzup'
    }

Or with levels set to default (unlimited)

    tree = {
      field: 'value',
      some_field: [ 'some_value', 'some_other_value' ],
      field2: {
        nested_field: 'nested_value2',
        another_nested_field: {
          hey_yo: 'bro',
          _: 'wazzup'
        },
        _: 'value2'
      }
    }

A couple of things to note:

- Identical names ("name" = item that has children) will be overwritten by the last instance (`field2.nested_field` only contains the second instance).
- Multiple values ("value" = item that has no children) in the same block are put in an array (`some_field`).
- In blocks that have both value(s) and name(s), the value(s) will be stored with the identifier `_` (`field2._`).

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
