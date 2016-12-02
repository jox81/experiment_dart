import 'dart:math' as Math;
import 'package:webgl/src/animation_property.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/meshes.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewParticle extends Scene{

  /// implements ISceneViewBase
  num varA = 30;
  num varB = 20;
  num varCt = 0;

  Map<String, EditableProperty> get properties =>{
    'varA' : new EditableProperty<num>(num, ()=> varA, (num v)=> varA = v),
    'varB' : new EditableProperty<num>(num, ()=> varB, (num v)=> varB = v),
    'varCt' : new EditableProperty<num>(num, ()=> varCt, (num v)=> varCt = v),
  };

  SceneViewParticle();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  @override
  setupUserInput() {

    updateUserInputFunction = (){
    };

    updateUserInputFunction();

  }

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

    //Material
    String vShader = '''
    precision mediump float;

    attribute float varA, varB, varCt;

    attribute vec2 a_vertex;

    uniform float u_time;

    varying vec2 v_vertex;

    void main(void) {
      gl_PointSize = 2.;
      v_vertex = a_vertex;

      vec2 v = a_vertex*(mod(u_time+length(a_vertex),1.));
      float ct = varCt;//(cos(v.x * 30. + u_time * 20.)+cos(v.y*30.+u_time*20.));
      v = mat2(sin(v.x*(varA+ct)),cos(v.x*(varB+ct)),cos(v.y*(varA+ct)),sin(v.y*(varB+ct)))*v;

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
            'varA', data : varA);
        materialCustom.setShaderAttributWithName(
            'varB', data : varB);
        materialCustom.setShaderAttributWithName(
            'varCt', data : varCt);
        materialCustom.setShaderAttributWithName(
            'a_vertex', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
      }
      ..setShaderUniformsVariables = (Mesh mesh) {
        materialCustom.setShaderUniformWithName('u_time', shaderTime);
      };
    materials.add(materialCustom);


    Math.Random random = new Math.Random();

    int nump = 4800;
    Float32List pstart = new Float32List(nump * 2);
    var i = pstart.length;
    while (i-- != 0) {
      pstart[i] = 0.0;
      while (pstart[i] * pstart[i] < .3) {
        pstart[i] = random.nextDouble() * 2 - 1;
      }
    }

    CustomObject customObject = new CustomObject()
    ..mesh = new Mesh()
    ..mesh.mode = GL.POINTS
    ..mesh.vertexDimensions = 2
    ..mesh.vertices = pstart
    ..material = materialCustom;

    customObject.updateFunction = (num time) {
      shaderTime = time / 20000;
    };

    return customObject;
  }
}
