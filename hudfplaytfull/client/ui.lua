local speed = 0.0
local seatbeltOn = false
local cruiseOn = false

local bleedingPercentage = 0

local stress = 0
local StressGain = 0
local IsGaining = false

local hunger = 100
local thirst = 100

local toggleHud = true

local mumbleInfo = 2

local radarActive = false
local radarSettings = true

RegisterNetEvent('srp-hud:toggleHud')
AddEventHandler('srp-hud:toggleHud', function(toggleHud1)
    toggleHud = toggleHud1
end)

RegisterNetEvent('srp-hud:client:openHudSettings')
AddEventHandler('srp-hud:client:openHudSettings', function()
	SetNuiFocus(true, true)
    SendNUIMessage({
        action = "HudSettings"
    })	
end)

RegisterCommand("hudd",function()
    TriggerEvent('srp-hud:client:openHudSettings')
end)

RegisterNetEvent('srp-hud:client:closeNUI')
AddEventHandler('srp-hud:client:closeNUI', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('closeUI', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('toggleMinimap', function(data)
    radarActive = data.status
	radarSettings = data.status
	DisplayRadar(false)
end)

local fuel = 0

Citizen.CreateThread(function()
    Citizen.Wait(500)
    while true do 
		speed = GetEntitySpeed(GetVehiclePedIsIn(GLOBAL_PED, false)) * 3.6
		local pos = GetEntityCoords(GLOBAL_PED)
		local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
		if IsPedInAnyVehicle(GLOBAL_PED, false) then
		fuel = math.floor(GetVehicleFuelLevel(GetVehiclePedIsIn(GLOBAL_PED, false))+0.0)	
		end
		local engine = GetVehicleEngineHealth(GetVehiclePedIsIn(GLOBAL_PED))
		local stamina = (100 - GetPlayerSprintStaminaRemaining(GLOBAL_PLYID))
		local inwater = IsPedSwimmingUnderWater(GLOBAL_PED)
		local oxygen = GetPlayerUnderwaterTimeRemaining(GLOBAL_PLYID)
		local veh = GetVehiclePedIsIn(GLOBAL_PED, false)
		local flyer = IsPedInAnyPlane(GLOBAL_PED) or IsPedInAnyHeli(GLOBAL_PED)
		local altitude = false
		
		if flyer then
			altitude = math.floor(GetEntityHeightAboveGround(veh) * 3.28084)
		end

		SendNUIMessage({
			action = "hudtick",
			show = IsPauseMenuActive(),
			--show = true,
			health = GetEntityHealth(GLOBAL_PED),
			armor = GetPedArmour(GLOBAL_PED),
			bleeding = bleedingPercentage,
			thirst = mythirst,
			hunger = myhunger,
			stress = stress,
			street1 = GetStreetNameFromHashKey(street1),
			street2 = GetStreetNameFromHashKey(street2),
			area_zone = current_zone,
			speed = math.ceil(speed),
			altitude = altitude,
			altitudeShow = altitude ~= false,
			fuel = fuel,
			engine = engine,
			stamina = stamina,
			inwater = inwater,
			oxygen = oxygen,
			togglehud = true,
			mumble = mumbleInfo,
			talking = talking,
			vehicleCruiser = vehicleCruiser,
			--togglehud = toggleHud
			
		})
		Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(500)
        TriggerServerEvent("get_Status")
        if IsPedInAnyVehicle(PlayerPedId()) and radarSettings then
            
            SendNUIMessage({
                action = "car",
                show = true,
            })
            radarActive = true
        else
            SendNUIMessage({
                action = "car",
                show = false,
            })
            seatbeltOn = false
            cruiseOn = false

            SendNUIMessage({
                action = "seatbelt",
                seatbelt = seatbeltOn,
            })

            SendNUIMessage({
                action = "cruise",
                cruise = cruiseOn,
            })
            radarActive = false
        end
    end
end)

RegisterNetEvent('mumble:updateMumbleInfo')
AddEventHandler('mumble:updateMumbleInfo', function(mode)
	mumbleInfo = mode
	-- 1 - Whisper
	-- 2 - Normal
	-- 3 - Shouting
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = seatbeltOn,
        })
    else
        seatbeltOn = toggle
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = toggle,
        })
    end
