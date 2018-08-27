import 'dart:async';

import 'package:angular/angular.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl_application/components/value_components/bool_component/bool_component.dart';
import 'package:webgl_application/components/value_components/bool_component/bool_component.template.dart' as ngBool;
import 'package:webgl_application/components/value_components/function_component/parameter_name_component/parameter_name_component.dart';
import 'package:webgl_application/components/value_components/int_component/int_component.dart';
import 'package:webgl_application/components/value_components/int_component/int_component.template.dart' as ngInt;
import 'package:webgl_application/components/value_components/num_component/num_component.dart';
import 'package:webgl_application/components/value_components/num_component/num_component.template.dart' as ngNum;
import 'package:webgl_application/components/value_components/string_component/string_component.dart';
import 'package:webgl_application/components/value_components/string_component/string_component.template.dart' as ngString;
import 'package:webgl_application/components/value_components/vector2_component/vector2_component.dart';
import 'package:webgl_application/components/value_components/vector2_component/vector2_component.template.dart' as ngVec2;
import 'package:webgl_application/components/value_components/vector3_component/vector3_component.dart';
import 'package:webgl_application/components/value_components/vector3_component/vector3_component.template.dart' as ngVec3;
import 'package:webgl_application/components/value_components/vector4_component/vector4_component.dart';
import 'package:webgl_application/components/value_components/vector4_component/vector4_component.template.dart' as ngVec4;
import 'package:webgl_application/components/value_components/webglenum_component/webglenum_component.dart';
import 'package:webgl_application/components/value_components/webglenum_component/webglenum_component.template.dart' as ngEnum;
// Component to add dynamic components
@Component(
    selector: 'componentLoader',
    template: r'''<div #target></div>'''
)
class DynamicLoaderComponent implements AfterViewInit{

  @ViewChild('target', read:ViewContainerRef)
  ViewContainerRef target;

  ComponentRef cmpRef;
  Injector injector;

  DynamicLoaderComponent();

  Future createDynamicComponentType(Type newType, dynamic defaultValue, Function callBack)async {

    Type componentType = ComponentTypes.getComponentBaseType(newType);

    if(componentType == null) return;

    //TypeComponent
    ComponentFactory newComponentFactory = ComponentTypes.getComponentBaseFactory(componentType);
    ComponentRef cdRef = target.createComponent<dynamic>(newComponentFactory, -1, injector);

    switch(componentType){
      case BoolComponent:
        BoolComponent.initDynamicComponent(cdRef.instance as BoolComponent, defaultValue as bool, callBack);
        break;
      case StringComponent:
        StringComponent.initDynamicComponent(cdRef.instance as StringComponent, defaultValue as String, callBack);
        break;
      case IntComponent:
        IntComponent.initDynamicComponent(cdRef.instance as IntComponent, defaultValue as int, callBack);
        break;
      case NumComponent:
        NumComponent.initDynamicComponent(cdRef.instance as NumComponent, defaultValue as num, callBack);
        break;
      case Vector2Component:
        Vector2Component.initDynamicComponent(cdRef.instance as Vector2Component, defaultValue as Vector2, callBack);
        break;
      case Vector3Component:
        Vector3Component.initDynamicComponent(cdRef.instance as Vector3Component, defaultValue as Vector3, callBack);
        break;
      default:
        throw new Exception('DynamicLoaderComponent::createDynamicComponent : No component for $componentType');
        break;
    }
  }

  Future createDynamicComponentBaseType(Type newType, dynamic defaultValue, Function callBack, {String name})async {
    //parameter name
    if(name != null) {
      ComponentFactory nameFactory = ComponentTypes.getComponentBaseFactory(ParameterNameComponent);
      ComponentRef cdRefName = target.createComponent<dynamic>(nameFactory, -1, injector);
      ParameterNameComponent parameterNameComponent = cdRefName.instance as ParameterNameComponent;
      parameterNameComponent.name = name;
    }

    createDynamicComponentType(newType, defaultValue, callBack);
  }

  @override
  void ngAfterViewInit() {
    injector = target.injector;
  }
}

class ComponentTypes{

  static Type getComponentBaseType(Type type){
    Type typeComponent;

    switch(type.toString()){
      case 'bool':
        typeComponent = BoolComponent;
        break;
      case 'String':
        typeComponent = StringComponent;
        break;
      case 'int':
        typeComponent = IntComponent;
        break;
      case 'num':
        typeComponent = NumComponent;
        break;
      case 'Vector3':
        typeComponent = Vector3Component;
        break;
      case 'Vector2':
        typeComponent = Vector2Component;
        break;
      case 'Vector4':
        typeComponent = Vector4Component;
        break;
      case 'WebGLEnum':
        typeComponent = WebGLEnumComponent;
        break;
      default:
        print("ComponentTypes::getComponentBaseType : No component for $type");
//        throw new Exception("ComponentTypes::getType : No component for type");
        break;
    }

    return typeComponent;
  }

  static ComponentFactory getComponentBaseFactory(Type type){
    ComponentFactory componentFactory;

    switch(type.toString()){
      case 'bool':
        componentFactory = ngBool.BoolComponentNgFactory;
        break;
      case 'String':
        componentFactory = ngString.StringComponentNgFactory;
        break;
      case 'int':
        componentFactory = ngInt.IntComponentNgFactory;
        break;
      case 'num':
        componentFactory = ngNum.NumComponentNgFactory;
        break;
      case 'Vector2':
        componentFactory = ngVec2.Vector2ComponentNgFactory;
        break;
      case 'Vector3':
        componentFactory = ngVec3.Vector3ComponentNgFactory;
        break;
      case 'Vector4':
        componentFactory = ngVec4.Vector4ComponentNgFactory;
        break;
      case 'WebGLEnum':
        componentFactory = ngEnum.WebGLEnumComponentNgFactory;
        break;
      default:
        print("ComponentTypes::getComponentBaseFActory : No componentFactory for $type");
//        throw new Exception("getComponentBaseFActory::getType : No componentFactory for type");
        break;
    }

    return componentFactory;
  }
}