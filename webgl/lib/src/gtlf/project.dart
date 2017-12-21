import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/accessor_sparse.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/normal_texture_info.dart';
import 'package:webgl/src/gtlf/occlusion_texture_info.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

import '../camera.dart';
import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import '../utils/utils_assets.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/animation.dart';
import 'package:webgl/src/gtlf/asset.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture.dart';

// Todo (jpu) : synchronize id's list cohérent?
// Todo (jpu) : Ajouter des méthodes de Link reférénce ?
//> remplacer les listes par des Map<HashCode, Object>

// Todo (jpu) : Remplacer la copie complete des donnée par un design de Facade ? (utiliser des getter utilisant la source)?
// Todo (jpu) : UNPACK_COLORSPACE_CONVERSION_WEBGL flag to NONE to ignore colorSpace globaly in runtime
// Todo (jpu) : Acccessor getElement test ?
// 16/10/2017 : reading .bin files as Uint8List

GLTFProject _gltfProject;
GLTFProject get gltfProject => _gltfProject;

class GLTFProject {
  String baseDirectory;

  static Future<glTF.Gltf> loadGLTFResource(String url,
      {bool useWebPath: false}) async {
    UtilsAssets.useWebPath = useWebPath;

    Completer completer = new Completer<glTF.Gltf>();
    await UtilsAssets.loadJSONResource(url).then((Map<String, dynamic> result) {
      try {
        glTF.Gltf gltf = new glTF.Gltf.fromMap(result, new glTF.Context());
        completer.complete(gltf);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future as Future<glTF.Gltf>;
  }

  static Future<Uint8List> loadGltfBinResource (String url, {bool isRelative : true}) {
    Completer completer = new Completer<Uint8List>();

    String assetsPath = UtilsAssets.getWebPath(url);
    print('url : $url | assetsPath : $assetsPath');

    Random random = new Random();
    HttpRequest request = new HttpRequest()
      ..responseType = 'arraybuffer';
    request.open('GET', '$assetsPath?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.timeout = 2000;
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        ByteBuffer byteBuffer = request.response as ByteBuffer;
        completer.complete( new Uint8List.view(byteBuffer));
      }
    });
    request.send();

    return completer.future as Future<Uint8List>;
  }

  glTF.Gltf _gltfSource;
  glTF.Gltf get gltfSource => _gltfSource;

  List<GLTFBuffer> buffers = new List();
  List<GLTFBufferView> bufferViews = new List();
  List<Camera> cameras = new List();
  List<GLTFImage> images = new List();
  List<GLTFSampler> samplers = new List();
  List<GLTFTexture> textures = new List();
  List<GLTFPBRMaterial> materials = new List();
  List<GLTFAccessor> accessors = new List();
  List<GLTFMesh> meshes = new List();
  List<GLTFAnimation> animations = new List();
  GLTFAsset asset;

  List<GLTFScene> _scenes = new List();
  List<GLTFScene> get scenes => _scenes.toList(growable: false);
  void addScene(GLTFScene scene){
    assert(scene != null);
    _scenes.add(scene);
  }

  int _sceneId;
  GLTFScene get scene => _sceneId != null ? scenes[_sceneId] : null;
  set scene(GLTFScene value) {
    assert(value != null);
    GLTFScene projectScene = gltfProject.scenes.firstWhere((s)=>s.gltfSource == value.gltfSource);
    _sceneId = gltfProject.scenes.indexOf(projectScene);
  }

  List<GLTFNode> _nodes = new List();
  List<GLTFNode> get nodes => _nodes.toList(growable: false);
  void addNode(GLTFNode value){
    assert(value != null);
    _nodes.add(value);
  }

  @override
  String toString() {
    return 'GLTFProject: {"buffers": $buffers, "bufferViews": $bufferViews, "cameras": $cameras, "images": $images, "samplers": $samplers, "textures": $textures, "materials": $materials, "accessors": $accessors, "meshes": $meshes, "scenes": $scenes, "nodes": $nodes, "sceneId": $_sceneId}';
  }

  void _init([glTF.Gltf _gltfSource]) {

    if(_gltfSource != null) {

      asset = new GLTFAsset.fromGltf(_gltfSource.asset);

      //Buffers
      for (glTF.Buffer gltfBuffer in _gltfSource.buffers) {
        GLTFBuffer buffer = createBuffer(gltfBuffer);
        if (buffer != null) {
          buffers.add(buffer);
        }
      }

      //BufferViews
      for (glTF.BufferView gltfBufferView in _gltfSource.bufferViews) {
        GLTFBufferView bufferView = createBufferView(gltfBufferView);
        if (bufferView != null) {
          bufferViews.add(bufferView);
        }
      }

      //Images
      for (glTF.Image gltfSource in _gltfSource.images) {
        GLTFImage image = createImage(gltfSource);
        if (image != null) {
          images.add(image);
        }
      }

      //Samplers
      for (glTF.Sampler gltfSource in _gltfSource.samplers) {
        GLTFSampler sampler = createSampler(gltfSource);
        if (sampler != null) {
          samplers.add(sampler);
        }
      }

      //Textures
      for (glTF.Texture gltfTexture in _gltfSource.textures) {
        GLTFTexture texture = createTexture(gltfTexture);
        if (texture != null) {
          textures.add(texture);
        }
      }

      //Materials
      for (glTF.Material gltfMaterial in _gltfSource.materials) {
        GLTFPBRMaterial material = createMaterial(gltfMaterial);
        if (material != null) {
          materials.add(material);
        }
      }

      //Accessors
      for (glTF.Accessor gltfAccessor in _gltfSource.accessors) {
        GLTFAccessor accessor = createAccessor(gltfAccessor);
        if (accessor != null) {
          accessors.add(accessor);
        }
      }

      //Cameras
      for (glTF.Camera gltfCamera in _gltfSource.cameras) {
        Camera camera = createCamera(gltfCamera);
        if (camera != null) {
          cameras.add(camera);
        }
      }

      //Meshes
      for (glTF.Mesh gltfMesh in _gltfSource.meshes) {
        GLTFMesh mesh = createMesh(gltfMesh);
        if (mesh != null) {
          meshes.add(mesh);
        }
      }

      //Nodes
      for (glTF.Node gltfNode in _gltfSource.nodes) {
        GLTFNode node = createNode(gltfNode);
        if (node != null) {
          addNode(node);
        }
      }

      //Nodes hierarchy parenting
      for (glTF.Node gltfNode in _gltfSource.nodes) {
        if(gltfNode.children != null && gltfNode.children.length > 0){
          GLTFNode node = gltfProject.getNode(gltfNode);
          node.children = gltfNode.children.map((n) => gltfProject.getNode(n)).toList();
          node.children.forEach((n)=> n.parent = node);
        }
      }

      //Scenes
      for (glTF.Scene gltfScene in _gltfSource.scenes) {
        GLTFScene scene = new GLTFScene.fromGltf(gltfScene);
        if (scene != null) {
          addScene(scene);
        }
      }
      if(_gltfSource.scene != null) {
        scene = new GLTFScene.fromGltf(_gltfSource.scene);
      }

      //Animation
      for (glTF.Animation gltfAnimation  in _gltfSource.animations) {
        GLTFAnimation animation = new GLTFAnimation.fromGltf(gltfAnimation);
        if (animation != null) {
          animations.add(animation);
        }
      }
    }
  }

  GLTFProject._();

  factory GLTFProject(){
    _gltfProject = new GLTFProject._();
    _gltfProject._init();
    return _gltfProject;
  }

  Future fillBuffersData() async {
    for (GLTFBuffer buffer in buffers) {
      if(buffer.data == null && buffer.uri != null){
        String ressourcePath = '$baseDirectory${buffer.uri}';
        buffer.data = await loadGltfBinResource(ressourcePath, isRelative : false);
      }
    }
  }

  //> GLTF Creation

  // Todo (jpu) :
  factory GLTFProject.fromGltf(glTF.Gltf gltfSource) {
    if (gltfSource == null) return null;

    _gltfProject = new GLTFProject._();
    _gltfProject._gltfSource = gltfSource;
    _gltfProject._init(gltfSource);

    return _gltfProject;
  }

  GLTFBuffer createBuffer(glTF.Buffer gltfSource){
    if (gltfSource == null) return null;
    GLTFBuffer buffer = new GLTFBuffer(uri : gltfSource.uri,
    byteLength: gltfSource.byteLength,
    data : gltfSource.data,
    name : gltfSource.name);
    return buffer;
  }

  GLTFBuffer getBuffer(glTF.Buffer buffer) {
    int id = gltfProject.gltfSource.buffers.indexOf(buffer);
    return gltfProject.buffers.firstWhere((b)=>b.bufferId == id, orElse: ()=> throw new Exception('Buffer can only be bound to an existing project buffer'));
  }

  GLTFBufferView createBufferView(glTF.BufferView gltfSource) {
    if (gltfSource == null) return null;

    GLTFBufferView bufferView = new GLTFBufferView(
        buffer : gltfProject.getBuffer(gltfSource.buffer),
        byteLength: gltfSource.byteLength,
        byteOffset: gltfSource.byteOffset,
        byteStride: gltfSource.byteStride,
        usage: gltfSource.usage != null ? gltfSource.usage.target : null,
        target: gltfSource.usage != null
            ? gltfSource.usage.target
            : null, // Todo (jpu) : bug if -1 and usage == null. What to do ?
        name: gltfSource.name);

    return bufferView;
  }

  GLTFBufferView getBufferView(glTF.BufferView bufferView) {
    int id = gltfProject.gltfSource.bufferViews.indexOf(bufferView);

    return gltfProject.bufferViews.firstWhere((b) => b.bufferViewId == id,
        orElse: () => throw new Exception(
            'BufferView can only be bound to an existing project bufferView'));
  }


  GLTFAccessor createAccessor(glTF.Accessor gltfSource) {
    if (gltfSource == null) return null;

    GLTFAccessor accessor = new GLTFAccessor(
        byteOffset : gltfSource.byteOffset,
        byteLength :  gltfSource.byteLength,
        componentType : gltfSource.componentType,
        count : gltfSource.count,
        typeString : gltfSource.type,
//        type : ShaderVariableType.getByComponentAndType(gltfSource.componentType,gltfSource.type),
        elementLength : gltfSource.elementLength,
        components : gltfSource.components,
        normalized : gltfSource.normalized,
        componentLength : gltfSource.componentLength,
        max : gltfSource.max,
        min : gltfSource.min,
        byteStride : gltfSource.byteStride,
        sparse : gltfSource.sparse != null
            ? new GLTFAccessorSparse.fromGltf(gltfSource.sparse):null,
        isXyzSign : gltfSource.isXyzSign,
        isUnit : gltfSource.isUnit,
      name: gltfSource.name
    );

    if(gltfSource.bufferView != null) {
      GLTFBufferView bufferView = gltfProject.getBufferView(gltfSource.bufferView);
      assert(bufferView.bufferViewId != null);

      accessor.bufferView = bufferView;
    }
    return accessor;
  }

  GLTFAccessor getAccessor(glTF.Accessor accessor) {
    int id = gltfProject.gltfSource.accessors.indexOf(accessor);
    return gltfProject.accessors.firstWhere((a)=>a.accessorId == id, orElse: ()=> throw new Exception('Attribut accessor can only be bound to an existing project accessor'));
  }


  GLTFSampler createSampler(glTF.Sampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFSampler sampler = new GLTFSampler(
        magFilter : gltfSource.magFilter != -1 ? gltfSource.magFilter : TextureFilterType.LINEAR,
        minFilter : gltfSource.minFilter != -1 ? gltfSource.magFilter : TextureFilterType.LINEAR,
        wrapS : gltfSource.wrapS,
        wrapT : gltfSource.wrapT,
        name : gltfSource.name
    );
    return sampler;
  }

  GLTFSampler getSampler(glTF.Sampler sampler) {
    int id = gltfProject.gltfSource.samplers.indexOf(sampler);
    return gltfProject.samplers.firstWhere((s)=>s.samplerId == id, orElse: ()=> throw new Exception('Texture Sampler can only be bound to an existing project sampler'));
  }

  GLTFImage createImage(glTF.Image gltfSource) {
    if (gltfSource == null) return null;
    GLTFImage image = new GLTFImage(
        uri : gltfSource.uri,
        mimeType : gltfSource.mimeType,
        bufferView : createBufferView(gltfSource.bufferView),
        data : gltfSource.data,
        name : gltfSource.name
    );
    return image;
  }

  GLTFImage getImage(glTF.Image image) {
    int id = gltfProject.gltfSource.images.indexOf(image);
    return gltfProject.images.firstWhere((i)=>i.sourceId == id, orElse: ()=> throw new Exception('Texture Image can only be bound to an existing project image'));
  }

 GLTFTexture createTexture(glTF.Texture gltfSource) {
    if (gltfSource == null) return null;

    GLTFSampler sampler;
    if(gltfSource.sampler != null){
      sampler = gltfProject.getSampler(gltfSource.sampler);
    }

    GLTFImage image;
    if(gltfSource.source != null){
      image = gltfProject.getImage(gltfSource.source);
    }

    //Check if exist in project first
    GLTFTexture texture = getTexture(gltfSource);
    if(texture == null) {
      texture = new GLTFTexture(
          sampler : sampler,
          source : image,
          name: gltfSource.name
      );
    }else {
      texture.sampler = sampler;
      texture.source = image;
    }
    return texture;
  }

  GLTFTexture getTexture(glTF.Texture texture) {
    int id = gltfProject.gltfSource.textures.indexOf(texture);
    return gltfProject.textures.firstWhere((t)=>t.textureId == id, orElse: ()=> null);
  }

  GLTFPBRMaterial createMaterial(glTF.Material gltfSource) {
    if (gltfSource == null) return null;

    // Todo (jpu) : remove fromGltf
    GLTFPBRMaterial material = new GLTFPBRMaterial(
        pbrMetallicRoughness : new GLTFPbrMetallicRoughness.fromGltf(
            gltfSource.pbrMetallicRoughness),
        normalTexture : gltfSource.normalTexture != null
            ? new GLTFNormalTextureInfo.fromGltf(gltfSource.normalTexture)
            : null,
        occlusionTexture : gltfSource.occlusionTexture != null
            ? new GLTFOcclusionTextureInfo.fromGltf(
            gltfSource.occlusionTexture)
            : null,
        emissiveTexture : gltfSource.emissiveTexture != null
            ? new GLTFTextureInfo.fromGltf(gltfSource.emissiveTexture)
            : null,
        emissiveFactor : gltfSource.emissiveFactor,
        alphaMode : gltfSource.alphaMode,
        alphaCutoff : gltfSource.alphaCutoff,
        doubleSided : gltfSource.doubleSided,
        name : gltfSource.name
    );

    return material;
  }

  GLTFPBRMaterial getMaterial(glTF.Material material){
    int id = gltfProject.gltfSource.materials.indexOf(material);
    return gltfProject.materials.firstWhere((m)=>m.materialId == id, orElse: ()=> throw new Exception('Mesh material can only be bound to an existing project material'));
  }

  Camera createCamera(glTF.Camera gltfCamera){
    Camera camera;
    if(gltfCamera != null) {
      if (gltfCamera.perspective != null){
        camera = new CameraPerspective(gltfCamera.perspective.yfov, gltfCamera.perspective.znear, gltfCamera.perspective.zfar)
        ..type = CameraType.perspective
        ..aspectRatio = gltfCamera.perspective.aspectRatio;
      } else if (gltfCamera.orthographic != null) {
        camera = new CameraOrthographic()
          ..type = CameraType.orthographic
          ..znear = gltfCamera.orthographic.znear
          ..zfar = gltfCamera.orthographic.zfar
          ..xmag = gltfCamera.orthographic.xmag
          ..ymag = gltfCamera.orthographic.ymag;

        // Todo (jpu) :
//      cameraPerspective.extensions;
//      cameraPerspective.extras;
      }
    }
    return camera;
  }

  Camera getCamera(glTF.Camera gltfCamera){
    int id = gltfProject.gltfSource.cameras.indexOf(gltfCamera);
    return gltfProject.cameras.firstWhere((c)=>c.cameraId == id, orElse: ()=> throw new Exception('Camera can only be bound to an existing project camera'));
  }

  GLTFMesh createMesh(glTF.Mesh gltfSource) {
    if (gltfSource == null) return null;

      GLTFMesh mesh = new GLTFMesh(
          primitives : gltfSource.primitives
          .map((p) => new GLTFMeshPrimitive.fromGltf(p))
          .toList(),
      weights : gltfSource.weights != null
      ? (<double>[]..addAll(gltfSource.weights))
          : <double>[],
          name : gltfSource.name
      );

    return mesh;
  }

  GLTFMesh getMesh(glTF.Mesh mesh){
    int id = gltfProject.gltfSource.meshes.indexOf(mesh);
    return gltfProject.meshes.firstWhere((m)=>m.meshId == id, orElse: ()=> throw new Exception('Mesh can only be bound to an existing project mesh'));
  }

  GLTFNode createNode(glTF.Node gltfSource) {
    if (gltfSource == null) return null;

    GLTFNode node = new GLTFNode(
      name : gltfSource.name
    );

    node.translation = gltfSource.translation;
    node.rotation = gltfSource.rotation;
    node.scale = gltfSource.scale;
    node.matrix = gltfSource.matrix;

    if(gltfSource.mesh != null){
      GLTFMesh mesh = gltfProject.getMesh(gltfSource.mesh);
      node.mesh = mesh;
    }

    if(gltfSource.camera != null){
      Camera camera = gltfProject.getCamera(gltfSource.camera);
      node.camera = camera;
    }

    return node;
  }

  GLTFNode getNode(glTF.Node node)
  {
    int id = gltfProject.gltfSource.nodes.indexOf(node);
    return gltfProject.nodes.firstWhere((n)=>n.nodeId == id, orElse: ()=> throw new Exception('Node can only be binded to Nodes existing in project'));
  }
}