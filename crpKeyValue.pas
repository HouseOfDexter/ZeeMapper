unit crpKeyValue;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }
interface

uses
  Classes, SysUtils;

type
  EKeyValue = Exception;
  EKeyValueMapper = EKeyValue;
  EKeyValueLoader = EKeyValue;
  EKeyValueLoaderCnt = EKeyValueLoader;
  ETranslator = EKeyValue;

  TStreamClass = class of TStream;

  TKeyValueLoadEvent = procedure(aSender: TObject; var aSection: string;var aValues: TStrings) of object;

  TKeyValueClass = class of TcrpKeyValueData;
{______________________________________________________________________________}
  TcrpKeyValueData = class(TObject)
  private
    FValue: variant;
    FKey: variant;
  public
    property Key: variant read FKey write FKey;
    property Value: variant read FValue write FValue;
    constructor Create; virtual;
  end;

{______________________________________________________________________________}
  TcrpKeyValueMapper = class(TObject)
  private
    FIndex: integer;
    FBaseClass: TKeyValueClass;
    FList: TList;
    function GetCount: integer;
  protected
    function GetData(aIsKey: boolean; aData: Variant): TcrpKeyValueData;
  public
    constructor Create(aKeyValueClass: TKeyValueClass);
    destructor Destroy; override;
    function AddKey(aKey: Variant):TcrpKeyValueData; virtual;
    function AddKeyAndValue(aKey: Variant; aValue: Variant):TcrpKeyValueData; virtual;
    function GetValue(aValue: Variant): TcrpKeyValueData; virtual;
    function GetKey(aKey: Variant): TcrpKeyValueData; virtual;
    procedure DeleteKey(aKey: Variant);
    procedure DeleteValue(aValue: Variant);
    function FirstKey: TcrpKeyValueData; virtual;
    function NextKey: TcrpKeyValueData; virtual;
    function Finished: Boolean;
    function MatchKey(aKey, aValue: Variant): boolean;
    property Count: integer read GetCount;
  end;
{______________________________________________________________________________}
  TcrpKeyValueLoader = class(TObject)
  private
    FLoadFileName: string;
    FMapSList: TStrings;
    FMapper: TcrpKeyValueMapper;
    FOnLoadNew: TKeyValueLoadEvent;
    function GetIndexOfMap(aMapLine: string): integer;
    function GetMapStrList: TStrings;
  protected
    procedure LoadFile(aFileName: TFileName; aSection: string);
    procedure SaveFile(aFileName: TFileName; aMapList: TStrings; aSection: string);
    procedure LoadMapper;
    property LoadFileName: string read FLoadFileName write FLoadFileName;
  public
    procedure LoadNewFile(aFileName: TFileName; aSection: string);
    procedure ExportTo(aFileName: TFileName; aSection: string);
    procedure SaveToFile(aFileName: TFileName; aMapList: TStrings; aSection: string);
//    procedure SaveOption(aFileName: TFileName; aMapList: TStrings);
    procedure DeleteMapLine(aMapLine: string);
    procedure ClearMapLine(aMapLine: string);
    procedure SortBySize;
    property Mapper: TcrpKeyValueMapper read FMapper write FMapper;
    property MapStrList: TStrings read GetMapStrList;
    property OnLoadNew: TKeyValueLoadEvent read FOnLoadNew write FOnLoadNew;
    constructor Create(aKeyValueClass: TKeyValueClass);
    destructor Destroy; override;
  end;

{______________________________________________________________________________}
  TcrpRawLoader = class(TObject)
  private
    FRawFN: string;
    FKVLoader: TcrpKeyValueLoader;
    FStream: TStringStream;
    FStreamClass: TStreamClass;
    FStrings: TStrings;
    FExportFN: string;
  public
    Constructor Create(aStreamClass: TStreamClass; aKeyValueClass: TKeyValueClass);
    Destructor Destroy; override;
    procedure LoadRawFile;
    procedure SaveRawFile;
    property KeyValueLoader: TcrpKeyValueLoader read FKVLoader write FKVLoader;
    property RawFile: string read FRawFN write FRawFN;
    property Strings: TStrings read FStrings;
    property Stream: TStringStream read FStream;
    property ExportFileName: string read FExportFN write FExportFN;
  end;


