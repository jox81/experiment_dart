import 'package:reflectable/reflectable.dart';
import 'package:webgl/src/introspection/editable_property.dart';
import 'package:webgl/src/introspection/function_model.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'reflector.dart';

export 'reflector.dart';

class IntrospectionManager {
  static IntrospectionManager _instance;

  IntrospectionManager._init();

  static IntrospectionManager get instance {
    if (_instance == null) {
      _instance = new IntrospectionManager._init();
    }
    return _instance;
  }

  Map<String, EditableProperty> getPropertiesInfos(dynamic element) {
    Map<String, EditableProperty> propertiesInfos = {};
    if(element == null) return propertiesInfos;

    Map<String, MethodMirror> instance_mirror_getters = new Map();
    Map<String, MethodMirror> instance_mirror_setters = new Map();
    Map<String, MethodMirror> instance_mirror_functions = new Map();

    InstanceMirror im = reflector.reflect(element);
    ClassMirror cm = im.type;

    for (DeclarationMirror dm in cm.instanceMembers.values) {
      String name = dm.simpleName;

      if (dm is VariableMirror) {}
      else if (dm is MethodMirror &&
          dm.isGetter &&
          !dm.isPrivate && dm.owner.simpleName != "Object") {
        instance_mirror_getters[name] = dm;
      } else if (dm is MethodMirror && dm.isSetter && !dm.isPrivate) {
        instance_mirror_setters[name] = dm;
      } else if (dm is MethodMirror && dm.isRegularMethod && dm.owner.simpleName != "Object") {
        instance_mirror_functions[name] = dm;
      }
    }

//    for (DeclarationMirror v in class_mirror.declarations.values) {
//      String name = reflector.getName(v.simpleName);
//      if (v is VariableMirror) {
//        if(v.isFinal){
//          print('');
//        }
//      }
//
//    }

    /// Rempli les getters et associe un getter si existant. Sinon ce sera en lecture seule
    for (String key in instance_mirror_getters.keys) {
      //on ne veut pas de properties sinon boucle infinie bug !
      if (key != 'properties') {
        MethodMirror instance_mirror_field = instance_mirror_getters[key];

        String fieldSymbol = instance_mirror_field.simpleName;

        Type type;
        PropertyGetter getter;
        PropertySetter setter;

        type = instance_mirror_field.reflectedReturnType;
        getter = () => im.invokeGetter(fieldSymbol);

        if (instance_mirror_setters.containsKey('$key=')) {
          setter = (dynamic v) => im.invokeSetter(fieldSymbol, v);
        } else {
          setter = null;
        }

        propertiesInfos[key] = new EditableProperty<dynamic>(type, getter, setter);
      }
    }

    //Rempli les fonctions
    for (String key in instance_mirror_functions.keys) {
      MethodMirror mm = instance_mirror_functions[key];

      String fieldSymbol = mm.simpleName;

      Function function = () => im.invokeGetter(fieldSymbol) as Function;
      FunctionModel functionModel = new FunctionModel(function, im, mm);

      propertiesInfos[key] = new EditableProperty<dynamic>(FunctionModel,
              () => functionModel, null);
    }

    return propertiesInfos;
  }

  void logTypeInfos(
      Type type, {
        bool showBaseInfo: false,
        bool showLibrary: false,
        bool showType: false,
        bool showTypeVariable: false,
        bool showTypeDef: false,
        bool showFunctionType: false,
        bool showVariable: false,
        bool showParameter: false,
        bool showMethod: false,
      }) {
    ClassMirror classMirror = reflector.reflectType(type) as ClassMirror;

    Debug.log('logTypeInfos', () {
      if (showBaseInfo) {
        String simpleName = classMirror.simpleName;
        print('### $simpleName');
        print('');
        print(
            '### ClassMirror declarations     #################################');
      }
      for (DeclarationMirror decl in classMirror.declarations.values) {
        fillDeclarationInfos(classMirror, decl, showBaseInfo:showBaseInfo, showMethod: showMethod);
      }
      if (showBaseInfo) {
        print('');
        print(
            '### ClassMirror staticMembers  #################################');
      }
      for (DeclarationMirror decl in classMirror.staticMembers.values) {
        fillDeclarationInfos(classMirror, decl, showBaseInfo:showBaseInfo, showMethod: showMethod);
      }
      if (showBaseInfo) {
        print('');
        print(
            '### ClassMirror instanceMembers  #################################');
      }
      for (DeclarationMirror decl in classMirror.instanceMembers.values) {
        fillDeclarationInfos(classMirror, decl, showBaseInfo:showBaseInfo, showMethod: showMethod);
      }
    });
  }

