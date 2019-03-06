local storage = minetest.get_mod_storage()
minetest.register_privilege("licenses", {
	description = "Player can manage licenses",
	give_to_singleplayer= true,
})
-- licenses Command
minetest.register_chatcommand("licenses", {
    privs = {
        interact = true,
    },
    func = function(name, param)
      -- local arg1, arg2 = param:match('^(%S+)%s(.+)$')
      -- local table = minetest.deserialize(storage:get_string("licenses:table"))
      local player = minetest.get_player_by_name(name)
      minetest.chat_send_player(player:get_player_name(), "licenses_list: List all defined licenses" ..
       "\nlicenses_add <license_name>: Add new license to database (!)" ..
       "\nlicenses_remove <license_name>: Remove license from database (!)" ..
       "\nlicenses_assign <player_name> <license_name>: Assign a defined license to a player (!)" ..
       "\nlicenses_unassign <player_name> <license_name>: Unassign a defined license to a player (!)" ..
       "\nlicenses_see <player_name>: List all assigned licenses and each assign-gametime the  of a player" ..
       "\nlicenses_check <player_name> <license>: Returns, if license is currently assigned to player" ..
       "\nlicenses_get_license_time <player_name> <license>: Get assigntime of an assigned License from a player" ..
       "\nlicenses_get_last_assigntime <player_name>: Get the latest time, on which a player where assigned to an license")

    end
})

minetest.register_chatcommand("licenses_list", {
    privs = {
        interact = true,
    },
    func = function(name, param)
      local table = minetest.deserialize(storage:get_string("licenses:table"))
      if table == nil then
        minetest.chat_send_player(name, "No Licenses defined!")
      else
        minetest.chat_send_player(name, "Licenses defined:")
        for k, v in pairs(table) do
          if v == "defined" then
            minetest.chat_send_player(name, k)
          end
        end
      end
    end
})

minetest.register_chatcommand("licenses_add", {
    privs = {
        interact = true,
        licenses = true,
    },
    func = function(name, param)
      local table = minetest.deserialize(storage:get_string("licenses:table"))
      if param == "" then
        minetest.chat_send_player(name, "Correct use: licenses_add <license_name>")
      else
        if table == nil then
          table = {}
        end
        table[param] = "defined"
        storage:set_string("licenses:table", minetest.serialize(table))
        minetest.chat_send_player(name, "Successfully added License: " .. param)
      end
    end
})

minetest.register_chatcommand("licenses_remove", {
    privs = {
        interact = true,
        licenses = true,
    },
    func = function(name, param)
      local table = minetest.deserialize(storage:get_string("licenses:table"))
      if param == "" then
        minetest.chat_send_player(name, "Correct use: licenses_remove <license_name>")
      else
        if table == nil then
          table = {}
        end
        table[param] = nil
        storage:set_string("licenses:table", minetest.serialize(table))
        minetest.chat_send_player(name, "Successfully deleted License: " .. param)

      end
    end
})

minetest.register_chatcommand("licenses_assign", {
    privs = {
        interact = true,
        licenses = true,
    },
    func = function(name, param)
      local player, license = param:match('^(%S+)%s(.+)$')
      local table = minetest.deserialize(storage:get_string("licenses:table"))
      if player == nil or license == nil then
        minetest.chat_send_player(name, "Correct use: licenses_assign <player_name> <license_name>")
      else
        if table == nil then
          table = {}
        end
        -- Checke, ob das wirklich existiert
        local exists = false
        for k, v in pairs(table) do
          if k == license and v == "defined" then
            exists = true
          end
        end
        if exists and minetest.player_exists(player) and minetest.get_player_information(player) ~= nil then
          local meta = minetest.get_player_by_name(player):get_meta()
          local ptable = minetest.deserialize(meta:get_string("licenses:ptable"))
          if ptable == nil then
            ptable = {}
          end
          ptable[license] = minetest.get_gametime()
          meta:set_string("licenses:ptable", minetest.serialize(ptable))
          meta:set_int("licenses:assigntime", minetest.get_gametime())
          minetest.chat_send_player(name, "License successfully assigned")
        else
          minetest.chat_send_player(name, "License/Player doesnt exist/is not online at the moment! ")
        end
      end
    end
})

