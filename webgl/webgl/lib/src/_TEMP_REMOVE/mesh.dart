//import 'dart:typed_data';
//import 'package:vector_math/vector_math.dart';
//import 'package:webgl/src/geometry/node.dart';
//import 'package:webgl/src/camera.dart';
//import 'package:webgl/src/gltf/mesh/mesh.dart';
//import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
//import 'package:webgl/src/interface/IGizmo.dart';
//import 'package:webgl/src/interface/IScene.dart';
//import 'package:webgl/src/geometry/mesh_primitive.dart';
//import 'package:webgl/src/material/material.dart';
//import 'package:webgl/src/utils/utils_math.dart';
//import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
//
//Vector4 _defaultModelColor = new Vector4(1.0, 0.5, 0.0, 1.0);
//
//enum MeshType {
//  point,
//  line,
//  triangle,
//  quad,
//  pyramid,
//  cube,
//  sphere,
//  torus,
//  axis,
//  grid,
//  custom,
//  json,
//  multiLine,
//  vector,
//  skyBox,
//  axisPoints,
//}
//
//abstract class Mesh extends GLTFMesh {
//
//  MeshType meshType;
//
//  IGizmo _gizmo;
//  IGizmo get gizmo => _gizmo;
//  set gizmo(IGizmo value) => _gizmo = value;
//
//  UpdateFunction _updateFunction;
//  UpdateFunction get updateFunction => _updateFunction;
//  set updateFunction(UpdateFunction value) => _updateFunction = value;
//
//  factory Mesh.createByType(MeshType meshType, {bool doInitMaterial: true}) {
//    Mesh newMesh;
//    switch (meshType) {
////      case ModelType.torus:
////        newModel = new TorusModel(doInitMaterial:doInitMaterial);
////        break;
//      case MeshType.axis:
//        newMesh = new AxisMesh(doInitMaterial: doInitMaterial);
//        break;
//      case MeshType.grid:
//        newMesh = new GridMesh(doInitMaterial: doInitMaterial);
//        break;
//      default:
//        break;
//    }
//    return newMesh;
//  }
//
//  Mesh() {
////    throw new Exception("Don't use this CTOR");
//  }
//
//  // >> JSON
//
//  factory Mesh.fromJson(Map json) {
//    MeshType modelType = MeshType.values.firstWhere(
//        (m) => m.toString() == json["type"],
//        orElse: () => null);
//
//    Mesh object3d = new Mesh.createByType(modelType, doInitMaterial: true)
//      ..name = json["name"].toString();
////      ..rotation = new Matrix3.fromList(json["rotation"])
////      ..scale = ??;
//    if(json["position"] != null) {
//      object3d.translation = new Vector3.fromFloat32List(new Float32List.fromList(json["position"]as List<double>));
//    }
//    if(json["transform"] != null) {
//      object3d.matrix = new Matrix4.fromFloat32List(new Float32List.fromList(json["transform"] as List<double>));
//    }
//    return object3d;
//  }
//
//  Map toJson() {
//    Map json = new Map<String, dynamic>();
//    json["type"] = meshType.toString();
//    json["name"] = name;
////    json["position"] = position.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
////    json["rotation"] = rotation.storage;//.map((v)=>UtilsMath.roundPrecision(v)).toList();
////    json["scale"] = ??;
//    json["transform"] = matrix.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
//    return json;
//  }
//}
//

