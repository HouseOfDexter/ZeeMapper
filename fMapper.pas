unit fMapper;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Grids, ExtCtrls, crpMapper, ValEdit, crpBase,
  crpKeyValue, fAbstractFrame, ActnList, Menus;

type
  TfrMapper = class(TfrAbstractFrame)
    Panel1: TPanel;
    vleMapper: TValueListEditor;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure vleMapperStringsChange(Sender: TObject);
  private
    FMapLoader: TcrpKeyValueLoader;
    FMapper: TcrpKeyValueMapper;
    FMap: TFilename;
    FHasChanged: boolean;
    FOldValues: TStrings;
    FIsZeeMapperMap: boolean;
    procedure SetMap(const Value: TFilename);
    function GetHasChanged: boolean;
    procedure SetHasChanged(const Value: boolean);
    function GetMap: TFilename;
    function GetMapFileName: TFileName;
    procedure SetMapFileName(const Value: TFileName);
  protected
    property MapFileName: TFileName read GetMapFileName write SetMapFileName;
  public
    procedure LoadFrame; override;
    procedure UnloadFrame; override;
    procedure SaveMap;
    procedure SetKeyOptions(aCanUpdateKey: boolean);
    procedure UpdateMap(aSender: TObject; var aSection: string; var aValues: TStrings);
    property HasChanged: boolean read GetHasChanged write SetHasChanged;
    property Map: TFilename read GetMap write SetMap;
    property IsZeeMapperMap: boolean read FIsZeeMapperMap write FIsZeeMapperMap;
  end;

implementation

{$R *.dfm}

uses
  crpZeeMapperDefault, crpFileUtility;

procedure TfrMapper.SaveMap;
var
  a_MResult: TModalResult;

begin
  if HasChanged then
  begin
    a_MResult := MessageDlg('Save Changes to ""' + Map + '"" Map?',mtConfirmation, [mbYes, mbNo], 0);
    if a_MResult = mrYes then
      FMapLoader.SaveToFile(MapFileName, vleMapper.Strings, cSecMain);

    HasChanged := False;
  end;
end;

procedure TfrMapper.SetMap(const Value: TFilename);
begin
  FMap := Value;
  SetMapFileName(FMap);
end;

procedure TfrMapper.LoadFrame;
begin
  inherited;
  if not Assigned(FMapper) then
    FMapper := TcrpKeyValueMapper.Create(TcrpKVRuleData);
  if Assigned(FOldValues) then
    FreeAndNil(FOldValues);
  FOldValues := TStringList.Create;
end;

procedure TfrMapper.UnloadFrame;
begin
  SaveMap;
  if Assigned(FMapLoader) then
    FreeAndNil(FMapLoader);
  if Assigned(FMapper) then
    FreeAndNil(FMapper);
  FreeAndNil(FOldValues);
  inherited;
end;

procedure TfrMapper.UpdateMap(aSender: TObject; var aSection: string; var aValues: TStrings);
begin
  aSection := cSecMain;
  aValues := vleMapper.Strings;
end;

function TfrMapper.GetHasChanged: boolean;
begin
  Result := FHasChanged;
end;

procedure TfrMapper.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
end;

procedure TfrMapper.SetKeyOptions(aCanUpdateKey: boolean);
var
  a_KeyOptions: TKeyOptions;
begin
  if aCanUpdateKey then
    a_KeyOptions := [keyEdit, keyAdd, keyDelete, keyUnique]
  else
    a_KeyOptions := [keyUnique];
  vleMapper.KeyOptions := a_KeyOptions;
end;


function TfrMapper.GetMap: TFilename;
begin
  Result := FMap;
end;

function TfrMapper.GetMapFileName: TFileName;
begin
 Result := TcrpFileUtility.ExeDirectory(Application.ExeName) + FMap + cDefaultExt;
end;

procedure TfrMapper.SetMapFileName(const Value: TFileName);
var
  a_Map: string;
begin
  a_Map := TcrpFileUtility.ExeDirectory(Application.ExeName) + Value + cDefaultExt;
  FMapLoader := TcrpKeyValueLoader.Create(TcrpKVRuleData);
  FMapLoader.OnLoadNew := UpdateMap;
  FMapLoader.LoadNewFile(a_Map, cSecMain);
  FOldValues.Assign(vleMapper.Strings);
end;

procedure TfrMapper.vleMapperStringsChange(Sender: TObject);
begin
 HasChanged := True;
end;

end.
