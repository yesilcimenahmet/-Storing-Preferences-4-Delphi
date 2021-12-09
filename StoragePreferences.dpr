program StoragePreferences;

uses
  Vcl.Forms,
  Main in 'Main.pas' {FormMain},
  Storage.Preferences.Intf in 'library\Storage.Preferences.Intf.pas',
  Storage.Preferences in 'library\Storage.Preferences.pas',
  Registry.Management in 'library\Registry.Management.pas',
  Storage.Preferences.Adaptor.Regedit in 'library\Storage.Preferences.Adaptor.Regedit.pas',
  Storage.Preferences.Attributes in 'library\Storage.Preferences.Attributes.pas',
  App.Preferences in 'App.Preferences.pas',
  ArrayHelper in 'library\3rdParty\ArrayHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
