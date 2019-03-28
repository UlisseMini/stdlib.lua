-- return a function that makes sure all the paramaters
-- are equal to the types provided, for example
-- typechecked = typecheck(string.len, "len", "string")
-- typechecked(10) --> "bad argument #1 to 'len' (string expected got number)"
local function typecheck(fn, name, ...)
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

-- part returns a function that executes fn with all the arguments passed
-- to part plus any others.
local function part(fn, ...)
  if type(fn) ~= 'function' then
   error("bad argument #1 to 'part' (function expected, got "..type(fn)..")")
  end

  local args = table.pack(...)
  return function(...)
    local args2 = {...}
    local ret = {pcall(function()
      return fn(table.unpack(args), table.unpack(args2))
    end)}

    if ret[1] == false then
      error(ret[2], 2)
    else
      return table.unpack(ret, 2, #ret)
    end
  end
end

function table:map(fn)
  local result = {}
  for i,v in next, self do
    result[i] = fn(v)
  end

  return result
end
table.map = typecheck(table.map, "map", "table", "function")

function string.map(s, fn)
  return string.gsub(s, '.', fn)
end
string.map = typecheck(string.map, "map", "string", "function")

-- Return the exported functions.
return {
  part = part,
  typecheck = typecheck,
}
