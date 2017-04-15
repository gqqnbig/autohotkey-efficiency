#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Mouse, Screen
SysGet, monitorCount, MonitorCount

MouseGetPos, mouseX, mouseY

Loop, %MonitorCount%
{
	SysGet, bounding, Monitor, %A_Index%
	if(mouseX>= boundingLeft and mouseX<boundingRight and mouseY>=boundingTop and mouseY<boundingBottom)
	{
		currentMonitor:=A_Index
		break
	}	
}


if(currentMonitor)
	TrayTip  显示第%currentMonitor%个显示器的桌面
else
{
	TrayTip  无法判断当前桌面
	return
}

WinGet, windows, List

WinGet, active_id, ID, A

Loop, %windows%
{
	varName= windows%A_Index%
	winHandle:=%varName%
	WinGetPos, winX, winY, w,h, ahk_id %winHandle%
	WinGetTitle, title, ahk_id %winHandle%

	centerX:=winX+w/2
	centerY:=winY+h/2

	;ListVars
	;msgbox %title%: %winX%,%winY%
	if(centerX>=boundingLeft and centerX<boundingRight and centerY>=boundingTop and centerY<boundingBottom)
	{
		;msgbox 最小化%title%
		WinMinimize, ahk_id %winHandle%
	}

}

