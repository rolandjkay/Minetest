
-- minetest.register_on_punchnode(
--    function(pos, node, puncher)
--             minetest.chat_send_all("Hey!!  Stop it!!  That hurts")
--    end
--)


local function rotate_and_place(itemstack, placer, pointed_thing)
    local p0 = pointed_thing.under
    local p1 = pointed_thing.above
    local param2 = 0

    local placer_pos = placer:getpos()
    if placer_pos then
        param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
        minetest.chat_send_all(p0.x .. ",".. p0.y .. "," .. p0.z)
        minetest.chat_send_all(p1.x .. ",".. p1.y .. "," .. p1.z)
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


minetest.register_node("corners:acacia", {
    description = "Acacia Stair Corner",
    paramtype2 = "facedir",
    groups = {cracky = 3},
    sounds = sound_stone,
    tiles = {"default_acacia_wood.png"}, 
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

-- minetest.register_alias("corner", "corner_blocks:acacia")

