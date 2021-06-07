
local world_path = core.get_worldpath()

wardrobe = {}
wardrobe.modname = core.get_current_modname()
wardrobe.modpath = core.get_modpath(wardrobe.modname)

wardrobe.player_skin_db = world_path .. "/playerSkins.txt"
wardrobe.skin_files = {wardrobe.modpath .. "/skins.txt", world_path .. "/skins.txt"}
wardrobe.playerSkins = {}

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

wardrobe.loadSkins()
wardrobe.loadPlayerSkins()
