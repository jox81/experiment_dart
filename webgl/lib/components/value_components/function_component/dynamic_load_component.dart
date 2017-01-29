import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/value_components/bool_component/bool_component.dart';
import 'package:webgl/components/value_components/function_component/parameter_name_component/parameter_name_component.dart';
import 'package:webgl/components/value_components/int_component/int_component.dart';
import 'package:webgl/components/value_components/num_component/num_component.dart';
import 'package:webgl/components/value_components/string_component/string_component.dart';
import 'package:webgl/components/value_components/vector2_component/vector2_component.dart';
import 'package:webgl/components/value_components/vector3_component/vector3_component.dart';
import 'package:webgl/components/value_components/vector4_component/vector4_component.dart';
import 'package:webgl/components/value_components/webglenum_component/webglenum_component.dart';

// Component to add dynamic components
@Component(
    selector: 'componentLoader',
    template: r'''<div #target></div>'''
)
class DynamicLoaderComponent implements AfterViewInit{
  final ComponentResolver componentResolver;

  @ViewChild('target', read:ViewContainerRef)
  ViewContainerRef target;

  ComponentRef cmpRef;
  Injector injector;

  DynamicLoaderComponent(this.componentResolver);

  createDynamicComponentType(Type newType, defaultValue, Function callBack)async {

    Type componentType = ComponentTypes.getComponentBaseType(newType);

    if(componentType == null) return;

    //TypeComponent
    ComponentFactory newTypeFactory = await componentResolver.resolveComponent(componentType);
    ComponentRef cdRef = target.createComponent(newTypeFactory, -1, injector);

    switch(componentType){
      case BoolComponent:
        BoolComponent.initDynamicComponent(cdRef.instance, defaultValue, callBack);
        break;
      case StringComponent:
        StringComponent.initDynamicComponent(cdRef.instance, defaultValue, callBack);
        break;
      case IntComponent:
        IntComponent.initDynamicComponent(cdRef.instance, defaultValue, callBack);
        break;
      case NumComponent:
        NumComponent.initDynamicComponent(cdRef.instance, defaultValue, callBack);
        break;
      case Vector2Component:
        Vector2Component.initDynamicComponent(cdRef.instance, defaultValue, callBack);
        break;
      case Vector3Component:
        Vector3Component.initDynamicComponent(cdRef.instance, defaultValue, callBack);
        break;
      default:
        throw new Exception('DynamicLoaderComponent::createDynamicComponent : No component for $componentType');
        break;
    }

//    print("Component created : ${cdRef.instance.runtimeType}");
  }

  createDynamicComponentBaseType(Type newType, defaultValue, Function callBack, {String name})async {
    //parameter name
    if(name != null) {
      ComponentFactory nameFactory = await componentResolver.resolveComponent(
          ParameterNameComponent);
      ComponentRef cdRefName = target.createComponent(nameFactory, -1, injector);
      ParameterNameComponent parameterNameComponent = cdRefName.instance;
      parameterNameComponent.name = name;
    }

    createDynamicComponentType(newType, defaultValue, callBack);
  }

  @override
  ngAfterViewInit() {
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
}