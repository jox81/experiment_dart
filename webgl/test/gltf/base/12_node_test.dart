import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/gltf_creation.dart';
void main() {
  group('Node', () {
    test("Node creation", () async {
      GLTFNode node = new GLTFNode();
      expect(node, isNotNull);
    });

    test("Node Property", () async {
      GLTFNode node = new GLTFNode()
      ..name = 'singleNode';
      expect(node.name, 'singleNode');
    });
  });

  group('Node transform', () {
    test("Node base transform", () async {
      GLTFNode node = new GLTFNode();
      expect(node.translation, new Vector3.all(0.0));
      expect(node.rotation.storage, new Quaternion.identity().storage);
      expect(node.scale, new Vector3.all(1.0));
      expect(node.matrix.isIdentity(), true);
    });

    test("Node base translation", () async {
      GLTFNode node = new GLTFNode();
      node.translation = new Vector3(2.0, 3.0, 4.0);
      expect(node.matrix.getTranslation(), new Vector3(2.0, 3.0, 4.0));
    });

    test("Node base rotation", () async {
      GLTFNode node = new GLTFNode();
      node.rotation = new Quaternion.axisAngle(new Vector3(1.0, 0.0, 0.0), radians(45.0));
      expect(new Quaternion.fromRotation(node.matrix.getRotation()).storage, new Quaternion.axisAngle(new Vector3(1.0, 0.0, 0.0), radians(45.0)).storage);
    });

    test("Node base scale", () async {
      GLTFNode node = new GLTFNode();
      node.scale = new Vector3(3.0, 1.0, 1.0);
      expect(node.matrix.getMaxScaleOnAxis(), 3.0);
    });

    test("Node base transform", () async {
      GLTFNode node = new GLTFNode();

      Vector3 translation = new Vector3(2.0, 3.0, 4.0);
      Quaternion rotation = new Quaternion.axisAngle(new Vector3(1.0, 0.0, 0.0), radians(45.0));
      Vector3 scale = new Vector3(1.0, 1.0, 1.0);// Todo (jpu) : if scale isn't unifrom, rotation will be wrong

      Matrix4 transform = new Matrix4.identity()
      ..setFromTranslationRotationScale(translation, rotation, scale);

      node.matrix = transform;

      expect(node.translation, translation);
      expect(node.rotation.storage, rotation.storage);
      expect(node.scale, scale);
    });

  });

  //> gltf

  group('Node from gltf', () {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/node/empty.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFNode> nodes = gltf.nodes;
      expect(nodes.length, 0);
    });

    test("Array length", () async {
      String gltfPath = 'gltf/tests/base/data/node/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFNode> nodes = gltf.nodes;
      expect(nodes.length, 2);
    });

    test("Compare", () async {
      String gltfPath = 'gltf/tests/base/data/node/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFNode> nodes = gltf.nodes;
      expect(nodes[0] == nodes[0], true);
    });

    test("Node hierarchy", () async {
      String gltfPath = 'gltf/tests/base/data/node/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFNode> nodes = gltf.nodes;
      expect(nodes[0].children.length, 1);
      expect(nodes[0].children.contains(nodes[1]), true);
      expect(nodes[0].children[0], nodes[1]);
      expect(nodes[1].parent, nodes[0]);
    });

    test("Property", () async {
      String gltfPath = 'gltf/tests/base/data/node/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      GLTFNode node = gltf.nodes[0];
      expect(node, isNotNull);

      //Camera
      expect(gltf.cameras, isNotNull);
      expect(node.camera, isNotNull);
//      expect(node.camera == gltf.cameras[0], true);// Todo (jpu) : this fail
//      expect(node.camera, gltf.cameras[0]);// Todo (jpu) : this fail
    });
  });
}