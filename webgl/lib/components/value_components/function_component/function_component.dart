import 'dart:mirrors';
import 'package:angular2/core.dart';
import 'package:webgl/components/value_components/function_component/dynamic_load_component.dart';
import 'package:webgl/src/introspection.dart';

@Component(
    selector: 'function',
    templateUrl: 'function_component.html',
    styleUrls: const ['function_component.css'],
    directives: const [DynamicLoaderComponent]
)
class FunctionComponent implements AfterViewInit{

  @ViewChild('loader')
  DynamicLoaderComponent loader;

  @Input()
  FunctionModel functionModel;

  @Input()
  bool disabled = false;

  Type getComponentType(String typeString){
    return ComponentTypes.getComponentType(typeString);
  }

  String getName(){
    return functionModel.getName();
  }

  String result;
  String getReturnType(){
    return '${functionModel.getReturnType()} ${result != null ? ': $result' :''}';
  }

  List<String> getParameters(){
    return functionModel.getParameters();
  }

  Map<Symbol, dynamic> positionals;
  List<ParameterMirror> getPositionalArguments(){
    List<ParameterMirror> positionalParameter = functionModel.getPositionalArguments();
    if(positionals == null){
      positionals = {};
      positionalParameter.forEach((p)=> positionals[p.simpleName] = null);
    }
    return positionalParameter;
  }

  void setPositionalValue(ParameterMirror parameter, event){
    positionals[parameter.simpleName] = event;
  }

  Map<Symbol, dynamic> named;
  List<ParameterMirror> getNamedArguments(){
    List<ParameterMirror> namedParameters = functionModel.getNamedArguments();
    if(named == null){
      named = {};
      namedParameters.forEach((p)=> named[p.simpleName] = null);
    }
    return namedParameters;
  }

  void setNamedValue(ParameterMirror parameter, event){

    var typedInstance = Activator.createInstance(parameter.type.reflectedType);
//
//    reflectType()
//    ClassMirror cm = lm.classes['TestClass'];
//    Future tcFuture = cm.newInstance('', []);

    var typedValue = event.target.value;// as parameter.type.reflectedType;
    named[parameter.simpleName] = typedValue;
  }

  void invokeMethod(){
    Symbol memberName = functionModel.methodMirror.simpleName;
    result = functionModel.invoke(memberName, positionals.values, named);
  }

  @override
  ngAfterViewInit() {
    for(ParameterMirror param in getPositionalArguments()) {
      print(param.type.reflectedType);
      loader.createDynamicComponentBaseType(param.type.reflectedType, (v){
        setPositionalValue(param, v);
      });
    }
  }
}

class Activator {
  static createInstance(Type type, [Symbol constructor, List
  arguments, Map<Symbol, dynamic> namedArguments]) {
    if (type == null) {
      throw new ArgumentError("type: $type");
    }

    if (constructor == null) {
      constructor = const Symbol("");
    }

    if (arguments == null) {
      arguments = const [];
    }

    var typeMirror = reflectType(type);
    if (typeMirror is ClassMirror) {
      return typeMirror.newInstance(constructor, arguments,
          namedArguments).reflectee;
    } else {
      throw new ArgumentError("Cannot create the instance of the type '$type'.");
    }
  }
}