-- Lizenz wieder abnehmen
minetest.register_chatcommand("licenses_unassign", {
    privs = {
        interact = true,
        licenses = true,
    },
    func = function(name, param)
      local player, license = param:match('^(%S+)%s(.+)$')
      local table = minetest.deserialize(storage:get_string("licenses:table"))
      if player == nil or license == nil then
        minetest.chat_send_player(name, "Correct use: licenses_unassign <player_name> <license_name>")
      else
        if table == nil then
          table = {}
        end
        -- Checke, ob das wirklich existiertlicenses_get_license_time
        local exists = false
        for k, v in pairs(table) do
          if k == license and v == "defined" then
            exists = true
          end
        end
        if exists and minetest.player_exists(player) and minetest.get_player_information(player) ~= nil then
          local meta = minetest.get_player_by_name(player):get_meta()
          local ptable = minetest.deserialize(meta:get_string("licenses:ptable"))
          if ptable == nil then
            ptable = {}
          end
          ptable[license] = nil
          meta:set_string("licenses:ptable", minetest.serialize(ptable))
          minetest.chat_send_player(name, "License successfully unassigned")
        else
          minetest.chat_send_player(name, "License/Player doesnt exist/is not online at the moment! ")
        end
      end
    end
})

-- lizenzen eines Spielers einsehen
minetest.register_chatcommand("licenses_see", {
    privs = {
        interact = true,
    },
    func = function(name, param)
      local player = param
      local table = minetest.deserialize(storage:get_string("licenses:table"))
      if player == "" then
        player = name
      end

      if table == nil then
        table = {}
      end
      if minetest.player_exists(player) and minetest.get_player_information(player) ~= nil then
        local meta = minetest.get_player_by_name(player):get_meta()
        local ptable = minetest.deserialize(meta:get_string("licenses:ptable"))
        if ptable == nil then
          ptable = {}
        end
        minetest.chat_send_player(name, "Licenses from " .. player .. ":")
        for k, v in pairs(ptable) do
          if v ~= nil  then
            minetest.chat_send_player(name, k .. "  " .. v)
          end
        end
      else
        minetest.chat_send_player(name, "Player doesnt exist/is not online at the moment! ")
      end
    end
})

-- Nach einer bestimmten Lizenz fragen
function licenses_check_player_by_licese(player, license)
  local table = minetest.deserialize(storage:get_string("licenses:table"))
  if player == nil or license == nil then
    print("licenses_check_player_by_licese: corrext use: licenses_check_player_by_licese(playername, license)")
    return false
  else
    if table == nil then
      table = {}
    end
    -- Checke, ob das wirklich existiert
    local exists = false
    for k, v in pairs(table) do
      if k == license and v == "defined" then
        exists = true
      end
    end
    if exists and minetest.player_exists(player) and minetest.get_player_information(player) ~= nil then
      local meta = minetest.get_player_by_name(player):get_meta()
      local ptable = minetest.deserialize(meta:get_string("licenses:ptable"))
      if ptable == nil then
        ptable = {}
      end
      for k, v in pairs(ptable) do
        if k == license  then
          return true
        end
      end
      return false
    else
      print("licenses_check_player_by_licese: Player"..player.."doesnt exist/is not online at the moment, or "..license.." doesnt exist! ")
      return nil
    end
  end
end

minetest.register_chatcommand("licenses_check", {
    privs = {
        interact = true,
    },
    func = function(name, param)
      local player, license = param:match('^(%S+)%s(.+)$')
      local table = minetest.deserialize(storage:get_string("licenses:table"))
      if player == nil or param == "" then
        minetest.chat_send_player(name, "Correct use: licenses_check <player_name> <license>")
      else
        minetest.chat_send_player(name, tostring(licenses_check_player_by_licese(player, license)))
      end
    end
})
-- Lizenzdatum eines Spielers einsehen
function licenses_check_player_license_time(player, license)
  local table = minetest.deserialize(storage:get_string("licenses:table"))
  if player == nil or license == nil then
    print("licenses:check_player_by_licese: corrext use: licenses_check_player_license_time(playername, license)")
    return nil
  else
    if table == nil then
      table = {}
    end
    -- Checke, ob das wirklich existiert
    local exists = false
    for k, v in pairs(table) do
      if k == license and v == "defined" then
        exists = true
      end
    end
    if exists and minetest.player_exists(player) and minetest.get_player_information(player) ~= nil then
      local meta = minetest.get_player_by_name(player):get_meta()
      local ptable = minetest.deserialize(meta:get_string("licenses:ptable"))
      if ptable == nil then
        ptable = {}
      end
      for k, v in pairs(ptable) do
        if k == license  then
          return v
        end
      end

    end
    print("licenses_check_player_license_time: Player"..player.."doesnt exist/is not online at the moment, or "..license.." doesnt exist! ")
    return nil

  end
