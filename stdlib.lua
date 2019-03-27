-- return a function that makes sure all the paramaters
-- are equal to the types provided, for example
-- fn = typecheck(string.len, "string")
-- fn(10) --> "bad argument #1 to 'len' (string expected got number)"
function typecheck(fn, name, ...)
  if type(fn) ~= "function" then
    error(
      "bad argument #1 to 'typecheck' (want function got "..type(fn)..")", 2)
  elseif type(name) ~= "string" then
    error(
      "bad argument #2 to 'typecheck' (want string got "..type(name)..")", 2)
  end

  local wants = {...}
  return function(...)
    local args = {...}
    for i,want in pairs(wants) do
      if type(args[i]) ~= want then
        error(
          string.format(
            "bad argument #%d to '%s' (%s expected got %s)",
              i, name, want, type(args[i])
              )
          , 3)
      end
    end

    return fn(...)
  end
end

-- lazy returns a function that executes fn with all the arguments passed
-- to lazy plus any others.
function lazy(fn, ...)
  local args = table.pack(...)
  return function(...)
    return fn(table.unpack(args), ...)
  end
end
lazy = typecheck(lazy, "lazy", "function")

-- map over a table and set the every key to the result of fn applied to the
-- value.
function table:map(fn)
  local result = {}
  for i,v in next, self do
    result[i] = fn(v)
  end

  return result
end
table.map = typecheck(table.map, "map", "table", "function")

-- Return the exported functions.
return {
  lazy = lazy,
  typecheck = typecheck,
}
