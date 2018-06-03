import 'package:webgl/src/introspection.dart';

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