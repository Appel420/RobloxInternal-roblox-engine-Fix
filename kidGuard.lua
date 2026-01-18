local function detectViolation(chatLog, userId)
    local age = Players:GetHumanoidDescriptionFromUserId(userId).Age  -- or verified age endpoint
    local isChild = age and age <= 12

    if isChild then
        -- never auto-ban, never store voice, drop buffers
        DisableVoiceChatForPlayer(userId)
        PurgeVoiceBuffer(userId)

        local flags = scanTextOnly(chatLog)
        if hasSevereFlag(flags) and not isChildSafeContext(flags) then
            QueueForHumanReview(userId, flags)  -- hold + manual
            return "review_hold"
        end
        return "ok"
    else
        -- adult path: existing aggressive filters stay
        local flags = scanAll(chatLog, userId)
        if hasSevereFlag(flags) then
            BanUser(userId, "automated")
        end
        return "ok"
    end
end