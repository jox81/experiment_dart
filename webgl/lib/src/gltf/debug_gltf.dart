import 'dart:typed_data';

import 'package:webgl/src/gltf/accessor.dart';
import 'package:webgl/src/gltf/animation.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/gltf_creation.dart';
import 'package:webgl/src/gltf/image.dart';
import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/sampler.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/texture.dart';
import 'package:webgl/src/debug/utils_debug.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/gltf/project.dart';
import 'dart:async';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/debug/utils_debug.dart' as debug;

GLTFProject _gltf;

Future<GLTFProject> loadGLTF(String gltfUrl, {bool useWebPath : false}) async {

  // Todo (jpu) : assert path exist and get real file
  String filePart = new Uri.file(gltfUrl).pathSegments.last;
  String gtlfDirectory = gltfUrl.replaceFirst(filePart, '');

  glTF.Gltf gltfSource =
  await GLTFCreation.loadGLTFResource(gltfUrl, useWebPath: useWebPath);
  GLTFProject _gltf = await GLTFCreation.getGLTFProject(gltfSource, gtlfDirectory);

  assert(_gltf != null);
  print('');
  print('> _gltf file loaded : ${gltfUrl}');
  print('');

  return _gltf;
}

/// [gltfUrl] the url to find the gtlf file.
/// [doGlTFProjectLog] log gltf items infos
/// [isDebug] log traces
GLTFProject debugGltf(GLTFProject gltfProject, {bool doGlTFProjectLog : false, bool isDebug:false}) {
  debug.isDebug = isDebug;
  _gltf = gltfProject;
  if(doGlTFProjectLog) {
    _testScenes();
    _testNodes();
    _testMeshes();
    _testAccessors();
    _testBufferViews();
    _testBuffers();
    _testCameras();
    _testImages();
    _testSamplers();
    _testTextures();
    _testMaterials();
    _testAnimations();
  }
  return _gltf;
}

void _testScenes() {
  Debug.log('Scenes', () {
    print('scene counts : ${_gltf.scenes.length}');
    for (int i = 0; i < _gltf.scenes.length; i++) {
      print('> $i');
      GLTFScene scene = _gltf.scenes[i];
      print('$scene');
    }
    print('');
  });
}

void _testNodes() {
  Debug.log('Nodes', () {
    print('nodes counts : ${_gltf.nodes.length}');
    for (int i = 0; i < _gltf.nodes.length; i++) {
      print('> $i');
      GLTFNode node = _gltf.nodes[i];
      print('$node');
    }
    print('');
  });
}

void _testMeshes() {
  Debug.log('Meshes', () {
    print('meshes counts : ${_gltf.meshes.length}');
    for (int i = 0; i < _gltf.meshes.length; i++) {
      print('> $i');
      GLTFMesh mesh = _gltf.meshes[i];
      print('$mesh');
    }
    print('');
  });
}

void _testAccessors() {
  Debug.log('Accessors', () {
    print('accessors counts : ${_gltf.accessors.length}');
    for (int i = 0; i < _gltf.accessors.length; i++) {
      print('> $i');
      GLTFAccessor accessor = _gltf.accessors[i];
      print('$accessor');

      if(accessor.componentType == 5126) {
        Float32List verticesInfos = accessor.bufferView.buffer.data.buffer
            .asFloat32List(
            accessor.bufferView.byteOffset + accessor.byteOffset,
            accessor.count * accessor.components);
        print(verticesInfos);
      }else if(accessor.componentType == 5123){
        Uint16List indices = accessor.bufferView.buffer.data.buffer
            .asUint16List(accessor.byteOffset, accessor.count);
        print(indices);
      }
    }
    print('');
  });
}

void _testBufferViews() {
  Debug.log('BufferViews', () {
    print('BufferViews counts : ${_gltf.bufferViews.length}');
    for (int i = 0; i < _gltf.bufferViews.length; i++) {
      print('> $i');
      GLTFBufferView bufferView = _gltf.bufferViews[i];
      print('$bufferView');
    }
    print('');
  });
}

void _testBuffers() {
  Debug.log('Buffers', () {
    print('Buffers counts : ${_gltf.buffers.length}');
    for (int i = 0; i < _gltf.buffers.length; i++) {
      print('> $i');
      GLTFBuffer buffer = _gltf.buffers[i];
      print('$buffer');
      if(buffer.data != null) {
        List<String> gltfBits = buffer.data.map((int v) => v.toRadixString(16))
            .toList();
        print('data hex formatted : $gltfBits');
        print('data as byte : ${buffer.data}');
        print('data as Int16List : ${buffer.data.buffer.asInt16List()}');
        print('data as Int32List : ${buffer.data.buffer.asInt32List()}');
        print('data as Float32List : ${buffer.data.buffer.asFloat32List()}');
      }
    }
    print('');
  });
}

void _testCameras() {
  Debug.log('Cameras', () {
    print('Cameras counts : ${_gltf.cameras.length}');

    for (int i = 0; i < _gltf.cameras.length; i++) {
      print('> $i');
      Camera camera = _gltf.cameras[i];
      print('$camera');
    }
    print('');
  });
}

void _testImages() {
  Debug.log('Images', () {
    print('Images counts : ${_gltf.cameras.length}');
    for (int i = 0; i < _gltf.images.length; i++) {
      print('> $i');
      GLTFImage image = _gltf.images[i];
      print('$image');
    }
    print('');
  });
}

void _testSamplers() {
  Debug.log('Samplers', () {
    print('Sample counts : ${_gltf.samplers.length}');
    for (int i = 0; i < _gltf.samplers.length; i++) {
      print('> $i');
      GLTFSampler sampler = _gltf.samplers[i];
      print('$sampler');
    }
    print('');
  });
}

void _testTextures() {
  Debug.log('Textures', () {
    print('texture counts : ${_gltf.textures.length}');
    for (int i = 0; i < _gltf.textures.length; i++) {
      print('> $i');
      GLTFTexture texture = _gltf.textures[i];
      print('$texture');
    }
    print('');
  });
}

void _testMaterials() {
  Debug.log('Materials', () {
    print('material counts : ${_gltf.materials.length}');
    for (int i = 0; i < _gltf.materials.length; i++) {
      print('> $i');
      GLTFPBRMaterial material = _gltf.materials[i];
      print('$material');
    }
    print('');
  });
}

void _testAnimations() {
  Debug.log('Animations', () {
    print('animations counts : ${_gltf.animations.length}');
    for (int i = 0; i < _gltf.animations.length; i++) {
      print('> $i');
      GLTFAnimation animation = _gltf.animations[i];
      print('$animation');
    }
    print('');
  });
}