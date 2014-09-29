unit fZeeMapper;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, ImgList, ComCtrls, JvExComCtrls,
  JvComCtrls, ToolWin, crpMapper, StdCtrls, Buttons, ExtCtrls, Grids,
  fOptions, JvExStdCtrls, JvButton, JvCtrls, crpBase, crpKeyValue, fMapper,
  fEditor, fRule, fAbstractFrame;

const
  //tab sheet index
  cTSMaps = 0;
  cTSMapper = 1;
  cTSRulesList = 2;
  cTSRule = 3;
  cTSEditor = 4;

  //Status Bar Panel
  cSBState = 0;
  cSBMessage = 1;
type
    EzeeMapper = Exception;

type
  TNotifyList = procedure(aList: TStrings; var aIndex: integer) of object;

  TChildNotify = procedure(aSender: TObject; aDeleting: boolean) of object;

  TTranslateFile = class(Tobject)
    Row: integer;
    Col: integer;
    FullName: string;
    constructor Create(aFileName: string; aCol, aRow: integer);
  end;

  TTranslateFileList = class(TObject)
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    function GetTranslateFile(aCol, aRow: integer): string;
    procedure AddTranslateFile(aFileName: string; aCol, aRow: integer);
  end;

  TfrmZeeMapper = class(TForm)
    pcMapper: TPageControl;
    tsMaps: TTabSheet;
    tvMap: TJvTreeView;
    tsMapper: TTabSheet;
    sbMap: TStatusBar;
    ilToolbar: TImageList;
    alMap: TActionList;
    actAddCheckedNodes: TAction;
    actDeleteCheckedNodes: TAction;
    actAddNode: TAction;
    actDeleteNode: TAction;
    actCheckAll: TAction;
    actUncheckAll: TAction;
    actSave: TAction;
    actRename: TAction;
    actClick: TAction;
    actValidateName: TAction;
    actEditMap: TAction;
    actExportValueToChild: TAction;
    actAbout: TAction;
    pumTreeView: TPopupMenu;
    miAddCheckedNodes: TMenuItem;
    miDeleteCheckedMaps: TMenuItem;
    miExportToChild: TMenuItem;
    N3: TMenuItem;
    miAddMap: TMenuItem;
    miDeleteMap: TMenuItem;
    N2: TMenuItem;
    miSelectAll: TMenuItem;
    miUnselectAll: TMenuItem;
    miRename: TMenuItem;
    miEditMap: TMenuItem;
    mnmMain: TMainMenu;
    mmiFile: TMenuItem;
    mmiEdit: TMenuItem;
    mmiAddMap: TMenuItem;
    mmiDeleteMap: TMenuItem;
    N1: TMenuItem;
    mmiSelectAll: TMenuItem;
    miRun: TMenuItem;
    miExport: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    ilMap: TImageList;
    tsRules: TTabSheet;
    tsRule: TTabSheet;
    ListView1: TListView;
    Panel1: TPanel;
    edtRuleName: TLabeledEdit;
    BitBtn1: TBitBtn;
    lvRule: TListView;
    Panel2: TPanel;
    tbMap: TToolBar;
    btnSave: TToolButton;
    btnEditMap: TToolButton;
    btnExportValue: TToolButton;
    btnRename: TToolButton;
    btnExport: TToolButton;
    btnDeleteChecked: TToolButton;
    btnCheckAll: TToolButton;
    btnUncheckAll: TToolButton;
    actFindRuleIcon: TAction;
    ilRules: TImageList;
    Panel3: TPanel;
    lvExport: TListView;
    Panel4: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    sgTranslateFiles: TStringGrid;
    Splitter1: TSplitter;
    btnSelTransFiles: TToolButton;
    ToolButton10: TToolButton;
    actExit: TAction;
    actSelTransFiles: TAction;
    actTranslate: TAction;
    btnBaseMapForTranslation: TToolButton;
    actBaseMapForTranslation: TAction;
    lvBase: TListView;
    Label4: TLabel;
    btnExportMapForTranslation: TToolButton;
    actExportMapForTranslation: TAction;
    actOptions: TAction;
    miTools: TMenuItem;
    miOptions: TMenuItem;
    MapTranslation1: TMenuItem;
    ExportTranslation1: TMenuItem;
    OpenFiles1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    N4: TMenuItem;
    OpenFiles2: TMenuItem;
    odlgOpenTranslateFiles: TOpenDialog;
    btnOpenDlgTransLoc: TJvImgBtn;
    JvImgBtn1: TJvImgBtn;
    JvImgBtn2: TJvImgBtn;
    Panel5: TPanel;
    Label1: TLabel;
    tsEditor: TTabSheet;
    frMapper: TfrMapper;
    frRule: TfrRule;
    frEditor: TfrEditor;
    btnTranslateEditor: TToolButton;
    cboBase: TComboBox;
    cboExport: TComboBox;
    Panel6: TPanel;
    cboExportEdit: TComboBox;
    cboBaseEdit: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    btnClearMapSelected: TToolButton;
    btnClearMapAll: TToolButton;
    actClearMapSelected: TAction;
    actClearMapAll: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actSaveExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actAddCheckedNodesExecute(Sender: TObject);
    procedure actAddNodeExecute(Sender: TObject);
    procedure actCheckAllExecute(Sender: TObject);
    procedure actClickExecute(Sender: TObject);
    procedure actDeleteCheckedNodesExecute(Sender: TObject);
    procedure actDeleteNodeExecute(Sender: TObject);
    procedure actEditMapExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actExportValueToChildExecute(Sender: TObject);
    procedure actRenameExecute(Sender: TObject);
    procedure actUncheckAllExecute(Sender: TObject);
    procedure actValidateNameExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pcMapperChange(Sender: TObject);
    procedure pcMapperChanging(Sender: TObject; var AllowChange: Boolean);
    procedure actOptionsExecute(Sender: TObject);
    procedure actExportMapForTranslationExecute(Sender: TObject);
    procedure actSelTransFilesExecute(Sender: TObject);
    procedure actTranslateExecute(Sender: TObject);
    procedure tvMapStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure tvMapDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvMapDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgTranslateFilesMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure actClearMapSelectedExecute(Sender: TObject);
    procedure actClearMapAllExecute(Sender: TObject);
    procedure cboChange(Sender: TObject);
  private
    FDefaultTransLoc: string;
    FDefaultSaveLoc: string;
    FDefaultExt: string;
    FUseFileExt: boolean;
    FDeleted: boolean;

    FAppDir: string;
    FCount: integer;
    FNode: TJvTreeNode;
    FRect: TRect;
    FHasChanged: boolean;
    FIsValid: boolean;
    FValidList: TStringList;
    FIsInBranch: boolean;
    FCheckMapText: string;
    FTranslateFileList: TTranslateFileList;

    FOnWalkParent: TNotifyEvent;
    FOnWalkChild: TNotifyEvent;
    FMapLoader: TcrpKeyValueLoader;
    FTreeMap: TcrpTreeMapper;
    FMapList: TStrings;
    FMapExporter: TcrpMapExporter;
    FEditorTranslator: TcrpTranslator;
    FDragControl: TDragControlObjectEx;
    FOnWalkList: TNotifyList;
    FOnWalkSibling: TNotifyEvent;
    FOnWalkTree: TNotifyEvent;
  private
    procedure AddCheckedNode(aSender: TObject);
    procedure AddSelectedNode(aSender: TObject);
    procedure AddNode(aStrList: TStrings; var aIndex: integer);
    procedure CheckAll(aSender: TObject);
    procedure CountChecked(aSender: TObject);
    procedure CountNode(aSender: TObject);
    procedure DeleteCheckedNode(aSender: TObject);
    procedure DeleteChildNode(aSender: TObject);
    procedure DeleteMapping(aNode: TTreeNode);
    procedure EditNode(aSender: TObject);
    procedure EnableActions;
    procedure ExportMap(aSender: TObject);
    procedure UpdateOptions(aStrList: TStrings; var aIndex: integer);

    procedure ExportValueToChild(aSender: TObject);
    function FindParentNode(aNodeText: string): TTreeNode;
    function ExtractName(aFileName: string): string;
    function FullMapName(aFileName: string): string;
    function FullFilename(aFileName: string; aExtension: string): string;
    function GetAppDir: string;
    function GetChildMapText(aNode: TTreeNode): string;
    function GetHasChanged: boolean;
    function GetKey(aKey: string): string;
    function GetKeyValue(aValue: string): string;
    function GetMapText(aNode: TTreeNode): string;
    function GetSelfMapText(aNode: TTreeNode): string;
    function IsAssignedNode(aNode: TObject): boolean;
    function IsBranch(aDragNode: TTreeNode): boolean;
    procedure CheckBranch(aSender: TObject);
    procedure LoadTreeView;
    procedure LoadFormMapper;
    procedure MapAll(aSender: TObject);
    procedure SaveTreeView;
    procedure SetHasChanged(const Value: boolean);
    procedure StartWalk;
    function isFirstNode: boolean;
    procedure SaveOptions(afrmOptions: tfrmOptions); overload;
    procedure SaveOptions; overload;
    procedure LoadOptions;
    procedure LoadTranslateFiles;
    procedure AppException(Sender: TObject; E: Exception);
    function GetFrame(aWinControl: TWinControl): TfrAbstractFrame;
    procedure ClearNames(aStrings: TStrings);

    procedure TranslateFile(aFileName: string);
    procedure TranslateFiles;
    procedure TranslateEditor;
    procedure Translate;


    procedure StartDrag(aDrag: TControl);
    procedure AcceptDragOver(aOver: TControl;var aAccept: boolean); overload;
    procedure StartDrop(aDrop: TControl);
    function AllowDrag(aDrag: TControl): boolean;

    procedure UnCheckAll(aSender: TObject);
    procedure ValidateName(aSender: TObject);
    procedure WalkChild(aNode: TTreeNode);
    procedure WalkList(aStrList: TStrings; var aIndex: integer);
    procedure WalkParent(aNode: TTreeNode);
    procedure WalkSibling(aNode: TTreeNode);
    procedure WalkTree(aNode: TTreeNode);
  public

    property HasChanged: boolean read GetHasChanged write SetHasChanged;
    property OnWalkTree: TNotifyEvent read FOnWalkTree write FonWalkTree;
    property OnWalkParent: TNotifyEvent read FOnWalkParent write FonWalkParent;
    property OnWalkChild: TNotifyEvent read FOnWalkChild write FOnWalkChild;
    property OnWalkSibling: TNotifyEvent read FOnWalkSibling write FOnWalkSibling;
    property OnWalkList: TNotifyList read FOnWalkList write FOnWalkList;
    property ApplicationDirectory: string read GetAppDir;

  end;

