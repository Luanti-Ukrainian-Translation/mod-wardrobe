
local world_path = core.get_worldpath()

wardrobe = {}
wardrobe.modname = core.get_current_modname()
wardrobe.modpath = core.get_modpath(wardrobe.modname)

wardrobe.player_skin_db = world_path .. "/playerSkins.txt"
wardrobe.skin_files = {wardrobe.modpath .. "/skins.txt", world_path .. "/skins.txt"}
wardrobe.playerSkins = {}

wardrobe.use_3d_armor = core.get_modpath("3d_armor") ~= nil and core.global_exists("armor")

-- suppresses showing preview if not cached
wardrobe.cached_previews = {}

function wardrobe.log(lvl, msg)
	if not msg then
		msg = lvl
		lvl = nil
	end

	msg = "[" .. wardrobe.modname .. "] " .. msg
	if not lvl then
		core.log(msg)
	else
		core.log(lvl, msg)
	end
end


local scripts = {
	"settings",
	"api",
	"formspec",
	"node",
}

for _, script in ipairs(scripts) do
	dofile(wardrobe.modpath .. "/" .. script .. ".lua")
end

-- workaround for not using mod name "wardrobe" which is registered with 3d_armor
if wardrobe.use_3d_armor and armor.set_skin_mod then
	armor.set_skin_mod("wardrobe")
end

wardrobe.loadSkins()
wardrobe.loadPlayerSkins()

local cached_textures = {}
core.register_on_mods_loaded(function()
	wardrobe.log("action", "checking cached skins ...")

	for _, modname in ipairs(core.get_modnames()) do
		local t_dir = core.get_modpath(modname) .. "/textures"
		for _, png in ipairs(core.get_dir_list(t_dir, false)) do
			if png:find("%.png$") then
				cached_textures[png] = true
			end
		end
	end

	for idx = wardrobe.skin_count, 1, -1 do
		local skin = wardrobe.skins[idx]
		if not cached_textures[skin] then
			wardrobe.log("error", "skin \"" .. skin .. "\" not found")
			table.remove(wardrobe.skins, idx)
			wardrobe.skinNames[skin] = nil
			wardrobe.skin_count = wardrobe.skin_count-1
		end

		local preview = skin:gsub("%.png$", "-preview.png")
		if cached_textures[preview] then
			wardrobe.cached_previews[skin] = true
		end
	end

	cached_textures = nil
end)
