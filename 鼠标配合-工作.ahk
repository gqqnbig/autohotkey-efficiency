#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
StringCaseSense Off

vsPath:="C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"
;如果全局声明出现在任何函数的外面, 默认情况下它可以对所有函数有效

rootPathes:=[]
#Include 公共.ahk

^!F12::
WinGet, processName, ProcessName, A
WinGetActiveTitle, winTitle
if(ProcessName="chrome.exe" || ProcessName="iexplore.exe" || ProcessName="firefox.exe") ;=总是忽略大小写
{
	if(InStr(winTitle,"[Code Map]")>0)
	{
		SendInput ^c
		sleep 30
		if(FileExist(Clipboard))
			run %vsPath% /edit %Clipboard%
		else
			SoundBeep
	}
	else
	{
		if(ProcessName="iexplore.exe")
		{
			ControlGetText, Clipboard, Edit1, A
			if(StrLen(Clipboard)==0)
				ControlGetText, Clipboard, Edit2, A
		}
		else
		{
			SendInput !d
			sleep 30
			SendInput ^c
			sleep 30
		}
		; 提取相对路径


		regP:=RegExMatch(Clipboard, "P)//((beta|demo|\w\w)\.loanspq\.com|loanspq\.localhost)", matchLength)
		if(regP>0)
		{
			filePathIndex:=regP+matchLength
			filePath:="Website" SubStr(Clipboard, filePathIndex)
			Goto, foundPath
		}

		regP:=RegExMatch(Clipboard, "P)//svn\.loanspq.com.+Trunk/LoansPQ2", matchLength)
		if(regP>0)
		{
			filePathIndex:=regP+matchLength
			filePath:= SubStr(Clipboard, filePathIndex)
			Goto, foundPath
		}
		return

		foundPath:

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
	SendInput ^c
	sleep 30
	partialPath:=Clipboard
	
	StringGetPos, p, partialPath, /
	if(p==-1) ;是自定义控件
	{
		partialPath:=partialPath ".vb"
		extension:=".vb"
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


	if(!StartsWith(partialPath,"\"))
		partialPath:= "\" partialPath

	found:=false
	Loop % rootPathes.MaxIndex()
	{
		path:=rootPathes[A_Index] partialPath
		if(FileExist(path))
		{
			TrayTip, Found in cache, %partialPath%, 1
			run %vsPath% /edit %path%
			found:=true
		}
	}
	if(found)
		return

	
	; CursorHandle := DllCall( "LoadCursor", Uint,0, Int,32514) ;等待光标
	TrayTip, Searching..., Searching..., 1
	Loop, C:\LoansPQ2\*%extension%, 0, 1
	{
		if(EndsWith(A_LoopFileFullPath, partialPath))
		{
			StringGetPos, p, A_LoopFileFullPath, %partialPath%, R
			rootPath:=SubStr(A_LoopFileFullPath, 1, p) ; 规定路径要以\结尾
			;MsgBox, %rootPath%

			rootPathes.Insert(rootPath)
			run %vsPath% /edit %A_LoopFileFullPath%
			TrayTip, Send to VS, %A_LoopFileFullPath%, 1
		}
	}
	;ListVars
	;MsgBox, No more findings.
	; CursorHandle := DllCall( "LoadCursor", Uint,0, Int,32512)
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
 

^l::
SendInput ^`;
SendInput {Backspace}
SendInput ^[
SendInput ^s
SendInput {down}
return


StartsWith(longText, value)
{
	return InStr(longText, value)=1
}
