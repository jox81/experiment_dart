import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

void main(){

  //Code from : stagexl-0.13.2/lib/src/animation/animation_chain.dart
  String dartCode = """
  @override
  bool advanceTime(num time) {

    _time += time;

    if (_started == false) {
      if (_time > _delay) {
        _started = true;
        if (_onStart != null) _onStart();
      } else {
        return true;
      }
    }

    if (_animatables.length > 0) {
      if (_animatables[0].advanceTime(time) == false) {
        _animatables.removeAt(0);
      }
    }

    if (_animatables.length == 0) {
      _completed = true;
      if (_onComplete != null) _onComplete();
      return false;
    } else {
      return true;
    }
  }
  """;
  CompilationUnit compilationUnit = parseCompilationUnit(dartCode);

  StringBuffer buffer = new StringBuffer();

  buffer.writeln('@startuml');
  buffer.writeln('A -> B');

  for (CompilationUnitMember declaration in compilationUnit.declarations) {
    if(declaration is FunctionDeclaration){
      if(declaration.functionExpression.body is BlockFunctionBody){
        NodeList<Statement> statements = (declaration.functionExpression.body as BlockFunctionBody).block.statements;
        for(Statement statement in statements){
          if(statement is ExpressionStatement){
            buffer.writeln(statement);
          }
          if(statement is IfStatement){
            buffer.writeln('alt ${statement.condition}');

            if(statement.elseStatement != null) {
              buffer.writeln('else ${statement.elseStatement}');
            }
            if(statement.thenStatement != null) {
              buffer.writeln('else ${statement.thenStatement}');
            }

            buffer.writeln('end');
          }
        }
      }
    }
  }

  buffer.writeln('@enduml');

  print(buffer.toString());
}