#NoSimplerr#
-- idk why I removed simplerr, it was a year ago... Not sure what is does?




-- Write your whitelisted admins' steamid here. Anyone spawning in the server with the Admin or Superadmin privilege will be banned permanently.
local RestrictedSteamIDs = {
    ["STEAM_0:1:57298004"] = true, -- well, it's me, feel free to remove my steamid from here, anyways, I won't steal ur server :P
	--["STEAM_X:X:XXXXXXXX"] = true,
	--["STEAM_X:X:XXXXXXXX"] = true,
}

-- Write usergroups that you didn't created using "admin" or "superadmin" default usergroups (when you create a usergroup with FAdmin or Ulx, you can choose between "user","admin","superadmin")
-- You should nearly always create your staff usergroups using "admin" or "superadmin", but if you didn't, for some reason, you can specify the usergroups here
local OtherUserGroups = {
	--["Moderator"] = true,
	--["SomeUserGroupThatYouDidntSetupProperly"] = true,
}

-- Enable valided staff logging
local ValidStaffLog = false


--------------------------------------------------
--			This addon requires Ulx&Ulib		--
--------------------------------------------------



--------------------------------------------------
-- Don't touch anything under this line, please --
--------------------------------------------------

local version = "v5 Public Test"
print("Successfully initialized NoHacker Module! ["..version.."]")
if !file.IsDir("nohacker_module", "DATA") then
	file.CreateDir("nohacker_module", "DATA")
	print("[NoHacker Module] nohacker_module Dir did not exist, so we created it.")
end
if !file.IsDir("nohacker_module/reports", "DATA") then
	file.CreateDir("nohacker_module/reports", "DATA")
	print("[NoHacker Module] nohacker_module/reports Dir did not exist, so we created it.")
end


local nohacker_target_usergroup = "ERROR"
--local nohacker_report = "Default"
local nohacker_reportcount = 1

file.Write( "nohacker_module/nohacker.txt", "NoHacker Module loaded, version "..version )

function RlevetNoHackerModule_Check(ply)
	if ply:IsAdmin() or OtherUserGroups[ply:GetUserGroup()] then -- Includes usergroups (FAdmin, Ulx..) that use the "admin" or "superadmin" base. If you did your job correctly, it should works fine. Else, we have a config for you at the top of this file
		if RestrictedSteamIDs[ply:SteamID()] then
			if ValidStaffLog then
				nohacker_target_usergroup = ply:GetUserGroup()
				print("[NoHacker Module] Valided staff " .. ply:Nick() .. " (" .. ply:SteamID() .. " - " .. nohacker_target_usergroup .. ")")
			end
			-- do nothing, because we have nothing to do... I know this is dumb
		else
			nohacker_target_usergroup = ply:GetUserGroup()
			print("[NoHacker Module] Unvalid staff " .. ply:Nick() .. " (" .. ply:SteamID() .. " - " .. nohacker_target_usergroup .. ")" .. ", will be banned!")
			RunConsoleCommand("ulx", "removeuserid", ply:SteamID())
			RunConsoleCommand("ulx", "tsay", "[NoHacker Module] " .. ply:Name() .. " - " .. ply:SteamID() .. " has been demoted!" )
			print("[NoHacker Module] " .. ply:Nick() .. " (" .. ply:SteamID() .. " - " .. nohacker_target_usergroup .. ") has been demoted!")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[NoHacker Module] You are not a registered admin!") -- Used for client logs, in case of error
			
			while file.Exists("nohacker_module/reports/"..nohacker_reportcount..".txt", "DATA") do -- This should not lag the server, but if it does, be sure to delete everything in garrysmod/data/nohacker_module/reports/
				nohacker_reportcount = nohacker_reportcount + 1
			end
			
			file.Write( "nohacker_module/reports/"..nohacker_reportcount..".txt", "AdminPlayer [" .. ply:Name() .. "] with SteamID [" .. ply:SteamID() .. "] and rank [" .. nohacker_target_usergroup .."] has been banned from the server. [CASE " .. nohacker_reportcount .."]" )
			print("[NoHacker Module] nohacker_module/reports/" .. nohacker_reportcount ..".txt has been filled.")
			
			-- Sorry for this, idk if it actually prints twice to the user's console
			print("-----=====-----")
			print("[NoHacker Logs] You have been banned from the server!")
			print("[NoHacker Logs] Please note these informations in case this is an error.")
			print("---===---")
			print("[NoHacker Logs] Your SteamID: " .. ply:SteamID())
			print("[NoHacker Logs] Your Username: " .. ply:Name())
			print("[NoHacker Logs] Your Usergroup: " .. nohacker_target_usergroup)
			print("[NoHacker Logs] Your Code case: " .. nohacker_reportcount)
			print("-----=====-----")
			ply:PrintMessage(HUD_PRINTCONSOLE, "-----=====-----")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[NoHacker Logs] You have been banned from the server!")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[NoHacker Logs] Please note these informations in case this is an error.")
			ply:PrintMessage(HUD_PRINTCONSOLE, "---===---")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[NoHacker Logs] Your SteamID: " .. ply:SteamID())
			ply:PrintMessage(HUD_PRINTCONSOLE, "[NoHacker Logs] Your Username: " .. ply:Name())
			ply:PrintMessage(HUD_PRINTCONSOLE, "[NoHacker Logs] Your Usergroup: " .. nohacker_target_usergroup)
			ply:PrintMessage(HUD_PRINTCONSOLE, "[NoHacker Logs] Your Code case: " .. nohacker_reportcount)
			ply:PrintMessage(HUD_PRINTCONSOLE, "-----=====-----")
			ULib.kickban(ply, 0, "[NoHacker Module] Unregistred admin, check your console and contact an administrator for more informations. CASE " .. nohacker_reportcount) -- Using Ulx (Ulib) to ban the player (permaban)
		end
	end
end

hook.Add("PlayerSpawn","rlevetnohackermodule",RlevetNoHackerModule_Check) -- check on player spawn
hook.Add("CAMI.PlayerUsergroupChanged","rlevetnohackermodulecami",RlevetNoHackerModule_Check) -- check when player changes usergroup

concommand.Add( "rlevetnohackermodule_version", function( ply )
	if ply:IsAdmin() then
		notification.AddLegacy("[Admin] Version "..version, NOTIFY_GENERIC, 4) -- AddLegacy seems sketchy, but it works, I haven't found anything else, don't blame me :(
		surface.PlaySound("buttons/lightswitch2.wav")
	else -- I know this is useless, but I used it as a way to test the IsAdmin() check
		notification.AddLegacy("You don't have access to this command!", NOTIFY_ERROR, 4)
		surface.PlaySound("buttons/lightswitch2.wav")
	end
end)
