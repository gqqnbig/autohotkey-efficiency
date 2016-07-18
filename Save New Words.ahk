; alt+shift+control+s 灵格斯单词放入生词本
!+^S::
; 调出灵格斯窗口
WinGet, activeProcess, ProcessName, A
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
