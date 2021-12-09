unit Storage.Preferences;

interface

uses
  System.Classes, System.SysUtils, System.Rtti, System.TypInfo,
  Storage.Preferences.Intf, System.Generics.Collections;

type
  TStoragePreferenceDataManagement = class(TInterfacedObject, IStoragePreferencesDataManagement)
  protected
    function ProcessRTTIPropertyParemeterHierarchy(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; CallbackRttiProperty: TProc<TRttiProperty>): string;
  end;

  TStoragePreferencesReader = class(TStoragePreferenceDataManagement, IStoragePreferencesReader)
  public
    function AsString(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: string): string; virtual; abstract;
    function AsInteger(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Integer): Integer; virtual; abstract;
    function AsInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Int64): Int64; virtual; abstract;
    function AsUInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: UInt64): UInt64; virtual; abstract;
    function AsBoolean(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Boolean): Boolean; virtual; abstract;
    function AsExtended(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Extended): Extended; virtual; abstract;
    function AsCurrency(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Currency): Currency; virtual; abstract;
    function AsVariant(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Variant): Variant; virtual; abstract;
    function AsDateTime(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: TDateTime): TDateTime; virtual; abstract;
  end;

  TStoragePreferencesWriter = class(TStoragePreferenceDataManagement, IStoragePreferencesWriter)
    function AsString(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: string): Boolean; virtual; abstract;
    function AsInteger(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Integer): Boolean; virtual; abstract;
    function AsInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Int64): Boolean; virtual; abstract;
    function AsUInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: UInt64): Boolean; virtual; abstract;
    function AsBoolean(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Boolean): Boolean; virtual; abstract;
    function AsExtended(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Extended): Boolean; virtual; abstract;
    function AsCurrency(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Currency): Boolean; virtual; abstract;
    function AsVariant(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Variant): Boolean; virtual; abstract;
    function AsDateTime(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: TDateTime): Boolean; virtual; abstract;
  end;

  TStoragePreferencesReadWriteAdapter = class(TInterfacedObject, IStoragePreferencesReadWriteAdapter)
  private
    FReader: IStoragePreferencesReader;
    FWriter: IStoragePreferencesWriter;
  protected
    function GetReader: IStoragePreferencesReader;
    function GetWriter: IStoragePreferencesWriter;
  public
    constructor Create(AReader: IStoragePreferencesReader; AWriter: IStoragePreferencesWriter); virtual;
  end;

  TStoragePreferences<T: IStoragePreferencesReadWriteAdapter> = class(TInterfacedObject, IStoragePreferences<T>)
  private
    type
      TRenderMode = (rmRead, rmWrite, rmDefault, rmAutoCreate, rmAutoFree);
  private
    FReaderWriter: T;
  private
    procedure SetReaderWriter(AValue: T);
    function GetReaderWriter: T;
  private
    function IsPreference(const Attributes: TArray<TCustomAttribute>): Boolean;
    function IsAutoCreate(const Attributes: TArray<TCustomAttribute>): Boolean;
    function GetDefault<T2>(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>): T2; overload;
    function GetDefault(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>): TValue; overload;
    function GetValue<T2>(RttiProperty: TRttiProperty; Instance: TObject): T2;
    function GetTypeInfo(RttiProperty: TRttiProperty): PTypeInfo;
    function IsString(RttiProperty: TRttiProperty): Boolean;
    function IsInteger(RttiProperty: TRttiProperty): Boolean;
    function IsInt64(RttiProperty: TRttiProperty): Boolean;
    function IsDecimal(RttiProperty: TRttiProperty): Boolean;
    function IsDateTime(RttiProperty: TRttiProperty): Boolean;
    function IsCurrency(RttiProperty: TRttiProperty): Boolean;
    function IsBoolean(RttiProperty: TRttiProperty): Boolean;
  protected
    procedure Render(Instance: TObject; RenderMode: TRenderMode; InstanceRttiPropertyStack: TArray<TRttiProperty>);
    procedure AfterLoad; virtual;
    procedure BeforeSave; virtual;
  public
    constructor Create(ReadWriter: T); virtual;
    procedure AfterConstruction; override;
    destructor Destroy; override;
    procedure Save;
    procedure Load;
  public
    property ReaderWriter: T read GetReaderWriter write SetReaderWriter;
  end;

implementation

uses
  Storage.Preferences.Attributes, ArrayHelper;

{ TStoragePreferences<T> }

procedure TStoragePreferences<T>.AfterConstruction;
begin
  inherited;
  Render(Self, rmDefault, nil);
end;

procedure TStoragePreferences<T>.BeforeSave;
begin

end;

