import 'dart:async';
import 'package:webgl/memory_tester/test_builder.dart';

Future main() async {
  buildMemoryTester(ItemType.webgl_shader)..initialize();
}
