import 'package:webgl/src/application.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/meshes.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';

class SceneViewParticleSimple extends Scene{

  SceneViewParticleSimple();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    CustomObject customObject = experiment(Application.currentScene);
    materials.add(customObject.material);
    models.add(customObject);

    //Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //... custom animation here
      customObject.updateFunction(time);
      _lastTime = time;
    };
  }

  Model experiment(Scene scene) {
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

    List<String> buffersNames = ['a_vertex'];

    MaterialCustom materialCustom = new MaterialCustom(
        vShader, fShader, buffersNames);
    materialCustom
      ..setShaderAttributsVariables = (Mesh mesh) {
        materialCustom.setShaderAttributWithName(
            'a_vertex', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
      }
      ..setShaderUniformsVariables = (Mesh mesh) {
        materialCustom.setShaderUniformWithName('u_time', shaderTime);
      };
    materials.add(materialCustom);


    int particleCount = 1;
    Float32List pstart = new Float32List(particleCount * 2);
    var i = pstart.length;
    while (i-- != 0) {
      pstart[i] = 0.0;
    }

    CustomObject customObject = new CustomObject()
    ..mesh = new Mesh()
    ..mesh.mode = DrawMode.POINTS
    ..mesh.vertexDimensions = 2
    ..mesh.vertices = pstart
    ..material = materialCustom;

    customObject.updateFunction = (num time) {
      shaderTime = time / 20000;
    };

    return customObject;
  }
}
