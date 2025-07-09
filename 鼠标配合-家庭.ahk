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
	handle:=WinWaitActive("B:\ ahk_pid " pid, , 5)
	if(handle!=0)
		WinActivate "ahk_id " handle
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

#hotif WinActive("ahk_exe PDFXEdit.exe") && A_Cursor!="IBeam"
a::+^f

j::down

k::up

#hotif

#hotif WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe")
^d::TrayTip "本脚本在Chrome里禁用了Control+d。如果要添加到收藏夹，请使用鼠标。", "屏蔽误操作", 1

#hotif WinActive("ahk_exe devenv.exe") 
$^;:: Send ";{Enter}"

^!F12 UP:: Send "{F12}"

^!F11 UP:: Send "^{F12}"

#hotif 


RAlt & g:: {  ; Ctrl+Shift+G as hotkey (you can change it)
    ; Step 1: Copy selected text
	A_Clipboard := "" ; Empty the clipboard
    Send("^c")
    ClipWait(1)
    if (!A_Clipboard) {
        ; MsgBox "Clipboard is empty or copy failed."
		SoundBeep
        return
    }

    ; Step 2: Show input box with clipboard content
    InputText := InputBox("Edit your Google search query:", "Search Google",, A_Clipboard)
    if InputText.Result != "OK" || InputText.Value == "" {
        return  ; Cancelled or empty
    }

    ; Step 3: Search Google
    query := InputText.Value
	url:="https://www.google.com/search?q=" . StrReplace(UrlEscape(query, 0x00002000), "+", "%2b")
	run(url)
}

; ======================================================================================================================
; UrlEscape() -> https://docs.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-urlescapea
; URL_DONT_ESCAPE_EXTRA_INFO     = 0x02000000
; URL_ESCAPE_SPACES_ONLY         = 0x04000000
; URL_ESCAPE_PERCENT             = 0x00001000
; URL_ESCAPE_SEGMENT_ONLY        = 0x00002000
; URL_ESCAPE_AS_UTF8             = 0x00040000 (Win 7+)
; URL_ESCAPE_ASCII_URI_COMPONENT = 0x00080000 (Win 8+)
; ======================================================================================================================
UrlEscape(Url, Flags := 0) {
   local CC := 1024
	local Esc:=""
	VarSetStrCapacity( &Esc, CC )
   DllCall("Shlwapi.dll\UrlEscape", "Str", Url, "Str", Esc, "UIntP", CC, "UInt", Flags, "UInt")
	return Esc
}



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
