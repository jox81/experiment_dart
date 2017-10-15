import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/geometry/meshes.dart';
import 'dart:math';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@MirrorsUsed(
    targets: const [
      SceneViewGLTF  ,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewGLTF extends Scene{

  String gltfUrl = '/gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf';
  GLTFProject gltf;

  SceneViewGLTF();

  @override
  Future setupScene() async {

    gltf = await debugGltf(gltfUrl);

    Model model = modelfromGltf(gltf);
    materials.add(model.material);
    models.add(model);
  }
}

Model modelfromGltf(GLTFProject gltf) {

  String vs = '''
    attribute vec3 aVertexPosition;
    vec4 aVertexColor = vec4(1.0, 1.0, 1.0, 1.0);

    uniform float pointSize;

    varying vec4 vPointColor;

    void main(void) {
      gl_Position = vec4(aVertexPosition, 1.0);
      gl_PointSize = pointSize;
      vPointColor = aVertexColor;
    }
  ''';

  String fs = '''
    precision mediump float;

    varying vec4 vPointColor;

    void main(void) {
        gl_FragColor = vPointColor;
    }
  ''';

  GLTFMesh gltfMesh = gltf.meshes[0];
  GLTFMeshPrimitive primitive = gltfMesh.primitives[0];


  Mesh mesh = new Mesh()
    ..mode = primitive.mode
    ..vertices = [
    ];





  //Material
  num pointSize = 5.0;
  MaterialCustom materialCustom = new MaterialCustom(vs, fs);
  materialCustom.setShaderAttributsVariables = (Model model) {
    materialCustom.setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices,  model.mesh.vertexDimensions);
  };
  materialCustom.setShaderUniformsVariables = (Model model) {
    materialCustom.setShaderUniform("pointSize", pointSize);
  };

  //
  CustomObject customModel = new CustomObject()
    ..mesh = mesh
    ..material = materialCustom;

  return customModel;
}