constructor TStoragePreferences<T>.Create(ReadWriter: T);
begin
  FReaderWriter := ReadWriter;
  Render(Self, rmAutoCreate, nil);
end;

destructor TStoragePreferences<T>.Destroy;
begin
  Render(Self, rmAutoFree, nil);
  inherited;
end;

function TStoragePreferences<T>.GetDefault(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>): TValue;
begin
  Result := TValue.Empty;
  if Length(InstanceRttiPropertyStack) > 0 then
  begin
    var ParentRttiProperty := InstanceRttiPropertyStack[High(InstanceRttiPropertyStack)];
    var Attributes := ParentRttiProperty.GetAttributes;
    for var Attribute in Attributes do
    begin
      if (Attribute is TCustomPreferenceValueAttr) then
      begin
        var Attr := (Attribute as TCustomPreferenceValueAttr);
        if SameText(Attr.Name, RttiProperty.Name) then
          Exit(Attr.Value);
      end;
    end;
  end;

  var Attributes := RttiProperty.GetAttributes;
  for var Attr in Attributes do
  begin
    if (Attr is TCustomPreferenceValueAttr) then
      Exit((Attr as TCustomPreferenceValueAttr).Value);
  end;
end;

function TStoragePreferences<T>.GetDefault<T2>(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>): T2;
begin
  FillChar(Result, SizeOf(T2), 0);
  var Val := GetDefault(RttiProperty, InstanceRttiPropertyStack);
  if not Val.IsEmpty then
    Result := Val.AsType<T2>;
end;

function TStoragePreferences<T>.GetReaderWriter: T;
begin
  Result := FReaderWriter;
end;

function TStoragePreferences<T>.GetTypeInfo(RttiProperty: TRttiProperty): PTypeInfo;
begin
  Result := RttiProperty.PropertyType.Handle;
end;

function TStoragePreferences<T>.GetValue<T2>(RttiProperty: TRttiProperty; Instance: TObject): T2;
begin
  Result := RttiProperty.GetValue(Instance).AsType<T2>;
end;

function TStoragePreferences<T>.IsAutoCreate(const Attributes: TArray<TCustomAttribute>): Boolean;
begin
  Result := False;
  for var Attr in Attributes do
  begin
    if Attr is TAutoCreate then
      if (Attr as TAutoCreate).Value then
        Exit(True);
  end;
end;

function TStoragePreferences<T>.IsBoolean(RttiProperty: TRttiProperty): Boolean;
begin
  var TI := GetTypeInfo(RttiProperty);
  Result := (TI = TypeInfo(Boolean));
end;

function TStoragePreferences<T>.IsCurrency(RttiProperty: TRttiProperty): Boolean;
begin
  var TI := GetTypeInfo(RttiProperty);
  Result := (TI = TypeInfo(Currency));
end;

function TStoragePreferences<T>.IsDateTime(RttiProperty: TRttiProperty): Boolean;
begin
  var TI := GetTypeInfo(RttiProperty);
  Result := (TI = TypeInfo(TDateTime)) or (TI = TypeInfo(TDate)) or (TI = TypeInfo(TTime));
end;

function TStoragePreferences<T>.IsDecimal(RttiProperty: TRttiProperty): Boolean;
begin
  var TI := GetTypeInfo(RttiProperty);
  Result := (TI = TypeInfo(Double)) or (TI = TypeInfo(Single)) or
    (TI = TypeInfo(Extended));

  if not Result then
  begin
    if (TI = TypeInfo(TDateTime)) or (TI = TypeInfo(TDate)) or (TI = TypeInfo(TTime)) then
      Exit;
    var Kind := RttiProperty.PropertyType.TypeKind;
    Result := Kind in [tkFloat];
  end;
end;

function TStoragePreferences<T>.IsInt64(RttiProperty: TRttiProperty): Boolean;
begin
  var TI := GetTypeInfo(RttiProperty);
  Result := (TI = TypeInfo(Int64)) or (TI = TypeInfo(UInt64)) or
    ((SizeOf(NativeInt) = 8) and (TI = TypeInfo(NativeInt))) or
    ((SizeOf(NativeUInt) = 8) and (TI = TypeInfo(NativeUInt)));

  if not Result then
  begin
    var Kind := RttiProperty.PropertyType.TypeKind;
    Result := Kind in [tkInt64];
  end;
end;

