//import 'dart:math' as Math;
//import 'package:vector_math/vector_math.dart';
//import 'package:webgl/src/gltf/mesh_primitive.dart';
//import 'dart:typed_data';
//import 'dart:async';
//
//
//
//import 'package:webgl/src/time/time.dart';
//import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
//@MirrorsUsed(
//    targets: const [
//      SceneViewParticle,
//    ],
//    override: '*')
//import 'dart:mirrors';
//
//class SceneViewParticle extends SceneJox{
//
//  /// implements ISceneViewBase
//  num varA = 30;
//  num varB = 20;
//  num varCt = 0;
//
//  SceneViewParticle();
//
//  @override
//  Future setupScene() async {
//
//    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
//
//    CustomObject customObject = experiment() as CustomObject;
//    materials.add(customObject.material);
//    meshes.add(customObject);
//
//    //Animation
//    updateSceneFunction = () {
//      customObject.updateFunction();
//    };
//  }
//
//  Mesh experiment() {
//    num shaderTime = 0.0;
//
//    //Material
//    String vShader = '''
//    precision mediump float;
//
//    attribute float varA, varB, varCt;
//
//    attribute vec2 a_vertex;
//
//    uniform float u_time;
//
//    varying vec2 v_vertex;
//
//    void main(void) {
//      gl_PointSize = 2.;
//      v_vertex = a_vertex;
//
//      vec2 v = a_vertex*(mod(u_time+length(a_vertex),1.));
//      float ct = varCt;//(cos(v.x * 30. + u_time * 20.)+cos(v.y*30.+u_time*20.));
//      v = mat2(sin(v.x*(varA+ct)),cos(v.x*(varB+ct)),cos(v.y*(varA+ct)),sin(v.y*(varB+ct)))*v;
//
//      gl_Position=vec4(v,0.,1.);
//    }
//  ''';
//
//    String fShader = '''
//    precision mediump float;
//
//    uniform float u_time;
//
//    varying vec2 v_vertex;
//
//    void main(void) {
//      gl_FragColor = vec4(.3,.7,1.,.1);
//    }
//  ''';
//
//    MaterialCustom materialCustom = new MaterialCustom(
//        vShader, fShader);
//    materialCustom
//      ..setShaderAttributsVariables = (Mesh model) {
//        materialCustom.setShaderAttributData(
//            'varA', varA);
//        materialCustom.setShaderAttributData(
//            'varB', varB);
//        materialCustom.setShaderAttributData(
//            'varCt', varCt);
//        materialCustom.setShaderAttributArrayBuffer(
//            'a_vertex', model.primitive.vertices, model.primitive.vertexDimensions);
//      }
//      ..setShaderUniformsVariables = (Mesh model) {
//        materialCustom.setShaderUniform('u_time', shaderTime);
//      };
//    materials.add(materialCustom);
//
//
//    Math.Random random = new Math.Random();
//
//    int nump = 4800;
//    Float32List pstart = new Float32List(nump * 2);
//    var i = pstart.length;
//    while (i-- != 0) {
//      pstart[i] = 0.0;
//      while (pstart[i] * pstart[i] < .3) {
//        pstart[i] = random.nextDouble() * 2 - 1;
//      }
//    }
//
//    CustomObject customObject = new CustomObject()
//    ..primitive = new MeshPrimitive()
//    ..primitive.mode = DrawMode.POINTS
//    ..primitive.vertexDimensions = 2
//    ..primitive.vertices = pstart
//    ..material = materialCustom;
//
//    customObject.updateFunction = () {
//      shaderTime = Time.currentTime / 20000;
//    };
//
//    return customObject;
//  }
//
//}
