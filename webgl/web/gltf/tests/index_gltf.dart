import 'package:webgl/src/camera.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'dart:async';
import 'package:gltf/gltf.dart' as glTF;

List<String> gltfTestsSamples = [
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


List<String> gltfSamples = [
  '/gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf'
];

Future main() async {
  String gltfUrl = gltfSamples.first;
  await debugGltf(gltfUrl);
}