{______________________________________________________________________________}
  TcrpKeyValueFinder = class(Tobject)
  private
    FCharsNeeded: boolean;
    FValue: string;
    FKey: string;
    procedure SetKey(const Value: string);
    procedure SetValue(const Value: string);
  public
    function MatchFound: boolean;
    function CharsNeeded: boolean;
    property Key: string read FKey write SetKey;
    property Value: string read FValue write SetValue;
    procedure AddValue(aValue: string);
    procedure Reset;
  end;

{______________________________________________________________________________}
  TcrpTranslator = class(TObject)
{Note this has no way to save values...other than stream and  TStrings}
  private
    FBaseRaw: TcrpRawLoader;
    FExportRaw: TcrpRawLoader;
    FMapBaseFN: string;
    FMapExportFN: string;
    FRaiseIfExist: boolean;
    FMergedMapper: TcrpKeyValueMapper;
    FFinder: TcrpKeyValueFinder;
    FStrings: TStrings;
    FRule: string;
    FSection: string;
    FExportFN: string;
    function GetStream: TStream;
    function GetStrings: TStrings;
    procedure SetMapBaseFN(const Value: string);
    procedure SetMapExportFN(const Value: string);
  protected
    procedure SetExportFN(const Value: string);
    function GetNotSetValues: string; virtual;
    function CanTranslate: boolean; virtual;
    function IsRule(aValue: string): boolean;
    procedure MergeMapFiles;
    procedure TranslateStream;
    property BaseRaw: TcrpRawLoader read FBaseRaw write FBaseRaw;
    property ExportRaw: TcrpRawLoader read FExportRaw write FExportRaw;
    property Rule: string read FRule write FRule;
  public
    constructor Create(aKeyValueClass: TKeyValueClass);
    destructor Destroy; override;
    procedure Translate; virtual;
    property Section: string read FSection write FSection;
    property Stream: TStream read GetStream;
    property Strings: TStrings read GetStrings;
    property MapFileBase: string read FMapBaseFN write SetMapBaseFN;
    property MapFileExport: string read FMapExportFN write SetMapExportFN;
    property ExportFileName: string read FExportFN write SetExportFN;
    property RaiseIfExist: boolean read FRaiseIfExist write FRaiseIfExist;
  end;


implementation

uses
  IniFiles, Math;

function CompareSize(List: TStringList;Index1, Index2: integer): Integer;
begin
{a value less than 0 if the string identified by Index1 comes before the string identified by Index2
	0 if the two strings are equivalent
	a value greater than 0 if the string with Index1 comes after the string identified by Index2.}
  Result := 0;
  if length(List[Index1]) = length(List[Index2]) then
    Result := 0
  else if length(List[Index1]) < length(List[Index2]) then
    Result := 1
  else if length(List[Index1]) > length(List[Index2]) then
    Result := -1;
end;  

{ TcrpMapData }
{______________________________________________________________________________}

constructor TcrpKeyValueData.Create;
begin
  inherited Create;
end;
{ TcrpMapper }
{______________________________________________________________________________}

constructor TcrpKeyValueMapper.Create(aKeyValueClass: TKeyValueClass);
begin
  inherited Create;
  FList :=  TList.Create;
  if Assigned(aKeyValueClass) then
    FBaseClass := aKeyValueClass
  else
    FBaseClass := TcrpKeyValueData;
end;

destructor TcrpKeyValueMapper.Destroy;
var
  a_Index: integer;
begin
  for a_Index := 0 to FList.Count -1 do
    TcrpKeyValueData(FList.Items[a_Index]).Free;
  FList.Free;
  inherited;
end;

function TcrpKeyValueMapper.AddKey(aKey: Variant): TcrpKeyValueData;
begin
  Result := GetKey(aKey);
  if not Assigned(Result) then
  begin
    Result := FBaseClass.Create;
    Result.Key := aKey;
    FList.Add(Result);
  end;
end;

function TcrpKeyValueMapper.AddKeyAndValue(aKey, aValue: Variant): TcrpKeyValueData;
begin
  Result := AddKey(aKey);
  if Assigned(Result) then
    Result.Value := aValue;
