typedef T PropertyGetter<T>();
typedef T PropertySetter<T>(T value);

class EditableProperty<T>{

  Type get type => T;

  PropertyGetter _getter;
  PropertySetter _setter;

  PropertyGetter get getter => _getter;
  PropertySetter get setter => _setter;

  EditableProperty(this._getter, this._setter);
}