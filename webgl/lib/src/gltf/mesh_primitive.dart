import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/gltf/accessor.dart';
import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/gltf/utils_gltf.dart';
import 'dart:math';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
//@MirrorsUsed(
//    targets: const [
//      MeshPrimitive,
//      _PointMeshPrimitive,
//      _LineMeshPrimitive2,
//      _LineMeshPrimitive,
//      _TriangleMeshPrimitive,
//      _QuadMeshPrimitive,
//      _PyramidMeshPrimitive,
//      _CubeMeshPrimitive,
//      _SphereMeshPrimitive,
//      _AxisMeshPrimitive,
//      _AxisPointMeshPrimitive,
//    ],
//    override: '*')
//import 'dart:mirrors';

/// Represent a part of a mesh
/// [attributs] associate an Accessor by vertex attribute usage : POSITION | NORMAL | TANGENT | TEXCOORD_ | COLOR_ | JOINTS_ | WEIGHTS_
/// in gltf file the accessor is define by its Id
class GLTFMeshPrimitive extends GltfProperty {
  Map<String, GLTFAccessor> attributes = new Map<String, GLTFAccessor>();
  Map<String, webgl.Buffer> buffers = new Map();

  /// DrawMode mode
  int drawMode;

  final bool hasPosition;
  final bool hasNormal;
  final bool hasTextureCoord;
  final bool hasTangent;

  final int colorCount;
  final int jointsCount;
  final int weigthsCount;
  final int texcoordCount;

  GLTFAccessor get positionAccessor => attributes['POSITION'];
  set positionAccessor(GLTFAccessor value) {
    attributes['POSITION'] = value;
  }

  GLTFAccessor get normalAccessor => attributes['NORMAL'];
  set normalAccessor(GLTFAccessor value) {
    attributes['NORMAL'] = value;
  }

  GLTFAccessor get uvAccessor => attributes['TEXCOORD_0'];
  set uvAccessor(GLTFAccessor value) {
    attributes['TEXCOORD_0'] = value;
  }

  GLTFAccessor _indicesAccessor;
  GLTFAccessor get indicesAccessor => _indicesAccessor;
  set indicesAccessor(GLTFAccessor value) {
    _indicesAccessor = value;
  }

  ///Default material element define in a gltf File or use of the same structure
  GLTFPBRMaterial _baseMaterial;
  GLTFPBRMaterial get baseMaterial => _baseMaterial;
  set baseMaterial(GLTFPBRMaterial value) {
    _baseMaterial = value;
  }

  ///Use this to define a custom material if needed
  RawMaterial _material;
  RawMaterial get material => _material;
  set material(RawMaterial value) {
    _material = value;
  }

  WebGLProgram _program;
  WebGLProgram get program => _program;

  bool _isMaterialInitialized = false;

  // Todo (jpu) : add other members ?
//  int get count => _count;
//  int get vertexCount => _vertexCount;
//  List<Map<String, Accessor>> get targets => _targets;

  GLTFMeshPrimitive({
      this.drawMode,
      this.hasPosition,
      this.hasNormal,
      this.hasTextureCoord,
      this.hasTangent,
      this.colorCount,
      this.jointsCount,
      this.weigthsCount,
      this.texcoordCount});

  @override
  String toString() {
    return 'GLTFMeshPrimitive{attributes: $attributes, mode: $drawMode, hasPosition: $hasPosition, hasNormal: $hasNormal, hasTextureCoord: $hasTextureCoord, hasTangent: $hasTangent, colorCount: $colorCount, jointsCount: $jointsCount, weigthsCount: $weigthsCount, texcoordCount: $texcoordCount, _indices: ${_indicesAccessor?.accessorId}, _materialId: ${_baseMaterial?.materialId}}';
  }

  //>

  Float32List get vertices {
    GLTFAccessor positionAccessor = attributes['POSITION'];
    return positionAccessor.bufferView.buffer.data.buffer
        .asFloat32List(
        positionAccessor.bufferView.byteOffset + positionAccessor.byteOffset,
        positionAccessor.count * positionAccessor.components);
  }  //>

