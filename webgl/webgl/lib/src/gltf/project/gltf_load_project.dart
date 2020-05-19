import 'package:webgl/introspection.dart';
import 'package:webgl/src/gltf/camera/types/orthographic_camera.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/camera/camera_type.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/gltf/accessor/accessor_sparse.dart';
import 'package:webgl/src/gltf/accessor/accessor_sparse_indices.dart';
import 'package:webgl/src/gltf/accessor/accessor_sparse_values.dart';
import 'package:webgl/src/gltf/animation/animation_channel.dart';
import 'package:webgl/src/gltf/animation/animation_channel_target.dart';
import 'package:webgl/src/gltf/animation/animation_sampler.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
import 'package:webgl/src/gltf/texture_info/normal_texture_info.dart';
import 'package:webgl/src/gltf/texture_info/occlusion_texture_info.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/texture_info/texture_info.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/animation/animation.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/image.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/sampler.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/texture.dart';
import 'package:webgl/src/gltf/camera/camera.dart';
import 'dart:core';
import 'dart:typed_data';
import 'dart:async';
import 'package:webgl/src/gltf/pbr_material.dart';

/// Cette classe est utilisée lors du chargement d'un fichier .gltf
//@reflector
class GLTFLoadProject extends GLTFProject{

  glTF.Gltf _gltfSource;

  GLTFLoadProject();

  Future initFromSource(glTF.Gltf _gltfSource ) async {
    GLTFEngine.currentProject.reset();
    assert(_gltfSource != null);
    this._gltfSource = _gltfSource;

    asset = new GLTFAsset(_gltfSource.asset.version);

    //Buffers
    for (glTF.Buffer gltfBuffer in _gltfSource.buffers) {
      _createBuffer(gltfBuffer);
    }

    //BufferViews
    for (glTF.BufferView gltfBufferView in _gltfSource.bufferViews) {
      _createBufferView(gltfBufferView);
    }

    //Images
    for (glTF.Image gltfSource in _gltfSource.images) {
      _createImage(gltfSource);
    }

    //Samplers
    for (glTF.Sampler gltfSource in _gltfSource.samplers) {
      _createSampler(gltfSource);
    }

    //Textures
    for (glTF.Texture gltfTexture in _gltfSource.textures) {
      _createTexture(gltfTexture);
    }

    //Materials
    for (glTF.Material gltfMaterial in _gltfSource.materials) {
      _createMaterial(gltfMaterial);
    }

    //Accessors
    for (glTF.Accessor gltfAccessor in _gltfSource.accessors) {
      _createAccessor(gltfAccessor);
    }

    //Cameras
    for (glTF.Camera gltfCamera in _gltfSource.cameras) {
      _createCamera(gltfCamera);
    }

    //Meshes
    for (glTF.Mesh gltfMesh in _gltfSource.meshes) {
      _createMesh(gltfMesh);
    }

    //Nodes
    for (glTF.Node gltfNode in _gltfSource.nodes) {
      _createNode(gltfNode);
    }

    //Nodes hierarchy parenting
    for (glTF.Node gltfNode in _gltfSource.nodes) {
      if (gltfNode.children != null && gltfNode.children.length > 0) {
        GLTFNode node = _getNode(gltfNode);
        node.children = gltfNode.children.map((n) => _getNode(n)).toList();
        node.children.forEach((n) => n.parent = node);
      }
    }

    //Scenes
    for (glTF.Scene gltfScene in _gltfSource.scenes) {
      _createScene(gltfScene);
    }
    if (_gltfSource.scene != null) {
      scene = _getScene(_gltfSource.scene);
    }

    //Animation
    for (glTF.Animation gltfAnimation in _gltfSource.animations) {
      _createAnimation(gltfAnimation);
    }

    //do not forget to initalise buffer somewhere after calling this method
  }

  GLTFBuffer _createBuffer(glTF.Buffer gltfSource) {
    if (gltfSource == null) return null;
    GLTFBuffer buffer = new GLTFBuffer(
        uri: gltfSource.uri,
        byteLength: gltfSource.byteLength,
        data: gltfSource.data,
        name: gltfSource.name);

    return buffer;
  }

