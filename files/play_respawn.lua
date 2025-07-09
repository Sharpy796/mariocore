local player_id = GetUpdatedEntityID()
local dmgcomp = EntityGetFirstComponentIncludingDisabled(player_id,"DamageModelComponent")

function has_extra_life(entity)
    local lives = 0
    for _, child in ipairs(EntityGetAllChildren(entity) or {}) do
        local game_effect = EntityGetFirstComponent(child, "GameEffectComponent")
        if game_effect and ComponentGetValue2(game_effect, "effect") == "RESPAWN" then
            local counter = ComponentGetValue2(game_effect, "mCounter")
            if counter == 0 then
                lives = lives + 1
            end
        end
    end
    return lives ~= 0, lives
end

function damage_received( damage, desc, entity_who_caused, is_fatal )
    if (is_fatal) then
        if dmgcomp ~= nil then
            local hp = ComponentGetValue2(dmgcomp, "hp")*25
            local saving_grace = GameGetGameEffect(player_id, "SAVING_GRACE") ~= 0
            local extra_life, count = has_extra_life(player_id)
            if extra_life and not (saving_grace and hp > 1) then
                if count == 1 then
                    GamePlaySound("mods/mariocore/mariocore.bank", "mariocore/mario_death", 0, 0)
                else
                    GamePlaySound("mods/mariocore/mariocore.bank", "mariocore/mario_respawn", 0, 0)
                end
            end
        end
    end
end