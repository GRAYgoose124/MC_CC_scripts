local function energy_percent()
    reactor_energy = peripheral.call("back", "getEnergyStats")
    reserve_percent = reactor_energy["energyStored"] / reactor_energy["energyCapacity"]
    return reserve_percent
end

local function reactor_loop ()
    print("Starting reactor control loop")
        
    active = false
    tmprp = energy_percent()
    if tmprp > 0.95 then
        active = true
    end
        
    while true do
        reserve_percent = energy_percent()
        
        if reserve_percent < 0.50 and active ~= true then 
            print("Activating")
            peripheral.call("back", "setActive", true)
            active = true
        elseif reserve_percent > 0.95 and active then
            print("Deactivating")
            peripheral.call("back", "setActive", false)
            active = false
        end
        
        os.sleep(5)
    end
end

reactor_loop()