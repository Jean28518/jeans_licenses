# Minetest-Mod: Jeans Licenses
Github: https://github.com/Jean28518/minetest_licenses

This mod is adding an ingame license system for servers to minetest.
Its an alternative to the minetest-priv system. Its for ingame features. E.g. for a drivers license or something else.

----

## Commands:
`/help license` Display all other commands

`/license add <license>` Add License to the database.

`/license delete <license>` Delete License from the database.

`/license assign <player> <license>` Assign a player some license.

`/license revoke <player> <license>` Revoke a player some license.

`/license list <player>` See all license of a player.

`/license list` See all existing licenses on the server.

----

## Minetest Functions for Developers:
You can also combine this mod with your own mod:

`licenses.add(license)` Add a license to the database. Return true, if it was sucessfully done. Returns false, if error ocurred, or license is in database already.

`licenses.delete(license)` Deletes a license from the database. Returns true, if it was sucessfully done. Returns false, if error ocurred, or the license doenst exist.

`licenses.exists(license)` Returns true, if the license exists in the database. Returns false, if it isn't.

`licenses.assign(player_name, license)` Assigns a Player an license. Returns true, if sucessfully done. Returns false, if the license or the player doesnt exist.

`license.revoke(player_name, license)` Revokes a license from a player. Returns true, if sucessfully done. Returns false, if the license or the player doesnt exist.

`licenses.check(player_name, license)` Returns true, if the player has the license assigned. Returns false if not, or the player or the license doesnt exist.

`licenses.list_all()` Returns a String with all licenses listed in the database. When the database is empty, it returns an empty String like `""`

`licenses.player_list(player_name)` Returns a string with all licenses which are assigned to a specific player. It returns an empty String when the player has no licenses assigned. When the player doenst exist, it returns false.

**The mod doenst handle assign times anymore!**

### Old deprecated Functions:
*`licenses_add(license)` Adds a license to the database.*

*`licenses_check_player_by_licese(player_name, license)` Returns true, if License is currently assigned to the player. Otherwise returns false.*

*`licenses_check_player_license_time(player_name, license)` Returns the gametime, on which the license was assigned to the player.*

*`function licenses_check_player_license_time(player_name)` Returns the latest gametime, on that a player got assigned with any license.*

*`licenses_assign(player_name, license)` Returns true, if License where successfully assigned. Otherwise returns false.*

*`licenses_unassign(player_name, license)` Returns true, if License where successfully unassigned. Otherwise returns false.*

*`licenses_exists(license)` Returns true, if this license is in database. Otherwise returns false*
