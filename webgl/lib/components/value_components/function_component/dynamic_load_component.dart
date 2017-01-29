import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/value_components/vector2_component/vector2_component.dart';
import 'package:webgl/components/value_components/vector3_component/vector3_component.dart';

// Helper component to add dynamic components
@Component(
    selector: 'componentLoader',
    template: r'''
      <!--<button (click)="createDynamicComponent()">Create The Dynamic Component</button>-->
      <div #target></div>
      ''',
    directives: const [Vector3Component]
)
class DynamicLoaderComponent implements AfterViewInit{
  @Input()
  Type type;

  @ViewChild('target', read:ViewContainerRef)
  ViewContainerRef target;

  ComponentRef cmpRef;
  final ComponentResolver componentResolver;

  DynamicLoaderComponent(this.componentResolver);

  createDynamicComponent()async {
    if(type == null) return;
    createDynamicComponentType(type, null);
  }

  createDynamicComponentType(Type newType, Function callBack)async {
    ComponentFactory factory = await componentResolver.resolveComponent(newType);

    Injector ctxInjector = (target).injector;

    ComponentRef cdRef = target.createComponent(factory, -1, ctxInjector);
    switch(newType){
      case Vector3Component:
        Vector3Component component = cdRef.instance;
        component
          ..vector = new Vector3.all(0.5)
          ..vector3Change.listen((d){
            print(d);
            if(callBack != null){
              callBack(d);
            }
          });
        break;
      case Vector2Component:
        Vector2Component component = cdRef.instance;
        component
          ..vector = new Vector2.all(0.2)
          ..vector2Change.listen((d){
            print(d);
            if(callBack != null){
              callBack(d);
            }
          });
        break;
      default:
        throw new Exception('DynamicLoaderComponent::createDynamicComponent : No component for $newType');
        break;
    }

    print("Component created : ${cdRef.instance.runtimeType}");
  }

  createDynamicComponentBaseType(Type newType, Function callBack){
    Type componentType = ComponentTypes.getComponentBaseType(newType.toString());
    if(componentType != null) {
      createDynamicComponentType(componentType, callBack);
    }
  }

  @override
  ngAfterViewInit() {
    if(type != null){
      createDynamicComponent();
    }
  }
}

class ComponentTypes{
//  static Type get vector3ComponentType => Vector3Component;

  static Type getComponentType(String typeString){
    Type type;

    switch(typeString){
      case 'Vector3Component':
        type = Vector3Component;
        break;
      case 'Vector2Component':
        type = Vector2Component;
        break;
      default:
        print("ComponentTypes::getComponentType : No component for $typeString");
//        throw new Exception("ComponentTypes::getType : No component for $typeString");
        break;
    }

    return type;
  }

  static Type getComponentBaseType(String typeString){
    Type type;

    switch(typeString){
      case 'Vector3':
        type = Vector3Component;
        break;
      case 'Vector2':
        type = Vector2Component;
        break;
      default:
        print("ComponentTypes::getComponentBaseType : No component for $typeString");
//        throw new Exception("ComponentTypes::getType : No component for $typeString");
        break;
    }

    return type;
  }
}