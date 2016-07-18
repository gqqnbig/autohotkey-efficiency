#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

StringCaseSense, off


;==模式1==
; alt+shift+control+b 打开B盘
!+^B:: Run B:\

; alt+shift+contrl+c 关闭标签或窗口
!+^C UP::
WinGet, processName, ProcessName, A
WinGetActiveTitle, winTitle
if (ProcessName=="eclipse.exe") ;在编程环境中是单步跳过
	send {F10}
else if (ProcessName=="devenv.exe")
	send {F10}
else if (winTitle=="F12" && ProcessName=="iexplore.exe")
	send {F10}
else if (InStr(winTitle, "Developer Tool")==1 && ProcessName=="chrome.exe")
	send {F10}
else if (ProcessName=="chrome.exe")
	send ^w
else if(ProcessName=="Lingoes64.exe"|| ProcessName=="Lingoes.exe")
	send {Esc}
else 
	WinClose, A
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
		send {F6}
		sleep 30
		send ^c
		clipwait
		send ^t
		if(InStr(clipboard, "?")==0)
			clipboard=%clipboard%?nodup=true
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


; 如果longText以value结尾，则返回1；否则返回0。
EndsWith(longText, value)
{
	return InStr(longText, value)-1+StrLen(value)=StrLen(longText)
}