function TStoragePreferences<T>.IsInteger(RttiProperty: TRttiProperty): Boolean;
begin
  var TI := GetTypeInfo(RttiProperty);
  Result := (TI = TypeInfo(Integer)) or (TI = TypeInfo(Boolean)) or
    ((SizeOf(NativeInt) = 4) and (TI = TypeInfo(NativeInt))) or
    ((SizeOf(NativeUInt) = 4) and (TI = TypeInfo(NativeUInt))) or
    (TI = TypeInfo(Word)) or (TI = TypeInfo(Byte)) or
    (TI = TypeInfo(SmallInt)) or (TI = TypeInfo(ShortInt)) or (TI = TypeInfo(Cardinal));

  if not Result then
  begin
    var Kind := RttiProperty.PropertyType.TypeKind;
    Result := Kind in [tkInteger, tkEnumeration, tkSet];
  end;
end;

function TStoragePreferences<T>.IsPreference(const Attributes: TArray<TCustomAttribute>): Boolean;
begin
  Result := True;
  for var Attr in Attributes do
  begin
    if Attr is TPreference then
      Exit((Attr as TPreference).Value);
  end;
end;

function TStoragePreferences<T>.IsString(RttiProperty: TRttiProperty): Boolean;
begin
  var TI := GetTypeInfo(RttiProperty);
  Result := (TI = TypeInfo(string)) or (TI = TypeInfo(AnsiString)) or
    (TI = TypeInfo(Char)) or (TI = TypeInfo(AnsiChar)) or
    (TI = TypeInfo(WideString)) or (TI = TypeInfo(ShortString));

  if not Result then
  begin
    var Kind := RttiProperty.PropertyType.TypeKind;
    Result := Kind in [tkUString, tkString, tkLString,
      tkLString, tkWString, tkWideString, tkWChar, tkChar];
  end;
end;

procedure TStoragePreferences<T>.SetReaderWriter(AValue: T);
begin
  FReaderWriter := AValue;
end;

procedure TStoragePreferences<T>.Load;
begin
  Render(Self, rmRead, nil);
  AfterLoad;
end;

procedure TStoragePreferences<T>.AfterLoad;
begin

end;

