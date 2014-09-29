unit fAbstractFrame;

{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ActnList, Menus;

type
  TfrAbstractFrame = class(TFrame)
    pumFrame: TPopupMenu;
    alFrame: TActionList;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadFrame; virtual;
    procedure UnloadFrame; virtual;
    function AllowMove: boolean; virtual;
  end;

implementation

{$R *.dfm}

{ TfrmAbstractFrame }

function TfrAbstractFrame.AllowMove: boolean;
begin
  Result := True;
end;

procedure TfrAbstractFrame.LoadFrame;
begin
  alFrame.State := asNormal;
end;

procedure TfrAbstractFrame.UnloadFrame;
begin
  alFrame.State :=  asSuspended;
end;

end.
