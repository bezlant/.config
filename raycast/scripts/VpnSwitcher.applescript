#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title SwitchVPN
# @raycast.mode silent
# @raycast.icon 🔒
# @raycast.description Switch between Shadowrocket and Netzone VPNs
# @raycast.packageName Utilities

-- CONFIG: Netzone toggle coordinates
set netzoneX to 843
set netzoneY to 423

-- -----------------------------
-- 1️⃣ Check Shadowrocket state
tell application "Shadowrocket" to activate
log "🔄 Activating Shadowrocket..."

tell application "System Events"
	tell process "Shadowrocket"
		repeat until exists window 1
			delay 0.5
		end repeat
		
		set mainWin to window 1
		set allElements to entire contents of mainWin
		set vpnCheckbox to missing value
		set srValue to missing value
		
		-- find first checkbox with a value and exit
		repeat with el in allElements
			try
				if role of el is "AXCheckBox" then
					set vpnCheckbox to el
					set srValue to (value of el) as integer -- 0 = off, 1 = on
					exit repeat
				end if
			end try
		end repeat
		
		if vpnCheckbox is missing value then
			display dialog "❌ Could not find Shadowrocket VPN checkbox"
			log "❌ Failed to find Shadowrocket checkbox"
			return
		end if
	end tell
end tell

log "ℹ️ Shadowrocket state detected: " & srValue

-- -----------------------------
-- 2️⃣ Decide which VPN to connect
if srValue = 1 then
	log "🔄 Shadowrocket is currently ON, switching to Netzone..."
	
	-- Disconnect Shadowrocket first
	log "📴 Turning off Shadowrocket..."
	tell application "System Events"
		tell process "Shadowrocket"
			click vpnCheckbox
			delay 2 -- wait for disconnect
		end tell
	end tell
	log "✅ Shadowrocket disconnected"
	
	-- Connect Netzone
	log "🌐 Activating Netzone..."
	tell application "Netzone" to activate
	delay 0.5
	do shell script "/opt/homebrew/bin/cliclick c:" & netzoneX & "," & netzoneY
	log "✅ Netzone connected"
else
	log "🔄 Shadowrocket is currently OFF, switching to Shadowrocket..."
	
	-- Assume Netzone may be connected → click to disconnect
	log "📴 Disconnecting Netzone..."
	tell application "Netzone" to activate
	delay 0.5
	do shell script "/opt/homebrew/bin/cliclick c:" & netzoneX & "," & netzoneY
	delay 2 -- wait for disconnect
	log "✅ Netzone disconnected"
	
	-- Connect Shadowrocket
	log "🌐 Connecting Shadowrocket..."
	tell application "Shadowrocket" to activate
	tell application "System Events"
		tell process "Shadowrocket"
			click vpnCheckbox
		end tell
	end tell
	log "✅ Shadowrocket connected"
end if

log "🎯 VPN switch complete."
