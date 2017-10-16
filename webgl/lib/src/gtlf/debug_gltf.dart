import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:async';
import 'package:gltf/gltf.dart' as glTF;

GLTFProject gltf;

Future<GLTFProject> debugGltf(String gltfUrl) async {
  gltf = await _loadGLTF(gltfUrl);
  _testScenes();
  _testNodes();
  _testMeshes();
  _testBuffers();
  _testBufferViews();
  _testAccessors();
  _testCameras();
  _testImages();
  _testSamplers();
  _testTextures();
  _testMaterials();

  return gltf;
}

Future<GLTFProject> _loadGLTF(String gltfUrl) async {
  glTF.Gltf gltfSource =
  await GLTFProject.loadGLTFResource(gltfUrl, useWebPath: true);
  GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);
  await gltf.fillBuffersData();
  assert(gltf != null);
  print('');
  print('> gltf file loaded : ${gltfUrl}');
  print('');

  return gltf;
}

void _testScenes() {
  Debug.log('Scenes', () {
    print('scene counts : ${gltf.scenes.length}');
    for (int i = 0; i < gltf.scenes.length; ++i) {
      print('> $i');
      GLTFScene scene = gltf.scenes[i];
      print('$scene');
    }
    print('');
  });
}

void _testNodes() {
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

void _testMeshes() {
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

void _testBuffers() {
  Debug.log('Buffers', () {
    print('Buffers counts : ${gltf.buffers.length}');
    for (int i = 0; i < gltf.buffers.length; ++i) {
      print('> $i');
      GLTFBuffer buffer = gltf.buffers[i];
      print('$buffer');
      if(buffer.data != null) {
        List<String> gltfBits = buffer.data.map((int v) => v.toRadixString(16))
            .toList();
        print('data hex formatted : $gltfBits');
      }
    }
    print('');
  });
}

void _testBufferViews() {
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

void _testAccessors() {
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

void _testCameras() {
  Debug.log('Cameras', () {
    print('Cameras counts : ${gltf.cameras.length}');

    for (int i = 0; i < gltf.cameras.length; ++i) {
      print('> $i');
      Camera camera = gltf.cameras[i];
      print('$camera');
    }
    print('');
  });
}

void _testImages() {
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

void _testSamplers() {
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

void _testTextures() {
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

void _testMaterials() {
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
