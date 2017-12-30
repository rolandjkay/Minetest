-- Axes
--
--    ^ Z          facedir
--    |       ^ 0
--    |   3 <-+-> 1
--    |       | 2
--    +-----------> X
--
local tower = {
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

local block_codes = {
  c = "default:cobble",
  cw = "walls:cobble",
  sb = "default:stonebrick",
  sbs = "stairs:stair_stonebrick",
  jw = "default:junglewood",
  jws = "stairs:stair_junglewood",
  jwf = "default:fence_junglewood",
  jwc = "corners:jungle_wood",
  w = "default:wood",
  t = "default:tree",
  mpl = "default:mese_post_light",
}

local interpret_block_code = function(code)
  local fields = string.split(code, ":")
  return { type = fields[1], orientation = fields[2]}
end

local lookup_block_name = function(code_str)
  local code = interpret_block_code(code_str)
  local block_name = block_codes[code["type"]]

  return block_name == nil and "default:unknown" or block_name
end

local orientation_codes = {
  -- Codes for stars
  s = 0,
  n = 2,
  e = 3,
  w = 1,
  -- Codes for corners
  ne = 0,
  nw = 3,
  se = 1,
  sw = 2
}

local lookup_facedir = function(code_str)
  local code = interpret_block_code(code_str)
  local orientation = orientation_codes[code["orientation"]]
  return orientation == nil and 0 or orientation
end

minetest.after(5, function()
  local level_index = 0

  for _, level in ipairs(tower) do

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
