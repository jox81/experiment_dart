import "package:test/test.dart";
import 'dart:mirrors';

void main() {
  test("...", () {
    AnimatablePropertyNum ap = new AnimatablePropertyNum();
    ap.value = 2.0;
    expect(ap, isNotNull);

    TestObject testObj = new TestObject();

    Timeline timeline1 = new Timeline()
      ..keys = [
        new Keyframe()..time = 0.0 ..value = 5.0,
        new Keyframe()..time = 2.0 ..value = 10.0
      ];

    Timeline timeline2 = new Timeline()
      ..keys = [
        new Keyframe()..time = 0.0 ..value = 0.0,
        new Keyframe()..time = 5.0 ..value = 20.0
      ];

    testObj.x.value = 10.0;
    testObj.x.timeline = timeline1;
    expect(testObj.x.value, equals(10.0));

    testObj.count = 5;
    expect(testObj.count.value, equals(5));
    testObj.count = timeline2;
    expect(testObj.count.timeline, equals(timeline2));
    //ok pour les setter facile
    //Quid des getter ?
  });

  test("Testing passing parameter", () {
    Keyframe k = new Keyframe()..time = 0.0 ..value = 5.0;
    Manager.setNumValue(k, #value, 10.0);
    expect(k.value, equals(10.0));
  });
}

class Keyframe {
  num value;
  num time;
}

class Timeline {
  List<Keyframe> keys = new List();
}

class TestObject {
  AnimatablePropertyNum x = new AnimatablePropertyNum();

  AnimatablePropertyInt _count = new AnimatablePropertyInt();
  AnimatablePropertyInt get count => _count;
  Timeline get countBase => _count.timeline;
  set count(value) {
    if(value is int)_count.value = value;
    if(value is Timeline)_count.timeline = value;
    if(value is AnimatablePropertyInt)_count = value;
  }
}

abstract class AbstractAnimatableProperty<T> {
  T value;
  Timeline timeline;
}

class AnimatablePropertyInt extends AbstractAnimatableProperty<int>{
  AnimatablePropertyInt(){
    value = 0;
  }
}

class AnimatablePropertyNum extends AbstractAnimatableProperty<num>{
  AnimatablePropertyNum(){
    value = 0.0;
  }
}

class Manager{
  static void setNumValue(Object obj, Symbol symbol, value) {
    InstanceMirror classInstanceMirror = reflect(obj);
    classInstanceMirror.setField(symbol, value);
  }
}

