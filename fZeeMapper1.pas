unit fZeeMapper1;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released to
 the public domain, to compile this code you will need components from the
 JEDI Project;  All code from the JEDI Project is under the JEDI Project
 licensing agreement;}
interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, ComCtrls, ExtCtrls, JvBrowseFolder,
  JvComponentBase, JvBaseDlg, JvFindFiles, JvExComCtrls, JvComCtrls,
  ToolWin, IniFiles, crpMapper, ImgList, fMapper;

type
  TNotifyList = procedure(aList: TStrings; var aIndex: integer) of object;

  TzeeMapper = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure actDeleteNodeExecute(Sender: TObject);
    procedure actCheckAllExecute(Sender: TObject);
    procedure actDeleteCheckedNodesExecute(Sender: TObject);
    procedure actAddNodeExecute(Sender: TObject);
    procedure actUncheckAllExecute(Sender: TObject);
    procedure actRenameExecute(Sender: TObject);
    procedure actClickExecute(Sender: TObject);
    procedure actValidateNameExecute(Sender: TObject);
    procedure actEditMapExecute(Sender: TObject);
    procedure actExportValueToChildExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure pcMapperChange(Sender: TObject);
  private
    FOnWalkTree: TNotifyEvent;
    FCount: integer;
    FNode: TJvTreeNode;
    FRect: TRect;
    FHasChanged: boolean;
    FIsValid: boolean;
    FValidList: TStringList;
    FOnWalkParent: TNotifyEvent;
    FOnWalkChild: TNotifyEvent;
    FMapLoader: TcrpMapLoader;
    FMap: TcrpMapper;
    FMapExport: TcrpMapper;
    FMapList: TStrings;
    FOnWalkList: TNotifyList;
    FOnWalkSibling: TNotifyEvent;
    function GetAppDir: string;
  private
    { Private declarations }
    procedure LoadTreeView;
    procedure SaveTreeView;
    procedure WalkTree(aNode: TTreeNode);
    procedure WalkParent(aNode: TTreeNode);
    procedure WalkSibling(aNode: TTreeNode);
    procedure WalkChild(aNode: TTreeNode);
    procedure WalkList(aStrList: TStrings; var aIndex: integer);
    procedure DeleteMapping(aMap: string);
    procedure StartWalk;
    function IsAssignedNode(aNode: TObject): boolean;
    function FullMapName(aFileName: TFileName): string;
    function GetSelfMapText(aNode: TTreeNode): string;
    function GetMapText(aNode: TTreeNode): string;
    procedure AddNode(aStrList: TStrings; var aIndex: integer);
    function FindParentNode(aNodeText: string): TTreeNode;
    function GetMapLevel(aMapText: string): integer;
    function GetChildMapText(aNode: TTreeNode): string;
    function GetKey(aKey: string): string;
    function GetKeyValue(aValue: string): string;

    function GetHasChanged: boolean;
    procedure SetHasChanged(const Value: boolean);

    procedure CheckAll(aSender: TObject);
    procedure UnCheckAll(aSender: TObject);
    procedure DeleteCheckedNode(aSender: TObject);
    procedure AddCheckedNode(aSender: TObject);
    procedure CountChecked(aSender: TObject);
    procedure EditNode(aSender: TObject);
    procedure ValidateName(aSender: TObject);
    procedure ExportValueToChild(aSender: TObject);
    procedure ExportMap(aSender: TObject);
    procedure MapAll(aSender: TObject);
    procedure CountNode(aSender: TObject);

    procedure EnableActions;
    property HasChanged: boolean read GetHasChanged write SetHasChanged;
    property OnWalkTree: TNotifyEvent read FOnWalkTree write FonWalkTree;
    property OnWalkParent: TNotifyEvent read FOnWalkParent write FonWalkParent;
    property OnWalkChild: TNotifyEvent read FOnWalkChild write FOnWalkChild;
    property OnWalkSibling: TNotifyEvent read FOnWalkSibling write FOnWalkSibling;
    property OnWalkList: TNotifyList read FOnWalkList write FOnWalkList;
    property ApplicationDirectory: string read GetAppDir;
  public
    { Public declarations }
  end;

