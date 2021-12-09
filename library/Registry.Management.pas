unit Registry.Management;

interface

uses
  Winapi.Windows, System.Win.Registry, System.Classes, System.SysUtils,
  System.Variants, System.Rtti, System.TypInfo;

type
  IRegistryManager = interface
    ['{16FE6910-84B3-49E9-A537-6450FE5B0808}']
  end;

  TRegistryManager = class(TInterfacedObject, IRegistryManager)
  private
    FReg: TRegistry;
    FKeyPath: string;
    FHKey: HKEY;
  protected
    function ReadKey<T>(Key: string; Default: T; CanCreate: Boolean = True): T;
    function WriteKey<T>(Key: string; Data: T; CanCreate: Boolean = True): Boolean;
  protected
    function CheckTypeKindIsString(TypeKind: TTypeKind): Boolean;
    function CheckTypeKindIsNumber(TypeKind: TTypeKind): Boolean;
    function CheckTypeInfoIsDecimal<T>: Boolean;
  public
    function Read<T>(Key: string; Default: T): T;
    function Write<T>(Key: string; Data: T): Boolean;
    property KeyPath: string read FKeyPath write FKeyPath;
    constructor Create(HKey: HKEY; KeyPath: string); overload;
    constructor Create(HKey: HKEY; KeyPath: string; Access: Cardinal); overload;
    destructor Destroy; override;
  end;

implementation

{ TRegistryManager }

constructor TRegistryManager.Create(HKey: HKey; KeyPath: string);
begin
  Create(HKey, KeyPath, KEY_READ or KEY_WRITE or KEY_WOW64_64KEY);
end;

function TRegistryManager.CheckTypeInfoIsDecimal<T>: Boolean;
begin
  var TI := TypeInfo(T);
  Result := (TI = TypeInfo(Single)) or (TI = TypeInfo(Double)) or (TI = TypeInfo(Extended));
end;

function TRegistryManager.CheckTypeKindIsNumber(TypeKind: TTypeKind): Boolean;
begin
  Result := TypeKind in [TTypeKind.tkInteger, TTypeKind.tkEnumeration, TTypeKind.tkInt64];
end;

function TRegistryManager.CheckTypeKindIsString(TypeKind: TTypeKind): Boolean;
begin
  Result := TypeKind in [TTypeKind.tkChar, TTypeKind.tkString, TTypeKind.tkWChar,
    TTypeKind.tkLString, TTypeKind.tkWString, TTypeKind.tkUString];
end;

constructor TRegistryManager.Create(HKey: HKey; KeyPath: string; Access: Cardinal);
begin
  FHKey := HKey;
  FKeyPath := KeyPath;
  FReg := TRegistry.Create(Access);
  FReg.RootKey := FHKey;
end;

destructor TRegistryManager.Destroy;
begin
  FReg.Free;
  inherited;
end;

function TRegistryManager.ReadKey<T>(Key: string; Default: T; CanCreate: Boolean): T;
begin
  try
    Result := Default;
    if (FReg <> Nil) and not FKeyPath.Trim.IsEmpty and not Key.Trim.IsEmpty then
    begin
      var Info: TRegDataInfo;
      FReg.OpenKey(FKeyPath, CanCreate);
      if FReg.GetDataInfo(Key, Info) then
      begin
        var DataType: DWORD := REG_NONE;

        var VarArr := VarArrayCreate([0, Info.DataSize], varByte);

        var PVarArr := VarArrayAsPSafeArray(VarArr);

        if RegQueryValueEx(FReg.CurrentKey, PChar(Key), nil, @DataType, @PVarArr^.Data^, @Info.DataSize) = ERROR_SUCCESS then
        begin
          var TypeKind := PTypeInfo(TypeInfo(T))^.Kind;
          if CheckTypeKindIsString(TypeKind) then
            Result := TValue.From<string>(string(PChar(PVarArr^.Data))).AsType<T>
          else
            Result := T(PVarArr^.Data^);
        end;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TRegistryManager.Write<T>(Key: string; Data: T): Boolean;
begin
  Result := WriteKey<T>(Key, Data);
end;

function TRegistryManager.WriteKey<T>(Key: string; Data: T; CanCreate: Boolean): Boolean;
const
  UNKNOWN_VAR_TYPE_INFORMATION = 'Unknown variable type information';
begin
  Result := False;
  if Assigned(FReg) then
  begin
    FReg.OpenKey(KeyPath, CanCreate);
    if FReg.KeyExists(KeyPath) then
    begin
      var TypeKind := GetTypeKind(T);
      var TI := TypeInfo(T);
      if CheckTypeKindIsString(TypeKind) then
        FReg.WriteString(Key, TValue.From<T>(Data).AsString)
      else if TI = TypeInfo(Boolean) then
        FReg.WriteBool(Key, TValue.From<T>(Data).AsBoolean)
      else if CheckTypeKindIsNumber(TypeKind) then
        FReg.WriteInteger(Key, TValue.From<T>(Data).AsInteger)
      else if CheckTypeInfoIsDecimal<T>then
        FReg.WriteFloat(Key, TValue.From<T>(Data).AsType<Double>)
      else if TI = TypeInfo(Currency) then
        FReg.WriteCurrency(Key, TValue.From<T>(Data).AsCurrency)
      else if TI = TypeInfo(TDateTime) then
        FReg.WriteDateTime(Key, TValue.From<T>(Data).AsType<TDateTime>)
      else if TI = TypeInfo(TDate) then
        FReg.WriteDate(Key, TValue.From<T>(Data).AsType<TDate>)
      else if TI = TypeInfo(TTime) then
        FReg.WriteTime(Key, TValue.From<T>(Data).AsType<TTime>)
      else
        raise Exception.Create(UNKNOWN_VAR_TYPE_INFORMATION);
      Result := True;
    end;
  end;
end;

function TRegistryManager.Read<T>(Key: string; Default: T): T;
begin
  Result := ReadKey<T>(Key, Default);
end;

end.

