import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/value_components/vector3_component/vector3_component.dart';

// Helper component to add dynamic components
@Component(
    selector: 'componentLoader',
    template: r'''
      <button (click)="createDynamicComponent()">Create The Dynamic Component</button>
      <div #target></div>
      ''',
    directives: const [Vector3Component]
)
class DynamicLoadComponent {
  @Input()
  Type type;

  @ViewChild('target', read:ViewContainerRef)
  ViewContainerRef target;

  ComponentRef cmpRef;
  final ComponentResolver componentResolver;

  DynamicLoadComponent(this.componentResolver);

  createDynamicComponent()async {

    ComponentFactory factory = await componentResolver.resolveComponent(Vector3Component);

    Injector ctxInjector = (target).injector;

    ComponentRef cdRef = target.createComponent(factory, -1, ctxInjector);
    Vector3Component vector3component = cdRef.instance;

    vector3component
      ..vector = new Vector3.all(0.5)
      ..vector3Change.listen((d){
        print(d);
      });

    print("Component created : ${vector3component.runtimeType}");

  }
}