var
  zeeMapper: TzeeMapper;

implementation

{$R *.dfm}

uses
  fRename;

procedure TzeeMapper.FormCreate(Sender: TObject);
begin
  FMapLoader := TcrpMapLoader.Create(cDefaultFN);
  FMapExport := TcrpMapper.Create(TcrpMapData);
  FMap := TcrpMapper.Create(TcrpMapData);
  FMapLoader.Mapper := FMap;
  tvMap.Items.Add(nil, cDefaultName);
end;

procedure TzeeMapper.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  a_MResult: TModalResult;
begin
  if HasChanged then
  begin
    a_MResult := MessageDlg('Save Changes?',mtConfirmation, mbYesNoCancel, 0);
    if a_MResult = mrYes then
      SaveTreeView
    else if a_MResult = mrNo then
      Action := caFree
    else if a_MResult = mrCancel then
      Action := caNone;
  end else
    Action := caFree;
end;

procedure TzeeMapper.FormShow(Sender: TObject);
begin
 LoadTreeView;
end;


procedure TzeeMapper.LoadTreeView;
var
  a_Index: integer;
begin
  FMapList := TStringList.Create;
  try
    FMapLoader.LoadNewFile(FullMapName(cDefaultFN));
    FMapList.Assign(FMapLoader.MapStrList);
    OnWalkList := AddNode;
    a_Index := 0;
    WalkList(FMapList, a_Index);
  finally
    FMapList.Free;
  end;
end;

procedure TzeeMapper.SaveTreeView;
begin
  OnWalkTree := MapAll;
  FMapLoader.LoadNewFile(FullMapName(cDefaultFN));
  FMapList := TStringList.Create;
  try
    StartWalk;
    FMapLoader.SaveMap(frmMapper1.Map, FMapList);
  finally
    FMapList.Free;
    HasChanged := False;
  end;
end;

procedure TzeeMapper.MapAll(aSender: TObject);
begin
  if IsAssignedNode(aSender) and not TJvTreeNode(aSender).IsFirstNode  then
  begin
    FMapList.Add(GetSelfMapText(TTreeNode(aSender)) + '=' + TTreeNode(aSender).Text  );
  end;
end;

procedure TzeeMapper.actDeleteNodeExecute(Sender: TObject);
begin
//
  HasChanged := True;
end;

procedure TzeeMapper.actAddNodeExecute(Sender: TObject);
begin
  HasChanged := True;
  OnWalkTree := AddCheckedNode;
  StartWalk;
end;

procedure TzeeMapper.actCheckAllExecute(Sender: TObject);
begin
  FCount := 0;
  OnWalkTree := CheckAll;
  tvMap.CheckBoxes := False;
  tvMap.CheckBoxes := True;
  StartWalk;
  tvMap.Update;
end;

procedure TzeeMapper.actExitExecute(Sender: TObject);
begin
//
end;

procedure TzeeMapper.actRenameExecute(Sender: TObject);
var
  a_Node: TTreeNode;
  a_Original: string;
  a_Data: TcrpMapData;
begin
  a_Node := tvMap.Selected;
  if Assigned(a_Node) then
    frmRename := TfrmRename.Create(self);
    try
      frmRename.Left := ZeeMapper.Left + FRect.Left + 10 + tvMap.Left;
      frmRename.Top := ZeeMapper.Top + FRect.Top + 10 + tvMap.Top ;
      if frmRename.ShowModal = mrOk then
      begin
        a_Original := a_Node.Text;
        a_Node.Text := frmRename.edtMap.Text;
        actValidateNameExecute(Sender);
        if FIsValid then
        begin
          a_Data := FMap.GetKey(a_Original);
          if Assigned(a_Data) then
          begin
            RenameFile(ApplicationDirectory + a_Original + cDefaultExt ,
                       ApplicationDirectory + a_Node.Text + cDefaultExt);
            HasChanged := True;
            a_Data.Value := a_Node.Text
          end else
          //this is an error state...revert could not find in list
            a_Node.Text := a_Original;
        end else
        begin
          a_Node.Text := a_Original;
          MessageDlg('Duplicate Map Name', mtError,[mbOK], 0);
        end;
      end;
    finally
      frmRename.Release;
      frmRename := nil;
    end;
