@MirrorsUsed(
    targets: const [
      PropertyGetter,
      PropertySetter,
      EditableProperty,
    ],
    override: '*')
import 'dart:mirrors';

typedef T PropertyGetter<T>();
typedef T PropertySetter<T>(T value);

class EditableProperty<T>{

  Type type;

  PropertyGetter _getter;
  PropertySetter _setter;

  PropertyGetter get getter => _getter;
  PropertySetter get setter => _setter;

  EditableProperty(this.type, this._getter, this._setter);
}