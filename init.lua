ModRegisterAudioEventMappings("mods/mariocore/GUIDs.txt")

local perkluacontent = ModTextFileGetContent("data/scripts/perks/perk.lua")

local function escape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

perkluacontent = perkluacontent:gsub(escape("local flag_name = get_perk_picked_flag_name( perk_id )"), escape([[
local flag_name = get_perk_picked_flag_name( perk_id )

if( perk_id == "RESPAWN" ) then
    GamePlaySound("mods/mariocore/mariocore.bank", "mariocore/mario_1up", 0, 0)
end
]]))

function OnPlayerSpawned( player_entity )
    if not GameHasFlagRun("mariocore.luacomp_added") then
        local luacomp = EntityAddComponent2(player_entity, "LuaComponent")
        ComponentSetValue2(luacomp, "script_damage_received", "mods/mariocore/files/play_respawn.lua")
        GameAddFlagRun("mariocore.luacomp_added")
    end
end

ModTextFileSetContent("data/scripts/perks/perk.lua", perkluacontent)