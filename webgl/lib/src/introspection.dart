import 'dart:mirrors';

import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/utils.dart';

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

    InstanceMirror instance_mirror = reflect(element);
    var class_mirror = instance_mirror.type;

    Map<String, MethodMirror> instance_mirror_getters = new Map();
    Map<String, MethodMirror> instance_mirror_setters = new Map();
    Map<String, MethodMirror> instance_mirror_functions = new Map();

    for (DeclarationMirror v in class_mirror.instanceMembers.values) {
      String name = MirrorSystem.getName(v.simpleName);

      if (v is VariableMirror) {} else if (v is MethodMirror &&
          v.isGetter &&
          !v.isPrivate) {
        instance_mirror_getters[name] = v;
      } else if (v is MethodMirror && v.isSetter && !v.isPrivate) {
        instance_mirror_setters[name] = v;
      } else if (v is MethodMirror && v.isRegularMethod) {
        instance_mirror_functions[name] = v;
      }
    }

//    for (DeclarationMirror v in class_mirror.declarations.values) {
//      String name = MirrorSystem.getName(v.simpleName);
//      if (v is VariableMirror) {
//        if(v.isFinal){
//          print('');
//        }
//      }
//
//    }

    instance_mirror_getters
        .forEach((String key, MethodMirror instance_mirror_field) {
      if (instance_mirror_setters.containsKey('$key=')) {
        Symbol fieldSymbol = instance_mirror_field.simpleName;
        propertiesInfos[key] = new EditableProperty(
            instance_mirror.getField(fieldSymbol).reflectee.runtimeType,
            () => instance_mirror.getField(fieldSymbol).reflectee,
            (v) => instance_mirror.setField(fieldSymbol, v).reflectee);
      }
    });

    instance_mirror_functions
        .forEach((String key, MethodMirror instance_mirror_field) {
      Symbol fieldSymbol = instance_mirror_field.simpleName;
      propertiesInfos[key] = new EditableProperty(Function,
          () => instance_mirror.getField(fieldSymbol).reflectee, null);
    });

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
    ClassMirror classMirror = reflectClass(type);

    Utils.log('',(){
      if (showBaseInfo) {
        String simpleName = MirrorSystem.getName(classMirror.simpleName);
        print('### $simpleName');
        print('');
        print('### ClassMirror declarations     #################################');
      }
      for (DeclarationMirror decl in classMirror.declarations.values) {
        _fillDeclarationInfos(classMirror, decl, showMethod: showMethod);
      }
      if (showBaseInfo) {
        print('');
        print('### ClassMirror instanceMembers  #################################');
      }
      for (DeclarationMirror decl in classMirror.instanceMembers.values) {
        _fillDeclarationInfos(classMirror, decl, showMethod: showMethod);
      }
    });
  }

  void _fillDeclarationInfos(
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

    String simpleName = MirrorSystem.getName(decl.simpleName);
    String className = MirrorSystem.getName(classMirror.simpleName);
    String ownerName = MirrorSystem.getName(decl.owner.simpleName);

    if(showBaseInfo) {
      print('');
      print('### $simpleName : declarations infos ###');
      print(
          'simpleName : $simpleName / className : $className / ownerName : $ownerName');
      print(
          'qualifiedName : ${MirrorSystem.getName(decl.qualifiedName)}'); //ex : dart.dom.web_gl.RenderingContext.vertexAttrib2fv
      print('owner : $ownerName');
      print('isPrivate : ${decl.isPrivate}');
      print('isTopLevel : ${decl.isTopLevel}');
      print('location : ${decl.location}'); //ex : dart:web_gl:1445
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
          '### VariableMirror : $simpleName = ${classMirror.getField(decl.simpleName).reflectee}');
      print('type : ${MirrorSystem.getName(decl.type.simpleName)}');
      print('isStatic : ${decl.isStatic}');
      print('isFinal : ${decl.isFinal}');
      print('isConst : ${decl.isConst}');
    }
    if (decl is ParameterMirror && showParameter) {
      print('### $simpleName : ParameterMirror');
    }
    if (decl is MethodMirror && showMethod) {
      print('${MirrorSystem.getName(decl.returnType.simpleName)} $simpleName(');
      decl.parameters.forEach((p) {
        print(
            '   ${MirrorSystem.getName(p.type.simpleName)} ${MirrorSystem.getName(p.simpleName)},');
//        print('isOptional : ${p.isOptional}');
//        print('isNamed : ${p.isNamed}');
//        print('hasDefaultValue : ${p.hasDefaultValue}');
//        print('defaultValue : ${p.defaultValue}');
      });
      print(')');
//        print('source : ${decl.source}'); // retourne le code
//      print('parameters : ${decl.parameters}'); //Explore more in depth types
//      print('isStatic : ${decl.isStatic}');
//      print('isAbstract : ${decl.isAbstract}');
//      print('isSynthetic : ${decl.isSynthetic}');
//      print('isRegularMethod : ${decl.isRegularMethod}');
//      print('isOperator : ${decl.isOperator}');
//      print('isGetter : ${decl.isGetter}');
//      print('isSetter : ${decl.isSetter}');
//      print('isConstructor : ${decl.isConstructor}');
//      print('constructorName : ${decl.constructorName}');
//      print('isConstConstructor : ${decl.isConstConstructor}');
//      print('isGenerativeConstructor : ${decl.isGenerativeConstructor}');
//      print('isRedirectingConstructor : ${decl.isRedirectingConstructor}');
//      print('isFactoryConstructor : ${decl.isFactoryConstructor}');
    }
  }
}

abstract class IEditElement {
  Map<String, EditableProperty> _properties;
  Map<String, EditableProperty> get properties {
    if (_properties == null) {
      _properties = getPropertiesInfos();
    }
    return _properties;
  }

  Map<String, EditableProperty> getPropertiesInfos() {
    var elementToCheck = this;
    if (this is CustomEditElement) {
      elementToCheck = (this as CustomEditElement).element;
    }
    return IntrospectionManager.instance.getPropertiesInfos(elementToCheck);
  }
}

class CustomEditElement extends IEditElement {
  final dynamic element;
  CustomEditElement(this.element);
}
