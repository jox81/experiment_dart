import 'dart:async';
import 'dart:html';
import 'dart:mirrors';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/shaders.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_debug_js.dart';

Texture textureCrate;

Future main() async {

  WebglTestParameters webgl01 = new WebglTestParameters(querySelector('#glCanvas'));

  await ShaderSource.loadShaders();
  webgl01.setup();
  webgl01.render();
}

class WebglTestParameters {

  Buffer vertexBuffer;
  Buffer indicesBuffer;

  List<Model> models = new List();

  Program shaderProgram;

  int vertexPositionAttribute;

  UniformLocation pMatrixUniform;
  UniformLocation mvMatrixUniform;

  WebglTestParameters(CanvasElement canvas){
    initGL(canvas);
  }

  void initGL(CanvasElement canvas) {

    var names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"];
    for (var i = 0; i < names.length; ++i) {
      try {
        gl = canvas.getContext(names[i]);
      } catch (e) {}
      if (gl != null) {
        break;
      }
    }
    if (gl == null) {
      window.alert("Could not initialise WebGL");
      return null;
    }
  }

  void setup(){
    setupCamera();
    setupMeshes();

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(RenderingContext.DEPTH_TEST);



  }

  void setupCamera()  {
    Context.mainCamera = new Camera(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(10.0,10.0,10.0)
      ..cameraController = new CameraController();
  }

  void setupMeshes() {
    QuadModel quad = new QuadModel()
      ..transform.translate(2.0, 0.0, 0.0);
    models.add(quad);

    getInfos();
  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT);

    for(Model model in models){
      model.render();
    }
  }

  void getInfos(){

    var p = gl.getParameter(RenderingContext.CULL_FACE_MODE);

    Map<String, MethodMirror> instance_mirror_getters = new Map();


    ClassMirror classMirror = reflectClass(RenderingContext);

    print('#########################################################');
    String name = MirrorSystem.getName(classMirror.simpleName);
    print(name);
    print('#########################################################');
    print('');

    print('### ClassMirror declarations #######################################################');
    for(DeclarationMirror decl in classMirror.declarations.values){
      PrintDeclarationInfos(classMirror, decl);
    }

    print('### ClassMirror instanceMembers #######################################################');
    for(DeclarationMirror decl in classMirror.instanceMembers.values){
      PrintDeclarationInfos(classMirror, decl);
    }
  }

  void PrintDeclarationInfos(ClassMirror classMirror, DeclarationMirror decl){
    print('###');
    String name = MirrorSystem.getName(decl.simpleName);
    print('simpleName : ${decl.simpleName} : $name');
//      print('qualifiedName : ${decl.qualifiedName}');
//      print('owner : ${decl.owner}');
//      print('isPrivate : ${decl.isPrivate}');
//      print('isTopLevel : ${decl.isTopLevel}');
//      print('location : ${decl.location}');
//      print('metadata : ${decl.metadata}');

    if (decl is MethodMirror) {
      print(' --- MethodMirror');
//        print('returnType : ${decl.returnType}');
//        print('source : ${decl.source}');
//        print('parameters : ${decl.parameters}');
//        print('isStatic : ${decl.isStatic}');
//        print('isAbstract : ${decl.isAbstract}');
//        print('isSynthetic : ${decl.isSynthetic}');
//        print('isRegularMethod : ${decl.isRegularMethod}');
//        print('isOperator : ${decl.isOperator}');
//        print('isGetter : ${decl.isGetter}');
//        print('isSetter : ${decl.isSetter}');
//        print('isConstructor : ${decl.isConstructor}');
//        print('constructorName : ${decl.constructorName}');
//        print('isConstConstructor : ${decl.isConstConstructor}');
//        print('isGenerativeConstructor : ${decl.isGenerativeConstructor}');
//        print('isRedirectingConstructor : ${decl.isRedirectingConstructor}');
//        print('isFactoryConstructor : ${decl.isFactoryConstructor}');
    }

    if (decl is VariableMirror) {
      print(' --- VariableMirror');
//        print('type : ${decl.type}');
//        print('isStatic : ${decl.isStatic}');
//        print('isFinal : ${decl.isFinal}');
//        print('isConst : ${decl.isConst}');
        print(classMirror.getField(decl.simpleName).reflectee);
    }

    if (decl is TypeMirror) {
      print(' --- TypeMirror');
//        print('hasReflectedType : ${decl.hasReflectedType}');
//        print('reflectedType : ${decl.reflectedType}');
//        print('typeVariables : ${decl.typeVariables}');
//        print('typeArguments : ${decl.typeArguments}');
//        print('isOriginalDeclaration : ${decl.isOriginalDeclaration}');
//        print('originalDeclaration : ${decl.originalDeclaration}');
//        print('originalDeclaration : ${decl.originalDeclaration}');
    }
  }
}