unit fRename;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmRename = class(TForm)
    edtMap: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected  
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  frmRename: TfrmRename;

implementation

{$R *.dfm}

procedure TfrmRename.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Close;
end;

procedure TfrmRename.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Key := #0;
end;

procedure TfrmRename.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if edtMap.Text <> '' then
    ModalResult := mrOK
  else
    ModalResult := mrCancel;
end;

procedure TfrmRename.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := (Params.Style or WS_POPUP) and not(WS_DLGFRAME);
end;

end.
