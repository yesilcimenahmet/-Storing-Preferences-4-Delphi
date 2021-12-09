unit Storage.Preferences.Adaptor.Regedit;

interface

uses
  Winapi.Windows, System.Rtti, Storage.Preferences, Storage.Preferences.Intf,
  Registry.Management;

type
  TStoragePreferencesRegeditReader = class(TStoragePreferencesReader, IStoragePreferencesRegeditReader)
  private
    FRegistryManager: IRegistryManager;
  public
    function AsString(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: string): string; override;
    function AsInteger(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Integer): Integer; override;
    function AsInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Int64): Int64; override;
    function AsUInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: UInt64): UInt64; override;
    function AsBoolean(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Boolean): Boolean; override;
    function AsExtended(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Extended): Extended; override;
    function AsCurrency(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Currency): Currency; override;
    function AsVariant(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Variant): Variant; override;
    function AsDateTime(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: TDateTime): TDateTime; override;
    function AsType<T>(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: T): T;
  public
    constructor Create(RegistryManager: IRegistryManager);
    function Read<T>(Key: string; Default: T): T;
  end;

  TStoragePreferencesRegeditWriter = class(TStoragePreferencesWriter, IStoragePreferencesRegeditWriter)
  private
    FRegistryManager: IRegistryManager;
  public
    function AsString(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: string): Boolean; override;
    function AsInteger(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Integer): Boolean; override;
    function AsInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Int64): Boolean; override;
    function AsUInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: UInt64): Boolean; override;
    function AsBoolean(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Boolean): Boolean; override;
    function AsExtended(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Extended): Boolean; override;
    function AsCurrency(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Currency): Boolean; override;
    function AsVariant(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Variant): Boolean; override;
    function AsDateTime(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: TDateTime): Boolean; override;
    function AsType<T>(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: T): Boolean;
  public
    constructor Create(RegistryManager: IRegistryManager);
    function Write<T>(Key: string; Data: T): Boolean;
  end;

  TStoragePreferencesRegeditAdaptor = class(TStoragePreferencesReadWriteAdapter, IStoragePreferencesRegeditAdaptor)
  private
    FRegistryManager: TRegistryManager;
  public
    function GetReader: IStoragePreferencesRegeditReader;
    function GetWriter: IStoragePreferencesRegeditWriter;
  public
    constructor Create(HKey: HKEY; KeyPath: string; Access: Cardinal); reintroduce; virtual;
  end;

implementation

{ TStoragePreferencesRegeditAdaptor }

constructor TStoragePreferencesRegeditAdaptor.Create(HKey: HKey; KeyPath: string; Access: Cardinal);
begin
  FRegistryManager := TRegistryManager.Create(HKey, KeyPath, Access);
  inherited Create(TStoragePreferencesRegeditReader.Create(FRegistryManager),
TStoragePreferencesRegeditWriter.Create(FRegistryManager));
end;

function TStoragePreferencesRegeditAdaptor.GetReader: IStoragePreferencesRegeditReader;
begin
  Result := inherited GetReader as IStoragePreferencesRegeditReader;
end;

function TStoragePreferencesRegeditAdaptor.GetWriter: IStoragePreferencesRegeditWriter;
begin
  Result := inherited GetWriter as IStoragePreferencesRegeditWriter;
end;

{ TStoragePreferencesRegeditReader }

function TStoragePreferencesRegeditReader.AsBoolean(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Boolean): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<Boolean>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsCurrency(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Currency): Currency;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<Currency>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsDateTime(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: TDateTime): TDateTime;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<TDateTime>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsExtended(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Extended): Extended;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<Extended>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Int64): Int64;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<Int64>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsInteger(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Integer): Integer;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<Integer>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsString(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: string): string;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<string>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsType<T>(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: T): T;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<T>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsUInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: UInt64): UInt64;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<UInt64>(Key, Default);
end;

function TStoragePreferencesRegeditReader.AsVariant(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Variant): Variant;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Read<Variant>(Key, Default);
end;

constructor TStoragePreferencesRegeditReader.Create(RegistryManager: IRegistryManager);
begin
  FRegistryManager := RegistryManager;
end;

function TStoragePreferencesRegeditReader.Read<T>(Key: string; Default: T): T;
begin
  Result := (FRegistryManager as TRegistryManager).Read<T>(Key, Default);
end;

{ TStoragePreferencesRegeditWriter }

function TStoragePreferencesRegeditWriter.AsBoolean(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Boolean): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<Boolean>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsCurrency(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Currency): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<Currency>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsDateTime(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: TDateTime): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<TDateTime>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsExtended(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Extended): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<Extended>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Int64): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<Int64>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsInteger(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Integer): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<Integer>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsString(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: string): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<string>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsType<T>(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: T): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<T>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsUInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: UInt64): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<UInt64>(Key, Value);
end;

function TStoragePreferencesRegeditWriter.AsVariant(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Variant): Boolean;
var
  Key: string;
begin
  Key := ProcessRTTIPropertyParemeterHierarchy(RttiProperty, InstanceRttiPropertyStack, nil);
  Result := Write<Variant>(Key, Value);
end;

constructor TStoragePreferencesRegeditWriter.Create(RegistryManager: IRegistryManager);
begin
  FRegistryManager := RegistryManager;
end;

function TStoragePreferencesRegeditWriter.Write<T>(Key: string; Data: T): Boolean;
begin
  Result := (FRegistryManager as TRegistryManager).Write<T>(Key, Data);
end;

end.

