unit fOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExStdCtrls, JvButton, JvCtrls, ActnList, JvBaseDlg,
  JvSelectDirectory, ImgList, StdCtrls, ExtCtrls;

type
  TfrmOptions = class(TForm)
    edtDefaultTransLoc: TLabeledEdit;
    edtDefaultSaveLoc: TLabeledEdit;
    btnOk: TButton;
    btnCancel: TButton;
    cbUseFileExt: TCheckBox;
    edtDefaultExt: TLabeledEdit;
    ilOptions: TImageList;
    dlgSelectDir: TJvSelectDirectory;
    ActionList1: TActionList;
    actOpenDlgTransLoc: TAction;
    actOpenDlgSaveLoc: TAction;
    btnOpenDlgTransLoc: TJvImgBtn;
    btnOpenDlgSaveLoc: TJvImgBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtDefaultTransLocChange(Sender: TObject);
    procedure cbUseFileExtKeyPress(Sender: TObject; var Key: Char);
    procedure cbUseFileExtClick(Sender: TObject);
    procedure actOpenDlgTransLocExecute(Sender: TObject);
    procedure actOpenDlgSaveLocExecute(Sender: TObject);
  private
    FHasChanged: boolean;
    function GetHasChanged: boolean;
    procedure SetHasChanged(const Value: boolean);
    { Private declarations }
  protected
    property HasChanged: boolean read GetHasChanged write SetHasChanged;
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

procedure TfrmOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if HasChanged and not(ModalResult = mrCancel) then
    Self.ModalResult := mrOK
  else
    Self.ModalResult := mrCancel;
end;

function TfrmOptions.GetHasChanged: boolean;
begin
  Result := FHasChanged;
end;

procedure TfrmOptions.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
end;

procedure TfrmOptions.edtDefaultTransLocChange(Sender: TObject);
begin
  HasChanged := True;
end;

procedure TfrmOptions.cbUseFileExtKeyPress(Sender: TObject; var Key: Char);
begin
  HasChanged := True;
end;

procedure TfrmOptions.cbUseFileExtClick(Sender: TObject);
begin
  HasChanged := True;
end;

procedure TfrmOptions.actOpenDlgTransLocExecute(Sender: TObject);
begin
  if dlgSelectDir.Execute then
    edtDefaultTransLoc.Text := dlgSelectDir.Directory;
end;

procedure TfrmOptions.actOpenDlgSaveLocExecute(Sender: TObject);
begin
  if dlgSelectDir.Execute then
    edtDefaultSaveLoc.Text := dlgSelectDir.Directory;
end;

end.
