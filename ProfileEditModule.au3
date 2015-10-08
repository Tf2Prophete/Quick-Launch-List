Global $ProfileData, $CurrentProfile, $Gui, $ProgramListing

Func _AddProgram()
	GuiSetState(@SW_DISABLE, $Gui)
	$NameProgram = ""
	$Count = 1

		$ProfileData = IniReadSection(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs")
	If @Error Then
		Sleep(10)
	Else
	For $i = 1 To $ProfileData[0][0]
		$Count += 1
	Next
	EndIf

	$CheckNewProgram = MsgBox(4, "Add Program", "Would you like to add a program?")
	If $CheckNewProgram = 6 Then
		While $NameProgram = ""
			$NameProgram = InputBox("Add Program", "What would you like to name the program?" & @CRLF & "Type 'Cancel' to cancel")
			If $NameProgram = "Cancel" Then
				Sleep(10)
				Else
		$ProgramToAdd = FileOpenDialog("Add Program", @DesktopDir, "All (*.*)")
		If $ProgramToAdd = "" Then
			MsgBox(48, "Error", "No program added!")
			GuiSetState(@SW_ENABLE, $Gui)
			WinActivate($Gui)
		Else
			IniWrite(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs", $Count, $NameProgram & "|" & $ProgramToAdd)
			GUIDelete($Gui)
			_EditProfile()
		EndIf
				EndIf
		WEnd
		Else
		GuiSetState(@SW_ENABLE, $Gui)
		WinActivate($Gui)
		Sleep(10)
	EndIf
EndFunc   ;==>_AddProgram

Func _AddWebsite()
	GuiSetState(@SW_DISABLE, $Gui)
	$NameWebsite = ""
	$Count = 1
			$ProfileData = IniReadSection(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs")
	If @Error Then
		Sleep(10)
	Else
	For $i = 1 To $ProfileData[0][0]
		$Count += 1
	Next
	EndIf
	$CheckNewWebsite = MsgBox(4, "Add Website", "Would you like to add a website?")
	If $CheckNewWebsite = 6 Then
		While $NameWebsite = ""
			$NameWebsite = InputBox("Add Website", "What would you like to name the website?" & @CRLF & "Type 'Cancel' to cancel")
			If $NameWebsite = "Cancel" Then
				Sleep(10)
				GuiSetState(@SW_ENABLE, $Gui)
				WinActivate($Gui)
				Else
		$WebsiteToAdd = InputBox("Add Website", "Enter the URL of the website.")
		If $WebsiteToAdd = "" Then
			MsgBox(48, "Error", "No website added!")
			GuiSetState(@SW_ENABLE, $Gui)
			WinActivate($Gui)
		Else
			IniWrite(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs", $Count, $NameWebsite & "|" & $WebsiteToAdd)
			GUIDelete($Gui)
			_EditProfile()
		EndIf
				EndIf
		WEnd
		Else
		GuiSetState(@SW_ENABLE, $Gui)
		WinActivate($Gui)
		Sleep(10)
	EndIf
EndFunc   ;==>_AddWebsite

Func _RemoveProgramFromList()
	$ProgramToRemove = GUICtrlRead($ProgramListing)
	If $ProgramToRemove = "" Then
		Sleep(10)
		Else
	$Find = _ArraySearch($ProfileData, $ProgramToRemove, Default, Default, 1, 3)
	$Delete = _ArrayDelete($ProfileData, $Find)
	IniDelete(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs")
	For $i = 1 To $ProfileData[0][0] - 1
		IniWrite(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs", $i, $ProfileData[$i][1])
	Next
	$CheckIni = IniRead(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs", "1", "")
	If $CheckIni = "" Then
		IniWriteSection(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs", "")
	Else
		Sleep(10)
	EndIf
	GUIDelete($Gui)
	_EditProfile()
		EndIf

EndFunc   ;==>_RemoveCommentFromList