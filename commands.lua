minetest.register_chatcommand("license", {
    --params = "<param1> <param2>",
    description = "how to use licenses:\n"..
    "/license add <license>  -  Add License to the database.\n"..
    "/license delete <license>  -  Delete License from the database.\n"..
    "/license assign <player> <license>  -  Assign a player some license.\n"..
    "/license revoke <player> <license>  -  Revoke a player some license.\n"..
    "/license list <player>  -  See all license of a player.\n"..
    "/license list   -  See all existing licenses on the server.",
    privs = {interact=true, licenses=true},
    func = function(player_name, param)
      -- Command with 3 Arguments
      local var1, var2, var3 = string.match(param, "(%S+) (%S+) (%S+)")
      if var1 ~=nil and var2 ~= nil and var3 ~= nil and var1 == "assign" then
        if licenses.assign(var2, var3) then --assign license
          minetest.chat_send_player(player_name, "License "..var3.." assigned to "..var2.." successfully")
          minetest.log("action", player_name..": License "..var3.." assigned to "..var2.." successfully")
        else
          minetest.chat_send_player(player_name, "License/Player not found. Use: /license assign <player> <license>. See /help license for more information.")
        end
        return
      end

      if var1 ~=nil and var2 ~= nil and var3 ~= nil and var1 == "revoke" then
        if licenses.revoke(var2, var3) then
          minetest.chat_send_player(player_name, "License "..var3.." revoked to "..var2.." successfully")
          minetest.log("action", player_name..": License "..var3.." revoked to "..var2.." successfully")
        else
          minetest.chat_send_player(player_name, "Revoke failed. Either the player or the license doenst exist, or the player doesnt have the license assigned.")
        end
        return
      end

      var1, var2  = string.match(param, "(%S+) (%S+)")
      if var1 ~=nil and var2 ~= nil and var1 == "add" then
        if licenses.add(var2) then
          minetest.chat_send_player(player_name, "License "..var2.." successfully added.")
          minetest.log("action", player_name..": License "..var2.." successfully added.")
        else
          minetest.chat_send_player(player_name, "License "..var2.." already exists.")
        end
        return
      end

      if var1 ~=nil and var2 ~= nil and var1 == "delete" then
        if licenses.delete(var2) then
          minetest.chat_send_player(player_name, "License "..var2.." successfully deleted.")
          minetest.log("action", player_name..": License "..var2.." successfully deleted.")
        else
          minetest.chat_send_player(player_name, "License "..var2.." not found!.")
        end
        return
      end

      if var1 ~=nil and var2 ~= nil and var1 == "list" then
        if minetest.player_exists(var2) then
          minetest.chat_send_player(player_name, "Licenses of "..var2..": ".. licenses.player_list(var2))
        else
          minetest.chat_send_player(player_name, "Player doesnt exist!")
        end
        return
      end

      var1  = string.match(param, "(%S+)")
      if var1 ~= nil and var1 == "list" and var2 == nil then
        minetest.chat_send_player(player_name, "All Licenses: "..licenses.list_all())
        return
      end
      minetest.chat_send_player(player_name, "Command not found. See /help license for more information.")
    end
})