  Uint16List get indices {
    return _indicesAccessor.bufferView.buffer.data.buffer
      .asUint16List(_indicesAccessor.byteOffset, _indicesAccessor.count);
  }

  void bindMaterial(bool hasLODExtension, int reservedTextureUnits) {
    if(_isMaterialInitialized) return;

    bool debug = false;
    bool debugWithDebugMaterial = false;

    if(baseMaterial == null || debug){
      if(debugWithDebugMaterial){
        _material = new MaterialDebug()
          ..color = new Vector3.random();
      } else if(_material == null){
        _material = new KronosDefaultMaterial();
      }else{
        // use _material manually defined
      }
    } else {
      _material = new KronosPRBMaterial(normalAccessor != null, attributes['TANGENT'] != null, uvAccessor != null, hasLODExtension);
      KronosPRBMaterial materialPBR = _material as KronosPRBMaterial;

      materialPBR.baseColorMap = baseMaterial.pbrMetallicRoughness.baseColorTexture?.texture?.webglTexture;
      if (materialPBR.hasBaseColorMap) {
        materialPBR.baseColorSamplerSlot = baseMaterial.pbrMetallicRoughness.baseColorTexture.texture.textureId + reservedTextureUnits;
      }
      materialPBR.baseColorFactor = baseMaterial.pbrMetallicRoughness.baseColorFactor;

      materialPBR.normalMap = baseMaterial.normalTexture?.texture?.webglTexture;
      if(materialPBR.hasNormalMap) {
        materialPBR.normalSamplerSlot =
            baseMaterial.normalTexture.texture.textureId + reservedTextureUnits;
        materialPBR.normalScale = baseMaterial.normalTexture.scale != null
            ? baseMaterial.normalTexture.scale
            : 1.0;
      }

      materialPBR.emissiveMap = baseMaterial.emissiveTexture?.texture?.webglTexture;
      if(materialPBR.hasEmissiveMap) {
        materialPBR.emissiveSamplerSlot =
            baseMaterial.emissiveTexture.texture.textureId + reservedTextureUnits;
        materialPBR.emissiveFactor = baseMaterial.emissiveFactor;
      }

      materialPBR.occlusionMap = baseMaterial.occlusionTexture?.texture?.webglTexture;
      if(materialPBR.hasOcclusionMap) {
        materialPBR.occlusionSamplerSlot =
            baseMaterial.occlusionTexture.texture.textureId + reservedTextureUnits;
        materialPBR.occlusionStrength = baseMaterial.occlusionTexture.strength != null
            ? baseMaterial.occlusionTexture.strength
            : 1.0;
      }

      materialPBR.metallicRoughnessMap = baseMaterial.pbrMetallicRoughness.metallicRoughnessTexture?.texture?.webglTexture;
      if(materialPBR.hasMetallicRoughnessMap) {
        materialPBR.metallicRoughnessSamplerSlot =
            baseMaterial.pbrMetallicRoughness.metallicRoughnessTexture.texture
                .textureId + reservedTextureUnits;
      }

      materialPBR.roughness = baseMaterial.pbrMetallicRoughness.roughnessFactor;
      materialPBR.metallic = baseMaterial.pbrMetallicRoughness.metallicFactor;
    }

    _program = _material.getProgram();
    _isMaterialInitialized = true;
  }

  List<Triangle> _faces;
  List<Triangle> getFaces() {

    /*
    //Référence de construction
    0 - 3
    | \ |
    1 - 2

    vertices = [
      -1.0, 1.0, 0.0,
      -1.0, -1.0, 0.0,
      1.0, -1.0, 0.0,
      1.0, 1.0, 0.0
    ];
    indices = [
      0, 1, 2, 0, 2, 3,
    ];
    */

    if(_faces == null){
      _faces = [];

      if(indicesAccessor != null) {
        List<Float32List> fullVertices = [];
        int stepVertices = 3;
        for(int vertex = 0; vertex < vertices.length &&  vertices.length > stepVertices; vertex += stepVertices) {
          fullVertices.add(new Float32List.fromList([vertices[vertex + 0], vertices[vertex + 1], vertices[vertex + 2]]));
        }

        int stepIndices = 3;
        for(int i = 0; i < indices.length; i += stepIndices) {
          Vector3 p1 = new Vector3.fromFloat32List(fullVertices[indices[i]]);
          Vector3 p2 = new Vector3.fromFloat32List(fullVertices[indices[i + 1]]);
          Vector3 p3 = new Vector3.fromFloat32List(fullVertices[indices[i + 2]]);
          _faces.add(new Triangle.points(p1, p2, p3));
        }
      }
    }
    return _faces;
  }
}

