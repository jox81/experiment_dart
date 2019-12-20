import 'package:webgl/src/introspection/introspection.dart';

//@reflector
class AnimationChannelTargetPathType{
  static const AnimationChannelTargetPathType translation = const AnimationChannelTargetPathType("translation");
  static const AnimationChannelTargetPathType rotation = const AnimationChannelTargetPathType("rotation");
  static const AnimationChannelTargetPathType scale = const AnimationChannelTargetPathType("scale");
  static const AnimationChannelTargetPathType weights = const AnimationChannelTargetPathType("weights");

  final String path;

  const AnimationChannelTargetPathType(this.path);

  static List<AnimationChannelTargetPathType> get values => [
    translation,
    rotation,
    scale,
    weights,
  ];

  static AnimationChannelTargetPathType getByValue(String path) =>
      values.firstWhere((e)=>e.path == path, orElse: ()=> null);

  @override
  String toString() {
    return '$path';
  }
}