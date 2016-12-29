# Guidelines of FPGA examples

## git logs

Must be in the manner:
```
target: very short description

Long description with items if needed:
* target is a directory, such as docs or any of the *vendor_board*.
* If you don't have a very short description, consider to do partial commits.
* In long description, you can explain what do you add or fixed as general concept.
* You can also use a list of items explaining what do you do in individual files.
```
## HDL code

* VHDL is the prefered HDL language to use.
* Use suffix such as _i, _o and _io on ports names.
* Try to keep top.vhdl simple to understand and well documented.
* Add a wrapper.vhdl file when need to drive a complex vendor's core.

## File Header

Developed HDL files such as wrapper.vhdl, top.vhdl and top_tb.vhdl must have a header in the manner:
```
--
-- Name
--
-- Description
--
-- Author(s):
-- * Name of the author(s) of the file
--
-- Copyright (c) Year Authors
-- Distributed under the BSD 3-Clause License
--
```
