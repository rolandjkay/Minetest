
function string:split(sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

local function capitalizeFirst(word)
  return string.upper(string.sub(word, 1, 1)) .. string.sub(word, 2)
end

-- Convert a machine readable name like "acacia_wood" into humane
-- readable "Acacia Wood"
--
local function convertName(machine_name)
  local words = machine_name:split("_")
  
  local new_words = {}
  for n, word in ipairs(words) do
    table.insert(new_words, capitalizeFirst(word))
  end
  
  return table.concat(new_words, " ") 
end

local function rotate_and_place(itemstack, placer, pointed_thing)
    local p0 = pointed_thing.under
    local p1 = pointed_thing.above
    local param2 = 0

    local placer_pos = placer:getpos()
    if placer_pos then
        param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
    end

    local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
    local fpos = finepos.y % 1

    if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
                or (fpos < -0.5 and fpos > -0.999999999) then
        param2 = param2 + 20
        if param2 == 21 then
            param2 = 23
        elseif param2 == 23 then
            param2 = 21
        end
    end

    return minetest.item_place(itemstack, placer, pointed_thing, param2)
end

local function register_corner(name, image_name)
    if image_name == nil then 
      image_name = "default_" .. name
    end
  
    minetest.register_node("corners:" .. name, {
        description = convertName(name) .. " Stair Corner",
        paramtype2 = "facedir",
        groups = {cracky = 3},
        sounds = sound_stone,
        tiles = {image_name .. ".png"}, 
        drawtype = "nodebox",
        node_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
                {0, 0, 0, 0.5, 0.5, 0.5},
            },
        },
        on_place = function(itemstack, placer, pointed_thing)
                       if pointed_thing.type ~= "node" then
                           return itemstack
                       end

                       return rotate_and_place(itemstack, placer, pointed_thing)
                   end,
    })
end

-- Register all corner types
register_corner("brick")
register_corner("acacia_wood")
register_corner("aspen_wood")
register_corner("bronze_block")
register_corner("cobblestone", "default_cobble")
register_corner("desert_cobblestone", "default_desert_cobble")
register_corner("desert_sandstone")
register_corner("desert_sandstone_brick")
register_corner("desert_stone")
register_corner("desert_stone_brick")
register_corner("gold_block")
register_corner("ice")
register_corner("jungle_wood", "default_junglewood")
register_corner("mossy_cobblestone", "default_mossycobble")
register_corner("obsidian")
register_corner("obsidian_brick")
register_corner("pine_wood")
register_corner("sandstone")
register_corner("sandstone_brick")
register_corner("silver_sandstone")
register_corner("silver_sandstone_brick")
register_corner("snow")
register_corner("steel", "default_steel_block")
register_corner("stone")
register_corner("stone_brick")
register_corner("straw", "farming_straw")
register_corner("wooden", "default_wood")


