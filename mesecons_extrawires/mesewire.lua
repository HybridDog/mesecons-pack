local mesewire_rules =
{
	{x = 1, y = 0, z = 0},
	{x =-1, y = 0, z = 0},
	{x = 0, y = 1, z = 0},
	{x = 0, y =-1, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z =-1},
}

minetest.override_item("default:mese", {
	mesecons = {conductor = {
		state = mesecon.state.off,
		onstate = "mesecons_extrawires:mese_powered",
		rules = mesewire_rules
	}}
})

-- Copy node definition of powered mese from normal mese
-- and brighten to indicate mese is powered
local to_copy = {"use_texture_alpha", "post_effect_color", "walkable",
	"pointable", "diggable", "climbable", "buildable_to",
	"damage_per_second", "sounds", "drawtype", "paramtype", "paramtype2",
	"sunlight_propagates", "is_ground_content"}

local origdef = minetest.registered_nodes["default:mese"]
local def = {}
for _,i in pairs(to_copy) do
	def[i] = rawget(origdef, i)
end
def.tiles = {}
for i,v in pairs(origdef.tiles) do
	def.tiles[i] = v .. "^[brighten"
end
def.drop = "default:mese"
def.light_source = 5
def.groups = table.copy(origdef.groups)
def.groups.not_in_creative_inventory = 1
def.on_blast = mesecon.on_blastnode
def.mesecons = {conductor = {
	state = mesecon.state.on,
	offstate = "default:mese",
	rules = mesewire_rules
}}

minetest.register_node("mesecons_extrawires:mese_powered", def)