end;

procedure TcrpKeyValueMapper.DeleteKey(aKey: Variant);
var
  a_Index: integer;
  a_DeleteNode: TcrpKeyValueData;
begin
  for a_Index := 0 to FList.Count -1 do
  begin
    if (TcrpKeyValueData(FList.Items[a_Index]).Key = aKey) then
    begin
      a_DeleteNode := TcrpKeyValueData(FList.Items[a_Index]);
      a_DeleteNode.Free;
      FList.Delete(a_Index);
      Exit;
    end;
  end;
end;

procedure TcrpKeyValueMapper.DeleteValue(aValue: Variant);
var
  a_Index: integer;
  a_DeleteNode: TcrpKeyValueData;
begin
  for a_Index := 0 to FList.Count -1 do
  begin
    if (TcrpKeyValueData(FList.Items[a_Index]).Value = aValue) then
    begin
      a_DeleteNode := TcrpKeyValueData(FList.Items[a_Index]);
      a_DeleteNode.Free;
      FList.Delete(a_Index);
      Exit;
    end;
  end;
end;

function TcrpKeyValueMapper.Finished: Boolean;
begin
  Result :=  FIndex >= FList.Count;
end;

function TcrpKeyValueMapper.FirstKey: TcrpKeyValueData;
begin
  FIndex := 0;
  Result := TcrpKeyValueData(FList.Items[FIndex]);
end;

function TcrpKeyValueMapper.GetData(aIsKey: boolean; aData: Variant): TcrpKeyValueData;
var
  a_Index: integer;
  a_Data: string;
begin
  Result := nil;
  for a_Index := 0 to FList.Count -1 do
  begin
    a_Data := aData;
    if (aIsKey and  (TcrpKeyValueData(FList.Items[a_Index]).Key = a_Data)) or
       (not aIsKey and (TcrpKeyValueData(FList.Items[a_Index]).Value = a_Data)) then
    begin
      Result := TcrpKeyValueData(FList.Items[a_Index]);
      Exit;
    end;
  end;
end;

function TcrpKeyValueMapper.GetKey(aKey: Variant): TcrpKeyValueData;
begin
  Result := GetData(True, aKey);
end;

function TcrpKeyValueMapper.GetValue(aValue: Variant): TcrpKeyValueData;
begin
  Result := GetData(False, aValue);
end;

function TcrpKeyValueMapper.MatchKey(aKey, aValue: Variant): boolean;
var
  a_Map: TcrpKeyValueData;
begin
   Result := False;
   a_Map := GetKey(aKey);
   if Assigned(a_Map) then
   begin
     a_Map.Value := aValue;
     Result := True;
   end;
end;

function TcrpKeyValueMapper.NextKey: TcrpKeyValueData;
begin
  Result := nil;
  Inc(FIndex);
  if not Finished then
    Result := TcrpKeyValueData(FList.Items[FIndex]);
end;

function TcrpKeyValueMapper.GetCount: integer;
begin
  Result := FList.Count;
end;


{ TcrpKeyValueLoader }
{______________________________________________________________________________}

constructor TcrpKeyValueLoader.Create(aKeyValueClass: TKeyValueClass);
begin
  inherited Create;
  FMapSList := TStringList.Create;
  FMapper := TcrpKeyValueMapper.Create(aKeyValueClass);
end;

destructor TcrpKeyValueLoader.Destroy;
begin
  FMapSList.Free;
  FMapper.Free;
  inherited;
end;


procedure TcrpKeyValueLoader.ClearMapLine(aMapLine: string);
var
  a_Index: integer;
begin
  a_Index := GetIndexOfMap(aMapLine);
  if a_Index <> -1 then
    FMapSList.ValueFromIndex[a_Index] := '';
end;


procedure TcrpKeyValueLoader.DeleteMapLine(aMapLine: string);
var
  a_Index: integer;
begin
  a_Index := GetIndexOfMap(aMapLine);
  if a_Index <> -1 then
    FMapSList.Delete(a_Index);
end;

procedure TcrpKeyValueLoader.ExportTo(aFileName: TFileName; aSection: string);
var
  a_Index: integer;
  a_MapFile, a_ExportFile: TIniFile;