end

minetest.register_chatcommand("licenses_get_license_time", {
    privs = {
        interact = true,
    },
    func = function(name, param)
      local player, license = param:match('^(%S+)%s(.+)$')
      local table = minetest.deserialize(storage:get_string("licenses:table"))
      if player == nil or param == "" then
        minetest.chat_send_player(name, "Correct use: licenses_get_license_time <player_name> <license>")
      else
        local rueckgabe = licenses_check_player_license_time(player, license)
        if rueckgabe ~= nil then
          minetest.chat_send_player(name, tostring(rueckgabe))
        else
          minetest.chat_send_player(name, "Player doesnt exist/is not online at the moment, or license doenst exist!")
        end
      end
    end
})

-- Lizenz Time eines Spielers einsehen
function licenses_check_player_license_time(player)
  local table = minetest.deserialize(storage:get_string("licenses:table"))
  if player == nil then
    print("licenses:check_player_by_licese: corrext use: licenses_check_player_license_time(playername)")
    return nil
  else
    if minetest.player_exists(player) and minetest.get_player_information(player) ~= nil then
      local meta = minetest.get_player_by_name(player):get_meta()
      return meta:get_int("licenses:assigntime")
    end
    print("licenses_check_player_license_time: Player"..player.."doesnt exist/is not online at the moment! ")
    return nil
  end
end

minetest.register_chatcommand("licenses_get_last_assigntime", {
    privs = {
        interact = true,
    },
    func = function(name, param)
      local player = param
      if player == "" then
        player = name
      end
      local rueckgabe = licenses_check_player_license_time(player)
      if rueckgabe ~= nil then
        minetest.chat_send_player(name, tostring(rueckgabe))
      else
        minetest.chat_send_player(name, "Player doesnt exist/is not online at the moment!")
      end
    end
})

function licenses_assign(player, license)
  local table = minetest.deserialize(storage:get_string("licenses:table"))
  if player == nil or license == nil then
    print(name, "licenses_assign: Correct use: licenses_assign <player_name> <license_name>")
    return false
  else
    if table == nil then
      table = {}
    end
    -- Checke, ob das wirklich existiert
    local exists = false
    for k, v in pairs(table) do
      if k == license and v == "defined" then
        exists = true
      end
    end
    if exists and minetest.player_exists(player) and minetest.get_player_information(player) ~= nil then
      local meta = minetest.get_player_by_name(player):get_meta()
      local ptable = minetest.deserialize(meta:get_string("licenses:ptable"))
      if ptable == nil then
        ptable = {}
      end
      ptable[license] = minetest.get_gametime()
      meta:set_string("licenses:ptable", minetest.serialize(ptable))
      meta:set_int("licenses:assigntime", minetest.get_gametime())
      return true
    else
      print(name, "licenses_assign: License/Player doesnt exist/is not online at the moment! ")
      return false
    end
  end
end

function licenses_unassign(player, license)
  local table = minetest.deserialize(storage:get_string("licenses:table"))
  if player == nil or license == nil then
    print(name, "licenses_assign: Correct use: licenses_unassign <player_name> <license_name>")
    return false
  else
    if table == nil then
      table = {}
    end
    -- Checke, ob das wirklich existiert
    local exists = false
    for k, v in pairs(table) do
      if k == license and v == "defined" then
        exists = true
      end
    end
    if exists and minetest.player_exists(player) and minetest.get_player_information(player) ~= nil then
      local meta = minetest.get_player_by_name(player):get_meta()
      local ptable = minetest.deserialize(meta:get_string("licenses:ptable"))
      if ptable == nil then
        ptable = {}
      end
      ptable[license] = nil
      meta:set_string("licenses:ptable", minetest.serialize(ptable))
      return true
    else
      print(name, "licenses_assign: License/Player doesnt exist/is not online at the moment! ")
      return false
    end
  end
end

function licenses_exists(license)
	local table = minetest.deserialize(storage:get_string("licenses:table"))
	-- Checke, ob das wirklich existiert
	local exists = false
	for k, v in pairs(table) do
		if k == license and v == "defined" then
			exists = true
		end
	end
	return exists
end
