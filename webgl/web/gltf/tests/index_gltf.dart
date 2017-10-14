import 'package:webgl/src/camera.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/utils/utils_gltf.dart';
import 'dart:async';
import 'package:gltf/gltf.dart' as glTF;

//int gltfSampleIndex = 7;
List<String> gltfSamples = [
  ///Buffer tests
//  'gltf/tests/base/data/buffer/empty.gltf',
//  'gltf/tests/base/data/buffer/valid_full.gltf',

  ///BufferView tests
//  'gltf/tests/base/data/buffer_view/empty.gltf',
//  'gltf/tests/base/data/buffer_view/empty.gltf',
//  'gltf/tests/base/data/buffer_view/valid_full.gltf',

  ///Camera tests
//  'gltf/tests/base/data/camera/empty.gltf',
//  'gltf/tests/base/data/camera/valid_full.gltf',

  ///Images
//  'gltf/tests/base/data/image/empty.gltf',
//  'gltf/tests/base/data/image/valid_full.gltf',
//  'gltf/tests/base/data/image/invalid_mime_type_buffer_view.gltf',

  ///Samplers
//  'gltf/tests/base/data/sampler/empty.gltf',
//  'gltf/tests/base/data/sampler/valid_full.gltf',

  ///Textures
//  'gltf/tests/base/data/texture/empty.gltf',
//  'gltf/tests/base/data/texture/valid_full.gltf',

  ///Materials
//  'gltf/tests/base/data/material/empty.gltf',
//  'gltf/tests/base/data/material/valid_full.gltf',

  ///Accessors
//  'gltf/tests/base/data/accessor/empty.gltf',
//  'gltf/tests/base/data/accessor/get_elements.gltf',
//  'gltf/tests/base/data/accessor/alignment.gltf',
//  'gltf/tests/base/data/accessor/valid_full.gltf',

  /// Meshes
//  'gltf/tests/base/data/mesh/empty.gltf',
//  'gltf/tests/base/data/mesh/empty_object.gltf',
//  'gltf/tests/base/data/mesh/valid_full.gltf',

  ///Scenes
//  'gltf/tests/base/data/scene/empty.gltf',
//  'gltf/tests/base/data/scene/valid_full.gltf',

  /// Nodes
//  'gltf/tests/base/data/node/empty.gltf',
  'gltf/tests/base/data/node/valid_full.gltf',

  ///Others scenes
//  'gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf',
//  'gltf/samples/gltf_2_0/minimal.gltf',
];

GLTFProject gltf;

Future main() async {
  await loadGLTF();
  testBuffers();
  testBufferViews();
  testCameras();
  testImages();
  testSamplers();
  testTextures();
  testMaterials();
  testAccessors();
  testMeshes();
  testScenes();
  testNodes();
}

Future loadGLTF() async {
  String gltfUrl = gltfSamples.first;
  glTF.Gltf gltfSource =
      await GLTFProject.loadGLTFResource(gltfUrl, useWebPath: true);
  gltf = new GLTFProject.fromGltf(gltfSource);
  assert(gltf != null);
  print('');
  print('> gltf file loaded : ${gltfUrl}');
  print('');
}

void testBuffers() {
  Debug.log('Buffers', () {
    print('Buffers counts : ${gltf.buffers.length}');
    for (int i = 0; i < gltf.buffers.length; ++i) {
      print('> $i');
      GLTFBuffer buffer = gltf.buffers[i];
      print('$buffer');
    }
    print('');
  });
}

void testBufferViews() {
  Debug.log('BufferViews', () {
    print('BufferViews counts : ${gltf.bufferViews.length}');
    for (int i = 0; i < gltf.bufferViews.length; ++i) {
      print('> $i');
      GLTFBufferView bufferView = gltf.bufferViews[i];
      print('$bufferView');
    }
    print('');
  });
}

void testCameras() {
  Debug.log('Cameras', () {
    print('Cameras counts : ${gltf.cameras.length}');

    assert(gltf.cameras[0] is GLTFCameraPerspective);
    for (int i = 0; i < gltf.cameras.length; ++i) {
      print('> $i');
      Camera camera = gltf.cameras[i];
      print('$camera');
    }
    print('');
  });
}

void testImages() {
  Debug.log('Images', () {
    print('Images counts : ${gltf.cameras.length}');
    for (int i = 0; i < gltf.images.length; ++i) {
      print('> $i');
      GLTFImage image = gltf.images[i];
      print('$image');
    }
    print('');
  });
}

void testSamplers() {
  Debug.log('Samplers', () {
    print('Sample counts : ${gltf.samplers.length}');
    for (int i = 0; i < gltf.samplers.length; ++i) {
      print('> $i');
      GLTFSampler sampler = gltf.samplers[i];
      print('$sampler');
    }
    print('');
  });
}

void testTextures() {
  Debug.log('Textures', () {
    print('texture counts : ${gltf.textures.length}');
    for (int i = 0; i < gltf.textures.length; ++i) {
      print('> $i');
      GLTFTexture texture = gltf.textures[i];
      print('$texture');
    }
    print('');
  });
}

void testMaterials() {
  Debug.log('Materials', () {
    print('material counts : ${gltf.materials.length}');
    for (int i = 0; i < gltf.materials.length; ++i) {
      print('> $i');
      GLTFMaterial material = gltf.materials[i];
      print('$material');
    }
    print('');
  });
}

void testAccessors() {
  Debug.log('Accessors', () {
    print('accessors counts : ${gltf.accessors.length}');
    for (int i = 0; i < gltf.accessors.length; ++i) {
      print('> $i');
      GLTFAccessor accessor = gltf.accessors[i];
      print('$accessor');
    }
    print('');
  });
}

void testMeshes() {
  Debug.log('Meshes', () {
    print('meshes counts : ${gltf.meshes.length}');
    for (int i = 0; i < gltf.meshes.length; ++i) {
      print('> $i');
      GLTFMesh mesh = gltf.meshes[i];
      print('$mesh');
    }
    print('');
  });
}

void testScenes() {
  Debug.log('Scenes', () {
    print('meshes counts : ${gltf.scenes.length}');
    for (int i = 0; i < gltf.scenes.length; ++i) {
      print('> $i');
      GLTFScene scene = gltf.scenes[i];
      print('$scene');
    }
    print('');
  });
}

void testNodes() {
  Debug.log('Nodes', () {
    print('nodes counts : ${gltf.nodes.length}');
    for (int i = 0; i < gltf.nodes.length; ++i) {
      print('> $i');
      GLTFNode node = gltf.nodes[i];
      print('$node');
    }
    print('');
  });
}
