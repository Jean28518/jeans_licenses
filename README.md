# licenses
Github: https://github.com/Jean28518/minetest_licenses

This mod is adding an ingame license system for multiplayers to Minetest.

**Licenses can only read and wrote to the player, when the specific player is online, because of the use of `player:get_meta()`.**

----

## Chat-Commands:
`licenses`
List all commands.

 `licenses_list`
List all defined licenses.

`licenses_add LICENSE`
Add new license to database. 'licenses' attribut required.

 `licenses_remove LICENSE`
Remove license from database. 'licenses' attribut required.

 `licenses_assign PLAYERNAME LICENSE`
Assign a defined license to a player. 'licenses' attribut required.

 `licenses_unassign PLAYERNAME LICENSE`
Unassign a defined license to a player 'licenses' attribut required.

 `licenses_see PLAYERNAME`
List all assigned licenses and each assign-gametime the  of a player.

 `licenses_check PLAYERNAME LICENSE`
Returns, if license is currently assigned to player.

 `licenses_get_license_time PLAYERNAME LICENSE`
Get assigntime of an assigned License from a player.

 `licenses_get_last_assigntime PLAYERNAME`
Get the latest time, on which a player where assigned to an license.

----

## Minetest Functions for Developers:
You can also combine this mod with your own mod:

`licenses_check_player_by_licese(player, license)` Returns true, if License is currently assigned to the player. Otherwise returns false.

`licenses_check_player_license_time(player, license)` Returns the gametime, on which the license was assigned to the player.

`function licenses_check_player_license_time(player)` Returns the latest gametime, on that a player got assigned with any license.

`licenses_assign(player, license)` Returns true, if License where successfully assigned. Otherwise returns false.

`licenses_unassign(player, license)` Returns true, if License where successfully unassigned. Otherwise returns false.