begin
{temp need to assign Section Name to cSecMain}
  a_MapFile := TIniFile.Create(LoadFileName);
  a_ExportFile := TIniFile.Create(aFileName);
  try
    a_MapFile.ReadSectionValues(aSection, FMapSList);
    for a_Index := 0 to FMapSList.Count -1 do
      a_ExportFile.WriteString(aSection, FMapSList.Names[a_Index] , '');
  finally
    a_MapFile.Free;
    a_ExportFile.Free;
  end;
end;

function TcrpKeyValueLoader.GetIndexOfMap(aMapLine: string): integer;
begin
  Result := FMapSList.IndexOfName(aMapLine);
  if Result = -1 then
    Result := FMapSList.IndexOf(aMapLine);
end;

function TcrpKeyValueLoader.GetMapStrList: TStrings;
begin
  Result := FMapSList;
end;

procedure TcrpKeyValueLoader.LoadFile(aFileName: TFileName; aSection: string);
var
  a_MapFile: TIniFile;
  a_MapList: TStrings;
begin
  if aFileName <> '' then
  begin
    FMapSList.Clear;
    a_MapList := FMapSList;
    a_MapFile := TIniFile.Create(aFileName);
    try
      if Assigned(FOnLoadNew) then
        FOnLoadNew(self, aSection, a_MapList);
      if Assigned(a_MapFile) and Assigned(a_MapList) then
        a_MapFile.ReadSectionValues(aSection, a_MapList);
      if a_MapList.Count = 0 then
        Raise EKeyValueLoaderCnt.Create(aFileName + ' Map has no values');
      if FMapSList <> a_MapList then
        FMapSList.Assign(a_MapList);
      LoadMapper;
    finally
      a_MapFile.Free;
    end;
  end else
    Raise EKeyValueLoader.Create('Mapper is not assigned.');
end;


procedure TcrpKeyValueLoader.LoadNewFile(aFileName: TFileName; aSection: string);
begin
  Self.LoadFileName := aFileName;
  LoadFile(aFileName, aSection);
end;
{
procedure TcrpKeyValueLoader.LoadOptions(aFileName: TFileName);
begin
  LoadFile(aFileName, cSecOptions);
end;
}
procedure TcrpKeyValueLoader.LoadMapper;
var
  a_Index: integer;
begin
  for a_Index := 0 to FMapSList.Count -1 do
    FMapper.AddKeyAndValue(FMapSList.Names[a_Index], FMapSList.ValueFromIndex[a_Index]);
end;

procedure TcrpKeyValueLoader.SaveFile(aFileName: TFileName; aMapList: TStrings;
  aSection: string);
var
  a_Index: integer;
  a_MapFile: TIniFile;
begin
  a_MapFile := TIniFile.Create(aFileName);
  try
    a_MapFile.EraseSection(aSection);
    for a_Index := 0 to aMapList.Count -1 do
      a_MapFile.WriteString(aSection, aMapList.Names[a_Index], aMapList.ValueFromIndex[a_Index]);
    a_MapFile.UpdateFile;
  finally
    a_MapFile.Free;
  end;
end;

procedure TcrpKeyValueLoader.SaveToFile(aFileName: TFileName; aMapList: TStrings; aSection: string);
begin
  SaveFile(aFileName, aMapList, aSection);
end;
{
procedure TcrpKeyValueLoader.SaveOption(aFileName: TFileName;
  aMapList: TStrings);
begin
  SaveFile(aFileName, aMapList, cSecOptions);
end;
}
procedure TcrpKeyValueLoader.SortBySize;
begin
  TStringList(FMapSList).CustomSort(@CompareSize);
end;


{ TcrpRawLoader }
{______________________________________________________________________________}
constructor TcrpRawLoader.Create(aStreamClass: TStreamClass; aKeyValueClass: TKeyValueClass);
begin
  inherited Create;
  FStreamClass := aStreamClass;
  FKVLoader := TcrpKeyValueLoader.Create(aKeyValueClass);
  FStrings := TStringList.Create;
end;

destructor TcrpRawLoader.Destroy;
begin
  if Assigned(FStream) then
    FStream.Free;
  FKVLoader.Free;
  FStrings.Free;
  inherited;