class MeshPrimitive {

  /// DrawMode mode
  int mode = DrawMode.TRIANGLES;

  List<double> vertices = [];

  List<int> _indices = new List();
  List<int> get indices => _indices;
  set indices(List<int> value) {
    _indices = value;
  }

  List<double> _uvs = new List();
  List<double> get uvs => _uvs;
  set uvs(List<double> value) {
    _uvs = value;
  }

  List<double> _normals = new List();
  List<double> get normals => _normals;
  set normals(List<double> value) {
    _normals = value;
  }

  List<double> _colors = new List();
  List<double> get colors => _colors;
  set colors(List<double> value) {
    _colors = value;
  }

  MeshPrimitive();

  factory MeshPrimitive.Point() {
    return new _PointMeshPrimitive();
  }

  factory MeshPrimitive.Line(List<Vector3> points) {
    return new _LineMeshPrimitive(points);
  }

  factory MeshPrimitive.Line2(List<Vector3> points) {
    return new _LineMeshPrimitive2(points);
  }

  factory MeshPrimitive.Triangle() {
    return new _TriangleMeshPrimitive();
  }

  factory MeshPrimitive.Quad() {
    return new _QuadMeshPrimitive();
  }

  factory MeshPrimitive.Pyramid() {
    return new _PyramidMeshPrimitive();
  }

  factory MeshPrimitive.Cube() {
    return new _CubeMeshPrimitive();
  }

  factory MeshPrimitive.Sphere({double radius : 1.0, int segmentV: 32, int segmentH: 32}) {
    return new _SphereMeshPrimitive(radius : radius, segmentV:segmentV, segmentH:segmentH);
  }

  factory MeshPrimitive.Axis() {
    return new _AxisMeshPrimitive();
  }

  factory MeshPrimitive.AxisPoints() {
    return new _AxisPointMeshPrimitive();
  }
}

class _PointMeshPrimitive extends MeshPrimitive {
  _PointMeshPrimitive() {

    mode = DrawMode.POINTS;
    vertices = [
      0.0, 0.0, 0.0,
    ];

  }
}

//Deprecated
class _LineMeshPrimitive2 extends MeshPrimitive {
  _LineMeshPrimitive2(List<Vector3> points) {
    assert(points.length >= 2);

    mode = DrawMode.LINES;

    vertices = [];

    for(int i = 0; i < points.length - 1; i++){
      Vector3 point1 = points[i];
      vertices.addAll(point1.storage);

      Vector3 point2 = points[i+1];
      vertices.addAll(point2.storage);

      colors.addAll([1.0, 0.0, 0.0, 1.0]);
    }
  }
}

class _LineMeshPrimitive extends MeshPrimitive {
  _LineMeshPrimitive(List<Vector3> points) {
    assert(points.length >= 2);

    mode = DrawMode.LINE_STRIP;

    vertices = [];

    for(int i = 0; i < points.length; i++){
      vertices.addAll(points[i].storage);
//      colors.addAll([1.0, 0.0, 0.0, 1.0]);
    }
  }
}

class _TriangleMeshPrimitive extends MeshPrimitive {
  _TriangleMeshPrimitive() {
    mode = DrawMode.TRIANGLES;

    vertices = [
      0.0, 0.0, 0.0,
      2.0, 0.0, 0.0,
      0.0, 2.0, 0.0
    ];
    indices = [0,1,2];
    uvs = [
      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,
    ];
  }
}