  GLTFBuffer _getBuffer(glTF.Buffer buffer) {
    int id = _gltfSource.buffers.indexOf(buffer);
    return buffers.firstWhere((b) => b.bufferId == id,
        orElse: () => throw new Exception(
            'Buffer can only be bound to an existing project buffer'));
  }

  GLTFBufferView _createBufferView(glTF.BufferView gltfSource) {
    if (gltfSource == null) return null;

    GLTFBufferView bufferView = new GLTFBufferView(
        buffer: _getBuffer(gltfSource.buffer),
        byteLength: gltfSource.byteLength,
        byteOffset: gltfSource.byteOffset,
        byteStride: gltfSource.byteStride,
        usage: gltfSource.usage != null ? gltfSource.usage.target : null,
        target: gltfSource.usage != null ? gltfSource.usage.target : null, // Todo (jpu) : bug if -1 and usage == null. What to do ?
        name: gltfSource.name);

    return bufferView;
  }

  GLTFBufferView _getBufferView(glTF.BufferView bufferView) {
    int id = _gltfSource.bufferViews.indexOf(bufferView);
    return bufferViews.firstWhere((b) => b.bufferViewId == id,
        orElse: () => throw new Exception(
            'BufferView can only be bound to an existing project bufferView'));
  }

  GLTFAccessor _createAccessor(glTF.Accessor gltfSource) {
    if (gltfSource == null) return null;

    GLTFAccessor accessor = new GLTFAccessor(
        byteOffset: gltfSource.byteOffset,
        byteLength: gltfSource.byteLength,
        componentType: gltfSource.componentType,
        count: gltfSource.count,
        typeString: gltfSource.type,
//        type : ShaderVariableType.getByComponentAndType(gltfSource.componentType,gltfSource.type),
        elementLength: gltfSource.elementLength,
        components: gltfSource.components,
        normalized: gltfSource.normalized,
        componentLength: gltfSource.componentLength,
        max: gltfSource.max,
        min: gltfSource.min,
        byteStride: gltfSource.byteStride,
        sparse: gltfSource.sparse != null
            ? _createGLTFAccessorSparse(gltfSource.sparse)
            : null,
        isXyzSign: gltfSource.isXyzSign,
        isUnit: gltfSource.isUnit,
        name: gltfSource.name);

    if (gltfSource.bufferView != null) {
      GLTFBufferView bufferView = _getBufferView(gltfSource.bufferView);
      assert(bufferView.bufferViewId != null);

      accessor.bufferView = bufferView;
    }

    return accessor;
  }

  GLTFAccessor _getAccessor(glTF.Accessor accessor) {
    int id = _gltfSource.accessors.indexOf(accessor);
    GLTFAccessor result  = accessors.firstWhere((a) => a.accessorId == id,
        orElse: () => throw new Exception(
            'Attribut accessor can only be bound to an existing project accessor'));
    return result;
  }

  GLTFSampler _createSampler(glTF.Sampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFSampler sampler = new GLTFSampler(
        magFilter: gltfSource.magFilter != -1
            ? gltfSource.magFilter
            : TextureFilterType.LINEAR,
        minFilter: gltfSource.minFilter != -1
            ? gltfSource.minFilter
            : TextureFilterType.LINEAR,
        wrapS: gltfSource.wrapS,
        wrapT: gltfSource.wrapT,
        name: gltfSource.name);

    return sampler;
  }

  GLTFSampler _getSampler(glTF.Sampler sampler) {
    int id = _gltfSource.samplers.indexOf(sampler);
    return samplers.firstWhere((s) => s.samplerId == id,
        orElse: () => throw new Exception(
            'Texture Sampler can only be bound to an existing project sampler'));
  }

