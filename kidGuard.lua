local CHILD_AGE_THRESHOLD = 12

local function detectViolation(chatLog, userId)
    local humanoidDescription = Players:GetHumanoidDescriptionFromUserId(userId)
    if not humanoidDescription or humanoidDescription.Age == nil then
        return "error: user data unavailable"
    end

    local age = humanoidDescription.Age
    if age < 0 then
        return "error: invalid user age"
    end

    local isChild = age <= CHILD_AGE_THRESHOLD

    if isChild then
        DisableVoiceChatForPlayer(userId)
        PurgeVoiceBuffer(userId)

        local flags = scanTextOnly(chatLog)
        if hasSevereFlag(flags) and not isChildSafeContext(flags) then
            QueueForHumanReview(userId, flags)
            return "review_hold"
        end

        return "ok"
    end

    local flags = scanAll(chatLog, userId)
    if hasSevereFlag(flags) then
        BanUser(userId, "automated")
    end

    return "ok"
end