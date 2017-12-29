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
    {".",   "sbn", "."},
    {"sbw", "sb",  "sbe"},
    {"sbw", "sb",  "sbe"},
    {".",   "sbs", "."},
  },
  {
    {".", ".",   "."},
    {".", "sb",  "."},
    {".", "jwf", "."},
    {".", ".",   "."},
  },
}

local lookup_block_name = function(str) 
  local str_prefix = string.sub(str, 1, 2)
  
  if str == "c" then
    return "default:cobble"
  elseif str == "sb" then
    return "default:stonebrick"
  elseif str_prefix == "sb" then
    return "stairs:stair_stonebrick"
  elseif str == "jwf" then
    return "default:fence_junglewood"
  else
    return "default:unknown"
  end
end

local lookup_facedir = function(str) 
  local str_suffix = string.sub(str, 3)
  minetest.log("warning", str_suffix)
  
  if str_suffix == "s" then
    return 0
  elseif str_suffix == "n" then
    return 2
  elseif str_suffix == "e" then
    return 3
  elseif str_suffix == "w" then
    return 1
  else
    return 0
  end
end

minetest.after(5, function()
  for level_index, level in ipairs(beacon_base) do
    for row_index, row in ipairs(level) do
      for column_index, block_str in ipairs(row) do
        if block_str ~= "." then
          minetest.log("warning", tostring(column_index) .. "," .. tostring(level_index) .. "," .. tostring(row_index) .. ":" .. block_str .. ":" .. tostring(lookup_facedir(block_str)) )
          minetest.add_node({x = 325 + column_index, y = 3 + level_index, z = 4 - row_index}, 
                            { name = lookup_block_name(block_str),
                              param2 = lookup_facedir(block_str)
                            }
                           )
        else
          minetest.log("warning", tostring(column_index) .. "," .. tostring(level_index) .. "," .. tostring(row_index) .. ":skipping")
        end
      end
    end
  end
end)

