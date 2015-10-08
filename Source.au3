#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Imgs\Icon2.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=R.S.S.
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #RequireAdmin
;~ #AutoIt3Wrapper_Icon=Imgs\Icon.ico

#include <TrayConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <Array.au3>


#include "ProfileEditModule.au3"


#include ".\Skins\Axis.au3"
#include "_UskinLibrary.au3"

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
Opt("GUIOnEventMode", 1)

_Uskin_LoadDLL()
_USkin_Init(_Axis(True))

Global $Gui, $CheckName = "", $LoadedProfile = "", $CurrentGui, $NameProgram, $CheckNewWebsite, $GetDir

$SettingsData = IniReadSection(@ScriptDir & "\Data\Settings.ini", "Settings")




$TrayMenuExit = TrayCreateItem("Exit...")
TrayItemSetOnEvent(-1, "_Exit")
$TrayRun = TrayCreateItem("Run Profile...")
TrayItemSetOnEvent(-1, "_RunPrograms")
$TrayMenuCurrentProfile = TrayCreateMenu("Current Profile...")
$TrayMenuSettings = TrayCreateMenu("Settings...")
$TrayMenuSettingsRunAsAdminItem = TrayCreateItem("Run as Admin", $TrayMenuSettings)
TrayItemSetOnEvent(-1, "_RunAsAdminCheck")
$TrayMenuSettingsProfileSelectionItem = TrayCreateItem("Profile Editing / Selection", $TrayMenuSettings)
TrayItemSetOnEvent(-1, "_ProfileGui")
$TrayCurrentProfileItem = TrayCreateItem("None", $TrayMenuCurrentProfile)

If $SettingsData[1][1] = "1" Then
	TrayItemSetState($TrayMenuSettingsRunAsAdminItem, $TRAY_CHECKED)
Else
	TrayItemSetState($TrayMenuSettingsRunAsAdminItem, $TRAY_UNCHECKED)
EndIf

