unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TFormMain = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure Add2Memo(const Str: string);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  App.Preferences, Storage.Preferences.Intf;

var
  Preferences: IStoragePreferences<IStoragePreferencesRegeditAdaptor>;

procedure InitializeRegeditPreferences;
begin
  Preferences := TApplicationRegeditPreferences.Create;
  Preferences.Load;
end;

function GetRegeditPreferences: TApplicationRegeditPreferences;
begin
  Result := (Preferences as TApplicationRegeditPreferences);
end;

procedure TFormMain.Add2Memo(const Str: string);
begin
  Memo1.Lines.Add(Str);
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
  with GetRegeditPreferences.General do
  begin
    Add2Memo(Format('%s: %s', ['Lang', Language]));
    Add2Memo(Format('%s: %s', ['Always Ask When Saving File', BoolToStr(FileOperations.AlwaysAskWhenSavingFile, True)]));
    Add2Memo(Format('%s: %s', ['Default Save Path', FileOperations.DefaultSavePath]));
  end;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  var Pref := GetRegeditPreferences;
  Pref.General.Language := 'EN';
  Pref.General.FileOperations.AlwaysAskWhenSavingFile := False;
  Pref.General.FileOperations.DefaultSavePath := 'D:\Directory';
  Pref.Save;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  InitializeRegeditPreferences;
end;

end.