end)

RegisterNetEvent('srp-hud:client:ToggleHarness')
AddEventHandler('srp-hud:client:ToggleHarness', function(toggle)
    SendNUIMessage({
        action = "harness",
        toggle = toggle
    })
end)

RegisterNetEvent('srp-hud:client:UpdateNitrous')
AddEventHandler('srp-hud:client:UpdateNitrous', function(toggle, level, IsActive)
    SendNUIMessage({
        action = "nitrous",
        toggle = toggle,
        level = level,
        active = IsActive
    })
end)

RegisterNetEvent('srp-hud:client:UpdateDrivingMeters')
AddEventHandler('srp-hud:client:UpdateDrivingMeters', function(toggle, amount)
    SendNUIMessage({
        action = "UpdateDrivingMeters",
        amount = amount,
        toggle = toggle,
    })
end)

local LastHeading = nil
local Rotating = "left"
local toggleCompass = false

RegisterNetEvent('srp-hud:toggleCompass')
AddEventHandler('srp-hud:toggleCompass', function(toggleCompass1)
    toggleCompass = toggleCompass1
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(GLOBAL_PED, false) then
            toggleCompass = true
        else
            toggleCompass = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if toggleCompass then
            local ped = GLOBAL_PED
            local PlayerHeading = GetEntityHeading(ped)
            if LastHeading ~= nil then
                if PlayerHeading < LastHeading then
                    Rotating = "right"
                elseif PlayerHeading > LastHeading then
                    Rotating = "left"
                end
            end
            LastHeading = PlayerHeading
            SendNUIMessage({
                action = "UpdateCompass",
                heading = PlayerHeading,
                lookside = Rotating,
                toggle = toggleCompass
            })
            Citizen.Wait(50)
        else
            SendNUIMessage({
                action = "UpdateCompass",
                heading = 1,
                lookside = 1,
                toggle = toggleCompass
            })
            Citizen.Wait(1500)
        end
    end
end)



RegisterNetEvent("vrp_status")
AddEventHandler("vrp_status", function(status)
     myhunger = 100 - status.hunger
     mythirst = 100 - status.thirst
end)


  --- Minimap

Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
	
	SetMinimapClipType(1)
	SetMinimapComponentPosition('minimap', 'L', 'B', -0.002, -0.060, 0.105, 0.16)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', -0.012, 0.015, 0.2, 0.292)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.015, 0.015, 0.2, 0.292)
	
	local minimap = RequestScaleformMovie("minimap")
	while not HasScaleformMovieLoaded(minimap) do
      Wait(0)
    end
	
	SetRadarBigmapEnabled(true, false)
	Wait(0)
	SetRadarBigmapEnabled(false, false)
	  
	SetBlipAlpha(GetNorthRadarBlip(), 0)

	while true do
		Wait(100)
		BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
		ScaleformMovieMethodAddParamInt(3)
		EndScaleformMovieMethod()
		if IsBigmapActive() or IsBigmapFull() then
			SetBigmapActive(false, false)
		end		

		if not invehicle and IsPedInAnyVehicle(GLOBAL_PED, false) then
			invehicle = true
			SetMapZoomDataLevel(0, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 0
			SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
			SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
			SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
			SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4

			Citizen.Wait(100)
			SetRadarZoom(950)
		end 

        if IsPedInAnyVehicle(PlayerPedId(),false) then
            DisplayRadar(true)
        else
            DisplayRadar(false)
        end
	end
end)

-- No idle cams
Citizen.CreateThread(function()
    while true do
      InvalidateIdleCam()
      N_0x9e4cfff989258472() -- Disable the vehicle idle camera
      Wait(10000) --The idle camera activates after 30 second so we don't need to call this per frame
    end 
end)