on open (fileList)
	set playlist to ""
	repeat with aFile in fileList
		set filePath to POSIX path of aFile
		set playlist to playlist & quoted form of filePath & " "
	end repeat
	do shell script "/opt/homebrew/bin/mpv " & playlist & "&>/dev/null &"
end open
# https://www.reddit.com/r/mpv/comments/1fhp8yv/setting_native_mpv_player_as_default_on_macos/
# export it as an app and then do step 4
# duti -s com.apple.ScriptEditor.id.open-with-mpv .mp4 all
# duti -s com.apple.ScriptEditor.id.open-with-mpv .mkv all
# duti -s com.apple.ScriptEditor.id.open-with-mpv .avi all
# duti -s com.apple.ScriptEditor.id.open-with-mpv .mov all
# duti -s com.apple.ScriptEditor.id.open-with-mpv .webm all
