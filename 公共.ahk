

recentlyClosed:=false

; windows+shift+alt+c 关闭标签或窗口
#!+c:: ;约从Chrome 53开始，alt+shift+control+c容易被Chrome先捕获，AutoHotKey后捕获UP事件，造成shift粘滞的现象。
if(recentlyClosed)
    return
else
   recentlyClosed:=true
SetTimer, ResetRecentlyClosed, -500
WinGet, processName, ProcessName, A
WinGetActiveTitle, winTitle

WinGet, pid, PID, A
if(A_IsAdmin==false && IsProcessElevated(pid))
{
	TrayTip, No Operation, Target window elevated. AutoHotKey is not going to work., 1
	return
}

;一个等号是不区分大小写的比较 https://autohotkey.com/docs/Variables.htm#operators
if (ProcessName="devenv.exe") ;在编程环境中是单步跳过
	send {F10}
else if (winTitle="F12" && ProcessName="iexplore.exe")
	send {F10}
else if (InStr(winTitle, "Developer Tool")==1 && ProcessName="chrome.exe")
	send {F10}
else if (ProcessName="chrome.exe" || ProcessName="iexplore.exe")
	send ^w
else if(ProcessName="Lingoes64.exe"|| ProcessName="Lingoes.exe")
	send {Esc}
else if (ProcessName="BCompare.exe")
	send ^w
else if (ProcessName="eclipse.exe")
	send {F10}
else 
	WinClose, A
return

ResetRecentlyClosed:
  recentlyClosed:=false
return

;alt+Windows+h 上一标签页
!#h:: send ^+{tab}

;control+alt+Windows+h 历史记录中的上一页
^!#h:: send !{left}

;alt+Windows+l 下一标签页
!#l:: 
WinGet, processName, ProcessName, A

WinGet, pid, PID, A
if(A_IsAdmin==false && IsProcessElevated(pid))
{
	TrayTip, No Operation, Target window elevated. AutoHotKey is not going to work., 1
	return
}
WinGetActiveTitle, winTitle

if (ProcessName=="devenv.exe") ;在编程环境中是单步进入
	send {F11}
else if (ProcessName=="eclipse.exe")
	send {F11}
else
	send ^{tab}
return

;control+alt+Windows+l 历史记录中的下一页
^!#l:: send !{right}

;windows+contrl+y 复制/获取副本命令
^#y UP::
WinGet, path, ProcessPath, A
if (EndsWith(path,"BCompare.exe"))
{
	sleep 30
	send ^n
}
else if (a_cursor="IBeam")
{
	sleep 30
	send ^c
}
else
{
	if(EndsWith(path, "chrome.exe")) ;chrome里复制当前标签
	{
		clipboard=
		send {F6}
		sleep 30
		send ^c
		clipwait
		send ^t
		if(InStr(clipboard, "?")==0)
		{
			clipboard=%clipboard%?nodup=true
		}
		else
			clipboard=%clipboard%&nodup=true
		sleep 30
		send ^v
		sleep 30
		send {enter}
	}
	else if(EndsWith(path,"explorer.exe"))
	{
		sleep 50
		send ^n
	}
	else
		run %path%
}
return

; 如果longText以value结尾，则返回1；否则返回0。
EndsWith(longText, value)
{
	return InStr(longText, value)-1+StrLen(value)=StrLen(longText)
}

;1:elevated
;0:not elevated
;-1:error (probably elevated)
; From https://autohotkey.com/boards/viewtopic.php?p=197426#p197426
IsProcessElevated(vPID)
{
	;PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
	if !(hProc := DllCall("kernel32\OpenProcess", UInt,0x1000, Int,0, UInt,vPID, Ptr))
		return -1
	;TOKEN_QUERY := 0x8
	hToken:=0
	if !(DllCall("advapi32\OpenProcessToken", Ptr,hProc, UInt,0x8, PtrP,hToken))
	{
		DllCall("kernel32\CloseHandle", Ptr,hProc)
		return -1
	}
	;TokenElevation := 20
	vIsElevated:=0
	vSize:=0
	vRet := (DllCall("advapi32\GetTokenInformation", Ptr,hToken, Int,20, UIntP,vIsElevated, UInt,4, UIntP,vSize))
	DllCall("kernel32\CloseHandle", Ptr,hToken)
	DllCall("kernel32\CloseHandle", Ptr,hProc)
	return vRet ? vIsElevated : -1
}
