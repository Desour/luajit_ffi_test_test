
local bench_get_content_id = false

-- deactivate mod security to use jdump ("jit.dump" also uses require)
local insec_env = minetest.request_insecure_environment()
local jdump = insec_env.require("jit.dump")

local table1 = {}

if bench_get_content_id then

	local time_start = minetest.get_us_time()

	--~ jdump.on()

	for i = 1, 10000000 do
		minetest.get_content_id("default:dirt")
		--~ unpack(table1)
	end

	--~ jdump.off()

	local dtime = minetest.get_us_time() - time_start
	minetest.log("action", "time taken: " .. (dtime / 1000) .. " ms")

end

local get_node_radius = 120
minetest.register_chatcommand("bench_get_node", {
	params = "",
	description = "Perform benchmark for get_node by using it at a cube around the player",
	privs = {},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()

		local x_min = pos.x - get_node_radius
		local y_min = pos.y - get_node_radius
		local z_min = pos.z - get_node_radius
		local x_max = pos.x + get_node_radius
		local y_max = pos.y + get_node_radius
		local z_max = pos.z + get_node_radius

		local time_start = minetest.get_us_time()
		--~ jdump.on()

		for x = x_min, x_max do
			for y = y_min, y_max do
				for z = z_min, z_max do
					pos.x = x
					pos.y = y
					pos.z = z
					minetest.get_node(pos)
				end
			end
		end

		--~ jdump.off()
		--~ return true, ""
		local dtime = minetest.get_us_time() - time_start
		return true, "time taken: " .. (dtime / 1000) .. " ms"
	end,
})