end;


procedure TzeeMapper.actUncheckAllExecute(Sender: TObject);
begin
  FCount := 0;
  OnWalkTree := UnCheckAll;
  tvMap.CheckBoxes := False;
  tvMap.CheckBoxes := True;
  StartWalk;
  tvMap.Update;
end;

procedure TzeeMapper.actDeleteCheckedNodesExecute(Sender: TObject);
begin
  HasChanged := True;
  OnWalkTree := DeleteCheckedNode;
  StartWalk;
end;

procedure TzeeMapper.actClickExecute(Sender: TObject);
begin
  FCount := 0;
  OnWalkTree := CountChecked;
  StartWalk;
  EnableActions;
end;

procedure TzeeMapper.actEditMapExecute(Sender: TObject);
begin
  HasChanged := True;
  OnWalkTree := EditNode;
  StartWalk;
end;

procedure TzeeMapper.actExportValueToChildExecute(Sender: TObject);
begin
//need to add a dialog to warn of losing map
  HasChanged := True;
  OnWalkTree := ExportValueToChild;
  StartWalk;
end;

procedure TzeeMapper.actValidateNameExecute(Sender: TObject);
begin
  OnWalkTree := ValidateName;
  FIsValid := True;
  FValidList := TStringList.Create;
  try
    try
      FValidList.Sorted := True;
      FValidList.Duplicates := dupError;
      StartWalk;
    finally
      FValidList.Free;
      FValidList := nil;
    end;
  except
    On EStringListError do
      FIsValid := False;
    else
      Raise;
  end;
end;


procedure TzeeMapper.CheckAll(aSender: TObject);
begin
  if IsAssignedNode(aSender)then
  begin
    if not TJvTreeNode(aSender).IsFirstNode then
      inc(FCount);
    TJvTreeNode(aSender).Checked := True;
  end;
end;

procedure TzeeMapper.UnCheckAll(aSender: TObject);
begin
  if IsAssignedNode(aSender)then
    TJvTreeNode(aSender).Checked := False;
end;


procedure TzeeMapper.DeleteCheckedNode(aSender: TObject);
begin
  HasChanged := True;
  if IsAssignedNode(aSender)then
    if TJvTreeNode(aSender).Checked then
      DeleteMapping(TJvTreeNode(aSender).Text);
end;

procedure TzeeMapper.DeleteMapping(aMap: string);
begin
  HasChanged := True;
end;


procedure TzeeMapper.AddCheckedNode(aSender: TObject);
var
  a_Node: TTreeNode;
  a_Data: TcrpMapData;
begin
  if IsAssignedNode(aSender)then
    if TJvTreeNode(aSender).Checked then
    begin
      HasChanged := True;
      a_Node := tvMap.Items.AddChild(TTreeNode(aSender), '');
      a_Node.Text := GetMapText(TTreeNode(aSender));
      a_Data := FMap.AddKey(a_Node.Text);
      FMap.AddObject(a_Data, a_Node);
    end;
end;

procedure TzeeMapper.EditNode(aSender: TObject);
begin
  if IsAssignedNode(aSender)then
   if not TJvTreeNode(aSender).IsFirstNode and
       (TJvTreeNode(aSender).Checked or TJvTreeNode(aSender).Selected)then
    begin
      //goto tsMapper
      pcMapper.ActivePage := tsMapper;
      frmMapper1.LoadFrame;
      frmMapper1.Map := TJvTreeNode(aSender).Text;
    end;
