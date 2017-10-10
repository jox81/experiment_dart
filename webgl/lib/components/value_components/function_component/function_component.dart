import 'dart:async';
import 'dart:mirrors';
import 'package:angular2/core.dart';
import 'package:webgl/components/value_components/function_component/dynamic_load_component.dart';
import 'package:webgl/src/introspection.dart';

@Component(
    selector: 'function',
    templateUrl: 'function_component.html',
    styleUrls: const ['function_component.css'],
    directives: const <dynamic>[DynamicLoaderComponent]
)
class FunctionComponent implements AfterViewInit{

  @ViewChild('loaderPositionalArguments')
  DynamicLoaderComponent loaderPositionalArguments;

  @ViewChild('loaderNamedArguments')
  DynamicLoaderComponent loaderNamedArguments;

  @Input()
  FunctionModel functionModel;

  @Input()
  bool disabled = false;

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
      positionals = new Map<Symbol, dynamic>();
      positionalParameter.forEach((p)=> positionals[p.simpleName] = null);
    }
    return positionalParameter;
  }

  void setPositionalValue(ParameterMirror parameter, dynamic event){
    positionals[parameter.simpleName] = event;
  }

  Map<Symbol, dynamic> named;
  List<ParameterMirror> getNamedArguments(){
    List<ParameterMirror> namedParameters = functionModel.getNamedArguments();
    if(named == null){
      named = new Map<Symbol, dynamic>();
      namedParameters.forEach((p)=> named[p.simpleName] = null);
    }
    return namedParameters;
  }

  void setNamedValue(ParameterMirror parameter, dynamic event){
    named[parameter.simpleName] = event;
  }

  void invokeMethod(){
    Symbol memberName = functionModel.methodMirror.simpleName;
    result = '${functionModel.invoke(memberName, positionals.values.toList(), named)}';
  }

  @override
  Future ngAfterViewInit() async {
    for(ParameterMirror param in getPositionalArguments()) {
      await loaderPositionalArguments.createDynamicComponentBaseType(param.type.reflectedType,
        param.hasDefaultValue?param.defaultValue.reflectee:null,
        (dynamic v)=> setPositionalValue(param, v),
        name:'${param.type.reflectedType} ${MirrorSystem.getName(param.simpleName)}');
    }

    for(ParameterMirror param in getNamedArguments()) {
      await loaderNamedArguments.createDynamicComponentBaseType(param.type.reflectedType,
        param.hasDefaultValue?param.defaultValue.reflectee:null,
        (dynamic v)=> setNamedValue(param, v),
        name:'{ ${param.type.reflectedType} ${MirrorSystem.getName(param.simpleName)} : ${param.hasDefaultValue ? '${param.defaultValue.reflectee}' : 'null'} }');
    }
  }
}