unit Storage.Preferences.Intf;

interface

uses
  System.SysUtils, System.Rtti;

type
  IStoragePreferencesDataManagement = interface
    ['{8AA00308-E91D-4254-8E6D-D9698E0E8EC2}']
    function ProcessRTTIPropertyParemeterHierarchy(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; CallbackRttiProperty: TProc<TRttiProperty>): string;
  end;

  IStoragePreferencesReader = interface(IStoragePreferencesDataManagement)
    ['{13C6F840-2C2B-4203-895D-C8EC73DF12AD}']
    function AsString(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: string): string;
    function AsInteger(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Integer): Integer;
    function AsInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Int64): Int64;
    function AsUInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: UInt64): UInt64;
    function AsBoolean(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Boolean): Boolean;
    function AsExtended(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Extended): Extended;
    function AsCurrency(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Currency): Currency;
    function AsVariant(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: Variant): Variant;
    function AsDateTime(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Default: TDateTime): TDateTime;
  end;

  IStoragePreferencesWriter = interface(IStoragePreferencesDataManagement)
    ['{C6965C19-29CA-482D-B88F-DE0C3B2A9577}']
    function AsString(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: string): Boolean;
    function AsInteger(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Integer): Boolean;
    function AsInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Int64): Boolean;
    function AsUInt64(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: UInt64): Boolean;
    function AsBoolean(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Boolean): Boolean;
    function AsExtended(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Extended): Boolean;
    function AsCurrency(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Currency): Boolean;
    function AsVariant(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: Variant): Boolean;
    function AsDateTime(RttiProperty: TRttiProperty; InstanceRttiPropertyStack: TArray<TRttiProperty>; Value: TDateTime): Boolean;
  end;

  IStoragePreferencesRegeditReader = interface(IStoragePreferencesReader)
    ['{60121E46-D1B9-48BA-BF71-4593AF1E4E04}']
  end;

  IStoragePreferencesRegeditWriter = interface(IStoragePreferencesWriter)
    ['{3C0630B6-FFFF-4765-8840-9304F6240DDF}']
  end;

  IStoragePreferencesReadWriteAdapter = interface
    ['{1695EDA2-47E4-4D60-9CF6-25DD1EC1D434}']
    function GetReader: IStoragePreferencesReader;
    function GetWriter: IStoragePreferencesWriter;
  end;

  IStoragePreferencesRegeditAdaptor = interface(IStoragePreferencesReadWriteAdapter)
    ['{DE559AC7-0B70-4CFB-9AF0-2B18B1C04069}']
    function GetReader: IStoragePreferencesRegeditReader;
    function GetWriter: IStoragePreferencesRegeditWriter;
  end;

  IStoragePreferences<T> = interface
    ['{301C0989-5CFD-450D-A8EF-4641DABFCCF9}']
    procedure Save;
    procedure Load;
    procedure SetReaderWriter(AValue: T);
    function GetReaderWriter: T;
  end;

implementation

end.

