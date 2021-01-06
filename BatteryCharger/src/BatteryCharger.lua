-- Toplevel namespace that will hold everything
BatteryCharger = {}

BatteryCharger.name = "Battery Charger"

function BatteryCharger:Initalize()
    
end

function BatteryCharger.OnAddOnLoaded(event,  addonName)
    -- As this event is fired on every addon load, make sure that the event is for our addon
    if addonName == BatteryCharger.name then
        BatteryCharger.Initalize()
    end
end

--Register our OnAddOnLoaded function to the event manager
EVENT_MANAGER:RegisterForEvent(BatteryCharger.name, EVENT_ADD_ON_LOADED, BatteryCharger.OnAddOnLoaded)