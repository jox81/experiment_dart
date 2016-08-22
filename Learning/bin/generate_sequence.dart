import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

StringBuffer buffer = new StringBuffer();

void main(){

  //Code from : stagexl-0.13.2/lib/src/animation/animation_chain.dart
  String dartCode01 = """
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

  String dartCode02 = """
    bool advanceTime(num time) {

    _averageFrameRate = 0.05 / time + 0.95 * _averageFrameRate;

    var children = _container.children;
    var childCount = max(1, children.length);
    var deltaCount = (_averageFrameRate / targetFrameRate - 1.0) * childCount;
    var speedCount = min(50, pow(deltaCount.abs().ceil(), 0.30));
    var scale = pow(0.99, childCount / 512);

    _container.rotation += time * 0.5;
    _container.scaleX = _container.scaleY = scale;

    // add a few bitmaps

    if (deltaCount > 0) {
      for(int i = 0; i < speedCount; i++) {
        var bitmap = new Bitmap(bitmapData);
        var bitmapScale = 1.0 / scale;
        var angle  = _random.nextDouble() * PI * 2.0;
        var distance = (50 + _random.nextInt(150)) * bitmapScale;
        bitmap.x = cos(angle) * distance;
        bitmap.y = sin(angle) * distance;
        bitmap.pivotX = bitmapData.width / 2.0;
        bitmap.pivotY = bitmapData.height / 2.0;
        bitmap.rotation = angle + PI / 2.0;
        bitmap.scaleX = bitmap.scaleY = bitmapScale;
        children.add(bitmap);
      }
    }

    // remove a few bitmaps

    if (deltaCount < 0) {
      speedCount = min(speedCount, children.length);
      for(int i = 0; i < speedCount; i++) {
        children.removeLast();
      }
    }

    // check for steady state

    _counterElement.text = children.length.toString();

    if (_deltaToggleSign != deltaCount.sign) {
      _deltaToggleSign = deltaCount.sign;
      _deltaToggleCount += 1;
    }

    if (_deltaToggleCount >= 10) {
      _container.removeFromParent();
      _benchmarkComplete();
      return false;
    } else {
      return true;
    }
  }
  """;

  generateSequence(dartCode02);
}

void generateSequence(String dartCode) {
  CompilationUnit compilationUnit = parseCompilationUnit(dartCode);

  buffer.writeln('@startuml');


  /*
  partition Initialization {
    :read config file;
    :init internal variable;
  }
   */
  for (CompilationUnitMember declaration in compilationUnit.declarations) {
    if(declaration is FunctionDeclaration){
      buffer.writeln('partition ${declaration.name.toString()} {');//Todo : How to add parameters
      buffer.writeln('start');
      if(declaration.functionExpression.body is BlockFunctionBody){
        Block block = (declaration.functionExpression.body as BlockFunctionBody).block;
        analyzeBlock(block);
      }else{
        buffer.writeln('!!BlockFunctionBody');
      }
      if(declaration.returnType.toString() == 'void') {
        buffer.writeln('stop');
      }
      buffer.writeln('}');
    }else if (declaration is TopLevelVariableDeclaration){
      buffer.writeln('#CCCCCC:$declaration');
    }else{
      buffer.writeln('!!FunctionDeclaration');
    }
  }

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
    buffer.writeln('stop'); //Return value
  }else if(statement is VariableDeclarationStatement){
    buffer.writeln('#AACCCC: ${statement}');
  }else if(statement is ForStatement){
    getForStatementContent(statement);
  }else if(statement is ForEachStatement){
    getForEachStatementContent(statement);
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

  buffer.writeln('#CCFFCC:$statement');
}

void getIfStatementContent(IfStatement statement, bool withElse) {
  buffer.writeln('${withElse?'else ':''}if(${statement.condition} ?) then (yes)');

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
      buffer.writeln('else (no)');
      analyzeBlock(elseStatement);
    }else if(statement.elseStatement is IfStatement){
      getIfStatementContent(statement.elseStatement, true);
    }else{
      analyzeStatement(statement.elseStatement);
    }
  }

  if(!withElse){
    buffer.writeln('endif');
  }

}

void getForStatementContent(ForStatement statement) {

  buffer.writeln('repeat');

  if(statement.body is Block){
    Block thenStatement = statement.body;
    analyzeBlock(thenStatement);
  }else{
    buffer.writeln('!!getForStatementContent');
  }

  buffer.writeln('repeat while (${statement.condition} ?) -[#black,dotted]-> infos');
}

void getForEachStatementContent(ForEachStatement statement) {

  buffer.writeln('repeat');

  if(statement.body is Block){
    Block blockStatement = statement.body;
    analyzeBlock(blockStatement);
  }else{
    buffer.writeln('!!getForEachStatementContent');
  }

  buffer.writeln('repeat while (${statement.loopVariable.identifier} in ${statement.iterable} ?) -[#black,dotted]-> infos');
}