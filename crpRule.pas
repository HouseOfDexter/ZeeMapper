unit crpRule;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }
interface

uses
  Classes, SysUtils, crpDefaults, crpZeeMapperDefault;

const
  cRuleSymbols = ['%','$', '@', '!', '^'];

type
  TRuleIndex = (RINotSet, RIIgnore, RIIgnoreUntil, RIIgnoreAfter, RIApplyMulti,
                RIApplyUntil, RIConvert, RIAsOneRule);

  ERule = Exception;
  TcrpDataClass = class of TcrpAbstractData;
{______________________________________________________________________________}
  TcrpAbstractData = class(TObject)
    constructor Create; virtual;
  end;
{______________________________________________________________________________}
  TcrpRule = class(TcrpAbstractData)
{these are our default Rules}
  private
    FRule: string;
    FRuleIndex: TRuleIndex;
    FNumOfSymbols: integer;
    FSymbolIndex: integer;
    procedure SetRule(const Value: string);
    function GetNumSymbols: integer;
    function GetRuleIndex: TRuleIndex;
    function GetRule: string;
    procedure SetRuleIndex(const Value: TRuleIndex);
    function GetSymbolIndex: integer;
    procedure SetSymbolIndex(const Value: integer);
  protected
    procedure DoNumOfSymbols;
    procedure DoRuleIndex;
  public
    property NumOfSymbols: integer read GetNumSymbols;
    property Rule: string read GetRule write SetRule;
    property RuleIndex: TRuleIndex read GetRuleIndex write SetRuleIndex;
    property SymbolIndex: integer read GetSymbolIndex write SetSymbolIndex;
    constructor Create; override;
    function isAfter: boolean;
    function isUntil: boolean;
  end;
{  TRuleIndex = (RINotSet, RIIgnore, RIIgnoreUntil, RIIgnoreAfter, RIApplyMulti, RIApplyUntil, RIConvert);}
{______________________________________________________________________________}
  TSpecificRule = class(TcrpRule)
  private
    FRuleValue: string;
    FValueToCheck: string;
    FIsMatch: boolean;
    FConvertTo: string;
    FWhen: string;
    FApply: string;
    FUntil: string;
    FTimes: string;
    FCombine: string;
    FReturnValue: string;
    procedure SetRuleValue(const Value: string);
    procedure SetValueToCheck(const Value: string);

  protected
    property WhenStr: string read FWhen write FWhen;
    property UntilStr: string read FUntil write FUntil;
    property ApplyStr: string read FApply write FApply;
    property TimesStr: string read FTimes write FTimes;
    property ConvertToStr: string read FConvertTo write FConvertTo;
    property CombineStr: string read FCombine write FCombine;

    procedure DoValueCheck; virtual; abstract;//temp do we need this?
    procedure InitRuleValue; virtual; abstract;
    procedure SetIsMatch(Value: boolean);
  public
    constructor Create; override;
    destructor Destroy; Override;
    property IsMatch: boolean read FIsMatch;
    property RuleValue: string read FRuleValue write SetRuleValue;
    property ValueToCheck: string read FValueToCheck write SetValueToCheck;
    property ReturnValue: string read FReturnValue write FReturnValue;
  end;
{______________________________________________________________________________}
  TSpecificRuleClass = class of TSpecificRule;

