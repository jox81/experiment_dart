import 'dart:io';
import 'package:analyzer/analyzer.dart';

void generateUml(){
  Directory dir = Directory.current; //Project directory

  List<FileSystemEntity> dartFiles = dir.listSync(followLinks: false, recursive : true);
  dartFiles.retainWhere((r) => r is File && r.path.endsWith(".dart") );

  dartFiles.forEach((f){

    CompilationUnit compilationUnit = parseDartFile(f.path);

    for (var declaration in compilationUnit.declarations) {
      if (declaration is ClassDeclaration) {
        ClassDeclaration theClass = declaration;
        print('---------------------------------------------  ${f.path}');
        print('${theClass.isAbstract ? "<<abstract>> ":""}${theClass.name}');
        print('___');
        theClass.members.forEach((m){
          if(m is FieldDeclaration){
            FieldDeclaration field = m;
            print('${m.fields.variables[0].name.toString().startsWith("_")?"- ":"+ "}${field.isSynthetic?"<<static>> ":""}${m.fields.variables[0].name} ${m.fields.type}: ${m.fields.type}');
          }

          if(m is MethodDeclaration){
            MethodDeclaration method = m;
            String params = "";
            method.parameters.parameters.forEach((p){
              params += p.runtimeType;
            });
            print('${method.isGetter?"<<get>> ":method.isSetter?"<<set>> ":""}${method.name}( $params ) ${(method.returnType != null)?": ${method.returnType}" : ""}');

          }

        });
      }
    }
  });
}