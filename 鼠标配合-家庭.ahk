#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

StringCaseSense, off

#include 公共.ahk

; window+control+b 打开B盘
#^b::
Process, Exist, dopus.exe
if(ErrorLevel=0)
    Run B:\
else
{
    fullPath := GetModuleFileNameEx(ErrorLevel)
    SplitPath, fullPath, , folderPath, 
    Run %folderPath%\dopusrt.exe  /acmd Go "B:\" NEWTAB=findexisting`,tofront
}
return


;windows+contrl+v 用vim打开当前光标下的文件
#IfWinActive ahk_class CabinetWClass
^#v UP::
SendInput +{RButton}
sleep 50
SendInput a
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
    SendInput {WheelUp}
    sleep 20
}
SendInput {WheelUp}
return
 
;contrl+F12 一次向下滚10次
^F12 UP::
Loop, 9
{
    SendInput {WheelDown}
    sleep 20
}
SendInput {WheelDown}
return



GetModuleFileNameEx( p_pid ) ; by shimanov -  www.autohotkey.com/forum/viewtopic.php?t=9000
{

   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
   if ( ErrorLevel or h_process = 0 )
      return

   name_size = 255
   VarSetCapacity( name, name_size )

   result := DllCall( "psapi.dll\GetModuleFileNameEx" ( A_IsUnicode ? "W" : "A" )
                 , "uint", h_process, "uint", 0, "str", name, "uint", name_size )

   DllCall( "CloseHandle", h_process )

   return, name
}