var
  frmZeeMapper: TfrmZeeMapper;

implementation

{$R *.dfm}
uses
  fRename, Math, FileCtrl, crpZeeMapperDefault, fAboutBox;

{Main Application and Form Events}
{______________________________________________________________________________}
procedure TfrmZeeMapper.FormCreate(Sender: TObject);
begin
  Application.OnException := AppException;

  FMapLoader := TcrpKeyValueLoader.Create(TcrpMapTreeData);
  FTreeMap := TcrpTreeMapper.Create(TcrpMapTreeData);
  FMapExporter := TcrpMapExporter.Create(TcrpMapTreeData);
  FEditorTranslator := TcrpTranslator.Create(TcrpMapTreeData);
  FTranslateFileList := TTranslateFileList.Create;

  FMapLoader.LoadNewFile(ApplicationDirectory + cDefaultName + cDefaultExt , cSecMain);
  tvMap.Items.Add(nil, cDefaultName);

  //we keep pointers to the linked component in the Tag Property
  lvBase.Tag := integer(cboBase);
  lvExport.Tag := integer(cboExport);
  cboBase.Tag := integer(lvBase);
  cboExport.Tag := integer(lvExport);

  frRule.LoadFrame;
end;

procedure TfrmZeeMapper.FormDestroy(Sender: TObject);
begin
  FMapLoader.Free;
  FTreeMap.Free;
  FMapExporter.Free;
  FEditorTranslator.Free;
  FTranslateFileList.Free;

  frMapper.UnloadFrame;
  frRule.UnLoadFrame;
  frEditor.UnLoadFrame;
