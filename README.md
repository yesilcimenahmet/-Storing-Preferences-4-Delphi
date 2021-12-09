# Storing-Preferences-4-Delphi
It provides class based storage. Supports storing nested classes and their properties.

<h3>Auto Creation & Destruction</h3>

It provides automatic creation and destruction of nested classes. 
For use  <i><b>[TAutoCreate(True)]</b></i> attribute.

<h4>Note</h4>
For automatic creation, at least one of the class's constructor methods must have no parameters. 
</br>Auto created objects are automatically destroyed.

<h3>Storage Adapters</h3>
Currently Regedit storage adapter is available. The planned storage adapters are Text and Binary.

<h3>Adapter Classes</h3>
  
Regedit: <i><code>TStoragePreferences< IStoragePreferencesRegeditAdaptor></code></i>

<h3>Usage</h3>
There are simply <b>Save</b> and <b>Read</b> methods. Fill the object, call the Save method to save it.
</br>You can set defaul values by giving attributes to classes.
</br>By default, every property within the class is included in the storage operation. Use the <i><code>[TPreference(False)]</code></i> attribute to ignore this.

<h3>Creating New Adapters</h3>

<i><code>TStoragePreferences<T: IStoragePreferencesReadWriteAdapter> = class(TInterfacedObject, IStoragePreferences<T>);</code><i>

Basically inherit the above class to create new adapters. Please review the codes for detailed information.
