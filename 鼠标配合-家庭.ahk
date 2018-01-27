#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

StringCaseSense, off

#include 公共.ahk

; window+control+b 打开B盘
#^b:: Run B:\

;windows+contrl+v 用vim打开当前光标下的文件
#IfWinActive ahk_class CabinetWClass
^#v UP::
send +{RButton}
sleep 50
send a
sleep 50
path:=substr(clipboard,2,-1)
IfExist, %path%
{
    run "C:\Program Files (x86)\Vim\vim74\gvim.exe" %clipboard%
}
else
{
    SoundPlay, *48
}
return
#If
 
 
;contrl+F11 一次向上滚10次
^F11 UP::
Loop, 9
{
    send {WheelUp}
    sleep 20
}
send {WheelUp}
return
 
;contrl+F12 一次向下滚10次
^F12 UP::
Loop, 9
{
    send {WheelDown}
    sleep 20
}
send {WheelDown}
return
