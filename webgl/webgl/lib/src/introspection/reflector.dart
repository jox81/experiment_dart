import 'package:reflectable/reflectable.dart';

List<ReflectCapability> capabilities = [
  instanceInvokeCapability,
  staticInvokeCapability,
  topLevelInvokeCapability,
  newInstanceCapability,
  metadataCapability,
  typeCapability,
  typeRelationsCapability,
  reflectedTypeCapability,
  libraryCapability,
  declarationsCapability,
  uriCapability,
  libraryDependenciesCapability,
  invokingCapability,
  typingCapability,
  delegateCapability,
  subtypeQuantifyCapability,
  superclassQuantifyCapability,
  admitSubtypeCapability,
];

// Annotate with this class to enable reflection.
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, declarationsCapability,
      superclassQuantifyCapability, reflectedTypeCapability,typeRelationsCapability,
//      admitSubtypeCapability,
      metadataCapability); // Request the capability to invoke methods.
}

const reflector = const Reflector();