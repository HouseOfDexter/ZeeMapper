unit fEditor;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, ComCtrls, ToolWin, ExtCtrls, StdCtrls, fAbstractFrame,
  ImgList, JvDialogs, Clipbrd;

type
  TfrEditor = class(TfrAbstractFrame)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    memEditor: TMemo;
    ilToolbar: TImageList;
    actCut: TAction;
    actPaste: TAction;
    actCopy: TAction;
    actOpenFile: TAction;
    actSaveFile: TAction;
    actSaveFileAs: TAction;
    dlgOpenFile: TJvOpenDialog;
    dlgSaveFile: TJvSaveDialog;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    actCopy1: TMenuItem;
    actCut1: TMenuItem;
    actPaste1: TMenuItem;
    actSelectAll: TAction;
    N1: TMenuItem;
    SelectAll1: TMenuItem;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure actCutExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actSaveFileExecute(Sender: TObject);
    procedure actSaveFileAsExecute(Sender: TObject);
    procedure memEditorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FAllowMove: boolean;
    FChanged: boolean;
    FFileName: TFileName;
  public
    { Public declarations }
    procedure LoadFrame; override;
    procedure UnLoadFrame; override;
    function AllowMove: boolean; override;
    procedure OpenFile;
    procedure SaveFile;
    procedure SaveFileAs;
  end;

implementation

{$R *.dfm}

uses
  crpDefaults;

{ TfrEditor }

procedure TfrEditor.OpenFile;
begin
  if dlgOpenFile.Execute then
    memEditor.Lines.LoadFromFile(dlgOpenFile.FileName);
end;

procedure TfrEditor.SaveFile;
begin
  if FFileName = '' then
    SaveFileAs
  else
  begin
    memEditor.Lines.SaveToFile(FFileName);
    FChanged := False;
  end;
end;

procedure TfrEditor.SaveFileAs;
begin
  if dlgSaveFile.Execute then
  begin
    FFileName := dlgSaveFile.FileName;
    memEditor.Lines.SaveToFile(FFileName);
    FChanged := False;
  end;
end;


procedure TfrEditor.actCutExecute(Sender: TObject);
begin
  inherited;
  memEditor.CutToClipboard;
  FChanged := True;
end;

procedure TfrEditor.actPasteExecute(Sender: TObject);
begin
  inherited;
  memEditor.PasteFromClipboard;
  FChanged := True;
end;

procedure TfrEditor.actCopyExecute(Sender: TObject);
begin
  inherited;
  memEditor.CopyToClipboard;
end;

procedure TfrEditor.actSelectAllExecute(Sender: TObject);
begin
  inherited;
  memEditor.SelectAll;
end;


procedure TfrEditor.LoadFrame;
begin
  inherited;
end;

procedure TfrEditor.UnLoadFrame;
var
  a_ModalResult: TModalResult;
begin
  inherited;
  if FChanged then
  begin
    a_ModalResult :=  MessageDlg(cSaveDialog, mtCustom, mbYesNoCancel, 0);
    if a_ModalResult = mrYes then
      SaveFile
    else if a_ModalResult = mrCancel then
      FAllowMove := False;
  end;
end;

function TfrEditor.AllowMove: boolean;
begin
  Result := FAllowMove;
end;

procedure TfrEditor.actOpenFileExecute(Sender: TObject);
begin
  inherited;
  OpenFile;
end;

procedure TfrEditor.actSaveFileExecute(Sender: TObject);
begin
  inherited;
  SaveFile;
end;

procedure TfrEditor.actSaveFileAsExecute(Sender: TObject);
begin
  inherited;
  SaveFileAs;
end;

procedure TfrEditor.memEditorKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  FChanged := True;
end;

end.
