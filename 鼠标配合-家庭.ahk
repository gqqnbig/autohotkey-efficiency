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


GetModuleFileNameEx( p_pid ) ; by shimanov -  www.autohotkey.com/forum/viewtopic.php?t=9000
{
   local h_process, name_size, result, name

   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
   if ( ErrorLevel or h_process = 0 )
      return

   name_size:= 255
   VarSetCapacity( name, name_size )

   result := DllCall( "psapi.dll\GetModuleFileNameEx" ( A_IsUnicode ? "W" : "A" )
                 , "uint", h_process, "uint", 0, "str", name, "uint", name_size )

   DllCall( "CloseHandle", "uint", h_process )

   return, name
}