  GLTFImage _createImage(glTF.Image gltfSource) {
    if (gltfSource == null) return null;
    GLTFImage image = new GLTFImage(
        uri: gltfSource.uri,
        mimeType: gltfSource.mimeType,
        bufferView: _createBufferView(gltfSource.bufferView),
        data: gltfSource.data,
        name: gltfSource.name);

    return image;
  }

  GLTFImage _getImage(glTF.Image image) {
    int id = _gltfSource.images.indexOf(image);
    return images.firstWhere((i) => i.sourceId == id,
        orElse: () => throw new Exception(
            'Texture Image can only be bound to an existing project image'));
  }

  GLTFTexture _createTexture(glTF.Texture gltfSource) {
    if (gltfSource == null) return null;

    GLTFSampler sampler;
    if (gltfSource.sampler != null) {
      sampler = _getSampler(gltfSource.sampler);
    }

    GLTFImage image;
    if (gltfSource.source != null) {
      image = _getImage(gltfSource.source);
    }

    //Check if exist in project first
    GLTFTexture texture = _getTexture(gltfSource);
    if (texture == null) {
      texture = new GLTFTexture(
          sampler: sampler, source: image, name: gltfSource.name);
    } else {
      texture.sampler = sampler;
      texture.source = image;
    }

    return texture;
  }

  GLTFTexture _getTexture(glTF.Texture texture) {
    int id = _gltfSource.textures.indexOf(texture);
    return textures
        .firstWhere((t) => t.textureId == id, orElse: () => null);
  }

  GLTFPBRMaterial _createMaterial(glTF.Material gltfSource) {
    if (gltfSource == null) return null;

    GLTFPBRMaterial material = new GLTFPBRMaterial(
        pbrMetallicRoughness:
        _createGLTFPbrMetallicRoughness(gltfSource.pbrMetallicRoughness),
        normalTexture: gltfSource.normalTexture != null
            ? _createGLTFNormalTextureInfo(gltfSource.normalTexture)
            : null,
        occlusionTexture: gltfSource.occlusionTexture != null
            ? _createGLTFOcclusionTextureInfo(gltfSource.occlusionTexture)
            : null,
        emissiveTexture: gltfSource.emissiveTexture != null
            ? _createGLTFTextureInfo(gltfSource.emissiveTexture)
            : null,
        emissiveFactor: gltfSource.emissiveFactor,
        alphaMode: gltfSource.alphaMode,
        alphaCutoff: gltfSource.alphaCutoff,
        doubleSided: gltfSource.doubleSided,
        name: gltfSource.name);

    return material;
  }

  GLTFPBRMaterial _getMaterial(glTF.Material material) {
    int id = _gltfSource.materials.indexOf(material);
    return materials.firstWhere((m) => m.materialId == id,
        orElse: () => throw new Exception(
            'Mesh material can only be bound to an existing project material'));
  }

  GLTFCamera _createCamera(glTF.Camera gltfCamera) {
    GLTFCamera camera;
    if (gltfCamera != null) {
      if (gltfCamera.perspective != null) {
        camera = new GLTFCameraPerspective(gltfCamera.perspective.yfov,
            gltfCamera.perspective.znear, gltfCamera.perspective.zfar)
          ..type = CameraType.perspective
          ..aspectRatio = gltfCamera.perspective.aspectRatio
          ..name = gltfCamera.name;
      } else if (gltfCamera.orthographic != null) {
        camera = new GLTFCameraOrthographic()
          ..type = CameraType.orthographic
          ..znear = gltfCamera.orthographic.znear
          ..zfar = gltfCamera.orthographic.zfar
          ..xmag = gltfCamera.orthographic.xmag
          ..ymag = gltfCamera.orthographic.ymag
          ..name = gltfCamera.name;

        // Todo (jpu) :
//      cameraPerspective.extensions;
//      cameraPerspective.extras;
      }
    }

    return camera;
  }

  GLTFCamera _getCamera(glTF.Camera gltfCamera) {
    int id = _gltfSource.cameras.indexOf(gltfCamera);
    return cameras.firstWhere((c) => c.cameraId == id,
        orElse: () => throw new Exception(
            'GLTFCamera can only be bound to an existing project camera'));
  }

