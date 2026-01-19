local CHILD_AGE_THRESHOLD = 12

local function detectViolation(chatLog, userId)
    -- Attempt to retrieve user's humanoid description
    local humanoidDescription = Players:GetHumanoidDescriptionFromUserId(userId)

    if not humanoidDescription then
        -- Log missing humanoid description for audit
        LogError("Missing humanoid description for userId: " .. userId)
        return "error: user data unavailable"
    end

    local age = humanoidDescription.Age

    -- Validate age
    if not age or age < 0 then
        LogError("Invalid age retrieved for userId: " .. userId)
        return "error: invalid user age"
    end

    local isChild = age <= CHILD_AGE_THRESHOLD

    if isChild then
        -- Handle child users
        DisableVoiceChatForPlayer(userId)
        PurgeVoiceBuffer(userId)

        local flags = scanTextOnly(chatLog)
        if hasSevereFlag(flags) and not isChildSafeContext(flags) then
            -- Log for human review
            LogWarning("Severe flags detected for child userId: " .. userId .. " Flags: " .. tostring(flags))
            QueueForHumanReview(userId, flags)
            return "review_hold"
        end

        LogInfo("Child userId: " .. userId .. " has passed checks.")
        return "ok"
    else
        -- Handle adult users with established filters
        local flags = scanAll(chatLog, userId)
        if hasSevereFlag(flags) then
            LogWarning("Adult userId: " .. userId .. " banned due to severe flags.")
            BanUser(userId, "automated")
        end

        LogInfo("Adult userId: " .. userId .. " has passed checks.")
        return "ok"
    end
end


local function rateLimit(userId)
    -- Implementation of rate limiting logic
end

-- 