If $SettingsData[2][1] > "" Then
	$CurrentProfile = $SettingsData[2][1]
	TrayItemSetText($TrayCurrentProfileItem, $CurrentProfile)
	$ProfileData = IniReadSection(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs")
EndIf

Func _RunAsAdminCheck()
	$SettingsData = IniReadSection(@ScriptDir & "\Data\Settings.ini", "Settings")
	If $SettingsData[1][1] = "1" Then
		IniWrite(@ScriptDir & "\Data\Settings.ini", "Settings", "1", "0")
		ShellExecute(@ScriptName)
		Exit
	Else
		IniWrite(@ScriptDir & "\Data\Settings.ini", "Settings", "1", "1")
		ShellExecute(@ScriptName, "", "", "runas")
		Exit
	EndIf
EndFunc   ;==>_RunAsAdminCheck





Func _ProfileGui()

	$CurrentGui = "Profile"

	$Gui = GUICreate("Profile Editor", 600, 300)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_CloseGui")

	GUICtrlCreateLabel("Current Profile", 225, 10, 200, 50)
	GUICtrlSetFont(-1, 15)

	$LoadedProfile = GUICtrlCreateInput($CurrentProfile, 140, 50, 300, 30, $ES_CENTER)
	GUICtrlSetFont(-1, 15)

	$CreateProfileButton = GUICtrlCreateButton("Create Profile", 20, 120, 160, 40)
	GUICtrlSetOnEvent($CreateProfileButton, "_CreateNewProfile")
	GUICtrlSetFont(-1, 15)

	$LoadProfileButton = GUICtrlCreateButton("Load Profile...", 425, 120, 160, 40)
	GUICtrlSetOnEvent($LoadProfileButton, "_LoadProfile")
	GUICtrlSetFont(-1, 15)

	$EditProfileButton = GUICtrlCreateButton("Edit Profile", 20, 210, 160, 40)
	GUICtrlSetOnEvent($EditProfileButton, "_EditProfile")
	GUICtrlSetFont(-1, 15)

	$RemoveProfileButton = GUICtrlCreateButton("Remove Profile", 425, 210, 160, 40)
	GUICtrlSetOnEvent($RemoveProfileButton, "_RemoveProfile")
	GUICtrlSetFont(-1, 15)

	$CloseButton = GUICtrlCreateButton("Close", 223, 165, 160, 40)
	GUICtrlSetOnEvent($CloseButton, "_CloseGui")
	GUICtrlSetFont(-1, 15)

	GuiCtrlCreateLabel("© R.S.S Software", 523, 288)
	GuiCtrlSetFont(-1, 7)

	GUISetState()
EndFunc   ;==>_ProfileGui

Func _RemoveProfile()
	$GetDir = ""
	$CheckCancel = MsgBox(4, "Remove Profile...", "Are you sure you want to remove a profile?")
	If $CheckCancel = 6 Then
		While $GetDir = ""
			$GetDir = FileSelectFolder("Remove Profile...", @ScriptDir & "\Data\Profiles")
			If $GetDir = "" Then
				MsgBox(64, "Error", "No profile selected!")
				$GetDir = 1
			Else
				$CheckCancel = MsgBox(4, "Remove Profile...", "Are you sure you wish to remove this profile?")
				If $CheckCancel = 6 Then
					DirRemove($GetDir, 1)
					MsgBox(0, "Remove Profile...", "Profile removed!")
				Else
					Sleep(10)
				EndIf
			EndIf
		WEnd
	Else
		Sleep(10)
	EndIf
EndFunc   ;==>_RemoveProfile


Func _EditProfile()


	GUIDelete($Gui)

	$CurrentGui = "Edit"

	$Gui = GUICreate("Edit Profile", 600, 270)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_CloseGui")

	GUICtrlCreateLabel("Program List", 225, 10, 200, 50)
	GUICtrlSetFont(-1, 15)

	$ProgramListing = GUICtrlCreateCombo("", 20, 50, 560, 30)
	GUICtrlSetFont(-1, 15)

	$ProfileData = IniReadSection(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs")
	If @error Then
		Sleep(10)
	Else

		For $i = 1 To $ProfileData[0][0]
			$StringSplit = StringSplit($ProfileData[$i][1], "|")
			GUICtrlSetData($ProgramListing, $StringSplit[1])
		Next

	EndIf

	$AddProgramButton = GUICtrlCreateButton("Add Program", 5, 140, 170, 50)
	GUICtrlSetOnEvent($AddProgramButton, "_AddProgram")
	GUICtrlSetFont(-1, 15)

	$AddWebsiteButton = GUICtrlCreateButton("Add Website", 215, 140, 170, 50)
	GUICtrlSetOnEvent($AddWebsiteButton, "_AddWebsite")
	GUICtrlSetFont(-1, 15)

	$CloseButton = GUICtrlCreateButton("Close", 215, 210, 170, 50)
	GUICtrlSetOnEvent($CloseButton, "_CloseGui")
	GUICtrlSetFont(-1, 15)

	$RemoveProgramButton = GUICtrlCreateButton("Remove Program", 425, 140, 170, 50)
	GUICtrlSetOnEvent($RemoveProgramButton, "_RemoveProgramFromList")
	GUICtrlSetFont(-1, 15)

	GUISetState()
EndFunc   ;==>_EditProfile


Func _LoadProfile()
	GUISetState(@SW_DISABLE, $Gui)

	$ProfileToLoad = FileOpenDialog("Load Profile...", @ScriptDir & "\Data\Profiles", "Ini Files (*.ini)")
	If $ProfileToLoad = "" Then
		MsgBox(48, "Error", "No profile loaded!")
		GUISetState(@SW_ENABLE, $Gui)
		WinActivate($Gui)
	Else
		$Split = StringSplit($ProfileToLoad, "\")
		$DataToPull = $Split[0]
		$ProfileLoaded = $Split[$DataToPull]
		$ProfileLoaded = StringTrimRight($ProfileLoaded, 4)
		$CurrentProfile = $ProfileLoaded
		GUICtrlSetData($LoadedProfile, $ProfileLoaded)
		MsgBox(0, "Load Profile...", "Profile loaded!")
		TrayItemSetText($TrayCurrentProfileItem, $ProfileLoaded)
		IniWrite(@ScriptDir & "\Data\Settings.ini", "Settings", "2", $ProfileLoaded)
		GUISetState(@SW_ENABLE, $Gui)
		WinActivate($Gui)
	EndIf
EndFunc   ;==>_LoadProfile


Func _CreateNewProfile()
	$CheckName = ""
	GUISetState(@SW_DISABLE, $Gui)

	$CheckCancel = MsgBox(4, "Create Profile...", "Are you ready to create a new profile?")
	If $CheckCancel = 6 Then
		While $CheckName = ""
			$CheckName = InputBox("New Profile...", "What would you like to name this new profile?")
			DirGetSize(@ScriptDir & "/Data/Profiles/" & $CheckName)
			If @error Then
				DirCreate(@ScriptDir & "/Data/Profiles/" & $CheckName)
				IniWrite(@ScriptDir & "/Data/Profiles/" & $CheckName & "/" & $CheckName & ".ini", "Profile", "Name", $CheckName)
				GUISetState(@SW_ENABLE, $Gui)
				WinActivate($Gui)
				MsgBox(0, "New Profile...", "Profile created!")
				GUICtrlSetData($LoadedProfile, $CheckName)
				TrayItemSetText($TrayCurrentProfileItem, $CheckName)
				IniWrite(@ScriptDir & "\Data\Settings.ini", "Settings", "2", $CheckName)
				$CurrentProfile = $CheckName
			Else
				MsgBox(48, "Error", "A profile already exists with this name!")
				$CheckCancel = MsgBox(4, "Create Profile...", "Would you like to try again?")
				If $CheckCancel = 6 Then
					$CheckName = ""
				Else
					GUISetState(@SW_ENABLE, $Gui)
					WinActivate($Gui)
				EndIf
			EndIf
		WEnd
	Else
		Sleep(10)
		GUISetState(@SW_ENABLE, $Gui)
		WinActivate($Gui)
	EndIf

EndFunc   ;==>_CreateNewProfile

Func _RunPrograms()
	$ProfileData = IniReadSection(@ScriptDir & "\Data\Profiles\" & $CurrentProfile & "\" & $CurrentProfile & ".ini", "Programs")
	If @error Then
		MsgBox(48, "Error", "No programs found!")
	Else
		For $i = 1 To $ProfileData[0][0]
			$SplitData = StringSplit($ProfileData[$i][1], "|")
			If @error Then
				MsgBox(48, "Error", "No programs listed!")
				ExitLoop
			Else
				ShellExecute($SplitData[2])
			EndIf
		Next
	EndIf

EndFunc   ;==>_RunPrograms

Func _CloseGui()
	If $CurrentGui = "Profile" Then
		GUIDelete($Gui)
	ElseIf $CurrentGui = "Edit" Then
		GUIDelete($Gui)
		_ProfileGui()
	EndIf
EndFunc   ;==>_CloseGui


Func _Exit()
	Exit
EndFunc   ;==>_Exit


While 1
	Sleep(10)
WEnd
