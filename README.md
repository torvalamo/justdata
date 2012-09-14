justdata
========

A parser for an ultra simplistic data tree, perfect for config files, etc

Usage
-----

		justdata.parse(file, options)

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
        wazzup

The indentation can be either tabs or spaces of any length and combination, 
as long as it is consistent within a block.

Using the above script to parse this will result in the following trees,
depending on options given

__{}__ (defaults)

not ordered, not combined, not ignored

    tree = {
      field: 'value',
      field2: [
        { nested_field: 'nested_value' },
        { nested_field: 'nested_value2' },
        'value2',
        { another_nested_field: [ 'hey_yo', 'wazzup' ] }
      ],
      some_field: [ 'some_value', 'some_other_value' ]
    }

__{ ordered: true }__

ordered (preserves the element order), not combined, not ignored

    tree = [
      { field: 'value' },
      { some_field: [ 'some_value', 'some_other_value' ] },
      { field2: [
        { nested_field: 'nested_value' },
        { nested_field: 'nested_value2' },
        'value2',
        { another_nested_field: [ 'hey_yo', 'wazzup' ] }
      ] }
    ]

__{ ordered: true, combined: true }__

not ordered (combined takes precedence), combined (combines key-value
elements into a common object), not ignored

Note `tree.field2` as well as `tree.field2.nested_field`

    tree = {
      field: 'value',
      field2: [
        {
          nested_field: [ 'nested_value', 'nested_value2' ],
          another_nested_field: [ 'hey_yo', 'wazzup' ]
        },
        'value2'
      ],
      some_field: [ 'some_value', 'some_other_value' ]
    }

__{ ordered: true, ignored: true }__

ordered, not combined, ignored (ignores values that have key-value
siblings)

Note `tree.field2`'s value2 is ignored.

    tree = [
      { field: 'value' },
      { some_field: [ 'some_value', 'some_other_value' ] },
      { field2: [
        { nested_field: 'nested_value' },
        { nested_field: 'nested_value2' },
        { another_nested_field: [ 'hey_yo', 'wazzup' ] }
      ] }
    ]

__{ combined: true, ignored: true }__

not ordered (combined takes precedence), combined, ignored

The combined flag is actually not necessary here, since combining is
automatic when there are no value-only siblings, which ignored takes
care of.

Note `tree.field2`'s value2 is ignored, and every level is an object
unless it has values only. This is a nice option for config files.

    tree = {
      field: 'value',
      field2: {
        another_nested_field: [ 'hey_yo', 'wazzup' ],
        nested_field: [ 'nested_value', 'nested_value2' ]
      },
      some_field: [ 'some_value', 'some_other_value' ]
    }

__{ levels: 0 }__

parse only the root level and return everything else as raw text

    tree = {
      field: 'value',
      some_field: 'some_value
    some_other_value',
      field2: 'nested_field
      nested_value
    nested_field
      nested_value2
    value2
    another_nested_field
      hey_yo
      wazzup'
    }

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