  GLTFMesh _createMesh(glTF.Mesh gltfSource) {
    if (gltfSource == null) return null;

    GLTFMesh mesh = new GLTFMesh(
        weights: gltfSource.weights != null
            ? (<double>[]..addAll(gltfSource.weights))
            : <double>[],
        name: gltfSource.name);

    mesh.primitives =
        gltfSource.primitives.map((p) => _createPrimitive(p)).toList();

    return mesh;
  }

  GLTFMesh _getMesh(glTF.Mesh mesh) {
    int id = _gltfSource.meshes.indexOf(mesh);
    return meshes.firstWhere((m) => m.meshId == id,
        orElse: () => throw new Exception(
            'Mesh can only be bound to an existing project mesh'));
  }

  GLTFNode _createNode(glTF.Node gltfSource) {
    if (gltfSource == null) return null;

    GLTFNode node = new GLTFNode(name: gltfSource.name);

    node.translation = gltfSource.translation;
    node.rotation = gltfSource.rotation;
    node.scale = gltfSource.scale;
    node.matrix = gltfSource.matrix;

    if (gltfSource.mesh != null) {
      GLTFMesh mesh = _getMesh(gltfSource.mesh);
      node.mesh = mesh;
    }

    if (gltfSource.camera != null) {
      GLTFCamera camera = _getCamera(gltfSource.camera);
      node.camera = camera;
    }

    return node;
  }

  GLTFNode _getNode(glTF.Node node) {
    int id = _gltfSource.nodes.indexOf(node);
    GLTFNode result =
     nodes.firstWhere((n) => n.nodeId == id,
        orElse: () => throw new Exception(
            'Node can only be binded to Nodes existing in project'));

    return result;
  }

  GLTFScene _createScene(glTF.Scene gltfSource) {
    if (gltfSource == null) return null;
    GLTFScene scene = new GLTFScene(name: gltfSource.name);

    //Scenes must be handled after nodes
    for (glTF.Node node in gltfSource.nodes) {
      GLTFNode gltfNode = _getNode(node);
      scene.addNode(gltfNode);
    }

    return scene;
  }

  GLTFScene _getScene(glTF.Scene scene) {
    int id = _gltfSource.scenes.indexOf(scene);
    return scenes.firstWhere((s) => s.sceneId == id,
        orElse: () => throw new Exception(
            'SCene can only be bound to Scene existing in project'));
  }

  GLTFPbrMetallicRoughness _createGLTFPbrMetallicRoughness(
      glTF.PbrMetallicRoughness gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFPbrMetallicRoughness(
        baseColorFactor: new Float32List.fromList(gltfSource.baseColorFactor),
        baseColorTexture: _createGLTFTextureInfo(gltfSource.baseColorTexture),
        metallicFactor: gltfSource.metallicFactor,
        roughnessFactor: gltfSource.roughnessFactor,
        metallicRoughnessTexture:
        _createGLTFTextureInfo(gltfSource.metallicRoughnessTexture));
  }

  GLTFMeshPrimitive _createPrimitive(glTF.MeshPrimitive gltfSource) {
    if (gltfSource == null) return null;
    GLTFMeshPrimitive meshPrimitive = new GLTFMeshPrimitive(
        drawMode:
        gltfSource.mode != null ? gltfSource.mode : DrawMode.TRIANGLES,
        hasPosition: gltfSource.hasPosition,
        hasNormal: gltfSource.hasNormal,
        hasTangent: gltfSource.hasTangent,
        colorCount: gltfSource.colorCount,
        jointsCount: gltfSource.jointsCount,
        weigthsCount: gltfSource.weightsCount,
        texcoordCount: gltfSource.texcoordCount);

    //attributs
    for (String key in gltfSource.attributes.keys) {
      GLTFAccessor accessor = _getAccessor(gltfSource.attributes[key]);
      meshPrimitive.attributes[key] = accessor;
    }

    //indices
    if (gltfSource.indices != null) {
      GLTFAccessor accessorIndices = _getAccessor(gltfSource.indices);
      assert(accessorIndices.accessorId != null);
      meshPrimitive.indicesAccessor = accessorIndices;
    }

    //material
    if (gltfSource.material != null) {
      GLTFPBRMaterial material = _getMaterial(gltfSource.material);
      meshPrimitive.baseMaterial = material;
    }
    return meshPrimitive;
  }

