; Start up
WinName := "ToF AHK Helper by wacloudy"
#NoEnv
Process, Priority,, High
#SingleInstance force
DetectHiddenWindows, On
DetectHiddenText, On
Menu, Tray, Icon, data\icon.png, ,1

; Force Run as Admin
IniRead, IsAdmin, data\settings.ini, Settings, IsAdmin
if IsAdmin
{
CommandLine := DllCall("GetCommandLine", "Str")
If !(A_IsAdmin || RegExMatch(CommandLine, " /restart(?!\S)")) {
    Try {
        If (A_IsCompiled) {
            Run *RunAs "%A_ScriptFullPath%" /restart
        } Else {
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
        }
    }
    ExitApp
}
}
Menu, Tray, NoStandard
Menu, Tray, DeleteAll
Menu, Tray, add, Reload, menu_reload
Menu, Tray, Icon, Reload, shell32.dll, 239, 16
Menu, Tray, add, Pause-Play, menu_pause
Menu, Tray, Icon, Pause-Play, imageres.dll, 233, 16
Menu, Tray, Default, Reload
Menu, Tray, add
Menu,Tray, add, Сreate AHK shortcut, menu_create_shortcut
Menu,Tray, Icon, Сreate AHK shortcut, shell32.dll,264, 16
Menu, Tray, add
Menu, Tray, add, Exit, menu_exit
Menu, Tray, Icon, Exit, shell32.dll,28, 16

; Set Binds
IniRead, map, data\settings.ini, Settings, map
IniRead, multislash, data\settings.ini, Settings, multislash
IniRead, auto_dodge, data\settings.ini, Settings, auto_dodge
IniRead, auto_attack, data\settings.ini, Settings, auto_attack
IniRead, auto_climb, data\settings.ini, Settings, auto_climb

IniRead, browser, data\setting.ini, Settings, browser
IniRead, map_title, data\settings.ini, Settings, map_title
IniRead, map_link, data\settings.ini, Settings, map_link

Hotkey, %map%, key_map, on
Hotkey, *~%multislash%, key_multislash, on
Hotkey, *~%auto_dodge%, key_auto_dodge, on
Hotkey, *~%auto_attack%, key_auto_attack, on
Hotkey, *~%auto_climb%, key_auto_climb, on

; Map
key_map:
IfWinActive, ahk_exe QRSL.exe
if WinExist("%map_title%")
	WinActivate
else {
	WinActivate, ahk_class Chrome_WidgetWin_1
	WinGetActiveTitle, starting_title
	loop {
		IfWinActive, %map_title%
			return
		send ^{Tab}
		WinGetActiveTitle, current_tab
		If (current_tab == starting_title)
			break
	}
	run, %map_link%
}
else {
	WinActivate, ahk_exe QRSL.exe
}
return

; Frigg Multislash
key_multislash:
IfWinActive, ahk_exe QRSL.exe
loop
{
	GetKeyState, key_held, %multislash%, P
	if key_held = U
		break
	SetKeyDelay, -1, -1
	Send +{Click Left}
}
return

; Spam dodge
#IfWinActive Tower of Fantasy
key_auto_dodge:
	loop
	{	
		GetKeyState, key_held, %auto_dodge%, P
		if key_held = U
			break
		Send {Shift}
	}
return

; Auto attack
key_auto_attack:
	loop
	{
		GetKeyState, key_held, %auto_attack%, P
		if key_held = U
			break
		Send {Click Left}
	}
return

; Fast Climber
key_auto_climb:
	loop
	{
		GetKeyState, key_held, %auto_climb%, P
		if key_held = U
			break
		SendInput {Control}
		sleep 50
		SendInput {Space}
		sleep 200
		SendInput {Space}
		sleep 50
		SendInput {w Down}
		sleep 70
		GetKeyState, key_held, %auto_climb%, P
		If key_held = U
			SendInput {w Up}
	}
return

; Menu Settings (can ignore)
menu_reload:
Reload
return

menu_pause:
Suspend, Toggle
toggle := toggle
if (toggle)
	Menu,Tray, Icon, Pause-Play, imageres.dll, 230, 16
Else {
	Menu,Tray, Icon, Pause-Play, imageres.dll, 233, 16
}
Pause , Toggle, 1
return

menu_create_shortcut:
FileCreateShortcut, %A_ScriptFullPath%, %A_Desktop%\tofahk.lnk,,,Tower of Fantasy Helper, %A_ScriptDir%\data\icon.png
return

menu_exit:
Exitapp
return
	