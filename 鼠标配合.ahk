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
	if(InStr(path, "chrome.exe")-1+10=StrLen(path)) ;chrome里复制当前标签
	{
		clipboard=
		send {F6}
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

;==模式2==
; alt+shift+control+s 灵格斯单词放入生词本
!+^S::
;WinGet, p_class, ProcessName, Class
;WinGet, p_txt, ProcessName, txt
;WinGet, p_atxt, ProcessName, a.txt
;ListVars
;return
; 调出灵格斯窗口
WinGet, activeProcess, ProcessName, A
;ListVars 
if (activeProcess!="Lingoes64.exe" && activeProcess!="Lingoes.exe")
{
	send {F10}
	WinActivate, Lingoes; ahk_class Afx:000000013F860000:0
	;sleep, 100 ;毫秒
	;WinGet, activeProcess, ProcessName, A
	;if (activeProcess!="Lingoes64.exe" && activeProcess!="Lingoes.exe")
	;{
	;	SoundPlay, *48
	;	return
	;}
	if (ErrorLevel==1)
	{
		SoundPlay, *48
		return
	}
}

; 获取单词
ControlGetText, word, Edit1, A
if (word=addedWord) ;不重复添加单词
{
	SoundPlay, *48
    return
}

; 调出生词本
WinGet, p_s, ProcessName, 生词本 ahk_class #32770
if (!p_s || p_s!="Newword.exe")
	Run "C:\Program Files (x86)\Kingsoft\PowerWord PE\Newword.exe"
else
	WinActivate, 生词本 ahk_class #32770

;sleep 100
WinWait, 生词本 ahk_class #32770

;打开添加生词窗口
send ^+A
WinWait, 添加单词 ahk_class #32770,,
if (ErrorLevel==1)
{
	SoundPlay, *48
	return
}

;send ^v
ControlSetText, Edit1, %word%, 添加单词 ahk_class #32770

counter=10
sleepTime=100
while counter>0
{
	sleep %sleepTime%
	ControlGetText, explain, Edit3, A
	if (!explain)
	{
		counter:=counter-1 
		sleepTime:=sleepTime+100
	}
	else
		counter=0
}	
send {Enter}

addedWord=%word%

return


; 如果longText以value结尾，则返回1；否则返回0。
EndsWith(longText, value)
{
	return InStr(longText, value)-1+StrLen(value)=StrLen(longText)
}


