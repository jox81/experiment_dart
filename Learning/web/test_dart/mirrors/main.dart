library test;

import 'dart:mirrors';

//Tutorial : https://www.dartlang.org/articles/libraries/reflection-with-mirrors

main(){
  MyClass myClass = new MyClass(3, 4);
  InstanceMirror myClassInstanceMirror = reflect(myClass);

  ClassMirror MyClassMirror = myClassInstanceMirror.type;

  InstanceMirror res = myClassInstanceMirror.invoke(#sum, []);
  print('sum = ${res.reflectee}');

  var f = MyClassMirror.invoke(#noise, []);
  print('noise = $f');

  print('\nMethods:');
  Iterable<DeclarationMirror> decls =
  MyClassMirror.declarations.values.where(
      (dm) => dm is MethodMirror && dm.isRegularMethod);
  decls.forEach((MethodMirror mm) {
    print(MirrorSystem.getName(mm.simpleName));
  });

  print('\nAll declarations:');
  for (var k in MyClassMirror.declarations.keys) {
    print(MirrorSystem.getName(k));
  }

  MyClassMirror.setField(#s, 91);
  print(MyClass.s);

  setValue(myClass, #i, 10);

  print(getValue(myClass, #i));
}

void setValue(MyClass myClass, Symbol symbol, int i) {
  InstanceMirror myClassInstanceMirror = reflect(myClass);
  myClassInstanceMirror.setField(symbol, 10);

  //Vérification
  InstanceMirror res = myClassInstanceMirror.getField(symbol);
  print('set = ${res.reflectee}');
}

dynamic getValue(MyClass myClass, Symbol symbol) {
  InstanceMirror myClassInstanceMirror = reflect(myClass);
  InstanceMirror res = myClassInstanceMirror.getField(symbol);
  print('get = ${res.reflectee}');
  print('type = ${res.reflectee.runtimeType}');
  return res.reflectee;
}

class MyClass {
  int i, j;
  int sum() => i + j;

  MyClass(this.i, this.j);

  static noise() => 42;

  static var s;
}
