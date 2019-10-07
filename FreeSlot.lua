local function GetLowest()
    local items = {}
    local lowest = nil
    for bagID = 0, 4 do
        if GetContainerNumSlots(bagID) > 0 then
            for slot = 0, GetContainerNumSlots(bagID) do
                local _, itemCount, _, quality, _, _, itemLink = GetContainerItemInfo(bagID, slot)
                if (itemLink == nil or quality > 0) then
                else
                    table.insert(items, {(select(11, GetItemInfo(itemLink)))*itemCount, itemLink, itemCount, bagID, slot})
                end
            end
        end
    end

    for _,v in pairs(items) do
        if (lowest == nil or v[1] < lowest[1]) then lowest = v end
    end
    return lowest
end

local function GetFreeSlots()
    local freeSlots = 0
    for bagID = 0, 4 do
        freeSlots = freeSlots + GetContainerNumFreeSlots(bagID)
    end
    return freeSlots
end

local function Evaluate()
    if GetFreeSlots() <= 1 then
        local totalValue, itemLink, itemCount, bagID, slot = unpack(GetLowest())
        DEFAULT_CHAT_FRAME:AddMessage("Discarding "..itemLink.." x "..itemCount.." (Value: "..totalValue.."c) due to insufficent bag space.")
        PickupContainerItem(bagID, slot)
        DeleteCursorItem()
    end
end


local loot = CreateFrame("Frame")
loot:RegisterEvent("LOOT_READY")
loot:SetScript("OnEvent", Evaluate)

-- TODO: Figure out why discard message displays multiple times
-- TODO: Skip discard if item to pick up is worth less than current lowest value item in bags
-- TODO: Blacklist of non-greys that we want to allow discarding of anyway
-- TODO: Figure out inconsistency in one/zero slot being available
-- TODO: Handling for cases where we have no greys to toss