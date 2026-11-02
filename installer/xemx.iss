; XEMX Windows installer (Inno Setup 6).
; Build: iscc /DAppVersion=0.1.0 /DArtefacts=..\build\XEMX_artefacts\Release installer\xemx.iss

#ifndef AppVersion
  #define AppVersion "0.1.0"
#endif
#ifndef Artefacts
  #define Artefacts "..\build\XEMX_artefacts\Release"
#endif

[Setup]
AppId={{7E3C51A2-4F0B-4B8E-9C6D-58A1E2F0C3D1}
AppName=XEMX
AppVersion={#AppVersion}
AppPublisher=XEMX
DefaultDirName={autopf}\XEMX
DefaultGroupName=XEMX
DisableProgramGroupPage=yes
OutputDir=..
OutputBaseFilename=XEMX-Setup
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
; Admin installs for everyone; "only for me" installs without admin rights.
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog
UninstallDisplayName=XEMX {#AppVersion}
UninstallDisplayIcon={app}\XEMX.exe

[Types]
Name: "full"; Description: "VST3 plug-in and standalone app"
Name: "vst3"; Description: "VST3 plug-in only"
Name: "custom"; Description: "Custom"; Flags: iscustom

[Components]
Name: "vst3"; Description: "VST3 plug-in (Ableton Live, Bitwig, Cubase, Reaper...)"; Types: full vst3 custom; Flags: fixed
Name: "standalone"; Description: "Standalone app"; Types: full

[Files]
Source: "{#Artefacts}\VST3\XEMX.vst3\*"; DestDir: "{code:Vst3Dir}\XEMX.vst3"; Components: vst3; Flags: recursesubdirs createallsubdirs ignoreversion
Source: "{#Artefacts}\Standalone\XEMX.exe"; DestDir: "{app}"; Components: standalone; Flags: ignoreversion
Source: "README-WINDOWS.txt"; DestDir: "{app}"; Flags: isreadme ignoreversion

[Icons]
Name: "{group}\XEMX"; Filename: "{app}\XEMX.exe"; Components: standalone
Name: "{group}\Uninstall XEMX"; Filename: "{uninstallexe}"

[UninstallDelete]
Type: filesandordirs; Name: "{code:Vst3Dir}\XEMX.vst3"

[Registry]
; Remember the chosen VST3 folder for upgrades and uninstall.
Root: HKA; Subkey: "Software\XEMX"; ValueType: string; ValueName: "Vst3Dir"; ValueData: "{code:Vst3Dir}"; Flags: uninsdeletekey

[Run]
Filename: "{app}\XEMX.exe"; Description: "Open XEMX standalone"; Components: standalone; Flags: postinstall nowait skipifsilent unchecked

[Code]
var
  Vst3Page: TInputDirWizardPage;

function DefaultVst3Dir(): String;
var
  Saved: String;
begin
  if RegQueryStringValue(HKA, 'Software\XEMX', 'Vst3Dir', Saved) and (Saved <> '') then
    Result := Saved
  else if IsAdminInstallMode then
    Result := ExpandConstant('{commoncf64}\VST3')
  else
    Result := ExpandConstant('{localappdata}\Programs\Common\VST3');
end;

procedure InitializeWizard();
begin
  Vst3Page := CreateInputDirPage(wpSelectComponents,
    'VST3 plug-in folder', 'Where should the XEMX VST3 plug-in go?',
    'Pick the folder your DAW scans for VST3 plug-ins. The standard folder works with Ableton Live out of the box. ' +
    'If you use a custom VST3 folder in Ableton, choose that one instead.',
    False, '');
  Vst3Page.Add('VST3 folder:');
  Vst3Page.Values[0] := DefaultVst3Dir();
end;

function Vst3Dir(Param: String): String;
begin
  if Vst3Page <> nil then
    Result := Vst3Page.Values[0]
  else
    Result := DefaultVst3Dir();
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
begin
  Result := MemoComponentsInfo + NewLine + NewLine +
            'VST3 plug-in folder:' + NewLine + Space + Vst3Dir('') + NewLine + NewLine + MemoDirInfo;
end;
