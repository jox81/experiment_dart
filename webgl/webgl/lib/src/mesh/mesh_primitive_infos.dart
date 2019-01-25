import 'dart:typed_data';
import 'package:webgl/src/introspection/introspection.dart';

@reflector
class MeshPrimitiveInfos{
  final bool useIndices;
  final bool useNormals;
  final bool useUVs;
  final bool useColors;

  MeshPrimitiveInfos({this.useIndices : true, this.useNormals : true, this.useUVs : true, this.useColors : true});

  Float32List vertexPositions;
  Int16List vertexIndices;
  Float32List vertexNormals;
  Float32List vertexUVs;
  Float32List vertexColors;
}