#Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

StringCaseSense "off"

TraySetIcon("icon.ico")

#include 公共.ahk

; window+control+b 打开B盘
#^b::
pid:=ProcessExist("dopus.exe")
if(pid==0)
    Run "B:\"
else
{
    fullPath := GetModuleFileNameEx(pid)
    SplitPath fullPath, , folderPath, 
    Run folderPath "\dopusrt.exe  /acmd Go B:\ NEWTAB=findexisting`,tofront"
}
return

#If A_Cursor=="IBeam"
^u UP::
Clipboard:=""
SendEvent "^c"
if(ClipWait(1))
{
	Clipboard:=StrLower(Clipboard)
	SendText Clipboard
}
else
	TrayTip "无法操作", "control+c没有把内容存入剪贴板", 17
return

^+u UP::
Clipboard:=""
SendEvent "^c"
if(ClipWait(1))
{
	Clipboard:=StrUpper(Clipboard)
	SendText Clipboard
}
else
	TrayTip "无法操作", "control+c没有把内容存入剪贴板", 17
return

#IF


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

   return name
}
