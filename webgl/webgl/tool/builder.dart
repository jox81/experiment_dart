import 'package:reflectable/reflectable_builder.dart' as builder;

void main(List<String> arguments) async {
  print(arguments);
  await builder.reflectableBuild(arguments);
}