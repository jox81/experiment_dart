#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:analyzer/src/generated/java_io.dart';
import 'package:analyzer/src/generated/sdk.dart' show DartSdk;
import 'package:analyzer/src/generated/sdk_io.dart' show DirectoryBasedDartSdk;
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/generated/source_io.dart';
import 'package:analyzer/file_system/file_system.dart' hide File;
import 'package:analyzer/file_system/physical_file_system.dart';

void main(List<String> args) {
  print('working dir ${new File('..').resolveSymbolicLinksSync()}');

  if (args.length < 2 || args.length > 3) {
    print(_usage);
    exit(0);
  }

  String packageRoot;
  if (args.length == 3) {
    packageRoot = args[2];
  }

  JavaSystemIO.setProperty("com.google.dart.sdk", args[0]);
  DartSdk sdk = DirectoryBasedDartSdk.defaultSdk;

  var resolvers = [
    new DartUriResolver(sdk),
    new PackageUriResolver([new JavaFile("")]),
    new ResourceUriResolver(PhysicalResourceProvider.INSTANCE)
  ];

  if (packageRoot != null) {
    var packageDirectory = new JavaFile(packageRoot);
    resolvers.add(new PackageUriResolver([packageDirectory]));
  }

  CompilationUnit resolvedUnit = getAstResolved(resolvers, new JavaFile(args[1]));

//  String path2 = (resolvedUnit.directives[0] as ImportDirective).source.fullName;
//  CompilationUnit resolvedUnitMaterial = getAstResolved(resolvers, new JavaFile(path2));


  var visitor = new _ASTVisitor();
  resolvedUnit.accept(visitor);
}

CompilationUnit getAstResolved(List resolvers, JavaFile javaFile) {
  AnalysisContext context = AnalysisEngine.instance.createAnalysisContext()
    ..sourceFactory = new SourceFactory(resolvers);

  Source source = new FileBasedSource(javaFile);
  ChangeSet changeSet = new ChangeSet()..addedSource(source);
  context.applyChanges(changeSet);
  LibraryElement libElement = context.computeLibraryElement(source);
  print("libElement: $libElement");

  CompilationUnit resolvedUnit =
  context.resolveCompilationUnit(source, libElement);
  return resolvedUnit;
}

List flatten_tree(AstNode n,[int depth=9999999]){
  var que = [];
  que.add(n);
  var nodes = [];
  int nodes_count = que.length;
  int dep = 0;
  int c = 0;
  if(depth == 0) return [n];
  while(que.isNotEmpty){
    var node = que.removeAt(0);
    if(node is! AstNode) continue;
    for(var cn in node.childEntities){
      nodes.add(cn);
      que.add(cn);
    }
    //Keeping track of how deep in the tree
    ++c;
    if(c == nodes_count){
      ++ dep; // One layer done
      if(depth <= dep) return nodes;
      c = 0;
      nodes_count = que.length;
    }
  }
  return nodes;
}

const _usage =
    'Usage: resolve_driver <path_to_sdk> <file_to_resolve> [<packages_root>]';

class _ASTVisitor extends GeneralizingAstVisitor {
  @override
  visitNode(AstNode node) {
    var lines = <String>['${node.runtimeType} : <"$node">'];
    if (node is SimpleIdentifier) {
      Element element = node.staticElement;
      if (element != null) {
        lines.add('  element: ${element.runtimeType}');
        LibraryElement library = element.library;
        if (library != null) {
          var fullName =
              element.library.definingCompilationUnit.source.fullName;
          lines.add("  from $fullName");
        }
      }
    }
    print(lines.join('\n'));
    return super.visitNode(node);
  }
}