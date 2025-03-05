lib.versionCheck('Qbox-project/npwd_mGarage')
assert(GetResourceState('mGarage') == 'started', 'mGarage is not started')

local garageConfig = exports.mGarage:OpenGarage()
local VEHICLES = exports.qbx_core:GetVehiclesByName()

lib.callback.register('npwd_mGarage:server:getPlayerVehicles', function(source)
	local player = exports.qbx_core:GetPlayer(source)
	if not player then return {} end

	local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { player.PlayerData.citizenid })
	for i = 1, #result do
		local vehicleData = result[i]
		local model = vehicleData.vehicle

		vehicleData.model = model
		vehicleData.vehicle = 'Unknown'
		vehicleData.brand = 'Vehicle'

		if vehicleData.state == 0 then
			vehicleData.state = 'out'
		elseif vehicleData.state == 1 then
			vehicleData.state = 'garaged'
		elseif vehicleData.state == 2 then
			vehicleData.state = 'impounded'
		else
			vehicleData.state = 'unknown'
		end

		if VEHICLES[model] then
			vehicleData.vehicle = VEHICLES[model].name
			vehicleData.brand = VEHICLES[model].brand
		end

		vehicleData.garage = garageConfig[vehicleData.garage]?.label or locale('states.garage_unknown')
	end

	return result
end)

RegisterNetEvent("npwd_mGarage:OpenGarage", function()
	local src          = source
	local Player       = QBCore.Functions.GetPlayer(src)
	local garageresult = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?',
		{ Player.PlayerData.citizenid })

	if garageresult[1] ~= nil then
		for _, v in pairs(garageresult) do
			local vehicleModel = v.vehicle
			v.model = vehicleModel
			v.vehicle = 'Unknown'
			v.brand = 'Vehicle'

			if v.state == 0 then
				v.state = "out"
			elseif v.state == 1 then
				v.state = "garaged"
			elseif v.state == 2 then
				v.state = "impounded"
				-- elseif v.state == 3 then -- add new state for seized vehicles
				-- 	v.state = "seized"
			else
				v.state = "unknown"
			end

			if QBCore.Shared.Vehicles[vehicleModel] then
				v.vehicle = QBCore.Shared.Vehicles[vehicleModel].name
				v.brand = QBCore.Shared.Vehicles[vehicleModel].brand
			end

			if (Garages[v.garage] ~= nil) then
				v.garage = Garages[v.garage].label
			else
				v.garage = "Unknown Garage"
			end
		end

		TriggerClientEvent('npwd_mGarage:ImpoundVehicle', src, garageresult)
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == 'mGarage' then
		garageConfig = exports.mGarage:GetGarages()
	end
end)

AddEventHandler('mGarage:server:garageRegistered', function(garageName, newGarageConfig)
	garageConfig[garageName] = newGarageConfig
end)
