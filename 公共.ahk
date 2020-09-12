SetKeyDelay 30


recentlyClosed:=false

; windows+shift+alt+c 关闭标签或窗口
#!+c:: ;约从Chrome 53开始，alt+shift+control+c容易被Chrome先捕获，AutoHotKey后捕获UP事件，造成shift粘滞的现象。
{
global recentlyClosed
if (recentlyClosed)
    return
else
   recentlyClosed:=true
SetTimer "ResetRecentlyClosed", -500
try
{
	ProcessName:=WinGetProcessName("A")
}
catch e
{
	TrayTip "无法操作", e.Message, 1
	return
}
winTitle:=WinGetTitle("A") 

pid:=WinGetPID("A")
if(A_IsAdmin==false && IsProcessElevated(pid))
{
	TrayTip "无法操作", "目标窗口具有管理员权限，而本脚本不具有管理员权限", 1
	return
}

;一个等号是不区分大小写的比较 https://autohotkey.com/docs/Variables.htm#operators
if (ProcessName="devenv.exe") ;在编程环境中是单步跳过
	SendInput "{F10}"
else if (winTitle="F12" && ProcessName="iexplore.exe")
	SendInput "{F10}"
else if (InStr(winTitle, "Developer Tool")==1 && ProcessName="chrome.exe")
	SendInput "{F10}"
else if (ProcessName="chrome.exe" || ProcessName="iexplore.exe")
	SendInput "^w"
else if(ProcessName="Lingoes64.exe"|| ProcessName="Lingoes.exe")
	SendInput "{Esc}"
else if (ProcessName="dopus.exe")
	SendInput "^w"
else if (ProcessName="BCompare.exe")
	SendInput "^w"
; 向ShellExperienceHost.exe发送WinClose会触发关机对话框。
else if(ProcessName = "ShellExperienceHost.exe")
	SendInput "{Esc}"
; explorer如果没有窗口，发送winclose会变成关机，容易误操作。
else if (ProcessName="explorer.exe")
	SendInput "^w"
else if (ProcessName="eclipse.exe")
	SendInput "{F10}"
else 
	WinClose "A"
}

ResetRecentlyClosed()
{
  global recentlyClosed
  recentlyClosed:=false
}
;alt+Windows+h 上一标签页
!#h::
{
try
{
	ProcessName:=WinGetProcessName("A")
}
catch e
{
	TrayTip "无法操作", e.Message, 1
	return
}
if (ProcessName="dopus.exe")
	SendInput "^{left}"
else
	SendInput "^+{tab}"
}

;control+alt+Windows+h 历史记录中的上一页
^!#h:: SendInput "!{left}"

;alt+Windows+l 下一标签页
!#l:: 
{
try
{
	ProcessName:=WinGetProcessName("A")
}
catch e
{
	TrayTip "无法操作", e.Message, 1
	return
}

pid:=WinGetPID("A")
if(A_IsAdmin==false && IsProcessElevated(pid))
{
	TrayTip "无法操作", "目标窗口具有管理员权限，而本脚本不具有管理员权限", 1
	return
}
winTitle:=WinGetTitle("A")

if (ProcessName="devenv.exe") ;在编程环境中是单步进入
	SendInput "{F11}"
else if (ProcessName="eclipse.exe")
	SendInput "{F11}"
else if(ProcessName="dopus.exe")
	SendInput "^{right}"
else
	SendInput "^{tab}"
}

;control+alt+Windows+l 历史记录中的下一页
^!#l:: SendInput "!{right}"

;windows+contrl+y 复制/获取副本命令
^#y UP::
{
path:=WinGetProcessPath("A")
if (EndsWith(path,"BCompare.exe"))
{
	SendInput "^n"
}
else if (a_cursor="IBeam")
{
	SendInput "^c"
}
else if(EndsWith(path, "chrome.exe")) ;chrome里复制当前标签
{
	A_Clipboard:=""
	SendInput("{F6}")
	SendEvent "^c"
	if(!clipwait(1))
	{
		TrayTip "快捷键错误", "F6没有获取到标签页地址", 1
		SendInput("!d")
		SendEvent "^c"
		if(!clipwait(1))
		{
			TrayTip "快捷键错误", "alt+d没有获取到标签页地址", 1
			return
		}
	}

	SendInput "^t"
	if(InStr(A_Clipboard, "?")==0)
	{
		A_Clipboard:= A_Clipboard "?nodup=true"
	}
	else
		A_Clipboard:= A_Clipboard "&nodup=true"
	SendText A_Clipboard
	SendInput "{enter}"
}
else if(EndsWith(path,"explorer.exe"))
{
	sleep 50
	SendInput "^n"
}
else
	run path
}


^!F11::
{
If WinActive("ahk_exe chrome.exe")
{
	send "^I"
	return
}
If WinActive("ahk_exe firefox.exe")
{
   send "^I"
   return
}
If WinActive("ahk_exe devenv.exe")
{
   send "^l"
   return
}
If WinActive("ahk_exe iexplore.exe")
{
   send "{F12}"
   return
}
}

; #If WinActive("ahk_exe chrome.exe")
; ^d::
; TrayTip "本脚本在Chrome里禁用了Control+d。如果要添加到收藏夹，请使用鼠标。", "屏蔽误操作", 1
; return
; #If 


; 如果longText以value结尾，则返回1；否则返回0。
EndsWith(longText, value)
{
	if(InStr(longText, value)=0)
		return 0
	return InStr(longText, value)-1+StrLen(value)=StrLen(longText)
}

;1:elevated
;0:not elevated
;-1:error (probably elevated)
; From https://autohotkey.com/boards/viewtopic.php?p=197426#p197426
IsProcessElevated(vPID)
{
	;PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
	if !(hProc := DllCall("kernel32\OpenProcess", "UInt", 0x1000, "Int", 0, "UInt",vPID, "Ptr"))
		return -1
	;TOKEN_QUERY := 0x8
	hToken:=0
	if !(DllCall("advapi32\OpenProcessToken", "Ptr",hProc, "UInt",0x8, "PtrP",hToken))
	{
		DllCall("kernel32\CloseHandle", Ptr,hProc)
		return -1
	}
	;TokenElevation := 20
	vIsElevated:=0
	vSize:=0
	vRet := (DllCall("advapi32\GetTokenInformation", "Ptr",hToken, "Int",20, "UIntP",vIsElevated, "UInt",4, "UIntP",vSize))
	DllCall("kernel32\CloseHandle", "Ptr",hToken)
	DllCall("kernel32\CloseHandle", "Ptr",hProc)
	return vRet ? vIsElevated : -1
}
