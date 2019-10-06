--------------------------------------------------------------------------------
-- MEMORY ----------------------------------------------------------------------
--------------------------------------------------------------------------------

local storage = minetest.get_mod_storage()
local licensesArray = minetest.deserialize(storage:get_string("licensesArray"))
if licensesArray == nil then
  licensesArray = {}
end
storage:set_string("licensesArray", minetest.serialize(licensesArray))
local playerLicenses = minetest.deserialize(storage:get_string("playerLicenses"))
if playerLicenses == nil then
  playerLicenses = {}
end
storage:set_string("playerLicenses", minetest.serialize(playerLicenses))
--------------------------------------------------------------------------------

function licenses.add(license)
	if licenses.exists(license) then return false end
	local licensesArray = minetest.deserialize(storage:get_string("licensesArray"))
	licensesArray[license] = true
	storage:set_string("licensesArray", minetest.serialize(licensesArray))
  return true
end

function licenses.delete(license)
	if not licenses.exists(license) then return false end
	local licensesArray = minetest.deserialize(storage:get_string("licensesArray"))
	licensesArray[license] = nil
	storage:set_string("licensesArray", minetest.serialize(licensesArray))
	return true
end

function licenses.exists(license)
	local licensesArray = minetest.deserialize(storage:get_string("licensesArray"))
	if licensesArray[license] == true then
		return true
	else
		return false
	end
end

function licenses.assign(player, license)
	if not licenses.exists(license) or not minetest.player_exists(player)  then return false end
	local playerLicenses = minetest.deserialize(storage:get_string("playerLicenses"))
	playerLicenses[player] = playerLicenses[player] or {}
	playerLicenses[player][license] = true
	storage:set_string("playerLicenses", minetest.serialize(playerLicenses))
	return true
end

function licenses.revoke(player, license)
	if not licenses.exists(license) or not minetest.player_exists(player)  then return false end
	local playerLicenses = minetest.deserialize(storage:get_string("playerLicenses"))
	playerLicenses[player] = playerLicenses[player] or {}
	playerLicenses[player][license] = nil
	storage:set_string("playerLicenses", minetest.serialize(playerLicenses))
	return true
end

function licenses.check(player, license)
	if not licenses.exists(license) or not minetest.player_exists(player)  then return false end
	local playerLicenses = minetest.deserialize(storage:get_string("playerLicenses"))
	playerLicenses[player] = playerLicenses[player] or {}
  if not licenses.exists(license) then -- remove a deleted license
    playerLicenses[player][license] = nil
    storage:set_string("playerLicenses", minetest.serialize(playerLicenses))
    return false
  end
  minetest.chat_send_all("")
	if playerLicenses[player][license] ~= nil and playerLicenses[player][license] == true then
		return true
	else

		return false
	end
end

function licenses.list_all()
	local licensesArray = minetest.deserialize(storage:get_string("licensesArray"))
	local returnvalue = ""
	for license, v in pairs(licensesArray) do
		returnvalue = returnvalue .. " " .. license
	end
	return returnvalue
end

function licenses.player_list(player_name)
  local playerLicenses = minetest.deserialize(storage:get_string("playerLicenses"))
  if not minetest.player_exists(player_name) then return false end
  playerLicenses[player_name] = playerLicenses[player_name] or {}
  local returnvalue = ""
  for license, v in pairs(playerLicenses[player_name]) do
    if not licenses.exists(license) then -- remove a deleted license
      playerLicenses[player_name][license] = nil
      license = ""
    end
		returnvalue = returnvalue .. " " .. license
	end
  storage:set_string("playerLicenses", minetest.serialize(playerLicenses))
  return returnvalue
end

--------------------------------------------------------------------------------
-- Old Function Names:
--------------------------------------------------------------------------------
function licenses_check_player_by_licese(player, license)
  return licenses.check(player, license)
end

function licenses_add(license)
  return licenses.add(license)
end

function licenses_check_player_license_time(player_name, license)
  return -1
end

function licenses_assign(player_name, license)
  return licenses.assign(player_name, license)
end

function licenses_unassign(player_name, license)
  return licenses.revoke(player_name, license)
end

function licenses_exists(license)
  return licenses.exists(license)
end
