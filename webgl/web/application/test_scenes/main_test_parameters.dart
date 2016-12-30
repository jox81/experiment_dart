import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:mirrors';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/shaders.dart';

Future main() async {
  WebglTestParameters webgl01 =
      new WebglTestParameters(querySelector('#glCanvas'));

  await ShaderSource.loadShaders();
  webgl01.setup();
  webgl01.render();
}

List<WebglConstant> webglConstants = new List();
List<WebglParameter> webglParameters = new List();

class WebglTestParameters {
  Buffer vertexBuffer;
  Buffer indicesBuffer;

  List<Model> models = new List();

  Program shaderProgram;

  int vertexPositionAttribute;

  UniformLocation pMatrixUniform;
  UniformLocation mvMatrixUniform;

  WebglTestParameters(CanvasElement canvas) {
    initGL(canvas);
  }

  void initGL(CanvasElement canvas) {
    Context.init(canvas);
  }

  void setup() {
    setupCamera();
    setupMeshes();

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(RenderingContext.DEPTH_TEST);
  }

  void setupCamera() {
    Context.mainCamera = new Camera(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(10.0, 10.0, 10.0)
      ..cameraController = new CameraController();
  }

  void setupMeshes() {
    QuadModel quad = new QuadModel()..transform.translate(2.0, 0.0, 0.0);
    models.add(quad);

    getInfos();
  }

  void render({num time: 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(
        RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT);

    for (Model model in models) {
      model.render();
    }
  }

  void getInfos() {
    InstanceMirror instanceMirror = reflect(gl);
    getInstanceMirroInfos(instanceMirror);

    ClassMirror classMirror = reflectClass(RenderingContext);
    getClassMirroInfos(classMirror);

//    getParameters();

//    logConstants();
//    logParameters();

//    testGetParameter();

    logContextAttributes();
  }

  Map getContextAttributes(){
    _ReturnedDictionary contextParameters = gl.getContextAttributes();
    return contextParameters.toMap;
  }

  void logContextAttributes(){
    Map contextAttributes = getContextAttributes();
    for(String key in contextAttributes.keys){
      print('$key : ${contextAttributes[key]}');
    }
  }

  void testGetParameter() {
    print('##################################################################');
    print('TEXTURE0 : 0x84C0 = ${0x84C0}'); // == 33984
    print('ACTIVE_TEXTURE : 0x84E0 = ${0x84E0}'); // == 34016
    print(getParameter(RenderingContext.ACTIVE_TEXTURE));
    //OK > ACTIVE_TEXTURE (34016) = TEXTURE0 : glEnum
    print('##################################################################');

    Object result = gl.getParameter(RenderingContext.BLEND_SRC_RGB);
    print(result);
    //NO > comment différencier une valeur int d'une valeur glEnum ?
    print(getParameter(RenderingContext.BLEND_SRC_RGB));
    print(0x0001);
  }

  void getParameters() {
    for (WebglConstant c in webglConstants) {
      WebglParameter webglParameter = getParameter(c.glEnum);
      if (webglParameter != null) {
        webglParameters.add(webglParameter);
      }
    }
  }

  WebglParameter getParameter(int glEnum) {
    var result = gl.getParameter(glEnum);
    int error = gl.getError();
    if (error != RenderingContext.INVALID_ENUM) {
//      print('--');
//      print(result);
//      print(result.runtimeType);

      String glEnumStringValue;

      if (result is int) {
        WebglConstant constant = webglConstants
            .firstWhere((c) => c.glEnum == (result as int), orElse: () => null);
        if (constant != null) {
          glEnumStringValue = webglConstants
              .firstWhere((c) => c.glEnum == constant.glEnum)
              .glName;
        }
      }
      WebglParameter param = new WebglParameter()
        ..glName = webglConstants.firstWhere((c) => c.glEnum == glEnum).glName
        ..glValue = glEnumStringValue != null ? glEnumStringValue : result
        ..glType = result.runtimeType.toString()
        ..glEnum = glEnum;
      return param;

//      String glName = webglConstants.firstWhere((c)=> c.glEnum == result).glName;
//      int value = classMirror.getField(decl.simpleName).reflectee;
//      glConstants[value] = name;
//      glParameters[value] = '$ret : ${ret.runtimeType.toString()}';

//      WebglParameter param = new WebglParameter();
//      param.glType = result.runtimeType;
    }

    return null;
  }

  void logConstants({bool nameFirst: true}) {
    print('##################################################################');
    print('Constants :');
    print('');
    webglConstants.forEach((c) {
      if (nameFirst) {
        print('${c.glName} = ${c.glEnum}');
      } else {
        print('${c.glName} = ${c.glEnum}');
      }
    });
    print('##################################################################');
  }

  void logParameters() {
    print('##################################################################');
    print('Parameters :');
    print('');
    webglParameters.forEach((p) {
      print('${p.toString()}');
    });
    print('##################################################################');
  }

  void getInstanceMirroInfos(InstanceMirror instanceMirror) {
//    print('');
//    print('##################################################################');
//    print('### InstanceMirror               #################################');
//    print('##################################################################');
//    print('');
  }

  void getClassMirroInfos(ClassMirror classMirror) {
//    print('##################################################################');
//    print('### ClassMirror                  #################################');
//    print('##################################################################');
//    String name = MirrorSystem.getName(classMirror.simpleName);
//    print('### $name');
//
//    print('### ClassMirror declarations     #################################');
    for (DeclarationMirror decl in classMirror.declarations.values) {
      PrintDeclarationInfos(classMirror, decl);
    }

//    print('### ClassMirror instanceMembers  #################################');
    for (DeclarationMirror decl in classMirror.instanceMembers.values) {
      PrintDeclarationInfos(classMirror, decl);
    }

//    print('##################################################################');
//    print('');
  }

  void PrintDeclarationInfos(ClassMirror classMirror, DeclarationMirror decl) {
    String name = MirrorSystem.getName(decl.simpleName);
    String className = MirrorSystem.getName(classMirror.simpleName);
    String ownerName = MirrorSystem.getName(decl.owner.simpleName);

//    print('$name / $className / $ownerName');
    if (className == ownerName) {
//      print('qualifiedName : ${MirrorSystem.getName(decl.qualifiedName)}'); //ex : dart.dom.web_gl.RenderingContext.vertexAttrib2fv
//      print('owner : $ownerName');
//      print('isPrivate : ${decl.isPrivate}'); // always false in RenderingContext
//      print('isTopLevel : ${decl.isTopLevel}'); // always false in RenderingContext
//      print('location : ${decl.location}'); //ex : dart:web_gl:1445
//      print('metadata : ${decl.metadata}');

      if (decl is LibraryMirror) {
        print('### $name : LibraryMirror');
      }

      if (decl is TypeMirror) {
        print('### $name : TypeMirror');
//        print('hasReflectedType : ${decl.hasReflectedType}');
//        print('reflectedType : ${decl.reflectedType}');
//        print('typeVariables : ${decl.typeVariables}');
//        print('typeArguments : ${decl.typeArguments}');
//        print('isOriginalDeclaration : ${decl.isOriginalDeclaration}');
//        print('originalDeclaration : ${decl.originalDeclaration}');
//        print('originalDeclaration : ${decl.originalDeclaration}');
      }

      if (decl is TypeVariableMirror) {
        print('### $name : TypeVariableMirror');
      }
      if (decl is TypedefMirror) {
        print('### $name : TypedefMirror');
      }
      if (decl is FunctionTypeMirror) {
        print('### $name : FunctionTypeMirror');
      }
      if (decl is VariableMirror) {
        int glEnum = classMirror.getField(decl.simpleName).reflectee;

        WebglConstant constant = new WebglConstant()
          ..glEnum = glEnum
          ..glName = name;

        webglConstants.add(constant);
//        print('### VariableMirror : $name = ${classMirror.getField(decl.simpleName).reflectee}');
////        print('type : ${MirrorSystem.getName(decl.type.simpleName)}'); // always int in RenderingContext
////        print('isStatic : ${decl.isStatic}'); // always true in RenderingContext
////        print('isFinal : ${decl.isFinal}'); // always true in RenderingContext
////        print('isConst : ${decl.isConst}'); // always true in RenderingContext
      }
      if (decl is ParameterMirror) {
        print('### $name : ParameterMirror');
      }
      if (decl is ParameterMirror) {
        print('### $name : ParameterMirror');
      }
      if (decl is MethodMirror) {
//        print('${MirrorSystem.getName(decl.returnType.simpleName)} $name(');
//        decl.parameters.forEach((p) {
//          print('   ${MirrorSystem.getName(p.type.simpleName)} ${MirrorSystem.getName(p.simpleName)},');
////          print('isOptional : ${p.isOptional}');
////          print('isNamed : ${p.isNamed}');// always false
////          print('hasDefaultValue : ${p.hasDefaultValue}');// always false
////          print('defaultValue : ${p.defaultValue}');// always null
//        });
//        print(')');

//        print('source : ${decl.source}'); // retourne le code
//        print('parameters : ${decl.parameters}'); //Explore more in depth
//        print('isStatic : ${decl.isStatic}');
//        print('isAbstract : ${decl.isAbstract}'); // always false in RenderingContext
//        print('isSynthetic : ${decl.isSynthetic}'); // always false in RenderingContext
//        print('isRegularMethod : ${decl.isRegularMethod}');
//        print('isOperator : ${decl.isOperator}'); // always false in RenderingContext
//        print('isGetter : ${decl.isGetter}');
//        print('isSetter : ${decl.isSetter}'); // always false in RenderingContext
//        print('isConstructor : ${decl.isConstructor}');
//        print('constructorName : ${decl.constructorName}');
//        print('isConstConstructor : ${decl.isConstConstructor}'); // always false in RenderingContext
//        print('isGenerativeConstructor : ${decl.isGenerativeConstructor}');
//        print('isRedirectingConstructor : ${decl.isRedirectingConstructor}'); // always false in RenderingContext
//        print('isFactoryConstructor : ${decl.isFactoryConstructor}'); // always false in RenderingContext
      }
    }
  }
}

class WebglParameter {
  int glEnum;
  String glName;
  String glType;
  dynamic glValue;

  WebglParameter();

  @override
  String toString() {
    String typeString = (glType == 'int' && glValue is String)? 'glEnum' : glType;
    return '$glName${glEnum != null ? ' (${glEnum})' : ''} = ${glValue} : $typeString ';
  }
}

class WebglConstant {
  int glEnum;
  String glName;

  WebglConstant();
}


// Creates a Dart class to allow members of the Map to be fetched (as if getters exist).
// TODO(terry): Need to use package:js but that's a problem in dart:html. Talk to
//              Jacob about how to do this properly using dart:js.
class _ReturnedDictionary {
  Map _values;

  noSuchMethod(Invocation invocation) {
    var key = MirrorSystem.getName(invocation.memberName);
    if (invocation.isGetter) {
      return _values[key];
    } else if (invocation.isSetter && key.endsWith('=')) {
      key = key.substring(0, key.length-1);
      _values[key] = invocation.positionalArguments[0];
    }
  }

  Map get toMap => _values;

  _ReturnedDictionary(Map value): _values = value != null ? value : {};
}
