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

local well = {
  {
    offset = {x = 0, y = -2, z = 0},
    data = {
      {"c", "c", "c", "c", "c"},
      {"c", "c", "c", "c", "c"},
      {"c", "c", "c", "c", "c"},
      {"c", "c", "c", "c", "c"}
    }
  },
  {
    {"c", "c",  "c",  "c",  "c"},
    {"c", "rw", "rw", "rw", "c"},
    {"c", "rw", "rw", "rw", "c"},
    {"c", "c",  "c",  "c",  "c"}
  },
  {
    {"sb", "c",  "cs:s",  "c",  "sb"},
    {"c",  "rw", "rw",    "rw", "c"},
    {"c",  "rw", "rw",    "rw", "c"},
    {"sb", "c",  "cs:n",  "c",  "sb"},
  },
  {
    {"cw", ".", ".",  ".", "cw"},
    {".",  ".", ".",  ".", "."},
    {".",  ".", ".",  ".", "."},
    {"cw", ".", ".",  ".", "cw"},
  },
  {
    {"wf", ".", ".",  ".", "wf"},
    {".",  ".", ".",  ".", "."},
    {".",  ".", ".",  ".", "."},
    {"wf", ".", ".",  ".", "wf"},
  },
  {
    {"wf", "wf", "wf", "wf", "wf"},
    {"wf", ".",  "wf", ".",  "wf"},
    {"wf", ".",  "wf", ".",  "wf"},
    {"wf", "wf", "wf", "wf", "wf"},
  },
  {
    {"mpl", ".", ".", ".", "mpl"},
    {".",   ".", ".", ".", "."},
    {".",   ".", ".", ".", "."},
    {"mpl", ".", ".", ".", "mpl"},
  }
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
  cs = "stairs:stair_cobble",
  sb = "default:stonebrick",
  sbs = "stairs:stair_stonebrick",
  jw = "default:junglewood",
  jws = "stairs:stair_junglewood",
  jwf = "default:fence_junglewood",
  wf = "default:fence_wood",
  jwc = "corners:jungle_wood",
  w = "default:wood",
  t = "default:tree",
  mpl = "default:mese_post_light",
  rw = "default:river_water_source",
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

local create_object = function(position, object_data)
  local level_index = 0
  local offset = { x = 0, y = 0, z = 0 }

  for _, level in ipairs(object_data) do

    -- Handle optional 'repeat_count'
    local repeat_count = 1
    if level["repeat_count"] ~= nil then repeat_count = level["repeat_count"] end

    -- Check for offsets; this is mainly used to allow buildings to have
    -- foundations or cellars underground.
    if level["offset"] ~= nil then
      for _, ordinate in ipairs({"x","y","z"}) do
        if level["offset"][ordinate] ~= nil then
           offset[ordinate] = offset[ordinate] + level["offset"][ordinate]
         end
      end
    end

    -- The actual data might be nested in a 'data' node.
    if level["data"] ~= nil then level = level["data"] end

    -- Loop for each copy
    for level_copy_index = 1,repeat_count do
      level_index = level_index + 1

      for row_index, row in ipairs(level) do
        for column_index, block_str in ipairs(row) do
          if block_str ~= "." then
            minetest.add_node({x = position.x + offset["x"] + column_index,
                               y = position.y + offset["y"] + level_index,
                               z = position.z + offset["z"] + row_index},
                              { name = lookup_block_name(block_str),
                                param2 = lookup_facedir(block_str)
                              }
                             )
          end
        end
      end
    end
  end
end

local register_hat = function(name, description, tiles, message, object_data)
  minetest.register_node("magic:" .. name, {
      description = description,
      groups = {cracky = 3},
      sounds = sound_stone,
      tiles = tiles,
      drawtype = "normal",
      on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        minetest.chat_send_all(message)
        create_object({x = pos.x, y = pos.y - 1, z = pos.z}, object_data)
      end
  })
end

register_hat("tower_hat", "Magician's Tower Hat", {"default_leaves.png"}, "Abracabara Simsalabim. Behold a Tower!", tower)
register_hat("well_hat", "Magician's Well Hat", {"default_stone.png^default_mineral_mese.png"}, "Abracabara Simsalabim. Behold a Well!", well)