end;


procedure TfrmZeeMapper.AppException(Sender: TObject; E: Exception);
begin
  sbMap.Panels[cSBMessage].Text := E.Message;
  //create a debug logger...
end;

procedure TfrmZeeMapper.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  a_MResult: TModalResult;
begin
  frMapper.UnloadFrame;
  if HasChanged then
  begin
    a_MResult := MessageDlg(cSaveChange,mtConfirmation, mbYesNoCancel, 0);
    if a_MResult = mrYes then
      SaveTreeView
    else if a_MResult = mrNo then
      Action := caFree
    else if a_MResult = mrCancel then
      Action := caNone;
  end else
    Action := caFree;
end;

procedure TfrmZeeMapper.FormShow(Sender: TObject);
begin
  LoadTreeView;
  LoadOptions;
  tvMap.FullExpand;
end;

{Walking procedures}
{______________________________________________________________________________}
procedure TfrmZeeMapper.WalkParent(aNode: TTreeNode);
begin
  if IsAssignedNode(aNode) then
  begin
    if Assigned(FOnWalkParent) then
      FOnWalkParent(aNode);
    WalkParent(TJvTreeNode(aNode).Parent);
  end;
end;

procedure TfrmZeeMapper.WalkSibling(aNode: TTreeNode);
begin
  if IsAssignedNode(aNode) then
  begin
    if Assigned(FOnWalkSibling) then
      FOnWalkSibling(aNode);
    WalkSibling(TJvTreeNode(aNode).GetNextSibling);
  end;
end;

procedure TfrmZeeMapper.WalkChild(aNode: TTreeNode);
begin
  FDeleted := False;
  if IsAssignedNode(aNode) and not TJvTreeNode(aNode).IsFirstNode then
  begin
    if Assigned(FOnWalkChild) then
      FOnWalkChild(aNode);
    if not FDeleted then
      if aNode.HasChildren  then
         WalkChild(TJvTreeNode(aNode).getFirstChild)
      else
         WalkChild(TJvTreeNode(aNode).getNextSibling);
  end;
end;


procedure TfrmZeeMapper.WalkTree(aNode: TTreeNode);
begin
  FDeleted := False;
  if Assigned(aNode) then
  begin
    if Assigned(FOnWalkTree) then
      FOnWalkTree(aNode);
    if not FDeleted then
      WalkTree(aNode.GetNext);
  end;
end;

procedure TfrmZeeMapper.WalkList(aStrList: TStrings; var aIndex: integer);
begin
  FDeleted := False;
  if Assigned(aStrList) then
    if Assigned(FOnWalkList) then
    begin
      FOnWalkList(aStrList, aIndex);
      inc(aIndex);
      if (aIndex < aStrList.Count) and Not FDeleted then
        WalkList(aStrList, aIndex);
    end;
end;

{Main Form Procedures}
{______________________________________________________________________________}

function TfrmZeeMapper.GetFrame(aWinControl: TWinControl): TfrAbstractFrame;
var
  a_iIndex: integer;
begin
  Result := nil;
  try
    for a_iIndex := 0 to aWinControl.ControlCount -1 do
    begin
    {we loop through all the children}
      if aWinControl.Controls[a_iIndex] is TfrAbstractFrame then
      begin
        Result := TfrAbstractFrame(aWinControl.Controls[a_iIndex]);
        break;
      end;
      if aWinControl.Controls[a_iIndex] is TWinControl then
  {if its a WinControl...meaning it can be a Parent to other controls...we loop
   through them, and so and so on.}
        GetFrame(TWinControl(aWinControl.Controls[a_iIndex]));
    end;
  except
    On Exception do
      EzeeMapper.Create('GetFrame');
  end;
end;

procedure TfrmZeeMapper.LoadOptions;
var
  a_Index: integer;
  a_MapList: TStringList;
begin
  a_MapList := TStringList.Create;
 try
   FMapLoader.LoadNewFile(FullMapName(cDefaultName), cSecOptions);
   a_MapList.Assign(FMapLoader.MapStrList);
   OnWalkList := UpdateOptions;
   a_Index := 0;
   WalkList(a_MapList, a_Index);
 finally
   a_MapList.Free;
 end;
end;

procedure TfrmZeeMapper.UpdateOptions(aStrList: TStrings; var aIndex: integer);
begin
{  cDefaultTransLocKey = 'DefaultTransLoc';
  cDefaultSaveLocKey = 'DefaultSaveLoc';
  cDefaultExtKey = 'DefaultExt';
  cUseFileExtKey = 'FileExt';}
  if (aStrList.Count > 0) and (aIndex >= 0) and (aIndex < aStrList.Count) then
  begin
    if aStrList.Names[aIndex] = cDefaultTransLocKey then
      FDefaultTransLoc :=  aStrList.ValueFromIndex[aIndex]
    else
    if aStrList.Names[aIndex] = cDefaultSaveLocKey then
      FDefaultSaveLoc :=  aStrList.ValueFromIndex[aIndex]
    else
    if aStrList.Names[aIndex] = cDefaultExtKey then
      FDefaultExt :=  aStrList.ValueFromIndex[aIndex]
    else
    if aStrList.Names[aIndex] = cUseFileExtKey then
      FUseFileExt :=  aStrList.ValueFromIndex[aIndex] = '1';
  end;
end;

procedure TfrmZeeMapper.LoadTreeView;
var
  a_Index: integer;
  a_MapList: TStringList;
begin
  sbMap.Panels[cSBState].Text := cStateLoading;
  a_MapList := TStringList.Create;
  try
    FMapLoader.LoadNewFile(FullMapName(cDefaultName), cSecMain);
    a_MapList.Assign(FMapLoader.MapStrList);
    OnWalkList := AddNode;
    a_Index := 0;
    WalkList(a_MapList, a_Index);
    ClearNames(a_MapList);
    cboBase.Items.Assign(a_MapList);
    cboExport.Items.Assign(a_MapList);
    cboBaseEdit.Items.Assign(a_MapList);
    cboExportEdit.Items.Assign(a_MapList);
    
    sbMap.Panels[cSBState].Text := cStateLoaded;
  finally
    a_MapList.Free;
  end;