//
//class JsonMesh extends Mesh {
//  MeshType get meshType => MeshType.json;
//  JsonMesh(Map jsonFile, {bool doInitMaterial: true}) {
//    primitives
//      ..vertices = jsonFile['meshes'][0]['vertices'] as List<double>
//      ..indices = (jsonFile['meshes'][0]['faces']).expand((List<int> i) => i).toList() as List<int>
//      ..textureCoords = jsonFile['meshes'][0]['texturecoords'][0] as List<double>
//      ..vertexNormals = jsonFile['meshes'][0]['normals'] as List<double>
//      ..material = new MaterialBase();
//  }
//}
//
//
//class FrustrumGizmo extends Mesh implements IGizmo {
//  bool visible = false;
//
//  final CameraPerspective _camera;
//  Matrix4 get _vpmatrix => _camera.viewProjectionMatrix;
//
//  Vector4 _positionColor = new Vector4(0.0, 1.0, 1.0, 1.0);
//  Vector4 _frustrumColor = new Vector4(0.0, 0.7, 1.0, 1.0);
//
//  num _positionPointSize = 6.0;
//
//  //camera
//  final Vector3 cameraPosition = new Vector3.zero();
//  final Vector3 cameraTargetPosition = new Vector3.zero();
//  //near
//  final Vector3 c0 = new Vector3.zero();
//  final Vector3 c1 = new Vector3.zero();
//  final Vector3 c2 = new Vector3.zero();
//  final Vector3 c3 = new Vector3.zero();
//  //far
//  final Vector3 c4 = new Vector3.zero();
//  final Vector3 c5 = new Vector3.zero();
//  final Vector3 c6 = new Vector3.zero();
//  final Vector3 c7 = new Vector3.zero();
//
//  final PointMesh cameraPositionPoint = new PointMesh();
//  final PointMesh cameraTargetPositionPoint = new PointMesh();
//
//  @override
//  List<Mesh> gizmoModels = [];
//
//  FrustrumGizmo(CameraPerspective camera) : _camera = camera {
//    _createFrustrumModel(_camera.viewProjectionMatrix);
//  }
//
//  void _createFrustrumModel(Matrix4 cameraMatrix) {
//    MaterialPoint frustrumPositionPointMaterial =
//        new MaterialPoint(pointSize: _positionPointSize, color: _positionColor);
//
//    MaterialBaseColor frustrumDirectionLineMaterial =
//        new MaterialBaseColor(_frustrumColor);
//
//    //near plane
//    gizmoModels
//        .add(new LineMesh(c0, c1)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c1, c2)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c2, c3)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c3, c0)..primitive.material = frustrumDirectionLineMaterial);
//
//    //far plane
//    gizmoModels
//        .add(new LineMesh(c4, c5)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c5, c6)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c6, c7)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c7, c4)..primitive.material = frustrumDirectionLineMaterial);
//
//    //sides
//    gizmoModels
//        .add(new LineMesh(c0, c4)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c1, c5)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c2, c6)..primitive.material = frustrumDirectionLineMaterial);
//    gizmoModels
//        .add(new LineMesh(c3, c7)..primitive.material = frustrumDirectionLineMaterial);
//
//    gizmoModels.add(new LineMesh(cameraPosition, cameraTargetPosition)
//      ..primitive.material = frustrumDirectionLineMaterial);
//
//    gizmoModels.add(cameraPositionPoint
//      ..primitive.material = frustrumPositionPointMaterial); //position
//    gizmoModels.add(cameraTargetPositionPoint
//      ..primitive.material = frustrumPositionPointMaterial); //target
//
//    updateGizmo();
//  }
//
//  @override
//  void updateGizmo() {
//    //Update only final positions
//    new Frustum.matrix(_vpmatrix)
//      ..calculateCorners(c5, c4, c0, c1, c6, c7, c3, c2);
//
//    cameraPosition.setFrom(_camera.translation);
//    cameraTargetPosition.setFrom(_camera.targetPosition);
//
//    cameraPositionPoint..translation = _camera.translation;
//    cameraTargetPositionPoint..translation = _camera.targetPosition;
//  }
//
//  @override
//  void render() {
//    if (!visible) return;
//    for (Mesh model in gizmoModels) {
//      model.render();
//    }
//  }
//}

////Todo : convert from javascript
//class TorusMesh extends Mesh {
//  /*
//  // Creates a 3D torus in the XY plane, returns the data in a new object composed of
////   several Float32Array objects named 'vertices' and 'colors', according to
////   the following parameters:
//// r:  big radius
//// sr: section radius
//// n:  number of faces
//// sn: number of faces on section
//// k:  factor between 0 and 1 defining the space between strips of the torus
//function makeTorus(r, sr, n, sn, k)
//{
//  // Temporary arrays for the vertices, normals and colors
//  var tv = new Array();
//  var tc = new Array();
//
//  // Iterates along the big circle and then around a section
//  for(var i=0;i<n;i++)               // Iterates over all strip rounds
//    for(var j=0;j<sn+1*(i==n-1);j++) // Iterates along the torus section
//      for(var v=0;v<2;v++)           // Creates zigzag pattern (v equals 0 or 1)
//      {
//        // Pre-calculation of angles
//        var a =  2*Math.PI*(i+j/sn+k*v)/n;
//        var sa = 2*Math.PI*j/sn;
//        var x, y, z;
//
//        // Coordinates on the surface of the torus
//        tv.push(x = (r+sr*Math.cos(sa))*Math.cos(a)); // X
//        tv.push(y = (r+sr*Math.cos(sa))*Math.sin(a)); // Y
//        tv.push(z = sr*Math.sin(sa));                 // Z
//
//        // Colors
//        tc.push(0.5+0.5*x);  // R
//        tc.push(0.5+0.5*y);  // G
//        tc.push(0.5+0.5*z);  // B
//        tc.push(1.0);  // Alpha
//      }
//
//  // Converts and returns array
//  var res = new Object();
//  res.vertices = new Float32Array(tv);
//  res.colors = new Float32Array(tc);
//  return res;
//}
//   */
//}

