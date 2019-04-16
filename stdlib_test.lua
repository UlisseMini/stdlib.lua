local std = require 'stdlib'

-- Test helper functions
local t = {}
function t.Eq(a, b)
  if a ~= b then
    error(('got %q, want %q'):format(b, a), 2)
  end
end

local test = {}
function test.partReturn()
  local fn = std.part(function(a,b)
    return a,b
  end, 'foo')

  local a, b = fn('bar')
  t.Eq(a, 'foo')
  t.Eq(b, 'bar')
end

-- TODO: Test partErrors being correct
function test.partErrors()
  local fn = std.part(function()
    error 'foo'
  end)

  local _, err = pcall(fn)
  if err:match 'stdlib.lua' then
    error(('%q should not contain stdlib.lua'):format(err))
  end
end

function test.tableMap()
  local testdata = {a = 'foo', b = 'bar'}

  local result = table.map(testdata, function(item)
    return 'Got '..item
  end)

  t.Eq(result.a, 'Got foo')
  t.Eq(result.b, 'Got bar')
end

function test.stringMap()
  local testdata = 'hello world'
  local wantdata = 'h e l l o   w o r l d '

  local result = testdata:map(function(char)
    return char..' '
  end)

  t.Eq(wantdata, result)
end

-- TODO: Test typecheck
function test.typecheck()
end

-- Run the tests
for tname, tc in pairs(test) do
  local _, err = pcall(tc)

  io.write(tname..'\t| ')
  if err then print(err)
         else print 'PASSED'
  end
end
