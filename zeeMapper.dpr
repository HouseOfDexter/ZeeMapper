program zeeMapper;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }
 {Some of the icons come from http://www.famfamfam.com/lab/icons/silk/ and
  check them out...and even Best...there Free!}

{%ToDo 'zeeMapper.todo'}

uses
  Forms,
  fRename in 'fRename.pas' {frmRename},
  fMapper in 'fMapper.pas' {frMapper: TFrame},
  fZeeMapper in 'fZeeMapper.pas' {frmZeeMapper},
  fRule in 'fRule.pas' {frRule: TFrame},
  fOptions in 'fOptions.pas' {frmOptions},
  crpDefaults in 'crpDefaults.pas',
  crpRule in 'crpRule.pas',
  crpBase in 'crpBase.pas',
  crpZeeMapperDefault in 'crpZeeMapperDefault.pas',
  crpFileUtility in 'crpFileUtility.pas',
  crpKeyValue in 'crpKeyValue.pas',
  fEditor in 'fEditor.pas' {frEditor: TFrame},
  fAbstractFrame in 'fAbstractFrame.pas' {frAbstractFrame: TFrame},
  fAboutBox in 'fAboutBox.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'zeeMapper';
  Application.CreateForm(TfrmZeeMapper, frmZeeMapper);
  Application.Run;
end.