  GLTFOcclusionTextureInfo _createGLTFOcclusionTextureInfo(
      glTF.OcclusionTextureInfo gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFOcclusionTextureInfo(gltfSource.texCoord,
        _createTexture(gltfSource.texture), gltfSource.strength);
  }

  GLTFNormalTextureInfo _createGLTFNormalTextureInfo(
      glTF.NormalTextureInfo gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFNormalTextureInfo(gltfSource.texCoord,
        _createTexture(gltfSource.texture), gltfSource.scale);
  }

  GLTFTextureInfo _createGLTFTextureInfo(glTF.TextureInfo gltfSource) {
    if (gltfSource == null) return null;

    GLTFTextureInfo textureInfo = new GLTFTextureInfo(gltfSource.texCoord);

    if (gltfSource.texture != null) {
      GLTFTexture texture = _getTexture(gltfSource.texture);
      textureInfo.texture = texture;
    }

    return textureInfo;
  }

  GLTFAnimationSampler _createGLTFAnimationSampler(
      glTF.AnimationSampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationSampler sampler =
    new GLTFAnimationSampler(gltfSource.interpolation);

    GLTFAccessor projectAccessorInput = _getAccessor(gltfSource.input);
    sampler.input = projectAccessorInput;

    GLTFAccessor projectAccessorOutput = _getAccessor(gltfSource.output);
    sampler.output = projectAccessorOutput;

    return sampler;
  }

  GLTFAnimationChannelTarget _createGLTFAnimationChannelTarget(
      glTF.AnimationChannelTarget gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationChannelTarget channelTarget =
    new GLTFAnimationChannelTarget(gltfSource.path);
    GLTFNode projectNode = _getNode(gltfSource.node);
    channelTarget.node = projectNode;

    return channelTarget;
  }

  GLTFAnimationChannel _createGLTFAnimationChannel(
      glTF.AnimationChannel gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationChannel channel = new GLTFAnimationChannel(
        _createGLTFAnimationChannelTarget(gltfSource.target));
    return channel;
  }

  GLTFAnimation _createAnimation(glTF.Animation gltfSource) {
    if (gltfSource == null) return null;

    //>
    List<GLTFAnimationSampler> samplers = new List();
    for (int i = 0; i < gltfSource.samplers.length; i++) {
      GLTFAnimationSampler sampler =
      _createGLTFAnimationSampler(gltfSource.samplers[i]);
      samplers.add(sampler);
    }

    //>
    List<GLTFAnimationChannel> channels = new List();
    for (int i = 0; i < gltfSource.channels.length; i++) {
      GLTFAnimationChannel channel =
      _createGLTFAnimationChannel(gltfSource.channels[i]);
      int id = gltfSource.samplers.indexOf(gltfSource.channels[i].sampler);

      channel
        ..sampler = samplers.firstWhere((s) => s.samplerId == id,
            orElse: () =>
            throw new Exception("can't get a corresponding sampler"));
      channels.add(channel);
    }

    GLTFAnimation animation = new GLTFAnimation(name: gltfSource.name)
      ..samplers = samplers
      ..channels = channels;

    return animation;
  }

  GLTFAccessorSparse _createGLTFAccessorSparse(glTF.AccessorSparse gltfSource) {
    return new GLTFAccessorSparse(
        gltfSource.count,
        new GLTFAccessorSparseIndices(
          gltfSource.indices.byteOffset,
          gltfSource.indices.componentType,
        ),
        new GLTFAccessorSparseValues(gltfSource.values.byteOffset,
            _getBufferView(gltfSource.values.bufferView)));
  }
}