end;


procedure TzeeMapper.StartWalk;
begin
  WalkTree(TJvTreeNode(tvMap.Items[0]));
end;

function TzeeMapper.IsAssignedNode(aNode: TObject): boolean;
begin
  Result := Assigned(aNode) and (aNode is TJvTreeNode);
end;

procedure TzeeMapper.CountChecked(aSender: TObject);
begin
  if IsAssignedNode(aSender) then
    if not TJvTreeNode(aSender).IsFirstNode and TJvTreeNode(aSender).Checked then
    begin
      inc(FCount);
      FNode := TJvTreeNode(aSender);
      if FCount = 1 then
        FRect := TJvTreeNode(aSender).DisplayRect(False);
    end;
end;

procedure TzeeMapper.EnableActions;
begin
  actEditMap.Enabled := (FCount = 1);
  actRename.Enabled := (FCount = 1);
end;


procedure TzeeMapper.ValidateName(aSender: TObject);
begin
  if IsAssignedNode(aSender) then
    FValidList.Add(TJvTreeNode(aSender).Text);
end;

procedure TzeeMapper.WalkParent(aNode: TTreeNode);
begin
  if IsAssignedNode(aNode) then
  begin
    if Assigned(FOnWalkParent) then
      FOnWalkParent(aNode);
    WalkParent(TJvTreeNode(aNode).Parent);
  end;
end;

procedure TzeeMapper.WalkSibling(aNode: TTreeNode);
begin
  if IsAssignedNode(aNode) then
  begin
    if Assigned(FOnWalkSibling) then
      FOnWalkSibling(aNode);
    WalkSibling(TJvTreeNode(aNode).GetNextSibling);
  end;
end;



procedure TzeeMapper.WalkChild(aNode: TTreeNode);
begin
  if IsAssignedNode(aNode) and not TJvTreeNode(aNode).IsFirstNode then
  begin
    if Assigned(FOnWalkChild) then
      FOnWalkChild(aNode);
    if aNode.HasChildren then
      WalkChild(TJvTreeNode(aNode).getFirstChild)
    else
      WalkChild(TJvTreeNode(aNode).getNextSibling);
  end;
end;


procedure TzeeMapper.WalkTree(aNode: TTreeNode);
begin
  if Assigned(aNode) then
  begin
    if Assigned(FOnWalkTree) then
      FOnWalkTree(aNode);
      WalkTree(aNode.GetNext);
  end;
end;

procedure TzeeMapper.WalkList(aStrList: TStrings; var aIndex: integer);
begin
  if Assigned(aStrList) then
    if Assigned(FOnWalkList) then
    begin
      FOnWalkList(aStrList, aIndex);
      inc(aIndex);
      if aIndex < aStrList.Count then
        WalkList(aStrList, aIndex);
    end;
end;

procedure TzeeMapper.ExportValueToChild(aSender: TObject);
begin
  if IsAssignedNode(aSender) then
  begin
    if not TJvTreeNode(aSender).IsFirstNode then
    begin
      if not TJvTreeNode(aSender).HasChildren then
        AddCheckedNode(aSender);
//need to walk children...
         OnWalkChild := ExportMap;
         WalkChild(TJvTreeNode(aSender));
    end;
  end;
end;

function TzeeMapper.FullMapName(aFileName: TFileName): string;
begin
  Result := ApplicationDirectory + aFileName;
end;

procedure TzeeMapper.ExportMap(aSender: TObject);
begin
  FMapLoader.LoadNewFile(TJvTreeNode(aSender).Parent.Text);
  FMapLoader.ExportMap(FullMapName(TJvTreeNode(aSender).Text));
end;


function TzeeMapper.GetMapText(aNode: TTreeNode): string;
var
  a_ChildText: string;
