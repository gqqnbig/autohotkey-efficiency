keyword= WScript.Arguments(0)

On Error Resume Next

MSVS_versions = Array _
( _
    "VisualStudio.DTE.15.0", _
    "VisualStudio.DTE.14.0", _
    "VisualStudio.DTE.12.0", _
    "VisualStudio.DTE.11.0", _
    "VisualStudio.DTE.10.0", _
    "VisualStudio.DTE.9.0", _
    "VisualStudio.DTE.8.0", _
    "VisualStudio.DTE.7.1", _
    "VisualStudio.DTE.7" _
)

For each version in MSVS_versions
    Err.Clear
    Set dte = getObject(,version)
    If Err.Number = 0 Then
        Exit For
    End If
Next

If Err.Number <> 0 Then
    Set dte = WScript.CreateObject("VisualStudio.DTE")
    Err.Clear
End If

dte.MainWindow.Activate
dte.MainWindow.Visible = True
dte.UserControl = True

dte.ExecuteCommand "View.ViewDesigner"
dte.ExecuteCommand "View.ViewMarkup"
dte.ExecuteCommand "Edit.Find", "ID=^""" & keyword & "^"" /doc"

