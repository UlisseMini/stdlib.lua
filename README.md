# stdlib.lua
contains all the standard library functions i want.
it can be loaded with
```lua
local std = require 'stdlib'
```
WARNING: Not all functions are returned. some are inserted into
global tables such as table.

## Examples

```lua
local std = require 'stdlib'

-- Execute the function print on every character, same as
-- ('foobar'):gsub('.', print)
('foobar'):map(print)

--[[ Output
f
o
o
b
a
r
]]
```

```lua
local std = require 'stdlib'

-- Create a new function that says foo plus other arguments
fooAnd = std.part(print, 'foo')
fooAnd('bar', 'baz') --> foo     bar     baz
```

```lua
local std = require 'stdlib'

-- Execute a function on every element of a table and return the new table
t = {
    a = 'foo',
    b = 'bar',
    [10] = 'hello'
}

local result = table.map(t, function(item)
    return 'Processed: '..item
end)

-- t is unchanged, result is the new table.
for i,v in pairs(result) do print(i,v) end

--[[ Output
b       Processed: bar
a       Processed: foo
10      Processed: hello
]]
```
