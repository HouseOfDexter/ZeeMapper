unit crpZeeMapperDefault;

{written by Charles Richard Peterson, 2007; You can reach me at
 www.houseofdexter.com or houseofdexter@gmail.com;  The code is released under
 Mozilla Public License 1.1 (MPL 1.1);   }

interface

uses
  SysUtils;

const
  cDefaultRule = 'Rule';
  cDefaultName = 'zeeMapper';
  cMapText = 'Map';
  cMapDelimiter = '-';
  cRuleDelimiter = '-';
  cRuleFldDelimiter = ',';
  cRuleAscii = '#';


  cDefaultExt = '.crp';
  cDefaultTxtExt = '.txt';
  cSecMain = 'Main';
  cSecOptions = 'Option';

  cDefaultTransLocKey = 'DefaultTransLoc';
  cDefaultSaveLocKey = 'DefaultSaveLoc';
  cDefaultExtKey = 'DefaultExt';
  cUseFileExtKey = 'FileExt';

//Rules
{if you add more Rules add to crpRule SetRuleIndex and }

  cRIgnoreSet = ['%'];
  cRIgnoreUntilSet = ['@'];
  cRIgnoreAfterSet = ['%'];
  cRApplyMultiSet = ['%', '^', '$'];
  cRApplyUntilSet = ['%','!', '@'];
  cRConvertSet= ['%', '!'];
  cRAsOneRuleSet = ['^'];

  cRIgnore =  'Ignore When %';
  cRIgnoreUntil = 'Ignore Until @';
  cRIgnoreAfter ='Ignore After When %';
  cRApplyMulti = 'When %, Apply ^ Times $';
  cRApplyUntil = 'When % Convert To ! Until @';
  cRConvert = 'When % Convert To !';
  cRAsOneRule = 'Combine Next ^ Rules as One';


    //Status State
  cStateLoading = 'Loading';
  cStateLoaded = 'Loaded';
  cStateSaving = 'Saving';
  cStateSaved = 'Saved';
  cStateDrag= 'Dragging';
  cStateDropped = 'Dropped';
  cStateImporting = 'Importing';
  cStateImported = 'Imported';
  cStateTranslating = 'Translating';
  cStateTranslated = 'Translated';
  cStateStarted = 'Started';
  cStateFinished = 'Finished';
  cStateExporting = 'Exporting';
  cStateExported = 'Exported';

  cStartDragError = 'You can not drag a Map that does not exist or is in a different branch!';
  cExportMapNotSel = 'Export Map not selected';
  cBaseMapNotSel = 'Base Map not selected';
  cDupeMapName = 'Duplicate Map Name';
  cSaveChange = 'Save Changes?';
  cRenameError = 'Unable to rename Map';




//error messages

implementation



end.
