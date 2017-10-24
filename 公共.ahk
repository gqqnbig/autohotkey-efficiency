

recentlyClosed:=false

; alt+shift+contrl+c 关闭标签或窗口
!+^C:: ;约从Chrome 53开始，alt+shift+control+c容易被Chrome先捕获，AutoHotKey后捕获UP事件，造成shift粘滞的现象。
if(recentlyClosed)
    return
else
   recentlyClosed:=true
SetTimer, ResetRecentlyClosed, -500
WinGet, processName, ProcessName, A
WinGetActiveTitle, winTitle
;一个等号是不区分大小写的比较
if (ProcessName="eclipse.exe") ;在编程环境中是单步跳过
	send {F10}
else if (ProcessName="devenv.exe")
	send {F10}
else if (winTitle="F12" && ProcessName="iexplore.exe")
	send {F10}
else if (InStr(winTitle, "Developer Tool")==1 && ProcessName="chrome.exe")
	send {F10}
else if (ProcessName="chrome.exe")
	send ^w
else if(ProcessName="Lingoes64.exe"|| ProcessName="Lingoes.exe")
	send {Esc}
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
;VarSetCapacity(winTitle, 255)
WinGetActiveTitle, winTitle
if (ProcessName=="eclipse.exe") ;在编程环境中是单步进入
	send {F11}
else if (ProcessName=="devenv.exe")
	send {F11}
else
	send ^{tab}
return

;control+alt+Windows+l 历史记录中的下一页
^!#l:: send !{right}

;windows+contrl+y 复制/获取副本命令
^#y UP::
if (a_cursor="IBeam")
{
	sleep 30
	send ^c
}
else
{
	WinGet, path, ProcessPath, A
	if(EndsWith(path, "chrome.exe")) ;chrome里复制当前标签
	{
		clipboard=
		send !d
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

