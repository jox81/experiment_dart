import 'dart:async';
import 'dart:html';

import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/project/project.dart';

List<String> gltfTestsSamples = [
  ///Buffer tests
//  './base/data/buffer/empty.gltf',
//  './base/data/buffer/valid_full.gltf',

  ///BufferView tests
//  './base/data/buffer_view/empty.gltf',
//  './base/data/buffer_view/empty.gltf',
//  './base/data/buffer_view/valid_full.gltf',

  ///Camera tests
//  './base/data/camera/empty.gltf',
//  './base/data/camera/valid_full.gltf',

  ///Images
//  './base/data/image/empty.gltf',
//  './base/data/image/valid_full.gltf',
//  './base/data/image/invalid_mime_type_buffer_view.gltf',

  ///Samplers
//  './base/data/sampler/empty.gltf',
//  './base/data/sampler/valid_full.gltf',

  ///Textures
//  './base/data/texture/empty.gltf',
//  './base/data/texture/valid_full.gltf',

  ///Materials
//  './base/data/material/empty.gltf',
//  './base/data/material/valid_full.gltf',

  ///Accessors
//  './base/data/accessor/empty.gltf',
//  './base/data/accessor/get_elements.gltf',
//  './base/data/accessor/alignment.gltf',
//  './base/data/accessor/valid_full.gltf',

  /// Meshes
//  './base/data/mesh/empty.gltf',
//  './base/data/mesh/empty_object.gltf',
//  './base/data/mesh/valid_full.gltf',

  ///Scenes
//  './base/data/scene/empty.gltf',
//  './base/data/scene/valid_full.gltf',

  /// Nodes
//  './base/data/node/empty.gltf',
//  './base/data/node/valid_full.gltf',
];


List<String> gltfSamples = [
  '/gltf/samples/gltf_2_0/00_triangle_without_indices/gltf_embed/TriangleWithoutIndices.gltf',
//  '/gltf/samples/gltf_2_0/01_triangle_with_indices/gltf_embed/Triangle.gltf',
//  '/gltf/samples/gltf_2_0/02_simple_meshes/gltf_embed/SimpleMeshes.gltf',
//  '/gltf/samples/gltf_2_0/plane_textured/test_texture.gltf',
//  '/gltf/samples/gltf_2_0/05_box/gltf_embed/Box.gltf',

  ///basic exemple
  //  './gltfsamples/gltf_2_0/minimal.gltf',
];

Future main() async {
  CanvasElement canvas = new CanvasElement();
  GLTFEngine engine = new GLTFEngine(canvas);

  GLTFProject project = await Engine.assetsManager.loadGLTFProject(gltfSamples.first, useWebPath : true);
  project.debug(doProjectLog : true, isDebug:false);
}