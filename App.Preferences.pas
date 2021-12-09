unit App.Preferences;

interface

uses
  Winapi.Windows, System.SysUtils, Storage.Preferences, Storage.Preferences.Intf,
  Storage.Preferences.Attributes, System.RTTI;

const
  REG_KEY_PATH = '\Software\myapp\';

type
  TAdvancedPreference = class
  private
    FStartWithWindows: Boolean;
    FShowMouse: Boolean;
    FAppendDateInfo2FileName: Boolean;
    FAppendTimeInfo2FileName: Boolean;
    FImageType2Upload: Integer;
    FJPEGQuality2Upload: Integer;
    FPDFSize: Integer;
    FPDFOrientation: Integer;
  public
    [TDefaultBoolean(True)]
    property StartWithWindows: Boolean read FStartWithWindows write FStartWithWindows;
    [TDefaultBoolean(True)]
    property ShowMouse: Boolean read FShowMouse write FShowMouse;
    [TDefaultBoolean(True)]
    property AppendDateInfo2FileName: Boolean read FAppendDateInfo2FileName write FAppendDateInfo2FileName;
    [TDefaultBoolean(True)]
    property AppendTimeInfo2FileName: Boolean read FAppendTimeInfo2FileName write FAppendTimeInfo2FileName;
    [TDefaultInteger(0)]
    property ImageType2Upload: Integer read FImageType2Upload write FImageType2Upload;
    [TDefaultInteger(75)]
    property JPEGQuality2Upload: Integer read FJPEGQuality2Upload write FJPEGQuality2Upload;
    [TDefaultInteger(5)]
    property PDFSize: Integer read FPDFSize write FPDFSize;
    [TDefaultInteger(0)]
    property PDFOrientation: Integer read FPDFOrientation write FPDFOrientation;
  end;

  TFileOperations = class
  private
    FAlwaysAskWhenSavingFile: Boolean;
    FDefaultSavePath: string;
    FDefaultFileExt: Integer;
  public
    [TDefaultBoolean(True)]
    property AlwaysAskWhenSavingFile: Boolean read FAlwaysAskWhenSavingFile write FAlwaysAskWhenSavingFile;
    [TDefaultString('C:\Directory')]
    property DefaultSavePath: string read FDefaultSavePath write FDefaultSavePath;
    [TDefaultInteger(1)]
    property DefaultFileExt: Integer read FDefaultFileExt write FDefaultFileExt;
  end;

  TGeneralPreference = class
  private
    FFileOperations: TFileOperations;
    FLanguage: string;
  public
    [TDefaultString('TR')]
    property Language: string read FLanguage write FLanguage;
    [TAutoCreate(True)]
    property FileOperations: TFileOperations read FFileOperations write FFileOperations;
  end;

  TApplicationRegeditPreferences = class(TStoragePreferences<IStoragePreferencesRegeditAdaptor>)
  private
    FGeneral: TGeneralPreference;
    FAdvanced: TAdvancedPreference;
  private
    procedure CheckConstraints;
  protected
    procedure AfterLoad; override;
    procedure BeforeSave; override;
  public
    [TAutoCreate(True)]
    property General: TGeneralPreference read FGeneral write FGeneral;
    [TAutoCreate(True)]
    property Advanced: TAdvancedPreference read FAdvanced write FAdvanced;
  public
    constructor Create; reintroduce; virtual;
  end;

implementation

uses
  Storage.Preferences.Adaptor.Regedit;

{ TApplicationRegeditPreferences }

procedure TApplicationRegeditPreferences.BeforeSave;
begin
  CheckConstraints;
end;

procedure TApplicationRegeditPreferences.CheckConstraints;
begin
  var JQ := Advanced.JPEGQuality2Upload;
  if (JQ < 40) or (JQ > 100) then
    Advanced.JPEGQuality2Upload := 75;

  var DF := General.FileOperations.DefaultFileExt;
  if not (DF in [0, 1, 2, 3, 4, 5, 6]) then
    General.FileOperations.DefaultFileExt := 1;

  var PS := Advanced.PDFSize;
  if (PS < 0) or (PS > 11) then
    Advanced.PDFSize := 5; //A4
  var PO := Advanced.PDFOrientation;
  if (PO < 0) or (PO > 2) then
    Advanced.PDFOrientation := 0; //Auto
end;

constructor TApplicationRegeditPreferences.Create;
begin
  inherited Create(TStoragePreferencesRegeditAdaptor.Create(HKEY_CURRENT_USER,
REG_KEY_PATH, KEY_READ or KEY_WRITE or KEY_WOW64_64KEY));
end;

procedure TApplicationRegeditPreferences.AfterLoad;
begin
  CheckConstraints;
end;

end.

