import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:webgl/src/geometry/mesh_primitive.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
@MirrorsUsed(
    targets: const [
      SceneViewParticleSimple,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewParticleSimple extends SceneJox{

  SceneViewParticleSimple();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    CustomObject customObject = experiment() as CustomObject;
    materials.add(customObject.material);
    meshes.add(customObject);

    //Animation
    updateSceneFunction = () {
      customObject.updateFunction();
    };
  }

  Mesh experiment() {
    num shaderTime = 0.0;

    String vShader = '''
    precision mediump float;

    attribute vec2 a_vertex;

    uniform float u_time;

    varying vec2 v_vertex;

    void main(void) {
      gl_PointSize = 2.0;
      v_vertex = a_vertex;

      vec2 v = a_vertex;
      v.y = 0.5 * sin(20.0 * u_time);

      gl_Position=vec4(v,0.,1.);
    }

  ''';

    String fShader = '''
    precision mediump float;

    uniform float u_time;

    varying vec2 v_vertex;

    void main(void) {
      gl_FragColor = vec4(.3,.7,1.,.1);
    }
  ''';

    MaterialCustom materialCustom = new MaterialCustom(
        vShader, fShader);
    materialCustom
      ..setShaderAttributsVariables = (Mesh model) {
        materialCustom.setShaderAttributArrayBuffer(
            'a_vertex', model.primitive.vertices, model.primitive.vertexDimensions);
      }
      ..setShaderUniformsVariables = (Mesh model) {
        materialCustom.setShaderUniform('u_time', shaderTime);
      };
    materials.add(materialCustom);


    int particleCount = 1;
    Float32List pstart = new Float32List(particleCount * 2);
    var i = pstart.length;
    while (i-- != 0) {
      pstart[i] = 0.0;
    }

    CustomObject customObject = new CustomObject()
    ..primitive = new MeshPrimitive()
    ..primitive.mode = DrawMode.POINTS
    ..primitive.vertexDimensions = 2
    ..primitive.vertices = pstart
    ..material = materialCustom;

    customObject.updateFunction = () {
      shaderTime = Time.currentTime / 20000;
    };

    return customObject;
  }
}
