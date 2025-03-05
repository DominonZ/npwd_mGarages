local function findVehFromPlateAndLocate(plate)
	local gameVehicles = GetGamePool('CVehicle')
	for i = 1, #gameVehicles do
		local vehicle = gameVehicles[i]
		if DoesEntityExist(vehicle) then
			if qbx.getVehiclePlate(vehicle) == plate then
				local vehCoords = GetEntityCoords(vehicle)
				SetNewWaypoint(vehCoords.x, vehCoords.y)
				return true
			end
		end
	end
end

RegisterNUICallback("npwd:mGarage:getVehicles", function(_, cb)
	local vehicles = lib.callback.await('npwd_mGarage:server:getPlayerVehicles', false)
	for _, v in pairs(vehicles) do
		local type = GetVehicleClassFromName(v.model)
		if type == 15 or type == 16 then
			v.type = "aircraft"
		elseif type == 14 then
			v.type = "boat"
		elseif type == 13 or type == 8 then
			v.type = "bike"
		else
			v.type = "car"
		end
	end

	cb({ status = "ok", data = vehicles })
end)

RegisterNUICallback("npwd:mGarage:requestWaypoint", function(data, cb)
	exports.npwd:createNotification({
		notisId = 'npwd:mGarage:requestWaypoint',
		appId = 'npwd_mGarage',
		content = findVehFromPlateAndLocate(data.plate) and locale('notification.marked') or
			locale('notification.cannot_locate'),
		keepOpen = false,
		duration = 5000,
		path = '/npwd_mGarage',
	})
	cb({})
end)

RegisterNuiCallback("npwd:mGarage:valetVehicle", function(data, cb)
	local coords = QBCore.Functions.GetCoords(PlayerPedId())
	local ret, coordsTemp, heading = GetClosestVehicleNodeWithHeading(coords.x, coords.y, coords.z, 1, 3.0, 0)
	local retval, coordsSide = GetPointOnRoadSide(coordsTemp.x, coordsTemp.y, coordsTemp.z)
	-- coordsSide vector3 location  / heading float
	print(data.vehicle.model .. 'spawned')
	print(data.vehicle.state)
	if data.vehicle.state == 'garaged' then
		QBCore.Functions.SpawnVehicle(data.vehicle.model, function(veh)
			QBCore.Functions.TriggerCallback('npwd:mGarage:server:GetVehicleProperties', function(properties)
				QBCore.Functions.SetVehicleProperties(veh, properties)
				SetVehicleNumberPlateText(veh, data.vehicle.plate)
				exports['ox-fuel']:SetFuel(veh, data.vehicle.fuel)
				SetEntityAsMissionEntity(veh, true, true)
				SetEntityHeading(veh, heading)
				TriggerServerEvent('npwd:mGarage:server:updateVehicleState', 0, data.vehicle.plate, "Out")
				TriggerServerEvent('mVehicles:server:HasKeys', data.vehicle.plate)
				SetVehicleEngineOn(veh, true, true, false)
			end, data.vehicle.plate)
		end, coordsSide, true)
	else
		QBCore.Functions.Notify("Arac zaten disarida!", "error")
	end

	cb({})
end)