end;

procedure TcrpRawLoader.LoadRawFile;
var
  a_TmpStream: TStream;
begin
  if Assigned(FStream) then
    FStream.Free;
    if ExportFileName = '' then
    begin
      FStream := TStringStream.Create('');
      FStrings.SaveToStream(FStream);
    end
    else
    begin
      a_TmpStream := TFileStream.Create(RawFile, fmOpenRead);
      try
        FStream := TStringStream.Create('');
        FStream.CopyFrom(a_TmpStream, a_TmpStream.Size);
      finally
        a_TmpStream.Free;
      end;
    end;
end;

procedure TcrpRawLoader.SaveRawFile;
var
  a_TmpStream: TStream;
begin
  a_TmpStream := TFileStream.Create(RawFile, fmCreate);
  try
    a_TmpStream.CopyFrom(FStream, FStream.Size);
  finally
    a_TmpStream.Free;
  end;
end;

{ TcrpKeyValueFinder }
{______________________________________________________________________________}

procedure TcrpKeyValueFinder.AddValue(aValue: string);
begin
  FValue := FValue + aValue;
end;

function TcrpKeyValueFinder.CharsNeeded: boolean;
begin
 Result := (POS(FValue, FKey)> 0) or FCharsNeeded;
  if Result then
    FCharsNeeded := True;
end;

function TcrpKeyValueFinder.MatchFound: boolean;
begin
  Result := CompareStr(FValue, FKey) = 0;
  if Result then
    FCharsNeeded := False;
end;

procedure TcrpKeyValueFinder.Reset;
begin
  FCharsNeeded := False;
end;

procedure TcrpKeyValueFinder.SetKey(const Value: string);
begin
  FKey := Value;
end;

procedure TcrpKeyValueFinder.SetValue(const Value: string);
begin
  FValue := Value;
end;

{ TcrpTranslator }
{______________________________________________________________________________}

constructor TcrpTranslator.Create(aKeyValueClass: TKeyValueClass);
begin
  FMergedMapper := TcrpKeyValueMapper.Create(aKeyValueClass);
  FBaseRaw := TcrpRawLoader.Create(TStringStream, aKeyValueClass );
  FExportRaw := TcrpRawLoader.Create(TStringStream, aKeyValueClass);
  FFinder := TcrpKeyValueFinder.Create;
  FStrings := TStringList.Create;
end;

destructor TcrpTranslator.Destroy;
begin
  FMergedMapper.Free;
  FBaseRaw.Free;
  FExportRaw.Free;
  FFinder.Free;
  FStrings.Free;
  inherited;
end;

function TcrpTranslator.CanTranslate: boolean;
begin
  Result := (FMapBaseFN <> '') and (FMapExportFN <> '');
end;


function TcrpTranslator.GetNotSetValues: string;
begin
  Result := '';
  if FMapBaseFN = '' then
    Result := 'MapBase FileName not set'
  else if FMapExportFN = '' then
    Result := 'MapExport FileName not set'
  else if FExportFN = '' then
    Result := 'Map FileName not set';
end;

function TcrpTranslator.GetStream: TStream;
begin
  Result := FExportRaw.Stream;
end;

function TcrpTranslator.GetStrings: TStrings;
begin
  Result := FStrings;
end;

function TcrpTranslator.IsRule(aValue: string): boolean;
begin
//temp
  Result := False;
end;

procedure TcrpTranslator.MergeMapFiles;
var
  a_ExpCnt, a_BaseCnt: integer;
  a_Base, a_Export: TcrpKeyValueMapper;
  a_BaseData, a_ExportData: TcrpKeyValueData;
