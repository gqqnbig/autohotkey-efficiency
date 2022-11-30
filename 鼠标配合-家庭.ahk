#Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

TraySetIcon("icon.ico")

#include 公共.ahk

; window+control+b 打开B盘
#^b::
{
pid:=ProcessExist("dopus.exe")
if(pid==0)
    Run "B:\"
else
{
    fullPath := GetModuleFileNameEx(pid)
    SplitPath fullPath, , &folderPath
    Run folderPath "\dopusrt.exe  /acmd Go B:\ NEWTAB=findexisting`,tofront"
	sleep 1000
	WinActivate "B:\ ahk_pid " pid
}
}

#hotif A_Cursor=="IBeam" && !WinActive("ahk_exe putty.exe")
^u UP::
{
A_Clipboard:=""
SendEvent "^c"
if(ClipWait(1))
{
	A_Clipboard:=StrLower(A_Clipboard)
	SendText A_Clipboard
}
else
	TrayTip "无法操作", "control+c没有把内容存入剪贴板", 17
}

^+u UP::
{
A_Clipboard:=""
SendEvent "^c"
if(ClipWait(1))
{
	A_Clipboard:=StrUpper(A_Clipboard)
	SendText A_Clipboard
}
else
	TrayTip "无法操作", "control+c没有把内容存入剪贴板", 17
}

#hotif

#hotif WinActive("ahk_exe PDFXCview.exe") && InStr(ControlGetClassNN(ControlGetFocus("A")), "Edit")==0
; DSUI:CmdEdit2
; Edit1
a::+^f

j::down

k::up

#hotif

#hotif WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe")
^d::TrayTip "本脚本在Chrome里禁用了Control+d。如果要添加到收藏夹，请使用鼠标。", "屏蔽误操作", 1
#hotif 


#hotif ! WinActive("ahk_exe putty.exe")
;ctrl+g 用google搜索剪贴板关键词
^g::run "https://www.google.com/search?q=" . A_Clipboard
#hotif



GetModuleFileNameEx( p_pid ) ; by shimanov -  www.autohotkey.com/forum/viewtopic.php?t=9000
{
   local h_process, name_size, result, name

   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
   if ( h_process = 0 )
      return

   name_size:= 255
   VarSetStrCapacity( &name, name_size )

   result := DllCall( "psapi.dll\GetModuleFileNameExW", "uint", h_process, "uint", 0, "str", name, "uint", name_size )

   DllCall( "CloseHandle", "uint", h_process )

   return name
}
