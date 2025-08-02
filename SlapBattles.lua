-- Slap Battles Script
-- View the owner profile here: github.com/Giangplay
-- view the official string here: raw.githubusercontent.com/Giangplay/Slap_Battles/main/Slap_Battles.lua
--[[
I've do a little remake and recode:

Guide:
[+] Added Stuff
[-] Removed Stuff
[/] Changed Stuff



[/] Better queueteleport keep UI.
 |_ I have do some little modifications, doing a little change to the Keep UI System:
 |  |_ New method to keep UI: plr.OnTeleport <- RBXConnection to better identify
 |
 |_ New File Creating System:
 |   |_ For improve the identification to the Keep UI System, i've added a little system that creates a file, that uses '.giangsett' has identificator.
 |      |_ I didn't do a directly change for this settings by now, but you can change it by editting directly from your archiver browser: 'SlapBattles.giangsett'
 |
 |_ I did it to functions that requires the player to be teleported to another place and uses queueteleport.
]]