procedure TStoragePreferences<T>.Render(Instance: TObject; RenderMode: TRenderMode; InstanceRttiPropertyStack: TArray<TRttiProperty>);
begin
  var IRPropertyStack: TArray<TRttiProperty> := nil;
  if Assigned(InstanceRttiPropertyStack) and (Length(InstanceRttiPropertyStack) > 0) then
    IRPropertyStack := InstanceRttiPropertyStack;

  var RttiContext := TRttiContext.Create;
  try
    var RttiType := RttiContext.GetType(Instance.ClassType);
    try
      for var Prop in RttiType.GetDeclaredProperties do
      begin
        if IsPreference(Prop.GetAttributes) then
        begin
          if Prop.PropertyType.IsInstance then
          begin
            if (RenderMode = rmAutoCreate) or (RenderMode = rmAutoFree) then
            begin
              if IsAutoCreate(Prop.GetAttributes) then
              begin
                var Methods := Prop.PropertyType.AsInstance.GetMethods;
                if Assigned(Methods) then
                begin
                  var Constructors: TArray<TRttiMethod> := nil;
                  var ToInvokeConstructor: TRttiMethod := nil;
                  TArray.ForEach<TRttiMethod>(Methods,
                    procedure(var Method: TRttiMethod; Index: Integer)
                    begin
                      if Method.IsConstructor then
                        TArray.Add<TRttiMethod>(Constructors, Method);
                    end);

                  TArray.ForEach<TRttiMethod>(Constructors,
                    function(var Method: TRttiMethod; Index: Integer): Boolean
                    begin
                      var Parameters := Method.GetParameters;
                      if not Assigned(Parameters) or (Length(Parameters) = 0) then
                      begin
                        ToInvokeConstructor := Method;
                        Result := False;
                      end
                      else
                        Result := True;
                    end);
                  if Assigned(ToInvokeConstructor) then
                  begin
                    if RenderMode = rmAutoCreate then
                    begin
                      Prop.SetValue(Instance, ToInvokeConstructor.Invoke(Prop.PropertyType.AsInstance.MetaclassType, []));
                    end
                    else
                    begin
                      TArray.Add<TRttiProperty>(IRPropertyStack, Prop);
                      Render(Prop.GetValue(Instance).AsType<TObject>, RenderMode, IRPropertyStack);

                      var Obj := Prop.GetValue(Instance).AsObject;
                      if Assigned(Obj) then
                        Obj.Free;
                      Prop.SetValue(Instance, TValue.From<Pointer>(nil));
                    end;
                  end;
                  Constructors := nil;
                end;
              end;
            end;

            if RenderMode <> rmAutoFree then
            begin
              TArray.Add<TRttiProperty>(IRPropertyStack, Prop);
              Render(Prop.GetValue(Instance).AsType<TObject>, RenderMode, IRPropertyStack);
              TArray.Delete<TRttiProperty>(IRPropertyStack, TArray.IndexOf<TRttiProperty>(IRPropertyStack, Prop));
            end;
          end
          else
          begin
            if RenderMode = rmRead then
            begin
              var Reader := FReaderWriter.GetReader;
              if Assigned(Reader) then
              begin
                var Value: TValue := TValue.Empty;
                if IsString(Prop) then
                begin
                  var DefaultValue := GetDefault<string>(Prop, IRPropertyStack);
                  Value := Reader.AsString(Prop, IRPropertyStack, DefaultValue);
                end
                else if IsBoolean(Prop) then
                  Value := Reader.AsBoolean(Prop, IRPropertyStack, GetDefault<Boolean>(Prop, IRPropertyStack))
                else if IsInteger(Prop) then
                  Value := Reader.AsInteger(Prop, IRPropertyStack, GetDefault<Integer>(Prop, IRPropertyStack))
                else if IsDateTime(Prop) then
                  Reader.AsDateTime(Prop, IRPropertyStack, GetDefault<TDateTime>(Prop, IRPropertyStack))
                else if IsDecimal(Prop) then
                  Reader.AsExtended(Prop, IRPropertyStack, GetDefault<Extended>(Prop, IRPropertyStack))
                else if IsInt64(Prop) then
                  Reader.AsInt64(Prop, IRPropertyStack, GetDefault<Int64>(Prop, IRPropertyStack))
                else if IsCurrency(Prop) then
                  Reader.AsCurrency(Prop, IRPropertyStack, GetDefault<Currency>(Prop, IRPropertyStack));
                if not Value.IsEmpty then
                  Prop.SetValue(Instance, Value);
                Value := TValue.Empty;
              end;
            end
            else if RenderMode = rmWrite then
            begin
              var Writer := FReaderWriter.GetWriter;
              if Assigned(Writer) then
              begin
                if IsString(Prop) then
                  Writer.AsString(Prop, IRPropertyStack, GetValue<string>(Prop, Instance))
                else if IsBoolean(Prop) then
                  Writer.AsBoolean(Prop, IRPropertyStack, GetValue<Boolean>(Prop, Instance))
                else if IsInteger(Prop) then
                  Writer.AsInteger(Prop, IRPropertyStack, GetValue<Integer>(Prop, Instance))
                else if IsDateTime(Prop) then
                  Writer.AsDateTime(Prop, IRPropertyStack, GetValue<TDateTime>(Prop, Instance))
                else if IsDecimal(Prop) then
                  Writer.AsExtended(Prop, IRPropertyStack, GetValue<Extended>(Prop, Instance))
                else if IsInt64(Prop) then
                  Writer.AsInt64(Prop, IRPropertyStack, GetValue<Int64>(Prop, Instance))
                else if IsCurrency(Prop) then
                  Writer.AsCurrency(Prop, IRPropertyStack, GetValue<Currency>(Prop, Instance));
              end;
            end
            else if RenderMode = rmDefault then
            begin
              Prop.SetValue(Instance, GetDefault(Prop, IRPropertyStack));
            end;
          end;
        end;
      end;
    finally
      RttiType.Free;
    end;
  finally
    RttiContext.Free;
  end;
end;

procedure TStoragePreferences<T>.Save;
begin
  Render(Self, rmWrite, nil);
end;

{ TStoragePreferencesReadWriteAdapter }

constructor TStoragePreferencesReadWriteAdapter.Create(AReader: IStoragePreferencesReader; AWriter: IStoragePreferencesWriter);
begin
  FReader := AReader;
  FWriter := AWriter;
end;

function TStoragePreferencesReadWriteAdapter.GetReader: IStoragePreferencesReader;
begin
  Result := FReader;
end;

function TStoragePreferencesReadWriteAdapter.GetWriter: IStoragePreferencesWriter;
begin
  Result := FWriter;
end;

{ TStoragePreferenceDataManagement }

function TStoragePreferenceDataManagement.ProcessRTTIPropertyParemeterHierarchy(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; CallbackRttiProperty: TProc<TRttiProperty>): string;
var
  Names: TArray<string>;
begin
  Result := '';
  if Assigned(RttiProperty) then
  begin
    TArray.ForEach<TRttiProperty>(InstanceRttiPropertyStack,
      procedure(var Value: TRttiProperty; Index: Integer)
      begin
        TArray.Add<string>(Names, Value.Name);
        if Assigned(CallbackRttiProperty) then
          CallbackRttiProperty(Value);
      end);

    if Assigned(CallbackRttiProperty) then
      CallbackRttiProperty(RttiProperty);

    TArray.Add<string>(Names, RttiProperty.Name);
    Result := string.Join('.', Names);
  end;
end;

end.

