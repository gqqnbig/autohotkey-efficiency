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
