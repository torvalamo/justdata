justdata
========

A parser for an ultra simplistic data tree, perfect for config files, etc

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

Note that `field2.nested_field` only contains the second instance. Identical names will be overwritten by the last instance.

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
