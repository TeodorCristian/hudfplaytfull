Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

local prox = 10.0
local isTalking = false
local LockPositions = false
local spawned = false
local showHUD = false
local expectancy = 500

local currSpeed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
vehicleCruiser = 'off'
local vehicleSignalIndicator = 'off'
local seatbeltEjectSpeed = 45.0 
local seatbeltEjectAccel = 100.0
local seatbeltIsOn = false
local vehiclesCars = {0,1,2,3,4,5,6,7,8,9,10,11,12,17,18,19,20};

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if not HasPedLoaded() then
			GLOBAL_PED = PlayerPedId()
			GLOBAL_PLYID = PlayerId()
			GLOBAL_SRVID = GetPlayerServerId(GLOBAL_PLYID)
        else
        Citizen.Wait(15000)
        end
    end
end)

function HasPedLoaded()
    if ped == PlayerPedId() then return true else return false end
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
local count = 0
local onceNotify = false
local onceNotifyDoi = false
local lr = false
local ld = false
local lrs = false
local lrd = false
local la = false
local las = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
		if IsPedInAnyVehicle(GLOBAL_PED, false) then
			local vehicle = GetVehiclePedIsIn(GLOBAL_PED, false)
			local vehicleClass = GetVehicleClass(vehicle)

			-- Vehicle Seatbelt
			--if IsPedInAnyVehicle(GLOBAL_PED, false) and GetIsVehicleEngineRunning(vehicle) then
			
				if IsControlJustReleased(0, Keys['G']) and (has_value(vehiclesCars, vehicleClass) == true and vehicleClass ~= 8) then
					seatbeltIsOn = not seatbeltIsOn
					if seatbeltIsOn then
						TriggerEvent("seatbelt:client:ToggleSeatbelt", true)
					else
						TriggerEvent("seatbelt:client:ToggleSeatbelt", false)
					end
				end
			

			-- Vehicle Cruiser
			if IsControlJustPressed(1, Keys['B']) and GetPedInVehicleSeat(vehicle, -1) == GLOBAL_PED and (has_value(vehiclesCars, vehicleClass) == true) then
				
				local vehicleSpeedSource = GetEntitySpeed(vehicle)

				if vehicleCruiser == 'on' then
					vehicleCruiser = 'off'
					SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
					
				else
					vehicleCruiser = 'on'
					print(vehicleSpeedSource)
					SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
				end
			end

			--Regula la Roti 

			if IsVehicleTyreBurst(vehicle, 0, false) then
				if not lr then
					count = count + 1
					lr = true
				end
			end
			if IsVehicleTyreBurst(vehicle, 1, false) then
				if not ld then
					count = count + 1
					ld = true
				end
			end
			if IsVehicleTyreBurst(vehicle, 2, false) then
				if not lrs then
					count = count + 1
					lrs = true
				end
			end
			if IsVehicleTyreBurst(vehicle, 3, false) then
				if not lrd then
					count = count + 1
					lrd = true
				end
			end
			if IsVehicleTyreBurst(vehicle, 4, false) then
				if not la then
					count = count + 1
					la = true
				end
			end
			if IsVehicleTyreBurst(vehicle, 5, false) then
				if not las then
					count = count + 1
					las = true
				end
			end
			if count == 1 then		
				SetEntityMaxSpeed(vehicle, 22.1273)	
				if not onceNotify then
					
					onceNotify = true
					TriggerEvent("fplaytbank:notifications", "inform", "Ai o roata sparta!")
				end
			end

			if count == 2 or count == 3 or count == 4 then
				SetEntityMaxSpeed(vehicle, 5.3313)
				if not onceNotifyDoi then
					
					onceNotifyDoi = true
					TriggerEvent("fplaytbank:notifications", "inform", "Ai rotile sparte!")
				end
				
			end


		else
			lr = false
			ld = false
			lrs = false
			lrd = false
			la = false
			las = false
			count = 0
			onceNotify = false
			onceNotifyDoi = false
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(150)
		if IsPedInAnyVehicle(GLOBAL_PED, false) then
			local PedCar = GetVehiclePedIsIn(GLOBAL_PED, false) -- optimizat
			local vehicle = PedCar
			--local carSpeed = math.ceil(GetEntitySpeed(PedCar)*3.6) -- Optimizat
			local vehicleSpeedSource = GetEntitySpeed(vehicle) -- optimizat
			local vehicleClass = GetVehicleClass(vehicle) -- optimizat
			local position = GetEntityCoords(GLOBAL_PED) -- optimizat
			if has_value(vehiclesCars, vehicleClass) == true and vehicleClass ~= 8 then
				local prevSpeed = currSpeed
				currSpeed = vehicleSpeedSource

				SetPedConfigFlag(GLOBAL_PED, 32, true)

				if not seatbeltIsOn then
					local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
					local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
					if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
						SetEntityCoords(GLOBAL_PED, position.x, position.y, position.z - 0.47, true, true, true)
						SetEntityVelocity(GLOBAL_PED, prevVelocity.x, prevVelocity.y, prevVelocity.z)
						SetPedToRagdoll(GLOBAL_PED, 1000, 1000, 0, 0, 0, 0)
					else
						-- Update previous velocity for ejecting player
						prevVelocity = GetEntityVelocity(vehicle)
					end
				else
					DisableControlAction(0, 75)
				end
			end
		else
		Citizen.Wait(5000)
		end
	end
end)




		