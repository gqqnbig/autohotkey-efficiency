#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode 2 ;包含指定的文字

; 如果打了分号
#IfWinActive, Eclipse
$;:: send {;}+{Enter}

$^;::send {;}

#IfWinActive

#IfWinActive, ahk_class CabinetWClass
F2::Send {F2}^a
#IfWinActive
