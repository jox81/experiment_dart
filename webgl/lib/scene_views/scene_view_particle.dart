import 'dart:math' as Math;
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/interaction.dart';

class SceneViewParticle extends Scene implements IEditScene{

  /// implements ISceneViewBase
  num varA = 30;
  num varB = 20;
  num varCt = 0;

  Map<String, AnimationProperty> get properties =>{
    'varA' : new AnimationProperty<num>(()=> varA, (num v)=> varA = v),
    'varB' : new AnimationProperty<num>(()=> varB, (num v)=> varB = v),
    'varCt' : new AnimationProperty<num>(()=> varCt, (num v)=> varCt = v),
  };

  final num viewAspectRatio;

  SceneViewParticle(Application application):this.viewAspectRatio = application.viewAspectRatio,super(application);

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

    Mesh mesh = await experiment(scene);
    materials.add(mesh.material);
    meshes.add(mesh);

    //Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //... custom animation here
      mesh.updateFunction(time);
      _lastTime = time;
    };
  }

  Mesh experiment(Scene scene) {
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
    Mesh mesh = new Mesh()
      ..mode = GL.POINTS
      ..vertexDimensions = 2
      ..vertices = pstart
      ..material = materialCustom;

    mesh.updateFunction = (num time) {
      shaderTime = time / 20000;
    };

    return mesh;
  }
}