class _QuadMeshPrimitive extends MeshPrimitive {
  _QuadMeshPrimitive() {
    mode = DrawMode.TRIANGLES;
    /*
    0 - 3
    | \ |
    1 - 2
    */
    vertices = [
      -1.0, 1.0, 0.0,
      -1.0, -1.0, 0.0,
      1.0, -1.0, 0.0,
      1.0, 1.0, 0.0
    ];
    indices = [
      0, 1, 2, 0, 2, 3,
    ];
    normals = [
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
    ];
    uvs = [
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
    ];
  }
}

class _PyramidMeshPrimitive extends MeshPrimitive {
  _PyramidMeshPrimitive() {
    vertices = [
      1.0, 0.0, 1.0,
      1.0, 0.0, -1.0,
      0.0, 2.0, 0.0,

      1.0, 0.0, -1.0,
      -1.0, 0.0, -1.0,
      0.0, 2.0, 0.0,

      -1.0, 0.0, -1.0,
      -1.0, 0.0, 1.0,
      0.0, 2.0, 0.0,

      -1.0, 0.0, 1.0,
      1.0, 0.0, 1.0,
      0.0, 2.0, 0.0,

      1.0, 0.0, 1.0,
      1.0, 0.0, -1.0,
      -1.0, 0.0, -1.0,

      1.0, 0.0, 1.0,
      -1.0, 0.0, -1.0,
      1.0, 0.0, -1.0,
    ];

    indices = [
      0, 1, 2, // right face
      3, 4, 5, // front face
      6, 7, 8, // left face
      9, 10, 11, // back face
      12, 13, 14, // bottom face
      15, 16, 17, // bottom face
    ];

    uvs = [
      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,
    ];

    normals = []
      ..addAll(new Plane.components(vertices[0], vertices[1], vertices[2], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[3], vertices[4], vertices[5], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[6], vertices[7], vertices[8], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[9], vertices[10], vertices[11], 1.0).normal.storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage);
  }
}

class _CubeMeshPrimitive extends MeshPrimitive {
  _CubeMeshPrimitive() {
    mode = DrawMode.TRIANGLES;

    vertices = [
      // Front face
      -1.0, -1.0, 1.0,
      1.0, -1.0, 1.0,
      1.0, 1.0, 1.0,
      -1.0, 1.0, 1.0,

      // Back face
      -1.0, -1.0, -1.0,
      -1.0, 1.0, -1.0,
      1.0, 1.0, -1.0,
      1.0, -1.0, -1.0,

      // Top face
      -1.0, 1.0, -1.0,
      -1.0, 1.0, 1.0,
      1.0, 1.0, 1.0,
      1.0, 1.0, -1.0,

      // Bottom face
      -1.0, -1.0, -1.0,
      1.0, -1.0, -1.0,
      1.0, -1.0, 1.0,
      -1.0, -1.0, 1.0,

      // Right face
      1.0, -1.0, -1.0,
      1.0, 1.0, -1.0,
      1.0, 1.0, 1.0,
      1.0, -1.0, 1.0,

      // Left face
      -1.0, -1.0, -1.0,
      -1.0, -1.0, 1.0,
      -1.0, 1.0, 1.0,
      -1.0, 1.0, -1.0,
    ];

    indices = [
      0, 1, 2, 0, 2, 3, // Front face
      4, 5, 6, 4, 6, 7, // Back face
      8, 9, 10, 8, 10, 11, // Top face
      12, 13, 14, 12, 14, 15, // Bottom face
      16, 17, 18, 16, 18, 19, // Right face
      20, 21, 22, 20, 22, 23 // Left face
    ];

    uvs = [
      // Front
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Back
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Top
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Bottom
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Right
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Left
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
    ];

    normals = [
      // Front face
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,

      // Back face
      0.0, 0.0, -1.0,
      0.0, 0.0, -1.0,
      0.0, 0.0, -1.0,
      0.0, 0.0, -1.0,

      // Top face
      0.0, 1.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 1.0, 0.0,

      // Bottom face
      0.0, -1.0, 0.0,
      0.0, -1.0, 0.0,
      0.0, -1.0, 0.0,
      0.0, -1.0, 0.0,

      // Right face
      1.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      1.0, 0.0, 0.0,

      // Left face
      -1.0, 0.0, 0.0,
      -1.0, 0.0, 0.0,
      -1.0, 0.0, 0.0,
      -1.0, 0.0, 0.0,
    ];

    List<List<double>> _colorsFace = [
      [1.0, 0.0, 0.0, 1.0], // Front face
      [1.0, 1.0, 0.0, 1.0], // Back face
      [0.0, 1.0, 0.0, 1.0], // Top face
      [0.0, 1.0, 1.0, 1.0], // Bottom face
      [0.0, 0.0, 1.0, 1.0], // Right face
      [1.0, 0.0, 1.0, 1.0], // Left face
    ];

    colors = new List.generate(4 * 4 * _colorsFace.length, (int index) {
      // index ~/ 16 returns 0-5, that's color index
      // index % 4 returns 0-3 that's color component for each color
      return _colorsFace[index ~/ 16][index % 4];
    }, growable: false);
  }
}

