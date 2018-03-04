import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';
import 'package:test_webgl/src/gltf/accessor.dart';
import 'package:test_webgl/src/gltf/buffer.dart';
import 'package:test_webgl/src/gltf/buffer_view.dart';
import 'package:test_webgl/src/gltf/mesh_primitive.dart';
import 'package:test_webgl/src/gltf/project.dart';
import 'package:test_webgl/src/gltf/utils_gltf.dart';
import 'package:test_webgl/src/utils/utils_math.dart';
import 'package:test_webgl/src/webgl_objects/datas/webgl_enum.dart';

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
      for (Triangle triangle in primitive.getFaces()) {
        _faces.add(new Triangle.copy(triangle));
      }
    }
    return _faces;
  }

  static GLTFMesh createMesh(Float32List vertexPositions, Int16List vertexIndices, Float32List vertexNormals, Float32List vertexUvs) {

    //Closure to check new added byte length to the list
    int checkAddedBytes(List<int> baseData, int lastBaseDataLength) {
//    print('added ${baseData.length - lastBaseDataLength} bytes');
      lastBaseDataLength = baseData.length;
      return lastBaseDataLength;
    }

    /// The mesh must have primitive
    GLTFMeshPrimitive primitive =
    new GLTFMeshPrimitive(drawMode: DrawMode.TRIANGLES, hasPosition: vertexPositions != null, hasNormal: vertexNormals != null, hasTextureCoord: vertexUvs != null);

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

    if(vertexIndices != null) {
      /// And the Accessor will have to have a BufferView
      GLTFBufferView bufferView = new GLTFBufferView(
          byteOffset: 0,
          byteLength: vertexIndices.buffer.lengthInBytes,
          byteStride: -1,
          target: BufferType.ELEMENT_ARRAY_BUFFER,
          usage: BufferType.ELEMENT_ARRAY_BUFFER,
      );

      /// The primitive may have Indices Accessor infos
      GLTFAccessor indicesAccessor = new GLTFAccessor(
          byteOffset: 0,
          byteLength: vertexIndices.buffer.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[SCALAR],
          count: vertexIndices.length,//for this Accessor, take length only
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

      baseData.addAll(vertexIndices.buffer.asUint8List().toList());

      ///Find next ofset with multiple of vertexPositions.elementSizeInBytes (4)
      int findNextIntMultiple(int startValue, int multiple){
        startValue -= 1;
        return  startValue + (multiple - startValue % multiple);
      }
      int x = vertexIndices.lengthInBytes;
      int n = vertexPositions.elementSizeInBytes;
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

    if(vertexPositions == null) {
      throw 'vertexPositions POSITION must be defined.';
    } else {

      /// The Accessor must have a BufferView
      GLTFBufferView bufferView = new GLTFBufferView(
          byteOffset: nextMultipleVertexDataOffset,
          byteLength: vertexPositions.buffer.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          target: BufferType.ARRAY_BUFFER,
          usage: BufferType.ARRAY_BUFFER,
      );

      /// The primitive must have POSITION Accessor infos
      GLTFAccessor positionAccessor = new GLTFAccessor(
          byteOffset: 0,
          byteLength: vertexPositions.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          count: vertexPositions.length ~/ vec3ComponentsCount,
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

      baseData.addAll(vertexPositions.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Normals can use same bufferView as Position

    if(vertexNormals != null) {
      /// Normals can use same bufferView as Position.
      /// So there's no need to create a new one.
      /// But length must be adjusted
      primitive.positionAccessor.bufferView.byteLength += vertexNormals.buffer.lengthInBytes;

      /// The primitive may have Indices Accessor infos
      GLTFAccessor normalAccessor = new GLTFAccessor(
          byteOffset: vertexPositions.length ~/ vec3ComponentsCount * 12,
          byteLength: vertexPositions.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          count: vertexNormals.length ~/ vec3ComponentsCount,
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

      baseData.addAll(vertexNormals.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Texture coords

    if(vertexUvs != null) {

      /// as uv is Vec2, it must be reorganised to match stride split
      int count = vertexUvs.length ~/ vec2ComponentsCount;
      vertexUvs = UtilsMath.convertVec2FloatListToVec3FloatList(vertexUvs,0.0);

      /// UV can use same bufferView as Position.
      /// So there's no need to create a new one.
      /// But length must be adjusted in proportion af position even if it's uv
      primitive.positionAccessor.bufferView.byteLength += vertexUvs.buffer.lengthInBytes;

      /// The primitive may have Indices Accessor infos
      GLTFAccessor uvAccessor = new GLTFAccessor(
          byteOffset: count * 12,//byte length
          byteLength: vertexUvs.lengthInBytes,
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

      baseData.addAll(vertexUvs.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Fill buffer with datas

    buffer.data = new Uint8List.fromList(baseData);
    buffer.byteLength = buffer.data.length;

    return mesh;
  }

  static GLTFMesh createMeshWithPrimitive(MeshPrimitive meshPrimitive, bool withIndices, bool withNormals, bool withUVs) {
    Float32List vertexPositions;
    vertexPositions = new Float32List.fromList(meshPrimitive.vertices);

    Int16List vertexIndices;
    if (withIndices) {
      vertexIndices = new Int16List.fromList(meshPrimitive.indices);
    }

    Float32List vertexNormals;
    if (withNormals) {
      vertexNormals = new Float32List.fromList(meshPrimitive.normals);
    }

    Float32List vertexUvs;
    if (withUVs) {
      vertexUvs = new Float32List.fromList(meshPrimitive.uvs);
    }

    return GLTFMesh.createMesh(vertexPositions, vertexIndices, vertexNormals, vertexUvs);
  }

  factory GLTFMesh.custom(Float32List vertexPositions, Int16List vertexIndices, Float32List vertexNormals, Float32List vertexUvs){
    GLTFMesh mesh =  GLTFMesh.createMesh(vertexPositions, vertexIndices, vertexNormals, vertexUvs);
    return mesh;
  }

  factory GLTFMesh.point(){
    MeshPrimitive meshPrimitive = new MeshPrimitive.Point();
    GLTFMesh mesh =  createMeshWithPrimitive(meshPrimitive, false, false, false)
      ..primitives[0].drawMode = meshPrimitive.mode;
    return mesh;
  }

  factory GLTFMesh.line(List<Vector3> points){
    MeshPrimitive meshPrimitive = new MeshPrimitive.Line(points);
    GLTFMesh mesh =  createMeshWithPrimitive(meshPrimitive, false, false, false)
      ..primitives[0].drawMode = meshPrimitive.mode;
    return mesh;
  }

  factory GLTFMesh.triangle({bool withIndices : true, bool withNormals : true, bool withUVs : true}){
    MeshPrimitive meshPrimitive = new MeshPrimitive.Triangle();
    return createMeshWithPrimitive(meshPrimitive, withIndices, withNormals, withUVs);
  }

  factory GLTFMesh.quad({bool withIndices : true, bool withNormals : true, bool withUVs : true}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Quad();
    return createMeshWithPrimitive(meshPrimitive, withIndices, withNormals, withUVs);
  }
  factory GLTFMesh.pyramid({bool withIndices : true, bool withNormals : true, bool withUVs : true}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Pyramid();
    return createMeshWithPrimitive(meshPrimitive, withIndices, withNormals, withUVs);
  }

  factory GLTFMesh.cube({bool withIndices : true, bool withNormals : true, bool withUVs : true}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Cube();
    return createMeshWithPrimitive(meshPrimitive, withIndices, withNormals, withUVs);
  }

  factory GLTFMesh.sphere({double radius : 1.0, int segmentV: 32, int segmentH: 32, bool withIndices : true, bool withNormals : true, bool withUVs : true}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Sphere(radius:radius, segmentV:segmentV, segmentH:segmentH);
    return createMeshWithPrimitive(meshPrimitive, withIndices, withNormals, withUVs);
  }

  factory GLTFMesh.axis({bool withIndices : true, bool withNormals : true, bool withUVs : true}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.Axis();
    return createMeshWithPrimitive(meshPrimitive, withIndices, withNormals, withUVs);
  }

  factory GLTFMesh.axisPoint({bool withIndices : true, bool withNormals : true, bool withUVs : true}) {
    MeshPrimitive meshPrimitive = new MeshPrimitive.AxisPoints();
    return createMeshWithPrimitive(meshPrimitive, withIndices, withNormals, withUVs);
  }
}