  void fillDeclarationInfos(
      ClassMirror classMirror,
      DeclarationMirror decl, {
        bool showBaseInfo: false,
        bool showLibrary: false,
        bool showType: false,
        bool showTypeVariable: false,
        bool showTypeDef: false,
        bool showFunctionType: false,
        bool showVariable: false,
        bool showParameter: false,
        bool showMethod: false,
      }) {
    String simpleName = decl.simpleName;
    String className = classMirror.simpleName;
    String ownerName = decl.owner.simpleName;

    if (showBaseInfo) {
      print('');
      print('### $simpleName : declarations infos_todo ###');
      print(
          'simpleName : $simpleName / className : $className / ownerName : $ownerName');
      print(
          'qualifiedName : ${decl.qualifiedName}'); //ex : dart.dom.web_gl.RenderingContext.vertexAttrib2fv
      print('## owner : $ownerName');
      print('isPrivate : ${decl.isPrivate}');
      print('isTopLevel : ${decl.isTopLevel}');
//      print('location : ${decl.location}'); //ex : dart:web_gl:1445
      print('metadata : ${decl.metadata}');
    }

    if (decl is LibraryMirror && showLibrary) {
      print('### $simpleName : LibraryMirror');
    }

    if (decl is TypeMirror && showType) {
      print('### $simpleName : TypeMirror');
      print('hasReflectedType : ${decl.hasReflectedType}');
      print('reflectedType : ${decl.reflectedType}');
      print('typeVariables : ${decl.typeVariables}');
      print('typeArguments : ${decl.typeArguments}');
      print('isOriginalDeclaration : ${decl.isOriginalDeclaration}');
      print('originalDeclaration : ${decl.originalDeclaration}');
      print('originalDeclaration : ${decl.originalDeclaration}');
    }

    if (decl is TypeVariableMirror && showTypeVariable) {
      print('### $simpleName : TypeVariableMirror');
    }
    if (decl is TypedefMirror && showTypeDef) {
      print('### $simpleName : TypedefMirror');
    }
    if (decl is FunctionTypeMirror && showFunctionType) {
      print('### $simpleName : FunctionTypeMirror');
    }
    if (decl is VariableMirror && showVariable) {
      print(
          '### VariableMirror : $simpleName = ${classMirror.instanceMembers[decl.simpleName].simpleName}');
      print('type : ${decl.type.simpleName}');
      print('isStatic : ${decl.isStatic}');
      print('isFinal : ${decl.isFinal}');
      print('isConst : ${decl.isConst}');
    }
    if (decl is ParameterMirror && showParameter) {
      print('### $simpleName : ParameterMirror');
    }
    if (decl is MethodMirror && showMethod) {
      print('$simpleName{');//print('${decl.reflectedReturnType} $simpleName(');//Todo (jpu) : add this
      decl.parameters.forEach((ParameterMirror p) {

        print('   ${p.simpleName},');
//        print('   ${p.type.simpleName} ${p.simpleName},');//Todo (jpu) : add this
        print('isOptional : ${p.isOptional}');
        print('isNamed : ${p.isNamed}');
        print('hasDefaultValue : ${p.hasDefaultValue}');
        print('defaultValue : ${p.defaultValue}');
      });
      print(')');
      print('source : ${decl.source}'); // retourne le code
      print('parameters : ${decl.parameters}'); //Explore more in depth types
      print('isStatic : ${decl.isStatic}');
      print('isAbstract : ${decl.isAbstract}');
      print('isSynthetic : ${decl.isSynthetic}');
      print('isRegularMethod : ${decl.isRegularMethod}');
      print('isOperator : ${decl.isOperator}');
      print('isGetter : ${decl.isGetter}');
      print('isSetter : ${decl.isSetter}');
      print('isConstructor : ${decl.isConstructor}');
      print('constructorName : ${decl.constructorName}');
      print('isConstConstructor : ${decl.isConstConstructor}');
      print('isGenerativeConstructor : ${decl.isGenerativeConstructor}');
      print('isRedirectingConstructor : ${decl.isRedirectingConstructor}');
      print('isFactoryConstructor : ${decl.isFactoryConstructor}');
    }
  }

  void getMethodNames(Type type, {bool log: true}) {
    List<String> methodNames = new List();

    ClassMirror classMirror = reflector.reflectType(type) as ClassMirror;
    for (DeclarationMirror decl in classMirror.instanceMembers.values) {
      if (decl is MethodMirror) {
        String simpleName = decl.simpleName;
        methodNames.add(simpleName);
      }
    }

    if (log) {
      Debug.log('Method names', () {
        methodNames.forEach((n) {
          print('$n');
        });
      });
    }
  }
}