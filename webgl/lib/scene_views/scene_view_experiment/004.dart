import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/meshes.dart';
import 'package:webgl/src/geometry/models.dart';
import 'dart:async';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future<Model> experiment() async {

  String vs = '''
    attribute vec3 aVertexPosition;

    uniform float time;

    void main(void) {
      gl_Position = vec4(aVertexPosition, 4.0);
    }
  ''';

  String fs = '''
    precision mediump float;

    void main() {
        gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
      }
  ''';

  //Material
  MaterialCustom materialCustom = new MaterialCustom(vs, fs);
  materialCustom.setShaderAttributsVariables = (Model model) {
    materialCustom.setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    materialCustom.setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);
  };
  materialCustom.setShaderUniformsVariables = (Model model) {
  };

  Mesh mesh = new Mesh()
  ..mode = DrawMode.TRIANGLES
  ..vertices = [
    0.0, 0.0, 0.0,
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    1.0, 1.0, 0.0]
  ..indices = [
    0, 1, 2,
    1, 3, 2
  ];
  CustomObject customObject = new CustomObject()
    ..mesh = mesh
    ..material = materialCustom;

  customObject.updateFunction = (){
  };

  return customObject;
}





