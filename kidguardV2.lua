local CHILD_AGE_THRESHOLD = 12

local function detectViolation(chatLog, userId)
    local humanoidDescription = Players:GetHumanoidDescriptionFromUserId(userId)
    if not humanoidDescription or humanoidDescription.Age == nil then
        LogError("Missing or invalid humanoid description for userId: " .. tostring(userId))
        return "error: user data unavailable"
    end

    local age = humanoidDescription.Age
    if age < 0 then
        LogError("Invalid age retrieved for userId: " .. tostring(userId))
        return "error: invalid user age"
    end

    local isChild = age <= CHILD_AGE_THRESHOLD

    if isChild then
        DisableVoiceChatForPlayer(userId)
        PurgeVoiceBuffer(userId)

        local flags = scanTextOnly(chatLog)
        if hasSevereFlag(flags) and not isChildSafeContext(flags) then
            LogWarning("Child account sent to human review for userId: " .. tostring(userId))
            QueueForHumanReview(userId, flags)
            return "review_hold"
        end

        LogInfo("Child userId: " .. tostring(userId) .. " has passed checks.")
        return "ok"
    end

    local flags = scanAll(chatLog, userId)
    if hasSevereFlag(flags) then
        LogWarning("Adult userId: " .. tostring(userId) .. " banned due to severe flags.")
        BanUser(userId, "automated")
    end

    LogInfo("Adult userId: " .. tostring(userId) .. " has passed checks.")
    return "ok"
end

local function rateLimit(userId)
    -- Implementation of rate limiting logic
end