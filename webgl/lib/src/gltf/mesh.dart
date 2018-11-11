import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/accessor.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/mesh_primitive.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/utils_gltf.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/utils/utils_math.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

enum MeshType {
  point,
  line,
  triangle,
  quad,
  pyramid,
  cube,
  sphere,
  torus,
  axis,
  grid,
  custom,
  json,
  multiLine,
  vector,
  skyBox,
  axisPoints,
}

@reflector
class GLTFMesh extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int meshId = nextId++;

  final List<double> weights; // Todo (jpu) : ?

  List<GLTFMeshPrimitive> primitives = new List();

  GLTFMesh({this.weights, String name: ''}) : super(name){
    GLTFProject.instance.meshes.add(this);
  }

  @override
  String toString() {
    return 'GLTFMesh{primitives: $primitives, weights: $weights}';
  }

  //
  List<Triangle> _faces;
  List<Triangle> getFaces() {
    _faces = new List();
    for (GLTFMeshPrimitive primitive in primitives) {
      List<Triangle> faces = primitive.getFaces();
      for (Triangle triangle in faces) {
        _faces.add(new Triangle.copy(triangle));
      }
    }
    return _faces;
  }

  static GLTFMesh createMesh(MeshPrimitiveInfos meshPrimitiveInfos) {

    //Closure to check new added byte length to the list
    int checkAddedBytes(List<int> baseData, int lastBaseDataLength) {
//    print('added ${baseData.length - lastBaseDataLength} bytes');
      lastBaseDataLength = baseData.length;
      return lastBaseDataLength;
    }

    /// The mesh must have primitive
    GLTFMeshPrimitive primitive =
    new GLTFMeshPrimitive(drawMode: DrawMode.TRIANGLES, hasPosition: meshPrimitiveInfos.vertexPositions != null, hasNormal: meshPrimitiveInfos.vertexNormals != null, hasTextureCoord: meshPrimitiveInfos.vertexUVs != null);

    /// A mesh is needed
    GLTFMesh mesh = new GLTFMesh()
      ..primitives.add(primitive);

    /// A buffer is needed to hold vertex data
    GLTFBuffer buffer = new GLTFBuffer();
    /// Buffer must have data defined as Uint8List
    List<int> baseData = new List();
    int lastBaseDataLength = 0;

    //> Indices

    int nextMultipleVertexDataOffset = 0;

    int scalarComponentsCount = ACCESSOR_COMPONENTS_COUNT[SCALAR];
    int vec2ComponentsCount = ACCESSOR_COMPONENTS_COUNT[VEC2];
    int vec3ComponentsCount = ACCESSOR_COMPONENTS_COUNT[VEC3];
    int vec4ComponentsCount = ACCESSOR_COMPONENTS_COUNT[VEC4];

    if(meshPrimitiveInfos.vertexIndices != null) {
      /// And the Accessor will have to have a BufferView
      GLTFBufferView bufferView = new GLTFBufferView(
          byteOffset: 0,
          byteLength: meshPrimitiveInfos.vertexIndices.buffer.lengthInBytes,
          byteStride: -1,
          target: BufferType.ELEMENT_ARRAY_BUFFER,
          usage: BufferType.ELEMENT_ARRAY_BUFFER,
      );

      /// The primitive may have Indices Accessor infos
      GLTFAccessor indicesAccessor = new GLTFAccessor(
          byteOffset: 0,
          byteLength: meshPrimitiveInfos.vertexIndices.buffer.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[SCALAR],
          count: meshPrimitiveInfos.vertexIndices.length,//for this Accessor, take length only
          type : null,
          elementLength: scalarComponentsCount * ACCESSOR_COMPONENT_LENGTHS[UNSIGNED_SHORT],
          typeString: SCALAR,
          components: scalarComponentsCount,
          componentType: VertexAttribArrayType.UNSIGNED_SHORT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[UNSIGNED_SHORT],
          normalized: false);
      indicesAccessor.bufferView = bufferView;

      primitive.indicesAccessor = indicesAccessor;

      /// And the BufferView must refer to a Buffer for the datas
      bufferView.buffer = buffer;

      baseData.addAll(meshPrimitiveInfos.vertexIndices.buffer.asUint8List().toList());

      ///Find next ofset with multiple of vertexPositions.elementSizeInBytes (4)
      int findNextIntMultiple(int startValue, int multiple){
        startValue -= 1;
        return  startValue + (multiple - startValue % multiple);
      }
      int x = meshPrimitiveInfos.vertexIndices.lengthInBytes;
      int n = meshPrimitiveInfos.vertexPositions.elementSizeInBytes;
      nextMultipleVertexDataOffset = findNextIntMultiple(x, n);
//      print('vertexIndices.lengthInBytes : ${vertexIndices.lengthInBytes}');
//      print('vertexPositions.elementSizeInBytes : ${vertexPositions.elementSizeInBytes}');
//      print('nextMultipleVertexDataOffset : $nextMultipleVertexDataOffset');
      ///adjust space end
      int dataOffset = nextMultipleVertexDataOffset - baseData.length;
      for(int i = 0; i < dataOffset; i++) {
        baseData.add(0);
      }

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Positions

    if(meshPrimitiveInfos.vertexPositions == null) {
      throw 'vertexPositions POSITION must be defined.';
    } else {

      /// The Accessor must have a BufferView
      GLTFBufferView bufferView = new GLTFBufferView(
          byteOffset: nextMultipleVertexDataOffset,
          byteLength: meshPrimitiveInfos.vertexPositions.buffer.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          target: BufferType.ARRAY_BUFFER,
          usage: BufferType.ARRAY_BUFFER,
      );

      /// The primitive must have POSITION Accessor infos
      GLTFAccessor positionAccessor = new GLTFAccessor(
          byteOffset: 0,
          byteLength: meshPrimitiveInfos.vertexPositions.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          count: meshPrimitiveInfos.vertexPositions.length ~/ vec3ComponentsCount,
          type : 35665,
          elementLength: vec3ComponentsCount * ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          typeString: VEC3,
          components: vec3ComponentsCount,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          normalized: false,
      );
      positionAccessor.bufferView = bufferView;

      primitive.positionAccessor = positionAccessor;

      /// And the BufferView must refer to a Buffer for the datas
      bufferView.buffer = buffer;

      baseData.addAll(meshPrimitiveInfos.vertexPositions.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Normals can use same bufferView as Position

    if(meshPrimitiveInfos.vertexNormals != null) {
      /// Normals can use same bufferView as Position.
      /// So there's no need to create a new one.
      /// But length must be adjusted
      primitive.positionAccessor.bufferView.byteLength += meshPrimitiveInfos.vertexNormals.buffer.lengthInBytes;

      /// The primitive may have Indices Accessor infos
      GLTFAccessor normalAccessor = new GLTFAccessor(
          byteOffset: meshPrimitiveInfos.vertexPositions.length ~/ vec3ComponentsCount * 12,
          byteLength: meshPrimitiveInfos.vertexPositions.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          count: meshPrimitiveInfos.vertexNormals.length ~/ vec3ComponentsCount,
          type : 35665,
          elementLength: vec3ComponentsCount * ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          typeString: VEC3,
          components: vec3ComponentsCount,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          normalized: false,
      );
      normalAccessor.bufferView = primitive.positionAccessor.bufferView; //Re-use position bufferview

      primitive.normalAccessor = normalAccessor;

      baseData.addAll(meshPrimitiveInfos.vertexNormals.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Texture coords

    if(meshPrimitiveInfos.vertexUVs != null) {

      /// as uv is Vec2, it must be reorganised to match stride split
      int count = meshPrimitiveInfos.vertexUVs.length ~/ vec2ComponentsCount;
      meshPrimitiveInfos.vertexUVs = UtilsMath.convertVec2FloatListToVec3FloatList(meshPrimitiveInfos.vertexUVs,0.0);

      /// UV can use same bufferView as Position.
      /// So there's no need to create a new one.
      /// But length must be adjusted in proportion of position even if it's uv
      primitive.positionAccessor.bufferView.byteLength += meshPrimitiveInfos.vertexUVs.buffer.lengthInBytes;

      /// The primitive may have Indices Accessor infos
      GLTFAccessor uvAccessor = new GLTFAccessor(
          byteOffset: count * 12,//byte length
          byteLength: meshPrimitiveInfos.vertexUVs.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          count: count,
          type : null,
          elementLength: vec2ComponentsCount * ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          typeString: VEC2,
          components: vec2ComponentsCount,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          normalized: false,
      );
      uvAccessor.bufferView = primitive.positionAccessor.bufferView; //Re-use position bufferview

      primitive.uvAccessor = uvAccessor;

      baseData.addAll(meshPrimitiveInfos.vertexUVs.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Colors

    if(meshPrimitiveInfos.vertexColors != null) {

      /// as colors is Vec3, it must be reorganised to match stride split
      int count = meshPrimitiveInfos.vertexColors.length ~/ vec4ComponentsCount;
      meshPrimitiveInfos.vertexColors = meshPrimitiveInfos.vertexColors;

      /// Color can use same bufferView as Position.
      /// So there's no need to create a new one.
      /// And length musn't be adjusted in proportion of position beacause it's the same length
      primitive.positionAccessor.bufferView.byteLength += meshPrimitiveInfos.vertexColors.buffer.lengthInBytes;

      /// The primitive may have Indices Accessor infos
      GLTFAccessor colorAccessor = new GLTFAccessor(
          byteOffset: count * 12,//byte length
          byteLength: meshPrimitiveInfos.vertexColors.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC4],
          count: count,
          type : null,
          elementLength: vec4ComponentsCount * ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          typeString: VEC4,
          components: vec4ComponentsCount,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          normalized: false,
      );
      colorAccessor.bufferView = primitive.positionAccessor.bufferView; //Re-use position bufferview

      primitive.colorAccessor = colorAccessor;

      baseData.addAll(meshPrimitiveInfos.vertexColors.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Fill buffer with datas

    buffer.data = new Uint8List.fromList(baseData);
    buffer.byteLength = buffer.data.length;

    return mesh;
  }

  static GLTFMesh createMeshWithPrimitive(MeshPrimitive meshPrimitive, MeshPrimitiveInfos meshPrimitiveInfos) {
    meshPrimitiveInfos.vertexPositions = new Float32List.fromList(meshPrimitive.vertices);

    if (meshPrimitiveInfos.useIndices) {
      meshPrimitiveInfos.vertexIndices = new Int16List.fromList(meshPrimitive.indices);
    }

    if (meshPrimitiveInfos.useNormals) {
      meshPrimitiveInfos.vertexNormals = new Float32List.fromList(meshPrimitive.normals);
    }

    if (meshPrimitiveInfos.useUVs) {
      meshPrimitiveInfos.vertexUVs = new Float32List.fromList(meshPrimitive.uvs);
    }

    if (meshPrimitiveInfos.useColors) {
      meshPrimitiveInfos.vertexColors = new Float32List.fromList(meshPrimitive.colors);
    }

    return GLTFMesh.createMesh(meshPrimitiveInfos);
  }

  factory GLTFMesh.custom(Float32List vertexPositions, MeshPrimitiveInfos meshPrimitiveInfos){
    GLTFMesh mesh =  GLTFMesh.createMesh(meshPrimitiveInfos);
    return mesh;
  }

  factory GLTFMesh.point(){
    MeshPrimitive meshPrimitive = new MeshPrimitive.Point();
    MeshPrimitiveInfos meshPrimitiveInfos = new MeshPrimitiveInfos(
        useIndices : false,
        useNormals : false,
        useUVs : false,
        useColors : false);
    GLTFMesh mesh =  createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos)
      ..primitives[0].drawMode = meshPrimitive.mode;
    return mesh;
  }

  factory GLTFMesh.line(List<Vector3> points){
    MeshPrimitive meshPrimitive = new MeshPrimitive.Line(points);
    MeshPrimitiveInfos meshPrimitiveInfos = new MeshPrimitiveInfos(
      useIndices : false,
      useNormals : false,
      useUVs : false,
      useColors : false);
    GLTFMesh mesh =  createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos)
      ..primitives[0].drawMode = meshPrimitive.mode;
    return mesh;
  }

  factory GLTFMesh.triangle({MeshPrimitiveInfos meshPrimitiveInfos}){
    MeshPrimitive meshPrimitive = new MeshPrimitive.Triangle();
    return createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos ??= new MeshPrimitiveInfos());
  }

  factory GLTFMesh.quad({MeshPrimitiveInfos meshPrimitiveInfos}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Quad();
    return createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos ??= new MeshPrimitiveInfos());
  }

  factory GLTFMesh.pyramid({MeshPrimitiveInfos meshPrimitiveInfos}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Pyramid();
    return createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos ??= new MeshPrimitiveInfos());
  }

  factory GLTFMesh.cube({MeshPrimitiveInfos meshPrimitiveInfos}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Cube();
    return createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos ??= new MeshPrimitiveInfos());
  }

  factory GLTFMesh.sphere({double radius : 1.0, int segmentV: 32, int segmentH: 32, MeshPrimitiveInfos meshPrimitiveInfos}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Sphere(radius:radius, segmentV:segmentV, segmentH:segmentH);
    return createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos ??= new MeshPrimitiveInfos());
  }

  factory GLTFMesh.axis({MeshPrimitiveInfos meshPrimitiveInfos}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Axis();
    return createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos ??= new MeshPrimitiveInfos());
  }

  factory GLTFMesh.axisPoint({MeshPrimitiveInfos meshPrimitiveInfos}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.AxisPoints();
    return createMeshWithPrimitive(meshPrimitive, meshPrimitiveInfos ??= new MeshPrimitiveInfos());
  }

  factory GLTFMesh.byMeshType(MeshType meshType, {MeshPrimitiveInfos meshPrimitiveInfos}) {
    GLTFMesh mesh;

    switch (meshType){
      case MeshType.point:
        mesh = new GLTFMesh.point();
        break;
      case MeshType.line:
        mesh = new GLTFMesh.line([new Vector3(0.0,0.0,0.0), new Vector3(2.0,0.0,0.0)]);
        break;
      case MeshType.triangle:
        mesh = new GLTFMesh.triangle();
        break;
      case MeshType.quad:
        mesh = new GLTFMesh.quad();
        break;
      case MeshType.pyramid:
        mesh = new GLTFMesh.pyramid();
        break;
      case MeshType.cube:
        mesh = new GLTFMesh.cube();
        break;
      case MeshType.sphere:
        mesh = new GLTFMesh.sphere();
        break;
      case MeshType.torus:
        throw 'GLTFMesh.byMeshType no torus yet';
        break;
      case MeshType.axis:
        mesh = new GLTFMesh.axis();
        break;
      case MeshType.grid:
        throw 'GLTFMesh.byMeshType no Torus yet';
        break;
      case MeshType.custom:
        throw 'GLTFMesh.byMeshType no custom yet';
        break;
      case MeshType.json:
        throw 'GLTFMesh.byMeshType no json yet';
        break;
      case MeshType.multiLine:
        throw 'GLTFMesh.byMeshType no multiLine yet';
        break;
      case MeshType.vector:
        throw 'GLTFMesh.byMeshType no vector yet';
        break;
      case MeshType.skyBox:
        throw 'GLTFMesh.byMeshType no skyBox yet';
        break;
      case MeshType.axisPoints:
        throw 'GLTFMesh.byMeshType no axisPoints yet';
        break;
    }

    return mesh;
  }
}

@reflector
class MeshPrimitiveInfos{
  final bool useIndices;
  final bool useNormals;
  final bool useUVs;
  final bool useColors;

  MeshPrimitiveInfos({this.useIndices : true, this.useNormals : true, this.useUVs : true, this.useColors : true});

  Float32List vertexPositions;
  Int16List vertexIndices;
  Float32List vertexNormals;
  Float32List vertexUVs;
  Float32List vertexColors;
}