import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/utils/utils_gltf.dart';

@TestOn("dartium")

void main() {
  group('GltfReader', () {
    test('File extensions', () async {
//      final gltfReader = new GltfReader.filename(null, '.gltf', null);
//      final glbReader = new GltfReader.filename(null, '.glb', null);
//      final invalidReader = new GltfReader.filename(null, '.glb2', null);
//
//      expect(gltfReader, const isInstanceOf<GltfJsonReader>());
//      expect(glbReader, const isInstanceOf<GlbReader>());
//      expect(invalidReader, isNull);
    });
//
//    test('Stream error', () async {
//      const ERROR_STRING = 'Stream error throwable';
//
//      StreamController<List<int>> controller;
//      controller = new StreamController<List<int>>(onListen: () {
//        controller
//          ..addError(ERROR_STRING)
//          ..close();
//      });
//
//      final reader = new GltfJsonReader(controller.stream);
//
//      try {
//        await reader.read();
//        // ignore: avoid_catches_without_on_clauses
//      } catch (e) {
//        expect(e, equals(ERROR_STRING));
//      }
//    });
//
//    test('Empty stream', () async {
//      final reader =
//          new GltfJsonReader(new Stream<List<int>>.fromIterable([<int>[]]));
//
//      final context = new Context()
//        ..addIssue(SchemaError.invalidJson,
//            args: ['FormatException: Unexpected end of input (at offset 0)']);
//
//      await reader.read();
//      expect(reader.context.errors, unorderedMatches(context.errors));
//    });
//
//    test('Invalid stream', () async {
//      final reader = new GltfJsonReader(
//          new Stream<List<int>>.fromIterable(['{]'.codeUnits]));
//
//      final context = new Context()
//        ..addIssue(SchemaError.invalidJson,
//            args: ['FormatException: Unexpected character (at offset 1)']);
//
//      await reader.read();
//      expect(reader.context.errors, unorderedMatches(context.errors));
//    });
//
//    test('Invalid root type', () async {
//      final reader = new GltfJsonReader(
//          new Stream<List<int>>.fromIterable(['[]'.codeUnits]));
//
//      final context = new Context()
//        ..addIssue(SchemaError.typeMismatch, args: ['[]', 'JSON object']);
//
//      await reader.read();
//      expect(reader.context.errors, unorderedMatches(context.errors));
//    });
//
//    test('Empty root object', () async {
//      final reader = new GltfJsonReader(
//          new Stream<List<int>>.fromIterable(['{}'.codeUnits]));
//
//      final context = new Context()
//        ..addIssue(SchemaError.undefinedProperty, name: 'asset');
//
//      await reader.read();
//      expect(reader.context.errors, unorderedMatches(context.errors));
//    });
//
//    test('Smallest possible asset', () async {
//      final reader = new GltfJsonReader(new Stream<List<int>>.fromIterable(
//          ['{"asset":{"version":"2.0"}}'.codeUnits]));
//
//      final result = await reader.read();
//
//      expect(reader.context.errors, isEmpty);
//      expect(reader.context.warnings, isEmpty);
//
//      expect(result.mimeType, 'model/gltf+json');
//      expect(result.gltf, const isInstanceOf<Gltf>());
//    });
  });
}
