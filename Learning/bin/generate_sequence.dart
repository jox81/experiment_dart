import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

StringBuffer buffer = new StringBuffer();

void main(){

  //Code from : stagexl-0.13.2/lib/src/animation/animation_chain.dart
  String dartCode = """
  var a;

  @override
  bool advanceTime(num time) {

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

  buffer.writeln('@startuml');
  buffer.writeln('start');

  /*
  partition Initialization {
    :read config file;
    :init internal variable;
}
   */
  for (CompilationUnitMember declaration in compilationUnit.declarations) {
    if(declaration is FunctionDeclaration){
      buffer.writeln('partition ${declaration.name.toString()} {');//Todo : How to add parameters
      if(declaration.functionExpression.body is BlockFunctionBody){
        Block block = (declaration.functionExpression.body as BlockFunctionBody).block;
        analyzeBlock(block);
      }else{
        buffer.writeln('!!BlockFunctionBody');
      }
      buffer.writeln('}');
    }else if (declaration is TopLevelVariableDeclaration){
      buffer.writeln(':$declaration');
    }else{
      buffer.writeln('!!FunctionDeclaration');
    }
  }

  buffer.writeln('stop');
  buffer.writeln('@enduml');

  print(buffer.toString());
}

void analyzeBlock(Block block) {
  if(block is BlockImpl){
    analyzeStatements(block.statements);
  }else{
    buffer.writeln('!!analyzeBlock');
  }
}

void analyzeStatements(NodeList<Statement> statements) {
  for(Statement statement in statements){
    analyzeStatement(statement);
  }
}

void analyzeStatement(Statement statement) {
  if(statement is ExpressionStatement){
    getExpressionStatementContent(statement);
  }else if(statement is IfStatement){
    getIfStatementContent(statement, false);
  }else if(statement is ReturnStatement){
    buffer.writeln('stop'); //Todo : How to set return value
  }else{
    buffer.writeln('!!analyzeStatement');
  }
}

void getExpressionStatementContent(ExpressionStatement statement) {

  if(statement is AssignmentExpression){
    //buffer.writeln('AssignmentExpression');
  }else{
    //buffer.writeln('!!AssignmentExpression');
  }

  buffer.writeln(':$statement');
}

void getIfStatementContent(IfStatement statement, bool withElse) {
  buffer.writeln('${withElse?'else ':''}if(${statement.condition}) then');

  if(statement.thenStatement != null) {
    if(statement.thenStatement is Block){
      Block thenStatement = statement.thenStatement;
      analyzeBlock(thenStatement);
    }else{
      getExpressionStatementContent(statement.thenStatement);
    }
  }
  if(statement.elseStatement != null) {
    if(statement.elseStatement is Block) {
      Block elseStatement = statement.elseStatement;
      buffer.writeln('else');
      analyzeBlock(elseStatement);
    }else if(statement.elseStatement is IfStatement){
      getIfStatementContent(statement.elseStatement, true);
    }else{
      buffer.writeln('!statement.thenStatement IfStatement');
    }
  }

  if(!withElse){
    buffer.writeln('endif');
  }

}

void getElseIfStatementContent(IfStatement statement) {

}