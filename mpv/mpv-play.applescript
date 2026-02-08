on open fileList
	set homePath to system attribute "HOME"
	set mpvPlayPath to homePath & "/.local/bin/mpv-play"

	repeat with theFile in fileList
		set filePath to POSIX path of theFile
		do shell script quoted form of mpvPlayPath & " " & quoted form of filePath & " > /dev/null 2>&1 &"
	end repeat
end open

on run
	-- Do nothing when launched without files
end run
