import 'package:reflectable/reflectable.dart';
import 'reflector.dart';

//@reflector
class FunctionModel{
  final Function function;
  final InstanceMirror instancesMirror;
  final MethodMirror methodMirror;
  FunctionModel(this.function,this.instancesMirror, this.methodMirror);

  String getName(){
    return methodMirror.simpleName;
  }

  List<String> getParameters(){
    List<String> parameters = methodMirror.parameters.map((ParameterMirror p)=>'${p.type.simpleName} ${p.simpleName}').toList();
    return parameters;
  }

  List<String> getPositionalArgumentsString() {
    List<String> parameters = methodMirror.parameters.where((ParameterMirror p)=> !p.isNamed).map((ParameterMirror p)=>'${p.type.simpleName} ${p.simpleName}').toList();
    return parameters;
  }


  List<ParameterMirror> getPositionalArguments() {
    List<ParameterMirror> parameters = methodMirror.parameters.where((ParameterMirror p)=> !p.isNamed).toList();
    return parameters;
  }


  List<String> getNamedArgumentsString() {
    List<String> parameters = methodMirror.parameters.where((ParameterMirror p)=> p.isNamed).map((ParameterMirror p)=>'{${p.type.simpleName} ${p.simpleName} : ${p.reflectedType}}').toList();
    return parameters;
  }

  List<ParameterMirror> getNamedArguments() {
    List<ParameterMirror> parameters = methodMirror.parameters.where((ParameterMirror p)=> p.isNamed).toList();
    return parameters;
  }

  String getReturnType(){
    Type returnType;
    try{
      returnType = methodMirror.returnType.reflectedType;
    }catch(e){

    }
    return returnType != null ? returnType.toString() : 'void';
  }

  dynamic invoke(String memberName, List positionalArguments, Map<Symbol, dynamic> namedArguments) {
    InstanceMirror f = instancesMirror.invoke(memberName, positionalArguments, namedArguments) as InstanceMirror;
    return f.reflectee;
  }
}