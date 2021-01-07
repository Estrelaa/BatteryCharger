-- Toplevel namespace that will hold everything
BatteryCharger = {}

BatteryCharger.name = "BatteryCharger"


function BatteryCharger:FindSoulGems()
    local PlayerInventory = SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)

    for _, item in pairs(PlayerInventory) do
        if (IsItemSoulGem(SOUL_GEM_TYPE_FILLED,BAG_BACKPACK,item.slotIndex)) then
            return item.slotIndex
        end
    end
end

function BatteryCharger:TypeOfAttack(_, _, _,  _, ActionSlotType)
    local SoulGemSlot
    local ActiveWeapon, _
    
    if (ActionSlotType == 5 or ActionSlotType == 6) then
        ActiveWeapon, _ = GetActiveWeaponPairInfo()

        if (ActiveWeapon == 1)then
            if (IsItemChargeable(BAG_WORN, EQUIP_SLOT_MAIN_HAND)) then
                SoulGemSlot = BatteryCharger.FindSoulGems()
                --Check its charge value to make sure it super low or depleted
                if (GetChargeInfoForItem(BAG_WORN, EQUIP_SLOT_MAIN_HAND) < 125) then
                    d("Charging item")
                    ChargeItemWithSoulGem(BAG_WORN, EQUIP_SLOT_MAIN_HAND, BAG_BACKPACK, SoulGemSlot)
                end
            end
        end
        if (ActiveWeapon == 2) then
            if  IsItemChargeable(BAG_WORN, EQUIP_SLOT_BACKUP_MAIN) then
                --Check its charge value to make sure it super low or depleted
                d(GetItemLink(BAG_WORN, EQUIP_SLOT_BACKUP_MAIN))
            end
        end
    end
end

--Register our OnAddOnLoaded function to the event manager
EVENT_MANAGER:RegisterForEvent(BatteryCharger.name, EVENT_COMBAT_EVENT, BatteryCharger.TypeOfAttack)