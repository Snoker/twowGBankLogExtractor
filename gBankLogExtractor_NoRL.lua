local addonPrefix = "|cff33ff99[gBankLogExtractor]|r "
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")

-- Safe print function
local function Print(msg)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(addonPrefix .. tostring(msg))
    end
end

-- Function to store collected lines into saved variable
local function StoreGuildBankLog(lines, tabIndex)
    if not lines or table.getn(lines) == 0 then return end

    local snap = {
        scannedAt = time(),
        entries = {},
        tabIndex = tabIndex,
    }

    -- Each line becomes an entry (can parse later if needed)
    for _, line in ipairs(lines) do
        table.insert(snap.entries, line)
    end

    table.insert(GBankLogData, snap)

end


-- Collect visible log lines from the UI
local function CollectVisibleLogLines()
    if not GuildBankFrame or not GuildBankFrame:IsVisible() then
        return {}
    end

    local candidates = {
        GuildBankFrameLog,
        GuildBankFrameLogScrollFrame,
        guild_bank_log,
    }
    local lines, seen = {}, {}

    local function grabFromFrame(f)
        if not f or seen[f] then return end
        seen[f] = true

        -- Regions (FontStrings) AI generated code, but extracts text from UI elements.
        local ok, r1,r2,r3,r4,r5,r6,r7,r8,r9,r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31 = pcall(f.GetRegions, f)
        if ok then
            for _, r in ipairs({r1,r2,r3,r4,r5,r6,r7,r8,r9,r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31}) do
                if r and r.GetObjectType and r:GetObjectType()=="FontString" then
                    local txt = r:GetText()
                    if type(txt)=="string" and txt ~= "" then
                        table.insert(lines, txt)
                    end
                end
            end
        end

        -- Children # AI generated code, I have absolutely no idea what this does. But it works.
        local kidsOk, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,
            c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,
            c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31 = pcall(f.GetChildren, f)
        if kidsOk then
            for _, child in ipairs({c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,
                                    c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,
                                    c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31}) do
                if child then grabFromFrame(child) end
            end
        end

        
    end

    for _, f in ipairs(candidates) do grabFromFrame(f) end

    -- sanitize results
    local clean = {}
    for _, v in ipairs(lines) do
        if type(v) == "string" and v ~= "" then
            table.insert(clean, v)
        end
    end
    return clean

end


local function SnapshotGuildBankLog(tabIndex)
    GBankLogData = GBankLogData or {}
    
    local rawLines = CollectVisibleLogLines()
    if table.getn(rawLines) == 0 then
        Print("No log lines found on this tab.")
        return
    end
    Print("Debug: collected rawLines count = "..table.getn(rawLines))
    StoreGuildBankLog(rawLines, tabIndex)

end





-- Slash command
SlashCmdList = SlashCmdList or {}
SLASH_GB1 = "/GB"
SlashCmdList["GB"] = function(msg)
    if not (GuildBankFrame and GuildBankFrame:IsVisible()) then
        Print("Guild bank is not open. Open it first.")
        return
    end
    GuildBankFrameBottomTab_OnClick(2) -- go to log tab
    for i = 1, 5 do
        GuildBankFrameTab_OnClick(i)
        SnapshotGuildBankLog(i)
    end     
end

