--- Calculates credits length
--- @private
function LU_d:DeathCalculateCreditsLength()
    self.credits.scroll_speed = tonumber(MagicNumbersGetValue("CREDITS_SCROLL_SPEED")) or 25
    self.credits.scroll_speed_multiplier = tonumber(MagicNumbersGetValue("CREDITS_SCROLL_SKIP_SPEED_MULTIPLIER")) or 15
    local offset = tonumber(MagicNumbersGetValue("CREDITS_SCROLL_END_OFFSET_EXTRA")) or 85
    local credits = ModTextFileGetContent("data/credits.txt")
    local credits_lines = 0
    for _ in credits:gmatch("[^\n]+") do
        credits_lines = credits_lines + 1
    end
    local _, height = self:GetTextDimension("A")
    local extra_lines = 37 -- two empty screens + 4 extra lines on start - logo at the end
    local total_distance = (credits_lines + extra_lines) * height
    self.credits.speed_up_until_frame = total_distance * 60
    self.credits.total_distance = self.credits.speed_up_until_frame + offset * 60 - 60
end

---Returns true is credits is playing
---@return boolean
---@nodiscard
function LU_d:DeathIsCreditsPlaying()
    if not self.credits.total_distance then self:DeathCalculateCreditsLength() end
    if GameHasFlagRun("ending_game_completed") and self.credits.frame < self.credits.total_distance then
        local scroll_speed = self.credits.scroll_speed
        -- don't speedup for last part (logo fade out)
        if InputIsKeyDown(self.c.codes.keyboard.space) and self.credits.frame < self.credits.speed_up_until_frame then
            scroll_speed = scroll_speed * self.credits.scroll_speed_multiplier
        end
        self.credits.frame = self.credits.frame + scroll_speed
        return true
    end
    return false
end