begin
  BaseRaw.KeyValueLoader.SortBySize;
  a_Base := BaseRaw.KeyValueLoader.Mapper;
  a_Export := ExportRaw.KeyValueLoader.Mapper;
  if Section = '' then
    ETranslator.Create('Section needs a value-Programmer error');
  BaseRaw.KeyValueLoader.LoadNewFile(BaseRaw.RawFile ,Section);
  ExportRaw.KeyValueLoader.LoadNewFile(ExportRaw.RawFile, Section);
  a_BaseCnt := a_Base.Count;
  a_ExpCnt := a_Export.Count;
  if (a_ExpCnt = 0) then
    Raise ETranslator.Create('Exporter does not have any values loaded');
  if  (a_BaseCnt = 0) then
    Raise ETranslator.Create('Importer does not have any values loaded');
  if a_ExpCnt <> a_BaseCnt then
    Raise ETranslator.Create('Importer/Exporter do not have the same size Map Files');
  a_BaseData := a_Base.FirstKey;
  a_ExportData := a_Export.FirstKey;
  While not a_Base.Finished do
  begin
    FMergedMapper.AddKeyAndValue(a_BaseData.Value, a_ExportData.Value);
    a_BaseData := a_Base.NextKey;
    a_ExportData := a_Export.NextKey;
  end;
end;

procedure TcrpTranslator.SetMapBaseFN(const Value: string);
begin
  FMapBaseFN := Value;
  BaseRaw.RawFile := Value;
end;

procedure TcrpTranslator.SetMapExportFN(const Value: string);
begin
  FMapExportFN := Value;
  ExportRaw.RawFile := Value;
end;

procedure TcrpTranslator.Translate;
begin
  if CanTranslate then
  begin
    FBaseRaw.Strings.Assign(FStrings);
    FBaseRaw.LoadRawFile;
    ExportRaw.LoadRawFile;
    MergeMapFiles;
    TranslateStream;
    FStrings.Clear;
    FExportRaw.Stream.Position := 1;
    FStrings.LoadFromStream(FExportRaw.Stream);
  end
  else
    Raise ETranslator.Create(GetNotSetValues);
end;

procedure TcrpTranslator.TranslateStream;
var
  a_Data: TcrpKeyValueData;
  //temp
  a_Value, a_Char: string;
  a_CharsNeeded, a_POS: integer;
begin
  a_Value := '';
  a_Char := '';
  a_POS := 0;
  a_CharsNeeded := 0;
  FFinder.Reset;
  if not Assigned(FBaseRaw.Stream) then
    ETranslator.Create('The Raw File has not been loaded')
  else
  begin
    FBaseRaw.Stream.Position := 0;
    FExportRaw.Stream.Position := 0;
    FExportRaw.Stream.WriteString(#10 + #13);
    While a_POS < FBaseRaw.Stream.Size do
    begin
      a_Char := FBaseRaw.Stream.ReadString(1);
      a_Value := a_Value + a_Char;
      FFinder.AddValue(a_Char);
      FFinder.Reset;
      a_Data := FMergedMapper.FirstKey;
      if Assigned(a_Data) then
      begin
        FFinder.Key := a_Data.Key;
      {loop through all the values...and if a Rule...we use that value}
        if IsRule(a_Value) then
        begin
          FExportRaw.Stream.WriteString(Rule);
        end else
        begin
          Repeat
      {once the key and value are placed in the finder...if match, ValueCharsNeeded
       will return a number...we will advance the stream by this number}
            if Assigned(a_Data) then
            begin
              {If a match...we use the Value}
              if FFinder.MatchFound then
              begin
                if a_Value <> '' then
                begin
                  FExportRaw.Stream.WriteString(a_Data.Value);
                  a_Value := '';
                  FFinder.Value := '';
                  break;
                end;
              end;
              if FFinder.CharsNeeded then
                break;
            end;
            a_Data := FMergedMapper.NextKey;
            if Assigned(a_Data) then
              FFinder.Key := a_Data.Key;
          until FMergedMapper.Finished;
        end;
      end;
  {If no matches found for all the keys...then we just use the current char...}
      if not(FFinder.CharsNeeded) then
      begin
        if FFinder.Value <> '' then
        begin
          FExportRaw.Stream.WriteString(FFinder.Value[1]);
          a_Value := '';
          FFinder.Value := '';
        end;
      end;
      a_POS := FBaseRaw.Stream.Position;
    end;
  end;
end;

procedure TcrpTranslator.SetExportFN(const Value: string);
begin
  if RaiseIfExist and FileExists(Value) then
    Raise ETranslator.Create('File already exist');
  FExportFN := Value;
end;

end.
