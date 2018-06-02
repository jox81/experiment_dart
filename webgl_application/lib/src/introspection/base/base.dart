import 'package:webgl/src/animation/animation_property.dart';
import 'package:webgl_application/src/introspection.dart';

@reflector // This annotation enables reflection on A.
class RefTest extends IEditElement{
  final int a;

  int _b;
  int get b => _b;
  set b(int value) {
    _b = value;
  }

  RefTest(this.a);
  greater(int x) => x > a;
  lessEqual(int x) => x <= a;
}

void test_introspection() {
  RefTest element = new RefTest(10)
    ..name = 'myName';
  Map<String, EditableProperty> propertiesInfos = element.getPropertiesInfos();

  print(propertiesInfos['name'].getter());
  propertiesInfos['name'].setter('myNewName');
  print(propertiesInfos['name'].getter());
  print("");

  IntrospectionManager.instance.getMethodNames(RefTest);
  IntrospectionManager.instance.logTypeInfos(RefTest, showBaseInfo: true, showFunctionType: true, showLibrary: true, showMethod: true, showParameter: true, showType: true, showTypeDef: true, showTypeVariable: true, showVariable: true);
}