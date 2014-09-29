unit fRule;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, Grids, ValEdit, ComCtrls, ToolWin, crpRule,
  fAbstractFrame, ActnList, Menus;

type
  TfrRule = class(TfrAbstractFrame)
    lvRules: TListView;
    vleRule: TValueListEditor;
    ilRule: TImageList;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    ToolButton6: TToolButton;
    ToolButton10: TToolButton;
    ilRuleIcons: TImageList;
    ValueListEditor1: TValueListEditor;
  private
    { Private declarations }
    FRuleList: TcrpRuleList;
  public
    { Public declarations }
    procedure LoadFrame; override;
    procedure UnloadFrame; override;
  end;

implementation

{$R *.dfm}

{ TfrmRule }

{ cRIgnore =  'Ignore When %';
  cRIgnoreUntil = 'Ignore Until @';
  cRIgnoreAfter ='Ignore After When %';
  cRApplyMulti = 'When %, Apply ^ Times $';
  cRApplyUntil = 'When % Convert To ! Until @';
  cRConvert = 'When % Convert To !';
  cRAsOneRule = 'Combine Next ^ Rules as One';}

{  cRApplyMulti = 'When %, Apply ^ Times $';}
{this will be in format "%-S`#,^-`#, '$-&R1'}

procedure TfrRule.LoadFrame;
var
  a_Rule: TcrpAbstractData;
begin
  inherited;
  lvRules.ViewStyle := vsIcon;
  lvRules.LargeImages := ilRule;
  lvRules.SmallImages := ilRule;
  FRuleList := TcrpRuleList.Create;
  a_Rule := FRuleList.GetFirst;
  while Assigned(a_Rule) or (not FRuleList.Finished) do
  begin
    a_Rule := FRuleList.GetNext;
    if Assigned(a_Rule) then
    begin
      lvRules.AddItem(TcrpRule(a_Rule).Rule, a_Rule);
      lvRules.Items[lvRules.Items.Count -1].ImageIndex := Integer(TcrpRule(a_Rule).RuleIndex) -1;
    end;
  end;
end;

procedure TfrRule.UnLoadFrame;
begin
  FreeAndNil(FRuleList);
  inherited;  
end;

end.
