import "package:test/test.dart";
import 'dart:mirrors';

void main() {
  test("...", () {
    TestObject testObj = new TestObject();

    Timeline timeline1 = new Timeline()
      ..keys = [
        new Keyframe()
          ..time = 0.0
          ..value = 5.0,
        new Keyframe()
          ..time = 2.0
          ..value = 10.0
      ];

    Timeline timeline2 = new Timeline()
      ..keys = [
        new Keyframe()
          ..time = 0.0
          ..value = 0.0,
        new Keyframe()
          ..time = 5.0
          ..value = 20.0
      ];

    testObj.x = 10.0;
    expect(testObj.x, equals(10.0));
    testObj.x = timeline1;
    expect(testObj.x, equals(timeline1));
    testObj.x = 5.0;
    expect(testObj.x, equals(5.0));

    testObj.count = 5;
    expect(testObj.count, equals(5));
    testObj.count = timeline2;
    expect(testObj.count, equals(timeline2));
  });

  test("Testing passing parameter", () {
    Keyframe k = new Keyframe()
      ..time = 0.0
      ..value = 5.0;
    Manager.setFieldValue(k, #value, 10.0);
    expect(k.value, equals(10.0));
  });
}

class TestObject {
  Map<Symbol, Timeline> animatables = new Map();

  num _x = 0.0;
  get x {
    return getAnimatableValue(#_x);
  }
  set x(value) {
    setAnimatableValue(#_x, value, 0.0);
  }

  int _count = 0;
  get count {
    return getAnimatableValue(#_count);
  }
  set count(value) {
    setAnimatableValue(#_count, value, 0);
  }

  dynamic getAnimatableValue(Symbol symbol){
    if (animatables[symbol] != null) {
      return animatables[symbol];
    } else {
      return Manager.getFieldValue(this, symbol);
    }
  }

  setAnimatableValue(Symbol symbol, value, defaultValue){
    InstanceMirror classInstanceMirror = reflect(this);
    if (value.runtimeType == classInstanceMirror.getField(symbol).reflectee.runtimeType) {
      Manager.setFieldValue(this, symbol, value);
      animatables[symbol] = null;
    } else if (value.runtimeType == Timeline) {
      Manager.setFieldValue(this, symbol, defaultValue);
      animatables[symbol] = value;
    } else {
      throw new FormatException('Value type is not accepted');
    }
  }
}
//class TestObject {
//  AnimatablePropertyNum x = new AnimatablePropertyNum();
//
//  AnimatablePropertyInt _count = new AnimatablePropertyInt();
//  AnimatablePropertyInt get count => _count;
//  Timeline get countBase => _count.timeline;
//  set count(value) {
//    if(value is int)_count.value = value;
//    if(value is Timeline)_count.timeline = value;
//    if(value is AnimatablePropertyInt)_count = value;
//  }
//}

class Keyframe {
  num value;
  num time;
}

class Timeline {
  List<Keyframe> keys = new List();
}

abstract class AbstractAnimatableProperty<T> {
  T value;
  Timeline timeline;
}

class Manager {
  static void setFieldValue(Object obj, Symbol symbol, value) {
    InstanceMirror classInstanceMirror = reflect(obj);
    classInstanceMirror.setField(symbol, value);
  }

  static dynamic getFieldValue(Object obj, Symbol symbol) {
    InstanceMirror classInstanceMirror = reflect(obj);
    InstanceMirror res = classInstanceMirror.getField(symbol);
    return res.reflectee;
  }
}