end;

procedure TfrmZeeMapper.SaveTreeView;
begin
  sbMap.Panels[cSBState].Text := cStateSaving;
  OnWalkTree := MapAll;
  FMapLoader.LoadNewFile(FullMapName(cDefaultName), cSecMain);
  FMapList := TStringList.Create;
  try
    StartWalk;
    FMapLoader.SaveToFile(FullMapName(cDefaultName) , FMapList, cSecMain);
    sbMap.Panels[cSBState].Text := cStateSaved;
  finally
    FMapList.Free;
    HasChanged := False;
  end;
end;

procedure TfrmZeeMapper.SaveOptions;
begin
  sbMap.Panels[cSBState].Text := cStateSaving;
  OnWalkTree := MapAll;
//  FMapLoader.LoadOptions();
  FMapList := TStringList.Create;
  try
    FMapList.Add( cDefaultTransLocKey + '=' + FDefaultTransLoc);
    FMapList.Add( cDefaultSaveLocKey + '=' + FDefaultSaveLoc);
    FMapList.Add( cDefaultExtKey + '=' + FDefaultExt);
    if FUseFileExt then
      FMapList.Add( cUseFileExtKey + '=' + '1')
    else
      FMapList.Add( cUseFileExtKey + '=' + '0');
    FMapLoader.SaveToFile(FullMapName(cDefaultName) , FMapList, cSecMain);
    sbMap.Panels[cSBState].Text := cStateSaved;
  finally
    FreeAndNil(FMapList);
  end;
end;

procedure TfrmZeeMapper.MapAll(aSender: TObject);
begin
  if IsAssignedNode(aSender) and not TJvTreeNode(aSender).IsFirstNode  then
  begin
    FMapList.Add(GetSelfMapText(TTreeNode(aSender)) + '=' + TTreeNode(aSender).Text  );
  end;
end;

procedure TfrmZeeMapper.ClearNames(aStrings: TStrings);
var
  a_TempStrings: TStrings;
  a_Index: integer;
begin
  a_TempStrings := TStringList.Create;
  try
    for a_Index := 0 to aStrings.Count -1 do
      a_TempStrings.Add(aStrings.ValueFromIndex[a_Index]);
    aStrings.Assign(a_TempStrings);  
  finally
    a_TempStrings.Free;
  end;
end;

procedure TfrmZeeMapper.CheckAll(aSender: TObject);
begin
  if IsAssignedNode(aSender)then
  begin
    if not TJvTreeNode(aSender).IsFirstNode then
      inc(FCount);
    TJvTreeNode(aSender).Checked := True;
  end;
end;

procedure TfrmZeeMapper.UnCheckAll(aSender: TObject);
begin
  if IsAssignedNode(aSender)then
    TJvTreeNode(aSender).Checked := False;
end;

procedure TfrmZeeMapper.DeleteCheckedNode(aSender: TObject);
begin
  if IsAssignedNode(aSender)then
    if TJvTreeNode(aSender).Checked then
       if TJvTreeNode(aSender).HasChildren then
       begin
         OnWalkChild := DeleteChildNode;
         WalkChild(TJvTreeNode(aSender));
         DeleteMapping(TJvTreeNode(aSender));
       end
       else
         DeleteMapping(TJvTreeNode(aSender));
end;


procedure TfrmZeeMapper.DeleteChildNode(aSender: TObject);
begin
  if not TJvTreeNode(aSender).HasChildren then
    DeleteMapping(TJvTreeNode(aSender));
end;


procedure TfrmZeeMapper.DeleteMapping(aNode: TTreeNode);
begin
  if Assigned(aNode) then
  begin
    if FileExists(FullMapName(aNode.Text)) then
      DeleteFile(FullMapName(aNode.Text));
    FTreeMap.DeleteValue(aNode.Text);
    aNode.Delete;
    HasChanged := True;
    FDeleted := True;
  end;
end;


procedure TfrmZeeMapper.AddCheckedNode(aSender: TObject);
var
  a_Node: TTreeNode;
  a_Data: TcrpKeyValueData;
begin
  if IsAssignedNode(aSender)then
    if TJvTreeNode(aSender).Checked then
    begin
      a_Node := tvMap.Items.AddChild(TTreeNode(aSender), '');
      if Assigned(a_Node) then
      begin
        a_Node.Text := GetMapText(TTreeNode(aSender));
        a_Data := FTreeMap.AddKey(a_Node.Text);
        if Assigned(a_Data) then
        begin
          FTreeMap.AddTreeNode(a_Data, a_Node);
          HasChanged := True;
        end;
      end;
    end;
end;

procedure TfrmZeeMapper.AddSelectedNode(aSender: TObject);
var
  a_Node: TTreeNode;
  a_Data: TcrpKeyValueData;
begin
  if IsAssignedNode(aSender)then
    if TJvTreeNode(aSender).Selected then
    begin
      a_Node := tvMap.Items.AddChild(TTreeNode(aSender), '');
      if Assigned(a_Node) then
      begin
        a_Node.Text := GetMapText(TTreeNode(aSender));
        a_Data := FTreeMap.AddKey(a_Node.Text);
        if Assigned(a_Data) then
        begin
          FTreeMap.AddTreeNode(a_Data, a_Node);
          HasChanged := True;
        end;
      end;
    end;
end;

procedure TfrmZeeMapper.EditNode(aSender: TObject);
begin
  if IsAssignedNode(aSender)then
   if  TJvTreeNode(aSender).Selected then
    begin
      pcMapper.ActivePage := tsMapper;
      LoadFormMapper;
      abort;
    end;
end;

procedure TfrmZeeMapper.StartWalk;
begin
  WalkTree(TJvTreeNode(tvMap.Items[0]));
end;