{ cRIgnore =  'Ignore When %';
  cRIgnoreUntil = 'Ignore Until @';
  cRIgnoreAfter ='Ignore After When %';
  cRApplyMulti = 'When %, Apply ^ Times $';
  cRApplyUntil = 'When % Convert To ! Until @';
  cRConvert = 'When % Convert To !';
  cRAsOneRule = 'Combine Next ^ Rules as One';}
{______________________________________________________________________________}
  TIgnoreRule = class(TSpecificRule)
  protected
    procedure DoValueCheck; override;
    procedure InitRuleValue; override;
  public
  end;
{______________________________________________________________________________}
  TIgnoreUntilRule = class(TSpecificRule)
  protected
    procedure DoValueCheck; override;
    procedure InitRuleValue; override;
  public
  end;
{______________________________________________________________________________}
  TIgnoreAfterRule = class(TSpecificRule)
  protected
    procedure DoValueCheck; override;
    procedure InitRuleValue; override;
  public
  end;
{______________________________________________________________________________}
  TApplyMultiRule = class(TSpecificRule)
  protected
    procedure DoValueCheck; override;
    procedure InitRuleValue; override;
  public
  end;
{______________________________________________________________________________}
  TApplyUntilRule = class(TSpecificRule)
  protected
    procedure DoValueCheck; override;
    procedure InitRuleValue; override;
  public
  end;
{______________________________________________________________________________}
  TConvertRule = class(TSpecificRule)
  protected
    procedure DoValueCheck; override;
    procedure InitRuleValue; override;
  public
  end;
{______________________________________________________________________________}
  TIAsOneRule = class(TSpecificRule)
  protected
    procedure DoValueCheck; override;
    procedure InitRuleValue; override;
  public
  end;
{______________________________________________________________________________}
  TcrpValidateRule = class(TcrpAbstractData)
  private
    FContinue: boolean;
    FIndex: integer;
    FSymbol: char;
    FValue: string;
    FRule: TcrpRule;
    function GetRuleValue: string;
    procedure SetValue(const Value: string);
  public
    property Rule: TcrpRule  read FRule write FRule;
    property Symbol: char read FSymbol write FSymbol;
    property Value: string read FValue write SetValue;
    property RuleValue: string read GetRuleValue;
    constructor Create; override;
    function IsMatch: boolean;
  end;
{______________________________________________________________________________}
  TcrpAbstractList = class(TObject)
  private
    FList: TList;
    FIterIndex: integer;
  protected
    function GetData(aIndex: integer): TcrpAbstractData;
    property List: TList read FList;
  public
    constructor Create;
    destructor Destroy; override;
    function GetFirst: TcrpAbstractData;
    function GetNext: TcrpAbstractData;
    function Finished: boolean;
  end;
{______________________________________________________________________________}

  TcrpRuleList = class(TcrpAbstractList)
    constructor Create;
    function FindRule(aRule: string): TcrpRule;
  end;
{______________________________________________________________________________}
  TcrpSpecificRuleList = class(TcrpAbstractList)
  protected
    function CheckValue: boolean;
  public
    procedure AddRule(aRuleIndex: TRuleIndex; aRuleValue: string);
  end;
{______________________________________________________________________________}
  TcrpRuleData = class(TcrpAbstractData)
  private
    FRuleValue: string;
    FRuleStr: string;
    FRule: TcrpRule;
    procedure SetRuleValue(const Value: string);
    procedure SetRuleStr(const Value: string);
  public
    property Rule: TcrpRule read FRule write FRule;
    property RuleStr: string read FRuleStr write SetRuleStr;
    property RuleValue: string read FRuleValue write SetRuleValue;
  end;
{______________________________________________________________________________}
  TcrpRuleDataList = class(TcrpAbstractList)
  private
  public
    constructor Create;
    function AddRuleData(aRuleStr, aRuleValue: string): TcrpRuleData;
    function MatchRuleValue(aValue: string): boolean;
    function HasUntil: boolean;
    function HasAfter: boolean;
  end;
{______________________________________________________________________________}
  TcrpRuleMatcher = class(TObject)
  private
    FRuleDataList: TcrpRuleDataList;
    FRuleList: TcrpRuleList;
    FHasUntil: boolean;
    FHasAfter: boolean;
    FIsUntil: boolean;
    FIsAfter: boolean;
    FIsRule: boolean;
    FValue: string;
    procedure SetValue(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddRuleData(aRuleStr, aRuleValue: string);
    procedure ClearValue;
    function IsRule: boolean;
    property Value: string read FValue write SetValue;
  end;

implementation

uses MaskUtils, Math;

{
  cRIgnoreSet = ['%'];
  cRIgnoreUntilSet = ['@'];
  cRIgnoreAfterSet = ['%'];
  cRApplyMultiSet = ['%', '^', '$'];
  cRApplyUntilSet = ['^', '%', '@'];
  cRConvertSet= ['%', '!'];

  cRIgnore =  'Ignore When %';
  cRIgnoreUntil = 'Ignore Until @';
  cRIgnoreAfter ='Ignore After When %';
  cRApplyMulti = 'When %, Apply ^ Times $';
  cRApplyUntil = 'When % Convert To ! Until @';
  cRConvert = 'When % Convert To !';
}
{ TcrpRule }

function TcrpRule.GetNumSymbols: integer;
begin
  if FNumOfSymbols = -1 then
    DoNumOfSymbols;
  Result := FNumOfSymbols;
end;

function TcrpRule.GetRule: string;
begin
{ TRuleIndex = (RINotSet, RIIgnore, RIIgnoreUntil, RIIgnoreAfter, RIApplyMulti, RIApplyUntil, RIConvert)}
  if FRuleIndex = RIIgnore then
    Result := cRIgnore
  else if FRuleIndex = RIIgnoreUntil then
    Result := cRIgnoreUntil
  else if FRuleIndex = RIIgnoreAfter then
    Result := cRIgnoreAfter
  else if FRuleIndex = RIApplyMulti then
    Result := cRApplyMulti
  else if FRuleIndex = RIApplyUntil then
    Result := cRApplyUntil
  else if FRuleIndex = RIConvert then
    Result := cRConvert
  else if FRuleIndex = RIAsOneRule then
    Result := cRAsOneRule;
end;

function TcrpRule.GetRuleIndex: TRuleIndex;
begin
  if FRuleIndex = RINotSet then
    DoRuleIndex;
  Result := FRuleIndex;
end;

procedure TcrpRule.DoNumOfSymbols;
begin
  if FRuleIndex in [RIIgnore, RIIgnoreUntil, RIIgnoreAfter, RIAsOneRule] then
    FNumOfSymbols := 1
  else if FRuleIndex in [RIApplyMulti,RIApplyUntil] then
    FNumOfSymbols := 3
  else if FRuleIndex in [RIConvert] then
    FNumOfSymbols := 2;
end;

procedure TcrpRule.SetRule(const Value: string);
begin
  FRule := Value;
  if FRuleIndex = RINotSet then
    DoRuleIndex;
  DoNumOfSymbols;
end;

procedure TcrpRule.DoRuleIndex;
begin
{ TRuleIndex = (RINotSet, RIIgnore, RIIgnoreUntil, RIIgnoreAfter, RIApplyMulti, RIApplyUntil, RIConvert)}
  if FRule = cRIgnore then
    FRuleIndex := RIIgnore
  else if FRule = cRIgnoreUntil then
    FRuleIndex := RIIgnoreUntil
  else if FRule = cRIgnoreAfter then
    FRuleIndex := RIIgnoreAfter
  else if FRule = cRApplyMulti then
    FRuleIndex := RIApplyMulti
  else if FRule = cRApplyUntil then
    FRuleIndex := RIApplyUntil
  else if FRule = cRConvert then
    FRuleIndex := RIConvert
  else if FRule = cRAsOneRule then
    FRuleIndex := RIAsOneRule;
end;

constructor TcrpRule.Create;
begin
  FRuleIndex := RINotSet;
  FNumOfSymbols := -1;
end;

procedure TcrpRule.SetRuleIndex(const Value: TRuleIndex);
begin
  FRuleIndex := Value;
  if FRule = '' then
    Rule := GetRule;
end;

function TcrpRule.isAfter: boolean;
begin
  Result := FRuleIndex = RIIgnoreAfter;
end;

function TcrpRule.isUntil: boolean;
begin
  Result := FRuleIndex = RIIgnoreUntil;
end;

function TcrpRule.GetSymbolIndex: integer;
begin
  Result := FSymbolIndex;
end;

procedure TcrpRule.SetSymbolIndex(const Value: integer);
begin
  FSymbolIndex := Value;
end;


{ TcrpList }
{______________________________________________________________________________}
constructor TcrpAbstractList.Create;
begin
  FList := TList.Create;
end;

destructor TcrpAbstractList.Destroy;
var
  a_Index: integer;
begin
  for a_Index := 0 to FList.Count -1 do
    TcrpRule(FList.Items[a_Index]).Free;
  FList.Free;
  inherited;
end;

function TcrpAbstractList.Finished: boolean;
begin
  Result := FIterIndex >= FList.Count;
end;

function TcrpAbstractList.GetFirst: TcrpAbstractData;
begin
  FIterIndex := 0;
  Result := GetData(FIterIndex);
end;

function TcrpAbstractList.GetNext: TcrpAbstractData;
begin
  inc(FIterIndex);
  Result := GetData(FIterIndex);
end;

function TcrpAbstractList.GetData(aIndex: integer): TcrpAbstractData;
begin
  if (FList.Count > 0) and (FIterIndex < FList.Count) then
    Result :=  TcrpAbstractData(FList.Items[FIterIndex])
  else
    Result := nil;
end;
{______________________________________________________________________________}

{ TcrpValidateRule }

constructor TcrpValidateRule.Create;
begin
  FIndex := -1;
end;

function TcrpValidateRule.GetRuleValue: string;
begin

end;

function TcrpValidateRule.IsMatch: boolean;
begin
//temp
  Result := False;
end;

procedure TcrpValidateRule.SetValue(const Value: string);
begin
  FValue := Value;
end;
{______________________________________________________________________________}
{ TcrpRuleData }

procedure TcrpRuleData.SetRuleStr(const Value: string);
begin
  FRuleStr := Value;
end;

procedure TcrpRuleData.SetRuleValue(const Value: string);
begin
  FRuleValue := Value;
end;
{______________________________________________________________________________}
{ TcrpAbstractData }

constructor TcrpAbstractData.Create;
begin

end;
{______________________________________________________________________________}
{ TcrpRuleList }

constructor TcrpRuleList.Create;
var
  a_Index: TRuleIndex;
  a_Rule: TcrpRule;
begin
  inherited Create;
  for a_Index := Low(TRuleIndex) to High(TRuleIndex) do
  begin
    if a_Index <> RINotSet then
    begin
      a_Rule := TcrpRule.Create;
      a_Rule.RuleIndex := a_Index;
      List.Add(a_Rule);
    end;
  end;
end;

function TcrpRuleList.FindRule(aRule: string): TcrpRule;
begin
  Result := TcrpRule(GetFirst);
  while Assigned(Result)and not Finished do
    if Result.Rule = aRule then
      break;
end;
{______________________________________________________________________________}
{ TcrpRuleDataList }

function TcrpRuleDataList.AddRuleData(aRuleStr, aRuleValue: string): TcrpRuleData;
begin
  Result := TcrpRuleData.Create;
  Result.RuleStr := aRuleStr;
  Result.RuleValue := aRuleValue;
  List.Add(Result);
end;

constructor TcrpRuleDataList.Create;
begin
  inherited Create;
end;

function TcrpRuleDataList.HasAfter: boolean;
var
  a_Index: integer;
begin
  Result := False;
  for a_Index := 0 to List.Count -1 do
    if Assigned(TcrpRuleData(List.Items[a_Index]).Rule) then
      if TcrpRuleData(List.Items[a_Index]).Rule.isAfter then
      begin
        Result := True;
        break;
      end;
end;

function TcrpRuleDataList.HasUntil: boolean;
var
  a_Index: integer;
begin
  Result := False;
  for a_Index := 0 to List.Count -1 do
    if Assigned(TcrpRuleData(List.Items[a_Index]).Rule) then
      if TcrpRuleData(List.Items[a_Index]).Rule.isUntil then
      begin
        Result := True;
        break;
      end;
end;

function TcrpRuleDataList.MatchRuleValue(aValue: string): boolean;
var
  a_Index: integer;
begin
//temp
  Result := False;
  for a_Index := 0 to List.Count -1 do
  begin
  end;
end;
{______________________________________________________________________________}
{ TcrpRuleMatcher }

procedure TcrpRuleMatcher.AddRuleData(aRuleStr, aRuleValue: string);
var
  a_RuleData: TcrpRuleData;
begin
  a_RuleData := FRuleDataList.AddRuleData(aRuleStr, aRuleValue);
  a_RuleData.Rule := FRuleList.FindRule(aRuleStr);
  if not FHasAfter then
  begin
    FHasAfter :=  a_RuleData.Rule.isAfter;
    FIsAfter := a_RuleData.Rule.isAfter;
  end;
  if not FHasUntil then
  begin
    FHasUntil := a_RuleData.Rule.isUntil;
    FIsUntil := a_RuleData.Rule.isUntil;
  end;
end;

procedure TcrpRuleMatcher.ClearValue;
begin
{you want to clear the Value if a match has been found in the maps or in the
 Rules}
  FValue := '';
end;

constructor TcrpRuleMatcher.Create;
begin
  FRuleDataList := TcrpRuleDataList.Create;
  FRuleList := TcrpRuleList.Create;
end;

destructor TcrpRuleMatcher.Destroy;
begin
  FRuleDataList.Free;
  FRuleList.Free;
  inherited;
end;

function TcrpRuleMatcher.IsRule: boolean;
begin
  Result := FIsRule;
end;

procedure TcrpRuleMatcher.SetValue(const Value: string);
begin
  FValue := FValue + Value;
  if FIsUntil then
  begin
//    if FValue = FRuleDataList.
{we are at the beginning and we have a Rule to ignore all Rules and Values
 until @ reached}
  end else if (not FIsUntil) and  FIsAfter then
  begin
{we may be at the end have a Rule to ignore all Values after %}
  end else
  ;
end;
{______________________________________________________________________________}
{ TSpecificRule }

constructor TSpecificRule.Create;
begin

end;

destructor TSpecificRule.Destroy;
begin
  inherited;
end;

procedure TSpecificRule.SetIsMatch(Value: boolean);
begin
  FIsMatch := Value;
end;

procedure TSpecificRule.SetRuleValue(const Value: string);
begin
  FRuleValue := Value;
  InitRuleValue;
end;

procedure TSpecificRule.SetValueToCheck(const Value: string);
begin
  FValueToCheck := Value;
  DoValueCheck;
end;

{ TcrpSpecificRuleList }
{______________________________________________________________________________}
procedure TcrpSpecificRuleList.AddRule(aRuleIndex: TRuleIndex; aRuleValue: string);
var
  a_Rule: TSpecificRule;
begin
{  TRuleIndex = (RINotSet, RIIgnore, RIIgnoreUntil, RIIgnoreAfter, RIApplyMulti,
                RIApplyUntil, RIConvert, RIAsOneRule);}
  a_Rule := nil;
  if aRuleIndex = RINotSet then
    Raise ERule.Create('Add Rule, index not set.');
  if aRuleIndex = RIIgnore then
    a_Rule := TIgnoreRule.Create
  else if aRuleIndex = RIIgnoreUntil then
    a_Rule := TIgnoreUntilRule.Create
  else if aRuleIndex = RIIgnoreAfter then
    a_Rule := TIgnoreAfterRule.Create
  else if aRuleIndex = RIApplyMulti then
    a_Rule := TApplyMultiRule.Create
  else if aRuleIndex = RIApplyUntil then
    a_Rule := TApplyUntilRule.Create
  else if aRuleIndex = RIConvert then
    a_Rule := TConvertRule.Create
  else if aRuleIndex = RIAsOneRule then
    a_Rule := TIAsOneRule.Create;
  a_Rule.RuleValue := aRuleValue;

  List.Add(a_Rule);
end;


function TcrpSpecificRuleList.CheckValue: boolean;
begin
//temp
  Result := False;
end;

{ TIgnoreRule }
{______________________________________________________________________________}
procedure TIgnoreRule.DoValueCheck;
begin
  inherited;

end;

procedure TIgnoreRule.InitRuleValue;
begin
  inherited;

end;

{ TIgnoreUntilRule }
{______________________________________________________________________________}
procedure TIgnoreUntilRule.DoValueCheck;
begin
  inherited;

end;

procedure TIgnoreUntilRule.InitRuleValue;
begin
  inherited;

end;

{ TIgnoreAfterRule }
{______________________________________________________________________________}
procedure TIgnoreAfterRule.DoValueCheck;
begin
  inherited;

end;

procedure TIgnoreAfterRule.InitRuleValue;
begin
  inherited;

end;

{ TApplyMultiRule }
{______________________________________________________________________________}
procedure TApplyMultiRule.DoValueCheck;
begin
  inherited;

end;

procedure TApplyMultiRule.InitRuleValue;
begin
  inherited;

end;

{ TApplyUntilRule }
{______________________________________________________________________________}
procedure TApplyUntilRule.DoValueCheck;
begin
  inherited;

end;

procedure TApplyUntilRule.InitRuleValue;
begin
  inherited;

end;

{ TConvertRule }
{______________________________________________________________________________}
procedure TConvertRule.DoValueCheck;
begin
  inherited;

end;

procedure TConvertRule.InitRuleValue;
begin
  inherited;

end;

{ TIAsOneRule }
{______________________________________________________________________________}
procedure TIAsOneRule.DoValueCheck;
begin
  inherited;

end;

procedure TIAsOneRule.InitRuleValue;
begin
  inherited;

end;

end.
