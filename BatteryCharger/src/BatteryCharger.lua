BatteryCharger = {}

BatteryCharger.AddonName = "Battery Charger"
--If the charge left on the weapon is less than the value below, we will charge the weapon
BatteryCharger.ChargeTheshold = 3

-- We do this check to reduce the amount of times that FindSoulGems in called 
local function IsWeaponAttack(AttackType)
    if (AttackType == 5 or AttackType == 6) then
        return true
    else
        return false
    end
end

-- Gets the first soul gem found in the player's inventory
local function FindSoulGems()
    local PlayerInventory = SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)

    for _, item in pairs(PlayerInventory) do
        if (IsItemSoulGem(SOUL_GEM_TYPE_FILLED,BAG_BACKPACK,item.slotIndex)) then
            return item.slotIndex
        end
    end
end

local function ChargeWeapon(EquipmentSlot)
    local SoulGemSlot

    if (IsItemChargeable(BAG_WORN, EQUIP_SLOT_MAIN_HAND)) then
        SoulGemSlot = FindSoulGems()
        --Check its charge value to make sure it super low or depleted
        if (GetChargeInfoForItem(BAG_WORN, EQUIP_SLOT_MAIN_HAND) < BatteryCharger.ChargeTheshold) then
            ChargeItemWithSoulGem(BAG_WORN, EQUIP_SLOT_MAIN_HAND, BAG_BACKPACK, SoulGemSlot)
            d("Charge equiped weapon")
        end
    end
end


local function Main(_, _, _,  _, AttackType)
    local ActiveWeapon, _
    
    if (IsWeaponAttack(AttackType)) then
        ActiveWeapon, _ = GetActiveWeaponPairInfo()

        if (ActiveWeapon == 1)then
            ChargeWeapon(EQUIP_SLOT_MAIN_HAND)
        end
        if (ActiveWeapon == 2) then
            ChargeWeapon(EQUIP_SLOT_BACKUP_MAIN)
        end
    end
end

-- We use the combat event because it triggers numberous times a second which allows us to
-- check the weapon charge frequenly without destroying peoples computers
EVENT_MANAGER:RegisterForEvent(BatteryCharger.name, EVENT_COMBAT_EVENT, Main)