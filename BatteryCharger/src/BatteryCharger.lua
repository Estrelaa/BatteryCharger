-- Toplevel namespace that will hold everything
BatteryCharger = {}

BatteryCharger.name = "BatteryCharger"

function BatteryCharger:TypeOfAttack(_, _, _,  _, ActionSlotType)
    local SoulGemSlot
    local MainHandChargeInformation
    local OffhandChargeInformation
    local ActiveWeapon, _
    
    if (ActionSlotType == 5 or ActionSlotType == 6) then
        ActiveWeapon, _ = GetActiveWeaponPairInfo()

        if (ActiveWeapon == 1)then
            if IsItemChargeable(BAG_WORN, EQUIP_SLOT_MAIN_HAND) then
                --Check its charge value to make sure it super low or depleted
                d(GetItemLink(BAG_WORN, EQUIP_SLOT_MAIN_HAND))
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