begin
  a_ChildText := GetChildMapText(aNode);
  if aNode.Text <> cDefaultName then
  begin
   Result := GetKey(aNode.Text);
   if Result <> '' then
     Result := GetKeyValue(aNode.Text);
   if Result <> '' then
     Result := Result + cMapDelimiter;
  end else
   Result := cMapText;
  Result := Result + a_ChildText;
end;

function TzeeMapper.GetSelfMapText(aNode: TTreeNode): string;
begin
  Result := '';
  if aNode.Text <> cDefaultName then
  begin
   Result := GetKey(aNode.Text);
   if Result = '' then
     Result := GetKeyValue(aNode.Text);
  end else
   Result := cMapText + Result;
end;



procedure TzeeMapper.AddNode(aStrList: TStrings; var aIndex: integer);
var
  a_Node: TTreeNode;
  a_Key, a_Value: string;
  a_Data: TcrpMapData;
begin
  if aStrList.Count > 0 then
  begin
    a_Key := aStrList.Names[aIndex];
    a_Value := aStrList.ValueFromIndex[aIndex];
    a_Node := FindParentNode(a_Key);
    a_Node := tvMap.Items.AddChild(a_Node, a_Value);
    a_Data :=  FMap.AddKeyAndValue(a_Key, a_Value);
    FMap.AddObject(a_Data, a_Node);
  end;
end;

function TzeeMapper.FindParentNode(aNodeText: string): TTreeNode;
var
  a_MapData: TcrpMapData;
  a_MapText: string;
  a_Index: integer;
begin
  {Map1-1}
  a_MapText := Copy(aNodeText, 4, length(aNodeText));
  {1-1}
  a_Index := LastDelimiter(cMapDelimiter, a_MapText);
  if a_Index > 1 then
    a_MapText := Copy(a_MapText,1, a_Index -1);
  {1}
  a_MapData := FMap.GetKey(cMapText + a_MapText);
  if Assigned(a_MapData) then
    Result := TTreeNode(a_MapData.Obj)
  else
    Result := tvMap.Items[0];
end;

function TzeeMapper.GetMapLevel(aMapText: string): integer;
var
  a_Index: integer;
begin
{Level 0 is the Root Node...It has no Siblings..Level 1 is the first real level
 Level 1 = 1...Level 2 = 1-1...Level 3 = 1-1-1}
  Result := 0;
  if aMapText <> '' then
  begin
    inc(Result);
    for a_Index := 1 to length(aMapText) do
      if IsDelimiter(cMapDelimiter, aMapText, a_Index) then
        inc(Result);
  end;
end;


function TzeeMapper.GetChildMapText(aNode: TTreeNode): string;
begin
  FCount := 0;
  OnWalkSibling := CountNode;
  WalkSibling(aNode.GetFirstChild);
  Result := IntToStr(FCount);
end;

procedure TzeeMapper.CountNode(aSender: TObject);
begin
  if IsAssignedNode(aSender) then
    inc(FCount);
end;


function TzeeMapper.GetAppDir: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

function TzeeMapper.GetHasChanged: boolean;
begin
  Result := FHasChanged;
end;

procedure TzeeMapper.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
end;

procedure TzeeMapper.FormDestroy(Sender: TObject);
begin
  FMapLoader.Free;
  FMap.Free;
  FMapExport.Free;
end;

function TzeeMapper.GetKey(aKey: string): string;
var
  a_Data: TcrpMapData;
begin
  Result := '';
  a_Data := FMap.GetKey(aKey);
  if Assigned(a_Data) then
    Result := a_Data.Key;
end;

function TzeeMapper.GetKeyValue(aValue: string): string;
var
  a_Data: TcrpMapData;
begin
  Result := '';
  a_Data := FMap.GetValue(aValue);
  if Assigned(a_Data) then
    Result := a_Data.Key;
end;


procedure TzeeMapper.pcMapperChange(Sender: TObject);
begin
  if pcMapper.ActivePage = tsMaps then
    if Assigned(Self.tvMap.Selected) then
      frmMapper1.Map := Self.tvMap.Selected.Text
end;

end.

