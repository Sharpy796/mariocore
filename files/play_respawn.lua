function damage_received( damage, desc, entity_who_caused, is_fatal )
    if (is_fatal) then
        GamePlaySound("mods/mariocore/mariocore.bank", "mariocore/mario_death", 0, 0)
    end
end