unit Storage.Preferences.Attributes;

interface

uses
  System.Rtti, Vcl.Dialogs;

type
  TCustomPreferenceAttr<T> = class(TCustomAttribute)
  private
    FValue: T;
  public
    constructor Create(const AValue: T);
    property Value: T read FValue write FValue;
  end;

  TCustomPreferenceValueAttr = class(TCustomAttribute)
  private
    FName: string;
    FValue: TValue;
  protected
    constructor Create(AName: string; AValue: TValue); virtual;
  public
    property Name: string read FName write FName;
    property Value: TValue read FValue write FValue;
    destructor Destroy; override;
  end;

  TPreference = class(TCustomPreferenceAttr<Boolean>);

  TAutoCreate = class(TCustomPreferenceAttr<Boolean>);

  TDefault<T> = class(TCustomPreferenceValueAttr)
  private
    function GetValue: T;
    procedure SetValue(AValue: T);
  protected
    constructor Create(AName: string; AValue: T); reintroduce; overload;
  public
    property Value: T read GetValue write SetValue;
    constructor Create(AValue: T); reintroduce; overload;
  end;

  TDefaultString = class(TDefault<string>);

  TDefaultAnsiString = class(TDefault<AnsiString>);

  TDefaultChar = class(TDefault<Char>);

  TDefaultAnsiChar = class(TDefault<AnsiChar>);

  TDefaultInteger = class(TDefault<Integer>);

  TDefaultCardinal = class(TDefault<Cardinal>);

  TDefaultInt64 = class(TDefault<Int64>);

  TDefaultUInt64 = class(TDefault<UInt64>);

  TDefaultNativeInt = class(TDefault<NativeInt>);

  TDefaultNativeUInt = class(TDefault<NativeUInt>);

  TDefaultFixedInt = class(TDefault<FixedInt>);

  TDefaultFixedUInt = class(TDefault<FixedUInt>);

  TDefaultWord = class(TDefault<Word>);

  TDefaultSmallInt = class(TDefault<SmallInt>);

  TDefaultByte = class(TDefault<Byte>);

  TDefaultShortInt = class(TDefault<ShortInt>);

  TDefaultBoolean = class(TDefault<Boolean>);

implementation

{ TCustomPreferenceAttr<T> }

constructor TCustomPreferenceAttr<T>.Create(const AValue: T);
begin
  FValue := AValue;
end;

{ TCustomPreferenceValueAttr }

constructor TCustomPreferenceValueAttr.Create(AName: string; AValue: TValue);
begin
  FName := AName;
  FValue := AValue;
end;

destructor TCustomPreferenceValueAttr.Destroy;
begin
  FValue := TValue.Empty;
  inherited;
end;

{ TDefault<T> }

constructor TDefault<T>.Create(AValue: T);
begin
  inherited Create('', TValue.From<T>(AValue));
end;

constructor TDefault<T>.Create(AName: string; AValue: T);
begin
  inherited Create(AName, TValue.From<T>(AValue));
end;

function TDefault<T>.GetValue: T;
begin
  Result := inherited Value.AsType<T>;
end;

procedure TDefault<T>.SetValue(AValue: T);
begin
  inherited Value := TValue.From<T>(AValue);
end;

end.