function TfrmZeeMapper.IsAssignedNode(aNode: TObject): boolean;
begin
  Result := Assigned(aNode) and (aNode is TJvTreeNode);
end;

procedure TfrmZeeMapper.CountChecked(aSender: TObject);
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

procedure TfrmZeeMapper.EnableActions;
begin
  actEditMap.Enabled := (FCount = 1);
  actRename.Enabled := (FCount = 1);
end;


procedure TfrmZeeMapper.ValidateName(aSender: TObject);
begin
  if IsAssignedNode(aSender) then
    FValidList.Add(TJvTreeNode(aSender).Text);
end;

procedure TfrmZeeMapper.ExportValueToChild(aSender: TObject);
begin
  if IsAssignedNode(aSender) then
  begin
    sbMap.Panels[cSBState].Text :=  cStateExporting;
    if not TJvTreeNode(aSender).IsFirstNode and
     (TJvTreeNode(aSender).Selected or TJvTreeNode(aSender).Checked) then
    begin
{if It doesn't have any children create children}
      if not TJvTreeNode(aSender).HasChildren then
        AddCheckedNode(aSender);
         OnWalkChild := ExportMap;
         WalkChild(TJvTreeNode(aSender));
    end;
    sbMap.Panels[cSBState].Text :=  cStateExported;
  end;
end;

function TfrmZeeMapper.FullMapName(aFileName: string): string;
begin
  Result := TcrpMapFileUtility.FullMapName(ApplicationDirectory, aFileName);
end;

function TfrmZeeMapper.FullFilename(aFileName: string;
  aExtension: string): string;
begin
  Result := TcrpMapFileUtility.FullFileName(FDefaultTransLoc, aFileName, FDefaultExt);
end;


procedure TfrmZeeMapper.ExportMap(aSender: TObject);
begin
  if (TJvTreeNode(aSender).Parent.Selected or
     TJvTreeNode(TJvTreeNode(aSender).Parent).Checked) then
    if not FileExists(FullMapName(TJvTreeNode(aSender).Text)) then
    begin
      FMapLoader.LoadNewFile(FullMapName(TJvTreeNode(aSender).Parent.Text), cSecMain);
      FMapLoader.ExportTo(FullMapName(TJvTreeNode(aSender).Text), cSecMain);
    end;
end;

function TfrmZeeMapper.GetMapText(aNode: TTreeNode): string;
var
  a_ChildText: string;
begin
  a_ChildText := GetChildMapText(aNode);
  if aNode.Text <> cDefaultName then
  begin
   Result := GetKey(aNode.Text);
   if Result = '' then
     Result := GetKeyValue(aNode.Text);
   if Result <> '' then
     Result := Result + cMapDelimiter;
  end else
   Result := cMapText;
  Result := Result + a_ChildText;
end;

function TfrmZeeMapper.GetSelfMapText(aNode: TTreeNode): string;
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

procedure TfrmZeeMapper.AddNode(aStrList: TStrings; var aIndex: integer);
var
  a_Node: TTreeNode;
  a_Key, a_Value: string;
  a_Data: TcrpKeyValueData;
begin
  if aStrList.Count > 0 then
  begin
    a_Key := aStrList.Names[aIndex];
    a_Value := aStrList.ValueFromIndex[aIndex];
    a_Node := FindParentNode(a_Key);
    if Assigned(a_Node) then
    begin
      a_Node := tvMap.Items.AddChild(a_Node, a_Value);
      a_Node.ImageIndex := integer(FileExists(FullMapName(a_Value)));
      a_Data :=  FTreeMap.AddKeyAndValue(a_Key, a_Value);
      if Assigned(a_Data) then
        FTreeMap.AddTreeNode(a_Data, a_Node);
    end;
  end;
end;

function TfrmZeeMapper.FindParentNode(aNodeText: string): TTreeNode;
var
  a_MapData: TcrpKeyValueData;
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
  a_MapData := FTreeMap.GetKey(cMapText + a_MapText);
  if Assigned(a_MapData) and (a_MapData is TcrpMapTreeData) then
    Result := TcrpMapTreeData(a_MapData).TreeNode
  else
    Result := tvMap.Items[0];
end;


function TfrmZeeMapper.GetChildMapText(aNode: TTreeNode): string;
begin
  FCount := 0;
  OnWalkSibling := CountNode;
  WalkSibling(aNode.GetFirstChild);
  Result := IntToStr(FCount);
end;

procedure TfrmZeeMapper.CountNode(aSender: TObject);
begin
  if IsAssignedNode(aSender) then
    inc(FCount);
end;

function TfrmZeeMapper.GetAppDir: string;
begin
  if FAppDir = '' then
    FAppDir := TcrpMapFileUtility.ExeDirectory(Application.ExeName);
  Result := FAppDir;
end;

function TfrmZeeMapper.GetHasChanged: boolean;
begin
  Result := FHasChanged;
end;

procedure TfrmZeeMapper.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
end;

function TfrmZeeMapper.GetKey(aKey: string): string;
var
  a_Data: TcrpKeyValueData;
begin
  Result := '';
  a_Data := FTreeMap.GetKey(aKey);
  if Assigned(a_Data) then
    Result := a_Data.Key;
end;

function TfrmZeeMapper.GetKeyValue(aValue: string): string;
var
  a_Data: TcrpKeyValueData;
begin
  Result := '';
  a_Data := FTreeMap.GetValue(aValue);
  if Assigned(a_Data) then
    Result := a_Data.Key;
end;

function TfrmZeeMapper.isFirstNode: boolean;
begin
  Result :=  Self.tvMap.Selected = Self.tvMap.Items.GetFirstNode;
end;

procedure TfrmZeeMapper.pcMapperChanging(Sender: TObject;
  var AllowChange: Boolean);
var
  a_Frame: TfrAbstractFrame;
begin
  frMapper.SaveMap;
  a_Frame := GetFrame(pcMapper.ActivePage);
  if Assigned(a_Frame) then
    a_Frame.UnloadFrame;
end;

procedure TfrmZeeMapper.LoadFormMapper;
begin
  sbMap.Panels[cSBState].Text := cStateLoading;
  frMapper.SaveMap;
  frMapper.LoadFrame;
  frMapper.Map := Self.tvMap.Selected.Text;
  frMapper.SetKeyOptions(Not isFirstNode);
end;

procedure TfrmZeeMapper.SaveOptions(afrmOptions: tfrmOptions);
begin
  if Assigned(afrmOptions) then
  begin
    FDefaultTransLoc :=  afrmOptions.edtDefaultTransLoc.Text;
    FDefaultSaveLoc := afrmOptions.edtDefaultSaveLoc.Text;
    FUseFileExt := afrmOptions.cbUseFileExt.Enabled;
    if not FUseFileExt then
      FDefaultExt := afrmOptions.edtDefaultExt.Text;
    if FDefaultExt = '' then
      FDefaultExt := cDefaultTxtExt;
  end;
end;

{Drag and Drop procedures}
{______________________________________________________________________________}

procedure TfrmZeeMapper.AcceptDragOver(aOver: TControl;var aAccept: boolean);
begin
//FDragControl.Control started Drag...aOver is the control to decide if drop on
  aAccept := ((FDragControl.Control.ClassType = TListView) and
    (aOver.ClassType = TjvTreeView))
  or
    ((FDragControl.Control.ClassType = TjvTreeView) and
    (aOver.ClassType = TListView) and
    (TListView(aOver).Items.Count = 0));
end;

procedure TfrmZeeMapper.StartDrag(aDrag: TControl);
begin
  FDragControl := TDragControlObjectEx.Create(aDrag);
  sbMap.Panels[cSBState].Text := cStateDrag;
end;

procedure TfrmZeeMapper.StartDrop(aDrop: TControl);
var
  a_Data: TcrpKeyValueData;
begin
//FDragControl.Control started Drag...aDrop is the control to decide if drop on
  if FDragControl.Control.ClassType = TjvTreeView then
  begin
    TListView(aDrop).AddItem(TTreeView(FDragControl.Control).Selected.Text,
    TTreeView(FDragControl.Control));
    TListView(aDrop).Items[0].ImageIndex := 0;
    TComboBox(TListView(aDrop).Tag).Text := TListView(aDrop).Items[0].Caption;
  end else if FDragControl.Control.ClassType = TListView then
  begin
    a_Data := FTreeMap.GetKey(TTreeView(aDrop).GetNodeAt(FDragControl.DragPos.X, FDragControl.DragPos.Y).Text);
    if Assigned(a_Data) then
      TcrpKVRuleData(a_Data).Rule := TListView(aDrop).Items[0].Caption;
    FDragControl.Control.Enabled := False;
  end;
  sbMap.Panels[cSBState].Text := cStateDropped;
end;

function TfrmZeeMapper.AllowDrag(aDrag: TControl): boolean;
begin
  Result := False;
  if (aDrag is TjvTreeView ) then
  begin
    Result := IsBranch(TJvTreeView(aDrag).Selected) and not isFirstNode
      and FileExists(FullMapName(TJvTreeView(aDrag).Selected.Text));
    sbMap.Panels[cSBMessage].Text := '';
    sbMap.Panels[cSBState].Text := cStateDrag;
  end;
end;

function TfrmZeeMapper.IsBranch(aDragNode: TTreeNode): boolean;
  function GetText(aListView: TListView): string;
  begin
    Result := '';
    if aListView.Items.Count = 1 then
      Result := aListView.Items[0].Caption;
  end;
begin
  FCheckMapText := GetText(lvExport);
  if FCheckMapText = '' then
    FCheckMapText := GetText(lvBase);
  if FCheckMapText = '' then
    FIsInBranch := True
  else
  begin
    FIsInBranch := False;
    OnWalkChild := CheckBranch;
    WalkChild(aDragNode);
    OnWalkParent := CheckBranch;
    WalkParent(aDragNode);
  end;
  Result := FIsInBranch;
end;

procedure TfrmZeeMapper.CheckBranch(aSender: TObject);
begin
  if not FIsInBranch then
    FIsInBranch := TTreeNode(aSender).Text = FCheckMapText;
end;

procedure TfrmZeeMapper.TranslateFile(aFileName: string);
begin
  if aFileName <> '' then
  begin
    sbMap.Panels[cSBState].Text := cStateTranslating;
    //set all the neccessary properties
    FMapExporter.MapFileBase :=  FullMapName(lvBase.Items[0].Caption);
    FMapExporter.MapFileExport := FullMapName(lvExport.Items[0].Caption);
    FMapExporter.BaseFileName :=  aFileName;
    FMapExporter.ExportFileName  := FullFilename(ExtractName(aFileName),FDefaultExt);
    FMapExporter.Translate;
    sbMap.Panels[cSBState].Text := cStateTranslated;
  end;
end;

procedure TfrmZeeMapper.Translate;
begin
  if pcMapper.ActivePageIndex = cTSMaps then
  begin
    if (lvBase.Items.Count = 1) then
      if (lvExport.Items.Count = 1) then
          TranslateFiles
      else
        sbMap.Panels[cSBMessage].Text := cExportMapNotSel
    else
      sbMap.Panels[cSBMessage].Text := cBaseMapNotSel;
  end
  else
    TranslateEditor;

end;

procedure TfrmZeeMapper.TranslateFiles;
var
  a_ColIndex, a_RowIndex: integer;
  a_Cursor: TCursor;
begin
  a_Cursor := Screen.Cursor;
  sbMap.Panels[cSBState].Text := cStateStarted;
  try
    Screen.Cursor := crHourGlass;
    for a_ColIndex := 0 to  sgTranslateFiles.ColCount -1 do
      for a_RowIndex := 0 to sgTranslateFiles.RowCount -1 do
        TranslateFile(FTranslateFileList.GetTranslateFile(a_ColIndex, a_RowIndex)) ;
    sbMap.Panels[cSBState].Text := cStateFinished;
  finally
    Screen.Cursor := a_Cursor;
  end;
end;

procedure TfrmZeeMapper.TranslateEditor;
begin
  sbMap.Panels[cSBState].Text := cStateTranslating;
  //set all the neccessary properties
  FEditorTranslator.MapFileBase :=  FullMapName(cboBaseEdit.Text);
  FEditorTranslator.MapFileExport := FullMapName(cboExportEdit.Text);
  FEditorTranslator.Strings.Assign(frEditor.memEditor.Lines);
  FEditorTranslator.Section := cSecMain;
  FEditorTranslator.Translate;
  frEditor.memEditor.Lines.Assign(FEditorTranslator.Strings);
  sbMap.Panels[cSBState].Text := cStateTranslated;
end;

function TfrmZeeMapper.ExtractName(aFileName: string): string;
begin
  Result := TcrpMapFileUtility.ExtractName(aFileName);
end;

procedure TfrmZeeMapper.LoadTranslateFiles;
var
  a_Index, a_FileCount, a_ColCount, a_Col, a_Row: integer;
begin
  odlgOpenTranslateFiles := TOpenDialog.Create(Self);
  odlgOpenTranslateFiles.Options := [ofAllowMultiSelect, ofFileMustExist];
  try
    if odlgOpenTranslateFiles.Execute then
      if (odlgOpenTranslateFiles.Files.Count > 0) then
      begin
        a_FileCount := odlgOpenTranslateFiles.Files.Count;
        a_ColCount := sgTranslateFiles.ColCount;
        a_Col := 0;
        a_Row := 0;
//we set the Row Count-if not divisable...we need to add an extra row
        sgTranslateFiles.RowCount := (a_FileCount div a_ColCount);
        if (a_FileCount mod a_ColCount) <> 0 then
          sgTranslateFiles.RowCount := sgTranslateFiles.RowCount + 1;
        for a_Index := 0  to a_FileCount -1 do
        begin
//we place the minimized name in the Grid...and save the full file name in List...
          sgTranslateFiles.Canvas.FillRect(sgTranslateFiles.CellRect(a_Col, a_Row));
          sgTranslateFiles.Cells[a_Col, a_Row] :=
            MinimizeName(odlgOpenTranslateFiles.Files[a_Index], sgTranslateFiles.Canvas, sgTranslateFiles.DefaultColWidth);
          FTranslateFileList.AddTranslateFile(odlgOpenTranslateFiles.Files[a_Index], a_Col, a_Row);
          if ((a_Col + 1) mod a_ColCount) = 0 then
          begin
//is a new row...else move to column
            a_Col := 0;
            inc(a_Row);
          end else
            inc(a_Col);
        end;
      end;
  finally
    odlgOpenTranslateFiles.Free;
  end;
end;

{Events}
{______________________________________________________________________________}
procedure TfrmZeeMapper.actAboutExecute(Sender: TObject);
begin
  frmAboutBox := TAboutBox.Create(self);
  try
    frmAboutBox.ShowModal;
  finally
    frmAboutBox.Release;
    frmAboutBox := nil;
  end;
end;

procedure TfrmZeeMapper.actAddCheckedNodesExecute(Sender: TObject);
begin
  OnWalkTree := AddCheckedNode;
  StartWalk;
end;


procedure TfrmZeeMapper.actAddNodeExecute(Sender: TObject);
begin
  OnWalkTree := AddSelectedNode;
  StartWalk;
end;

procedure TfrmZeeMapper.actCheckAllExecute(Sender: TObject);
begin
  FCount := 0;
  OnWalkTree := CheckAll;
  tvMap.CheckBoxes := False;
  tvMap.CheckBoxes := True;
  StartWalk;
  tvMap.Update;
end;

procedure TfrmZeeMapper.actClickExecute(Sender: TObject);
begin
  FCount := 0;
  OnWalkTree := CountChecked;
  StartWalk;
  EnableActions;
end;

procedure TfrmZeeMapper.actDeleteCheckedNodesExecute(Sender: TObject);
begin
  OnWalkTree := DeleteCheckedNode;
  StartWalk;
end;

procedure TfrmZeeMapper.actDeleteNodeExecute(Sender: TObject);
var
  a_DeletedNode: TTreeNode;
begin
//hmmm bugged?
  a_DeletedNode := tvMap.Selected;
  if Assigned(a_DeletedNode) then
  begin
    DeleteFile(FullMapName(a_DeletedNode.Text));
    if a_DeletedNode.HasChildren then
      a_DeletedNode.DeleteChildren;
    a_DeletedNode.Delete;
  end;
end;

procedure TfrmZeeMapper.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;


procedure TfrmZeeMapper.actEditMapExecute(Sender: TObject);
begin
  OnWalkTree := EditNode;
  StartWalk;
end;

procedure TfrmZeeMapper.actExportExecute(Sender: TObject);
begin
//
end;


procedure TfrmZeeMapper.actExportMapForTranslationExecute(Sender: TObject);
begin
//
end;

procedure TfrmZeeMapper.actExportValueToChildExecute(Sender: TObject);
begin
//temp need to add a dialog to warn of losing map
  OnWalkTree := ExportValueToChild;
  StartWalk;
end;

procedure TfrmZeeMapper.actImportExecute(Sender: TObject);
begin
//
end;

procedure TfrmZeeMapper.actOptionsExecute(Sender: TObject);
begin
  frmOptions := TfrmOptions.Create(self);
  try
    frmOptions.edtDefaultTransLoc.Text := FDefaultTransLoc;
    frmOptions.edtDefaultSaveLoc.Text := FDefaultSaveLoc;
    frmOptions.cbUseFileExt.Checked := FUseFileExt;
    frmOptions.edtDefaultExt.Enabled := not FUseFileExt;
    if frmOptions.ShowModal = mrOK then
    begin
      SaveOptions(frmOptions);
      SaveOptions;
    end;
  finally
    frmOptions.Release;
  end;
end;

procedure TfrmZeeMapper.actRenameExecute(Sender: TObject);
var
  a_Node: TTreeNode;
  a_Original: string;
  a_Data: TcrpKeyValueData;
begin
  a_Node := tvMap.Selected;
  if Assigned(a_Node) then
    frmRename := TfrmRename.Create(self);
    try
      frmRename.Left := frmZeeMapper.Left + FRect.Left + 10 + tvMap.Left;
      frmRename.Top := frmZeeMapper.Top + FRect.Top + 10 + tvMap.Top ;
      if frmRename.ShowModal = mrOk then
      begin
        a_Original := a_Node.Text;
        a_Node.Text := frmRename.edtMap.Text;
        actValidateNameExecute(Sender);
        if FIsValid then
        begin
          a_Data := FTreeMap.GetValue(a_Original);
          if Assigned(a_Data) then
          begin
            RenameFile(ApplicationDirectory + a_Original + cDefaultExt ,
                       ApplicationDirectory + a_Node.Text + cDefaultExt);
            a_Data.Value := a_Node.Text
          end else
          begin
          //this is an error state...revert could not find in list
            a_Node.Text := a_Original;
            MessageDlg(cRenameError, mtError, [mbOK], 0);
          end;
        end else
        begin
          a_Node.Text := a_Original;
          MessageDlg(cDupeMapName, mtError,[mbOK], 0);
        end;
      end;
    finally
      frmRename.Release;
      frmRename := nil;
    end;
end;

procedure TfrmZeeMapper.actSaveExecute(Sender: TObject);
begin
//
end;


procedure TfrmZeeMapper.actSelTransFilesExecute(Sender: TObject);
begin
  LoadTranslateFiles;
end;

procedure TfrmZeeMapper.actTranslateExecute(Sender: TObject);
begin
  Translate;
end;

procedure TfrmZeeMapper.actUncheckAllExecute(Sender: TObject);
begin
  FCount := 0;
  OnWalkTree := UnCheckAll;
  tvMap.CheckBoxes := False;
  tvMap.CheckBoxes := True;
  StartWalk;
  tvMap.Update;
end;


procedure TfrmZeeMapper.actValidateNameExecute(Sender: TObject);
begin
//hmm...do I even care to Validate the Names for dupes?
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

procedure TfrmZeeMapper.pcMapperChange(Sender: TObject);
var
  a_Frame: TfrAbstractFrame;
begin
{  cTSMaps = 0;
  cTSMapper = 1;
  cTSRulesList = 2;
  cTSRule = 3;
  cTSEditor = 4;
}
  if Assigned(Self.tvMap.Selected) then
  begin
    a_Frame := GetFrame(pcMapper.ActivePage);
    if Assigned(a_Frame) then
    begin
      a_Frame.LoadFrame;
      if pcMapper.TabIndex = cTSMaps then
        Self.ActiveControl := tsMaps
      else if pcMapper.TabIndex = cTSMapper then
        Self.ActiveControl := tsMapper
      else if pcMapper.TabIndex = cTSRulesList then
        Self.ActiveControl := tsRules
      else if pcMapper.TabIndex = cTSRule then
        Self.ActiveControl := tsRule
      else if pcMapper.TabIndex = cTSEditor then
        Self.ActiveControl := tsEditor;
    end;
  end;
end;


procedure TfrmZeeMapper.sgTranslateFilesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  a_Col, a_Row: integer;
begin
  sgTranslateFiles.MouseToCell(X,Y,a_Col, a_Row);
  sbMap.Panels.Items[cSBMessage].Text  :=  FTranslateFileList.GetTranslateFile(a_Col, a_Row);
end;

procedure TfrmZeeMapper.tvMapStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  StartDrag(TControl(Sender));
  DragObject := FDragControl;
end;

procedure TfrmZeeMapper.tvMapDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
//The Source is the object being dragged, the Sender is the potential drop
  AcceptDragOver(TControl(Sender), Accept);
end;

procedure TfrmZeeMapper.tvMapDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
{The Source parameter of the OnDragDrop event is the object being dropped,
 and the Sender is the control the object is being dropped on}
  StartDrop(TControl(Sender));
end;

procedure TfrmZeeMapper.tvMapMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if AllowDrag(TTreeView(Sender)) then
    tvMap.BeginDrag(False, 2)
  else
    sbMap.Panels[cSBMessage].Text := cStartDragError;
end;

{ TTranslateFileList }

procedure TTranslateFileList.AddTranslateFile(aFileName: string; aCol, aRow: integer);
begin
  FList.Add(TTranslateFile.Create(aFileName, aCol, aRow) );
end;

constructor TTranslateFileList.Create;
begin
  FList := TList.Create;
end;

destructor TTranslateFileList.Destroy;
var
  a_Index: integer;
begin
  for a_Index := 0 to FList.Count -1 do
    TTranslateFile(FList.Items[a_Index]).Free;
  FList.Free;
  inherited;
end;

function TTranslateFileList.GetTranslateFile(aCol, aRow: integer): string;
var
  a_Index: integer;
begin
  Result := '';
  for a_Index := 0 to FList.Count -1 do
     if (TTranslateFile(FList.Items[a_Index]).Row = aRow) and
        (TTranslateFile(FList.Items[a_Index]).Col = aCol) then
     begin
       Result := TTranslateFile(FList.Items[a_Index]).FullName;
       Exit;
     end;
end;


{ TTranslateFile }

constructor TTranslateFile.Create(aFileName: string; aCol,
  aRow: integer);
begin
  FullName := aFileName;
  Col := aCol;
  Row := aRow;
end;


procedure TfrmZeeMapper.actClearMapSelectedExecute(Sender: TObject);
begin
  if Screen.ActiveControl is TListView then
  begin
    TListView(Screen.ActiveControl).Clear;
    TComboBox(TListView(Screen.ActiveControl).Tag).Clear;
  end;
end;

procedure TfrmZeeMapper.actClearMapAllExecute(Sender: TObject);
begin
  lvBase.Clear;
  lvExport.Clear;
  cboBase.Clear;
  cboExport.Clear;
end;

procedure TfrmZeeMapper.cboChange(Sender: TObject);
var
  a_ListBox: TListView;
begin
  if Sender is TComboBox then
  begin
    a_ListBox :=  TListView(TComboBox(Sender).Tag);
    a_ListBox.AddItem(TComboBox(Sender).Text, nil);
    a_ListBox.Items[0].ImageIndex := 0;
  end;
end;

end.
