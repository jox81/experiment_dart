import 'package:webgl/src/application.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/meshes.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/interface/IScene.dart';
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

class SceneViewParticleSimple extends Scene{

  SceneViewParticleSimple();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    CustomObject customObject = experiment(Application.instance.currentScene) as CustomObject;
    materials.add(customObject.material);
    models.add(customObject);

    //Animation
    updateSceneFunction = () {
      customObject.updateFunction();
    };
  }

  Model experiment(IUpdatableScene scene) {
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
      ..setShaderAttributsVariables = (Model model) {
        materialCustom.setShaderAttributArrayBuffer(
            'a_vertex', model.mesh.vertices, model.mesh.vertexDimensions);
      }
      ..setShaderUniformsVariables = (Model model) {
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
    ..mesh = new Mesh()
    ..mesh.mode = DrawMode.POINTS
    ..mesh.vertexDimensions = 2
    ..mesh.vertices = pstart
    ..material = materialCustom;

    customObject.updateFunction = () {
      shaderTime = Time.currentTime / 20000;
    };

    return customObject;
  }
}