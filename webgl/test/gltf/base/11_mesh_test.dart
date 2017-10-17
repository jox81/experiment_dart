import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/project.dart';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

void main() {
  group('Mesh', () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/mesh/empty.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFMesh> meshes = gltf.meshes;
      expect(meshes.length, 0);
    });

    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/mesh/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFMesh> meshes = gltf.meshes;
      expect(meshes.length, 1);
    });

    test("Property primitive", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/mesh/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFMesh mesh = gltf.meshes[0];
      expect(mesh, isNotNull);

      expect(mesh.primitives.length, 1);
    });

    test("Property weights", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/mesh/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFMesh mesh = gltf.meshes[0];
      expect(mesh, isNotNull);

      expect(mesh.weights.length, 2);
    });
  });

  group('MeshPrimitive', () {
    test("Property primitive", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/mesh/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFMesh mesh = gltf.meshes[0];
      expect(mesh, isNotNull);

      GLTFMeshPrimitive primitive = mesh.primitives[0];
      expect(primitive, isNotNull);

      expect(primitive.attributes.length, isNotNull);
      expect(primitive.mode, DrawMode.TRIANGLES);

    });
  });
}