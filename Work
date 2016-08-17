#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

vsPath:="C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"

fileMapping:={} ;键是结尾部分的路径,值是匹配的全路径数组

^!F12::
WinGet, processName, ProcessName, A
WinGetActiveTitle, winTitle
if(ProcessName=="chrome.exe" || ProcessName=="iexplore.exe")
{
	if(InStr(winTitle,"[Code Map]")>0)
	{
		send ^c
		sleep 30
		if(FileExist(Clipboard))
			run %vsPath% /edit %Clipboard%
		else
			SoundBeep
	}
	else
	{
		if(ProcessName=="iexplore.exe")
			ControlGetText, Clipboard, Edit1, A
		else
		{
			send !d
			sleep 30
			send ^c
			sleep 30
		}
		; 提取相对路径
		p:=0
		StringGetPos, p1, Clipboard, loanspq.localhost
		if(p1>-1)
		{
			p:=p1
			StringGetPos, p, Clipboard, /, L3
			p:=p+1
			filePath:="website" SubStr(Clipboard, p)
			Goto, foundPath
		}

		StringGetPos, p1, Clipboard, beta.loanspq.com
		if(p1>-1)
		{
			p:=p1
			StringGetPos, p, Clipboard, /, L3
			p:=p+1
			filePath:="website" SubStr(Clipboard, p)
			Goto, foundPath
		}


		StringGetPos, p1, Clipboard, svn.loanspq.com
		if(p1>-1)
		{
			StringGetPos, p1, Clipboard, Trunk/LoansPQ2
			p:=p1+14+2
			filePath:=SubStr(Clipboard, p)
			Goto, foundPath
		}
		else
			return

		foundPath:
		;MsgBox %filePath%

		; 去掉#
		StringGetPos, p, filePath, #
		if(p>-1)
			filePath:= SubStr(filePath, 1, p)

		; 去掉?查询字符
		StringGetPos, p2, filePath, ?
		if(p2>-1)
			filePath:= "C:\LoansPQ2\" SubStr(filePath, 1, p2)
		else
			filePath:= "C:\LoansPQ2\" filePath
		if(FileExist(filePath))
			run %vsPath% /edit %filePath%
		else
			SoundBeep 
	}
}
else
{
	send ^c
	sleep 30
	partialPath:=Clipboard
	
	StringGetPos, p, partialPath, /
	if(p==-1) ;是自定义控件
	{
		extension:=partialPath ".vb"
	}
	else
	{
		StringGetPos, p, partialPath, ~
		if(p==0)
			partialPath:= SubStr(partialPath, 2)
		StringReplace, partialPath, partialPath, /, \, All
		StringGetPos, p, partialPath, \, R
		extension:=SubStr(partialPath, p+2)
	}

	arr:=fileMapping[partialPath]
	if(arr)
	{
		TrayTip, Found in cache, %partialPath%, 1
		For index,value in arr
		{
			;debugValue:=SubStr(value,30)
			;ListVars
			;pause
			;SoundBeep 
			run %vsPath% /edit %value%
		}
		return
	}

	
	;tooltip, %partialPath%
	fileMapping[partialPath]:={}

	;ListVars
	;pause
	; CursorHandle := DllCall( "LoadCursor", Uint,0, Int,32514) ;等待光标
	TrayTip, Searching..., Searching..., 1
	Loop, C:\LoansPQ2\*%extension%, 0, 1
	{
		StringGetPos, p, A_LoopFileFullPath, %partialPath%
		if(p>-1)
		{
			; MsgBox, 4, , Open %A_LoopFileFullPath% ?
			; IfMsgBox, Yes
			; {
				fileMapping[partialPath].Insert(A_LoopFileFullPath)
				run %vsPath% /edit %A_LoopFileFullPath%
				TrayTip, Send to VS, %A_LoopFileFullPath%, 1
				;CursorHandle := DllCall( "LoadCursor", Uint,0, Int,32512) 
				;return
			; }
		}
	}
	;ListVars
	;MsgBox, No more findings.
	; CursorHandle := DllCall( "LoadCursor", Uint,0, Int,32512)
}
return
 
; alt+shift+contrl+c 关闭标签或窗口
!+^C UP::
WinGet, processName, ProcessName, A
WinGetActiveTitle, winTitle
if (ProcessName=="devenv.exe")
{
	if(InStr(winTitle,"Debugging")) ;在编程环境中是单步跳过
		send {F10}
	else
		send ^w
}
else if (winTitle=="F12" && ProcessName=="iexplore.exe")
	send {F10}
else if (InStr(winTitle, "Developer Tool")==1 && ProcessName=="chrome.exe")
	send {F10}
else if (ProcessName=="chrome.exe" || ProcessName=="iexplore.exe")
    send ^w
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
if (ProcessName=="devenv.exe" && InStr(winTitle, "Debugging")) ;在编程环境中是单步进入
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
	if(InStr(clipboard, "?")=-1)
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

^!F11::
IfWinActive ahk_exe chrome.exe
{
	send ^I
	return
}
IfWinActive ahk_exe firefox.exe
{
   send ^I
   return
}
IfWinActive ahk_exe devenv.exe
{
   send ^l
   return
}
IfWinActive ahk_exe iexplore.exe
{
   send {F12}
   return
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
