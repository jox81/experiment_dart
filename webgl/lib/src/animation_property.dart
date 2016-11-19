typedef T AnimationSetter<T>(T value);
typedef T AnimationGetter<T>();

class AnimationProperty<T>{

  Type get type => T;

  AnimationGetter _getter;
  AnimationSetter _setter;

  AnimationGetter get getter => _getter;
  AnimationSetter get setter => _setter;

  AnimationProperty(this._getter, this._setter);
}