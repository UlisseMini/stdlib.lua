local std = require 'stdlib'

-- Test helper functions
local t = {}
function t.Eq(a, b)
  if a ~= b then
    error(
      ('want %q, got %q'):format(a, b)
      , 2)
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

-- Run the tests
for tname, tc in pairs(test) do
  local _, err = pcall(tc)

  io.write(tname..'   | ')
  if err then print(err)
         else print 'PASSED'
  end
end
