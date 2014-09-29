unit crpFileUtility;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }
interface

uses
  SysUtils;

type

  TcrpFileUtility = class(TObject)
  public
    class function ExtractName(aFileName: string): string;
    class function FullDirectory(aDirectory: string): string;
    class function FullFileName(aDirectory: string; aFilename: string; aExtension: string): string;
    class function ExeDirectory(aExeName: string): string;
  end;

implementation

{ TcrpFileUtility }
{______________________________________________________________________________}


class function TcrpFileUtility.ExtractName(aFileName: string): string;
begin
  Result := ExtractFileName(aFileName);
  if Pos('.', Result) <> 0 then
     Result := Copy(Result, 1, POS('.', Result) -1);
end;

class function TcrpFileUtility.FullDirectory(aDirectory: string): string;
begin
  Result := IncludeTrailingPathDelimiter(aDirectory);
end;

class function TcrpFileUtility.FullFileName(aDirectory: string;
  aFilename: string; aExtension: string): string;
begin
  Result := FullDirectory(aDirectory) + aFileName + aExtension;
end;

class function TcrpFileUtility.ExeDirectory(aExeName: string): string;
begin
  Result := FullDirectory(ExtractFilePath(aExeName));
end;

end.
