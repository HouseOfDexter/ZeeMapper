unit crpBase;
{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }

interface

uses
  Classes, SysUtils, IniFiles, crpZeeMapperDefault, crpFileUtility, crpKeyValue;

type


  TcrpMapFileUtility = class(TcrpFileUtility)
    class function FullMapName(aDirectory: string; aFileName: string): string;  
  end;

{______________________________________________________________________________}
  TcrpKVRuleData = class(TcrpKeyValueData)
  private
    FRule: variant;  
  public
    property Rule: variant read FRule write FRule;
  end;

implementation



class function TcrpMapFileUtility.FullMapName(aDirectory: string; aFileName: string): string;
begin
  Result := FullFileName(FullDirectory(aDirectory), aFileName, cDefaultExt)
end;




end.
