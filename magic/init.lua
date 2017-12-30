-- Axes
--
--    ^ Z          facedir
--    |       ^ 0
--    |   3 <-+-> 1
--    |       | 2
--    +-----------> X
--
local beacon_base = {
  {
    {".", "c", "."},
    {"c", "c", "c"},
    {"c", "c", "c"},
    {".", "c", "."},
  },
  {
    {".",     "sbs:n", "."},
    {"sbs:w", "sb",    "sbs:e"},
    {"sbs:w", "sb",    "sbs:e"},
    {".",     "sbs:s", "."},
  },
  {
    {".", ".",   "."},
    {".", "sb",  "."},
    {".", "jwf", "."},
    {".", ".",   "."},
  },
  {
    repeat_count = 12,
    data = {
      {".", ".",   "."},
      {".", "t",  "."},
      {".", "jwf", "."},
      {".", ".",   "."},
    }
  },
  {
    {"jwc:se", "jws:n", "jwc:sw"},
    {"jws:w",  "jw",    "jws:e"},
    {"jwc:ne", "jws:s", "jwc:nw"},
    {".",      ".",     "."},
  },
  {
    {".", ".", "."},
    {".", "jw", "."},
    {".", ".", "."},
    {".", ".", "."},
  },
  {
    {".", ".", "."},
    {".", "cw", "."},
    {".", ".", "."},
    {".", ".", "."},
  },
  {
    {".", ".", "."},
    {".", "mpl", "."},
    {".", ".", "."},
    {".", ".", "."},
  },
}

function string:split(sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

local interpret_block_code = function(code)
  local fields = string.split(code, ":")
  return { type = fields[1], orientation = fields[2]}
end

local lookup_block_name = function(code_str)
  local code = interpret_block_code(code_str)

  if code["type"] == "c" then
    return "default:cobble"
  elseif code["type"] == "cw" then
    return "walls:cobble"
  elseif code["type"] == "sb" then
    return "default:stonebrick"
  elseif code["type"] == "sbs" then
    return "stairs:stair_stonebrick"
  elseif code["type"] == "jw" then
    return "default:junglewood"
  elseif code["type"] == "jws" then
    return "stairs:stair_junglewood"
  elseif code["type"] == "jwf" then
    return "default:fence_junglewood"
  elseif code["type"] == "jwc" then
    return "corners:jungle_wood"
  elseif code["type"] == "w" then
    return "default:wood"
  elseif code["type"] == "t" then
    return "default:tree"
  elseif code["type"] == "mpl" then
    return "default:mese_post_light"
  else
    return "default:unknown"
  end
end

local lookup_facedir = function(code_str)
  local code = interpret_block_code(code_str)

  if code["orientation"] == "s" then
    return 0
  elseif code["orientation"] == "n" then
    return 2
  elseif code["orientation"] == "e" then
    return 3
  elseif code["orientation"] == "w" then
    return 1
  elseif code["orientation"] == "ne" then
    return 0
  elseif code["orientation"] == "nw" then
    return 3
  elseif code["orientation"] == "se" then
    return 1
  elseif code["orientation"] == "sw" then
    return 2
  else
    return 0
  end
end

minetest.after(5, function()
  local level_index = 0

  for _, level in ipairs(beacon_base) do

    -- Handle optional 'repeat_count'
    local repeat_count = 1
    if level["repeat_count"] ~= nil then repeat_count = level["repeat_count"] end
    if level["data"] ~= nil then level = level["data"] end

    -- Loop for each copy
    for level_copy_index = 1,repeat_count do
      level_index = level_index + 1

      for row_index, row in ipairs(level) do
        for column_index, block_str in ipairs(row) do
          if block_str ~= "." then
            minetest.add_node({x = 325 + column_index, y = 3 + level_index, z = 4 - row_index},
                              { name = lookup_block_name(block_str),
                                param2 = lookup_facedir(block_str)
                              }
                             )
          end
        end
      end
    end
  end
end)