class _SphereMeshPrimitive extends MeshPrimitive {

  Matrix4 _matRotY = new Matrix4.identity();
  Matrix4 _matRotZ = new Matrix4.identity();

  Vector3 _tmpVec3 = new Vector3.zero();
  Vector3 _up = new Vector3(0.0, 1.0, 0.0);

  List<Vector3> sphereVerticesVector = [];

  _SphereMeshPrimitive({double radius : 1.0, int segmentV: 32, int segmentH : 32}) {

    mode = DrawMode.TRIANGLES;

    segmentV = max(1,segmentV--);

    int totalZRotationSteps = 1 + segmentV;
    int totalYRotationSteps = segmentH;

    for (int zRotationStep = 0;
    zRotationStep <= totalZRotationSteps;
    zRotationStep++) {
      double normalizedZ = zRotationStep / totalZRotationSteps;
      double angleZ = (normalizedZ * pi);//part of vertical half circle

      for (int yRotationStep = 0;
      yRotationStep <= totalYRotationSteps;
      yRotationStep++) {
        double normalizedY = yRotationStep / totalYRotationSteps;
        double angleY = normalizedY * pi * 2;//part of horizontal full circle

        _matRotZ.setIdentity();//reset
        _matRotZ.rotateZ(-angleZ);

        _matRotY.setIdentity();//reset
        _matRotY.rotateY(angleY);

        _tmpVec3 = (_matRotY * _matRotZ * _up) as Vector3;//up vector transformed by the 2 rotations

        _tmpVec3.scale(-radius);// why - ?
        vertices.addAll(_tmpVec3.storage);
        sphereVerticesVector.add(_tmpVec3);

        _tmpVec3.normalize();
        normals.addAll(_tmpVec3.storage);

        uvs.addAll([normalizedY, 1 - normalizedZ]);
      }

      if (zRotationStep > 0) {
        var verticesCount = sphereVerticesVector.length;
        var firstIndex = verticesCount - 2 * (totalYRotationSteps + 1);
        for (;
        (firstIndex + totalYRotationSteps + 2) < verticesCount;
        firstIndex++) {
          indices.addAll([
            firstIndex,
            firstIndex + 1,
            firstIndex + totalYRotationSteps + 1
          ]);
          indices.addAll([
            firstIndex + totalYRotationSteps + 1,
            firstIndex + 1,
            firstIndex + totalYRotationSteps + 2
          ]);
        }
      }
    }
  }
}

class _AxisMeshPrimitive extends MeshPrimitive {
  _AxisMeshPrimitive() {
    mode = DrawMode.LINES;
    vertices = [
      0.0,0.0,0.0,
      1.0,0.0,0.0,
      0.0,0.0,0.0,
      0.0,1.0,0.0,
      0.0,0.0,0.0,
      0.0,0.0,1.0,
    ];
    colors = [
      1.0,0.0,0.0,1.0,
      1.0,0.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,0.0,1.0,1.0,
      0.0,0.0,1.0,1.0,
    ];
  }
}

//Points
class _AxisPointMeshPrimitive extends MeshPrimitive {
  _AxisPointMeshPrimitive() {
    mode = DrawMode.POINTS;

    vertices = [
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 0.0, 1.0,
    ];
    colors = [
      1.0, 1.0, 0.0, 1.0,
      1.0, 0.0, 0.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
    ];
  }
}