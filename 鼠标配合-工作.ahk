﻿#Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
StringCaseSense "Off"

vsPath:="C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe"
;如果全局声明出现在任何函数的外面, 默认情况下它可以对所有函数有效

rootPathes:=[]
#Include 公共.ahk

^!F12::
ProcessName:=WinGetProcessName("A")
winTitle:=WinGetTitle("A")
if(ProcessName="chrome.exe" || ProcessName="iexplore.exe" || ProcessName="firefox.exe") ;=总是忽略大小写
{
	if(InStr(winTitle,"[Code Map]")>0)
	{
		SendInput "^c"
		sleep 30
		if(FileExist(Clipboard))
			run(vsPath " /edit " Clipboard)
		else
			SoundBeep
	}
	else
	{
		if(ProcessName="iexplore.exe")
		{
			Clipboard:=ControlGetText("Edit1", "A")
			if(StrLen(Clipboard)==0)
				Clipboard:=ControlGetText("Edit2", "A")
		}
		else
		{
			SendInput "!d"
			sleep 30
			SendInput "^c"
			sleep 30
		}
		; 提取相对路径


		regP:=RegExMatch(Clipboard, "//((beta|demo|\w\w)\.loanspq\.com|loanspq\.localhost)", matchLength)
		if(regP>0)
		{
			filePathIndex:=regP+matchLength.Len(0)
			filePath:="Website" SubStr(Clipboard, filePathIndex)
			Goto("foundPath")
		}

		regP:=RegExMatch(Clipboard, "//svn\.loanspq.com.+Trunk/LoansPQ2", matchLength)
		if(regP>0)
		{
			filePathIndex:=regP+matchLength.Len(0)
			filePath:= SubStr(Clipboard, filePathIndex)
			Goto("foundPath")
		}
		return

		foundPath:

		; 去掉#
		p:=InStr(filePath, "#")
		if(p>0)
			filePath:= SubStr(filePath, 1, p-1)

		; 去掉?查询字符
		p2:=InStr(filePath, "?")
		if(p2>0)
			filePath:= "C:\LoansPQ2\" SubStr(filePath, 1, p2-1)
		else
			filePath:= "C:\LoansPQ2\" filePath
		if(FileExist(filePath))
			run(vsPath " /edit " filePath)
		else
			SoundBeep 
	}
}
else
{
	SendInput "^c"
	sleep 30
	partialPath:=Clipboard
	
	p:=InStr(partialPath, "/")
	if(p==0) ;是自定义控件
	{
		partialPath:=partialPath ".vb"
		extension:=".vb"
	}
	else
	{
		p:=InStr(partialPath, "~")
		if(p==1)
			partialPath:= SubStr(partialPath, 2)
		partialPath:=StrReplace(partialPath, "/", "\")
		p:=InStr(partialPath, "\", ,-1)
		extension:=SubStr(partialPath, p+1)
	}


	if(!StartsWith(partialPath,"\"))
		partialPath:= "\" partialPath

	found:=false
	Loop(rootPathes.MaxIndex())
	{
		path:=rootPathes[A_Index] partialPath
		if(FileExist(path))
		{
			TrayTip(partialPath, "Found in cache",1)
			run(vsPath " /edit " path)
			found:=true
		}
	}
	if(found)
		return

	
	; CursorHandle := DllCall( "LoadCursor", Uint,0, Int,32514) ;等待光标
	TrayTip("Searching..." partialPath)
	Loop Files, "C:\LoansPQ2\*" extension, "FR"
	{
		if(EndsWith(A_LoopFileFullPath, partialPath))
		{
			p:=InStr(A_LoopFileFullPath, partialPath, ,-1)
			rootPath:=SubStr(A_LoopFileFullPath, 1, p) ; 规定路径要以\结尾

			rootPathes.Push(rootPath)
			run(vsPath " /edit " A_LoopFileFullPath)
			TrayTip(A_LoopFileFullPath,"Send to VS",  1)
		}
	}
}
return
 

^!F11::
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
return
 

^l::
SendInput "^`;"
SendInput "{Backspace}"
SendInput "^["
SendInput "^s"
SendInput "{down}"
return


#If WinActive("ahk_exe devenv.exe")
Insert::
SendInput "!+="
SendInput "^c"
run "WScript.exe `"Go to control definition.vbs`" " Clipboard
return
#If


StartsWith(longText, value)
{
	return InStr(longText, value)=1
}
