-- Toplevel namespace that will hold everything
BatteryCharger = {}

BatteryCharger.name = "BatteryCharger"
--If the charge left on the weapon is less than the value below, it will charge the weapon
BatteryCharger.ChargeTheshold = 3

-- We do this check to reduce the amount of times that FindSoulGems in called
function BatteryCharger.IsWeaponAttack(AttackType)
    if (AttackType == 5 or AttackType == 6) then
        return true
    else
        return false
    end
end

function BatteryCharger.ChargeWeapon(EquipmentSlot)
    local SoulGemSlot

    if (IsItemChargeable(BAG_WORN, EQUIP_SLOT_MAIN_HAND)) then
        SoulGemSlot = BatteryCharger.FindSoulGems()
        --Check its charge value to make sure it super low or depleted
        if (GetChargeInfoForItem(BAG_WORN, EQUIP_SLOT_MAIN_HAND) < BatteryCharger.ChargeTheshold) then
            d("Charging item")
            ChargeItemWithSoulGem(BAG_WORN, EQUIP_SLOT_MAIN_HAND, BAG_BACKPACK, SoulGemSlot)
        end
    end
end

-- Gets the first soul gem found in the player's inventory
function BatteryCharger:FindSoulGems()
    local PlayerInventory = SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)

    for _, item in pairs(PlayerInventory) do
        if (IsItemSoulGem(SOUL_GEM_TYPE_FILLED,BAG_BACKPACK,item.slotIndex)) then
            return item.slotIndex
        end
    end
end

function BatteryCharger:Main(_, _, _,  _, AttackType)
    local ActiveWeapon, _
    
    if (BatteryCharger.IsWeaponAttack(AttackType)) then
        ActiveWeapon, _ = GetActiveWeaponPairInfo()

        if (ActiveWeapon == 1)then
            BatteryCharger.ChargeWeapon(EQUIP_SLOT_MAIN_HAND)
        end
        if (ActiveWeapon == 2) then
            BatteryCharger.ChargeWeapon(EQUIP_SLOT_BACKUP_MAIN)
        end
    end
end

EVENT_MANAGER:RegisterForEvent(BatteryCharger.name, EVENT_COMBAT_EVENT, BatteryCharger.Main)