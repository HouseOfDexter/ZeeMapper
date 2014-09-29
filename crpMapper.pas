unit crpMapper;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }
interface

uses
  Classes, SysUtils, IniFiles, ComCtrls, crpBase, crpRule, crpZeeMapperDefault,
  crpKeyValue;
type
  EMapExporter = Exception;

{______________________________________________________________________________}
  TcrpMapTreeData = class(TcrpKVRuleData)
  private
    FTreeNode: TTreeNode;
  public
    property TreeNode: TTreeNode read FTreeNode write FTreeNode;
  end;

{______________________________________________________________________________}
  TcrpTreeMapper = class(TcrpKeyValueMapper)
  public
    procedure AddTreeNode(aData: TcrpKeyValueData; aTreeNode: TTreeNode);
  end;

{______________________________________________________________________________}
  TcrpMapExporter = class(TcrpTranslator)
  private
    FBaseFN: string;
    procedure SetBaseFN(const Value: string);
  protected
    function GetNotSetValues: string; override;
    procedure SaveStream(aStream: TStream);
  public
    function CanTranslate: boolean; override;
    procedure Translate; override;
    property BaseFileName: string read FBaseFN write SetBaseFN;
  end;

implementation

  uses
    crpDefaults;

{TcrpTreeMapper}
{______________________________________________________________________________}


procedure TcrpTreeMapper.AddTreeNode(aData: TcrpKeyValueData; aTreeNode: TTreeNode);
begin
  if Assigned(aData) and (aData is TcrpMapTreeData) then
    TcrpMapTreeData(aData).TreeNode := aTreeNode;
end;

{ TcrpMapExporter }
{______________________________________________________________________________}


function TcrpMapExporter.CanTranslate: boolean;
begin
  Result := Inherited CanTranslate and
     (FBaseFN <> '');
end;

procedure TcrpMapExporter.Translate;
begin
  Inherited Translate;
  if CanTranslate then
    SaveStream(ExportRaw.Stream)
  else
    Raise EMapExporter.Create(GetNotSetValues);
end;

function TcrpMapExporter.GetNotSetValues: string;
begin
{(FMapBaseFN <> '') and (FMapExportFN <> '') and
     (FBaseFN <> '') and (FExportFN <> '');}
  Result := inherited GetNotSetValues;
  if FBaseFN = '' then
    Result := 'Base FileName not set';
end;


procedure TcrpMapExporter.SetBaseFN(const Value: string);
begin
  FBaseFN := Value;
  BaseRaw.RawFile := Value;
  BaseRaw.LoadRawFile;
end;


procedure TcrpMapExporter.SaveStream(aStream: TStream);
var
  a_FileStream: TStream;
begin
  if aStream.Size > 0 then
  begin
    a_FileStream := TFileStream.Create(ExportFileName, fmCreate);
    try
      aStream.Position := 0;
      a_FileStream.CopyFrom(aStream, aStream.Size);
    finally
      a_FileStream.Free;
    end;
  end;
end;


end.
