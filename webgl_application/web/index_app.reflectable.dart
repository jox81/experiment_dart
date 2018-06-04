// This file has been generated by the reflectable package.
// https://github.com/dart-lang/reflectable.

import "dart:core";
import 'package:reflectable/mirrors.dart' as prefix21;
import 'package:vector_math/vector_math.dart' as prefix20;
import 'package:webgl/src/animation/animation_property.dart' as prefix22;
import 'package:webgl/src/camera/camera.dart' as prefix8;
import 'package:webgl/src/gltf/accessor.dart' as prefix16;
import 'package:webgl/src/gltf/animation.dart' as prefix18;
import 'package:webgl/src/gltf/asset.dart' as prefix19;
import 'package:webgl/src/gltf/buffer.dart' as prefix14;
import 'package:webgl/src/gltf/buffer_view.dart' as prefix15;
import 'package:webgl/src/gltf/image.dart' as prefix11;
import 'package:webgl/src/gltf/material.dart' as prefix9;
import 'package:webgl/src/gltf/mesh.dart' as prefix12;
import 'package:webgl/src/gltf/node.dart' as prefix1;
import 'package:webgl/src/gltf/project.dart' as prefix2;
import 'package:webgl/src/gltf/sampler.dart' as prefix17;
import 'package:webgl/src/gltf/scene.dart' as prefix3;
import 'package:webgl/src/gltf/skin.dart' as prefix6;
import 'package:webgl/src/gltf/texture.dart' as prefix10;
import 'package:webgl/src/gltf/utils_gltf.dart' as prefix5;
import 'package:webgl/src/interface/IComponent.dart' as prefix7;
import 'package:webgl/src/introspection.dart' as prefix0;
import 'package:webgl/src/light/light.dart' as prefix13;
import 'package:webgl_application/src/introspection/base/base.dart' as prefix4;

// ignore:unused_import
import "package:reflectable/mirrors.dart" as m;
// ignore:unused_import
import "package:reflectable/src/reflectable_transformer_based.dart" as r;
// ignore:unused_import
import "package:reflectable/reflectable.dart" show isTransformed;

final _data = {const prefix0.Reflector(): new r.ReflectorData(<m.TypeMirror>[new r.NonGenericClassMirrorImpl(r"GLTFNode", r".GLTFNode", 7, 0, const prefix0.Reflector(), const <int>[0, 1, 2, 3, 4, 5, 31, 32, 33, 34, 35, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66], const <int>[67, 35, 68, 69, 70, 71, 72, 73, 74, 75, 76, 31, 32, 33, 34, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65], const <int>[36, 37], 7, {r"nextId": () => prefix1.GLTFNode.nextId}, {r"nextId=": (value) => prefix1.GLTFNode.nextId = value}, {r"": (b) => ({name: ''}) => b ? new prefix1.GLTFNode(name: name) : null}, -1, 0, const <int>[], const <Object>[prefix0.reflector], null), new r.NonGenericClassMirrorImpl(r"GLTFProject", r".GLTFProject", 7, 1, const prefix0.Reflector(), const <int>[9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 77, 78, 79, 80, 107, 108, 109, 110, 111, 112], const <int>[67, 79, 68, 69, 70, 77, 78, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 108, 109, 110, 111], const <int>[80, 107], 8, {r"reset": () => prefix2.GLTFProject.reset, r"instance": () => prefix2.GLTFProject.instance}, {}, {r"create": (b) => ({reset: false}) => b ? new prefix2.GLTFProject.create(reset: reset) : null}, -1, 1, const <int>[], const <Object>[prefix0.reflector], null), new r.NonGenericClassMirrorImpl(r"GLTFScene", r".GLTFScene", 7, 2, const prefix0.Reflector(), const <int>[22, 23, 24, 113, 114, 115, 121, 122], const <int>[67, 114, 68, 69, 70, 71, 72, 73, 74, 75, 76, 113, 115, 118, 119, 120, 121], const <int>[116, 117], 7, {r"nextId": () => prefix3.GLTFScene.nextId}, {r"nextId=": (value) => prefix3.GLTFScene.nextId = value}, {r"": (b) => ({name: ''}) => b ? new prefix3.GLTFScene(name: name) : null}, -1, 2, const <int>[], const <Object>[prefix0.reflector], null), new r.NonGenericClassMirrorImpl(r"FunctionModel", r".FunctionModel", 7, 3, const prefix0.Reflector(), const <int>[25, 26, 27, 123, 124, 125, 126, 127, 128, 129, 130, 134], const <int>[67, 135, 68, 69, 70, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133], const <int>[], 8, {}, {}, {r"": (b) => (function, instancesMirror, methodMirror) => b ? new prefix0.FunctionModel(function, instancesMirror, methodMirror) : null}, -1, 3, const <int>[], const <Object>[prefix0.reflector], null), new r.NonGenericClassMirrorImpl(r"IEditElement", r".IEditElement", 519, 4, const prefix0.Reflector(), const <int>[28, 136, 137, 138, 141, 142], const <int>[67, 135, 68, 69, 70, 136, 137, 138, 139, 140, 141], const <int>[], 8, {}, {}, {}, -1, 4, const <int>[], const <Object>[prefix0.reflector], null), new r.NonGenericClassMirrorImpl(r"CustomEditElement", r".CustomEditElement", 7, 5, const prefix0.Reflector(), const <int>[29, 144], const <int>[67, 135, 68, 69, 70, 136, 137, 138, 139, 140, 141, 143], const <int>[], 4, {}, {}, {r"": (b) => (element) => b ? new prefix0.CustomEditElement(element) : null}, -1, 5, const <int>[], const <Object>[prefix0.reflector], null), new r.NonGenericClassMirrorImpl(r"RefTest", r".RefTest", 7, 6, const prefix0.Reflector(), const <int>[30, 145, 146, 148, 149, 150], const <int>[67, 135, 68, 69, 70, 136, 137, 138, 139, 140, 141, 145, 146, 147, 148, 149], const <int>[], 4, {}, {}, {r"": (b) => (a) => b ? new prefix4.RefTest(a) : null}, -1, 6, const <int>[], const <Object>[prefix0.reflector], null), new r.NonGenericClassMirrorImpl(r"GLTFChildOfRootProperty", r".GLTFChildOfRootProperty", 519, 7, const prefix0.Reflector(), const <int>[8, 151], const <int>[67, 135, 68, 69, 70, 71, 72, 73, 74, 75, 76], const <int>[], 9, {}, {}, {}, -1, 7, const <int>[], const <Object>[], null), new r.NonGenericClassMirrorImpl(r"Object", r"dart.core.Object", 7, 8, const prefix0.Reflector(), const <int>[67, 135, 68, 69, 70, 152], const <int>[67, 135, 68, 69, 70], const <int>[], null, {}, {}, {r"": (b) => () => b ? new Object() : null}, -1, 8, const <int>[], const <Object>[], null), new r.NonGenericClassMirrorImpl(r"GltfProperty", r".GltfProperty", 519, 9, const prefix0.Reflector(), const <int>[6, 7, 153], const <int>[67, 135, 68, 69, 70, 71, 72, 73, 74], const <int>[], 8, {}, {}, {}, -1, 9, const <int>[], const <Object>[], null)], <m.DeclarationMirror>[new r.VariableMirrorImpl(r"nextId", 32789, 0, const prefix0.Reflector(), -1, 10, 10, const <Object>[]), new r.VariableMirrorImpl(r"nodeId", 33797, 0, const prefix0.Reflector(), -1, 10, 10, const <Object>[]), new r.VariableMirrorImpl(r"weights", 2129925, 0, const prefix0.Reflector(), -1, 11, 12, const <Object>[]), new r.VariableMirrorImpl(r"skin", 32773, 0, const prefix0.Reflector(), -1, 13, 13, const <Object>[]), new r.VariableMirrorImpl(r"isJoint", 32773, 0, const prefix0.Reflector(), -1, 14, 14, const <Object>[]), new r.VariableMirrorImpl(r"components", 2129925, 0, const prefix0.Reflector(), -1, 15, 16, const <Object>[]), new r.VariableMirrorImpl(r"extensions", 2129925, 9, const prefix0.Reflector(), -1, 17, 18, const <Object>[]), new r.VariableMirrorImpl(r"extras", 32773, 9, const prefix0.Reflector(), 8, 8, 8, const <Object>[]), new r.VariableMirrorImpl(r"name", 32773, 7, const prefix0.Reflector(), -1, 19, 19, const <Object>[]), new r.VariableMirrorImpl(r"baseDirectory", 32773, 1, const prefix0.Reflector(), -1, 19, 19, const <Object>[]), new r.VariableMirrorImpl(r"cameras", 2129925, 1, const prefix0.Reflector(), -1, 20, 21, const <Object>[]), new r.VariableMirrorImpl(r"materials", 2129925, 1, const prefix0.Reflector(), -1, 22, 23, const <Object>[]), new r.VariableMirrorImpl(r"textures", 2129925, 1, const prefix0.Reflector(), -1, 24, 25, const <Object>[]), new r.VariableMirrorImpl(r"images", 2129925, 1, const prefix0.Reflector(), -1, 26, 27, const <Object>[]), new r.VariableMirrorImpl(r"meshes", 2129925, 1, const prefix0.Reflector(), -1, 28, 29, const <Object>[]), new r.VariableMirrorImpl(r"lights", 2129925, 1, const prefix0.Reflector(), -1, 30, 31, const <Object>[]), new r.VariableMirrorImpl(r"buffers", 2129925, 1, const prefix0.Reflector(), -1, 32, 33, const <Object>[]), new r.VariableMirrorImpl(r"bufferViews", 2129925, 1, const prefix0.Reflector(), -1, 34, 35, const <Object>[]), new r.VariableMirrorImpl(r"accessors", 2129925, 1, const prefix0.Reflector(), -1, 36, 37, const <Object>[]), new r.VariableMirrorImpl(r"samplers", 2129925, 1, const prefix0.Reflector(), -1, 38, 39, const <Object>[]), new r.VariableMirrorImpl(r"animations", 2129925, 1, const prefix0.Reflector(), -1, 40, 41, const <Object>[]), new r.VariableMirrorImpl(r"asset", 32773, 1, const prefix0.Reflector(), -1, 42, 42, const <Object>[]), new r.VariableMirrorImpl(r"nextId", 32789, 2, const prefix0.Reflector(), -1, 10, 10, const <Object>[]), new r.VariableMirrorImpl(r"sceneId", 33797, 2, const prefix0.Reflector(), -1, 10, 10, const <Object>[]), new r.VariableMirrorImpl(r"backgroundColor", 32773, 2, const prefix0.Reflector(), -1, 43, 43, const <Object>[]), new r.VariableMirrorImpl(r"function", 33797, 3, const prefix0.Reflector(), -1, 44, 44, const <Object>[]), new r.VariableMirrorImpl(r"instancesMirror", 33797, 3, const prefix0.Reflector(), -1, 45, 45, const <Object>[]), new r.VariableMirrorImpl(r"methodMirror", 33797, 3, const prefix0.Reflector(), -1, 46, 46, const <Object>[]), new r.VariableMirrorImpl(r"name", 32773, 4, const prefix0.Reflector(), -1, 19, 19, const <Object>[]), new r.VariableMirrorImpl(r"element", 17413, 5, const prefix0.Reflector(), null, null, null, const <Object>[]), new r.VariableMirrorImpl(r"a", 33797, 6, const prefix0.Reflector(), -1, 10, 10, const <Object>[]), new r.MethodMirrorImpl(r"translate", 262146, 0, null, -1, -1, const <int>[0], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"addChild", 262146, 0, null, -1, -1, const <int>[1], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"addComponent", 262146, 0, null, -1, -1, const <int>[2], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"update", 262146, 0, null, -1, -1, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"toString", 131074, 0, -1, 19, 19, const <int>[], const prefix0.Reflector(), const <Object>[override]), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 0, 10, 10, 36), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 0, 10, 10, 37), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 1, 10, 10, 38), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 2, 11, 12, 39), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 2, 11, 12, 40), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 3, 13, 13, 41), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 3, 13, 13, 42), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 4, 14, 14, 43), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 4, 14, 14, 44), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 5, 15, 16, 45), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 5, 15, 16, 46), new r.MethodMirrorImpl(r"translation", 131075, 0, -1, 47, 47, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"translation=", 262148, 0, null, -1, -1, const <int>[9], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"rotation", 131075, 0, -1, 48, 48, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"rotation=", 262148, 0, null, -1, -1, const <int>[10], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"scale", 131075, 0, -1, 47, 47, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"scale=", 262148, 0, null, -1, -1, const <int>[11], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"matrix", 131075, 0, -1, 49, 49, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"matrix=", 262148, 0, null, -1, -1, const <int>[12], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"parentMatrix", 131075, 0, -1, 49, 49, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"children", 4325379, 0, -1, 50, 51, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"children=", 262148, 0, null, -1, -1, const <int>[13], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"parent", 131075, 0, 0, 0, 0, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"parent=", 262148, 0, null, -1, -1, const <int>[14], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"mesh", 131075, 0, -1, 52, 52, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"mesh=", 262148, 0, null, -1, -1, const <int>[15], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"camera", 131075, 0, -1, 53, 53, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"camera=", 262148, 0, null, -1, -1, const <int>[16], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"visible", 131075, 0, -1, 14, 14, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"visible=", 262148, 0, null, -1, -1, const <int>[17], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"", 0, 0, -1, 0, 0, const <int>[3], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"==", 131074, 8, -1, 14, 14, const <int>[18], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"noSuchMethod", 65538, 8, null, null, null, const <int>[19], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"hashCode", 131075, 8, -1, 10, 10, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"runtimeType", 131075, 8, -1, 54, 54, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 6, 17, 18, 71), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 6, 17, 18, 72), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 7, 8, 8, 73), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 7, 8, 8, 74), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 8, 19, 19, 75), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 8, 19, 19, 76), new r.MethodMirrorImpl(r"addScene", 262146, 1, null, -1, -1, const <int>[23], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"addNode", 262146, 1, null, -1, -1, const <int>[24], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"toString", 131074, 1, -1, 19, 19, const <int>[], const prefix0.Reflector(), const <Object>[override]), new r.MethodMirrorImpl(r"reset", 262162, 1, null, -1, -1, const <int>[25], const prefix0.Reflector(), const <Object>[]), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 9, 19, 19, 81), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 9, 19, 19, 82), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 10, 20, 21, 83), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 10, 20, 21, 84), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 11, 22, 23, 85), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 11, 22, 23, 86), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 12, 24, 25, 87), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 12, 24, 25, 88), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 13, 26, 27, 89), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 13, 26, 27, 90), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 14, 28, 29, 91), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 14, 28, 29, 92), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 15, 30, 31, 93), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 15, 30, 31, 94), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 16, 32, 33, 95), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 16, 32, 33, 96), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 17, 34, 35, 97), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 17, 34, 35, 98), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 18, 36, 37, 99), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 18, 36, 37, 100), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 19, 38, 39, 101), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 19, 38, 39, 102), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 20, 40, 41, 103), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 20, 40, 41, 104), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 21, 42, 42, 105), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 21, 42, 42, 106), new r.MethodMirrorImpl(r"instance", 131091, 1, 1, 1, 1, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"scenes", 4325379, 1, -1, 55, 56, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"scene", 131075, 1, 2, 2, 2, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"scene=", 262148, 1, null, -1, -1, const <int>[40], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"nodes", 4325379, 1, -1, 50, 51, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"create", 1, 1, -1, 1, 1, const <int>[26], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"addNode", 262146, 2, null, -1, -1, const <int>[41], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"toString", 131074, 2, -1, 19, 19, const <int>[], const prefix0.Reflector(), const <Object>[override]), new r.MethodMirrorImpl(r"makeCurrent", 262146, 2, null, -1, -1, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 22, 10, 10, 116), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 22, 10, 10, 117), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 23, 10, 10, 118), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 24, 43, 43, 119), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 24, 43, 43, 120), new r.MethodMirrorImpl(r"nodes", 4325379, 2, -1, 50, 51, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"", 0, 2, -1, 2, 2, const <int>[42], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"getName", 131074, 3, -1, 19, 19, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"getParameters", 4325378, 3, -1, 57, 58, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"getPositionalArgumentsString", 4325378, 3, -1, 57, 58, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"getPositionalArguments", 4325378, 3, -1, 59, 60, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"getNamedArgumentsString", 4325378, 3, -1, 57, 58, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"getNamedArguments", 4325378, 3, -1, 59, 60, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"getReturnType", 131074, 3, -1, 19, 19, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"invoke", 65538, 3, null, null, null, const <int>[45, 46, 47], const prefix0.Reflector(), const <Object>[]), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 25, 44, 44, 131), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 26, 45, 45, 132), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 27, 46, 46, 133), new r.MethodMirrorImpl(r"", 0, 3, -1, 3, 3, const <int>[48, 49, 50], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"toString", 131074, 8, -1, 19, 19, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"getPropertiesInfos", 4325378, 4, -1, 61, 62, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"edit", 262146, 4, null, -1, -1, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"toJson", 4325378, 4, -1, 63, 64, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 28, 19, 19, 139), new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 28, 19, 19, 140), new r.MethodMirrorImpl(r"properties", 4325379, 4, -1, 61, 62, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"", 64, 4, -1, 4, 4, const <int>[], const prefix0.Reflector(), const []), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 29, null, null, 143), new r.MethodMirrorImpl(r"", 0, 5, -1, 5, 5, const <int>[52], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"greater", 65538, 6, null, null, null, const <int>[53], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"lessEqual", 65538, 6, null, null, null, const <int>[54], const prefix0.Reflector(), const <Object>[]), new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 30, 10, 10, 147), new r.MethodMirrorImpl(r"b", 131075, 6, -1, 10, 10, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"b=", 262148, 6, null, -1, -1, const <int>[56], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"", 0, 6, -1, 6, 6, const <int>[55], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"", 0, 7, -1, 7, 7, const <int>[57], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"", 128, 8, -1, 8, 8, const <int>[], const prefix0.Reflector(), const <Object>[]), new r.MethodMirrorImpl(r"", 0, 9, -1, 9, 9, const <int>[], const prefix0.Reflector(), const <Object>[])], <m.ParameterMirror>[new r.ParameterMirrorImpl(r"vector3", 32774, 31, const prefix0.Reflector(), -1, 47, 47, const <Object>[], null, null), new r.ParameterMirrorImpl(r"node", 32774, 32, const prefix0.Reflector(), 0, 0, 0, const <Object>[], null, null), new r.ParameterMirrorImpl(r"component", 32774, 33, const prefix0.Reflector(), -1, 65, 65, const <Object>[], null, null), new r.ParameterMirrorImpl(r"name", 47110, 66, const prefix0.Reflector(), -1, 19, 19, const <Object>[], '', #name), new r.ParameterMirrorImpl(r"_nextId", 32870, 37, const prefix0.Reflector(), -1, 10, 10, const [], null, null), new r.ParameterMirrorImpl(r"_weights", 2130022, 40, const prefix0.Reflector(), -1, 11, 12, const [], null, null), new r.ParameterMirrorImpl(r"_skin", 32870, 42, const prefix0.Reflector(), -1, 13, 13, const [], null, null), new r.ParameterMirrorImpl(r"_isJoint", 32870, 44, const prefix0.Reflector(), -1, 14, 14, const [], null, null), new r.ParameterMirrorImpl(r"_components", 2130022, 46, const prefix0.Reflector(), -1, 15, 16, const [], null, null), new r.ParameterMirrorImpl(r"value", 32774, 48, const prefix0.Reflector(), -1, 47, 47, const <Object>[], null, null), new r.ParameterMirrorImpl(r"value", 32774, 50, const prefix0.Reflector(), -1, 48, 48, const <Object>[], null, null), new r.ParameterMirrorImpl(r"value", 32774, 52, const prefix0.Reflector(), -1, 47, 47, const <Object>[], null, null), new r.ParameterMirrorImpl(r"value", 32774, 54, const prefix0.Reflector(), -1, 49, 49, const <Object>[], null, null), new r.ParameterMirrorImpl(r"children", 2129926, 57, const prefix0.Reflector(), -1, 50, 51, const <Object>[], null, null), new r.ParameterMirrorImpl(r"node", 32774, 59, const prefix0.Reflector(), 0, 0, 0, const <Object>[], null, null), new r.ParameterMirrorImpl(r"value", 32774, 61, const prefix0.Reflector(), -1, 52, 52, const <Object>[], null, null), new r.ParameterMirrorImpl(r"value", 32774, 63, const prefix0.Reflector(), -1, 53, 53, const <Object>[], null, null), new r.ParameterMirrorImpl(r"value", 32774, 65, const prefix0.Reflector(), -1, 14, 14, const <Object>[], null, null), new r.ParameterMirrorImpl(r"other", 16390, 67, const prefix0.Reflector(), null, null, null, const <Object>[], null, null), new r.ParameterMirrorImpl(r"invocation", 32774, 68, const prefix0.Reflector(), -1, 66, 66, const <Object>[], null, null), new r.ParameterMirrorImpl(r"_extensions", 2130022, 72, const prefix0.Reflector(), -1, 17, 18, const [], null, null), new r.ParameterMirrorImpl(r"_extras", 32870, 74, const prefix0.Reflector(), 8, 8, 8, const [], null, null), new r.ParameterMirrorImpl(r"_name", 32870, 76, const prefix0.Reflector(), -1, 19, 19, const [], null, null), new r.ParameterMirrorImpl(r"scene", 32774, 77, const prefix0.Reflector(), 2, 2, 2, const <Object>[], null, null), new r.ParameterMirrorImpl(r"value", 32774, 78, const prefix0.Reflector(), 0, 0, 0, const <Object>[], null, null), new r.ParameterMirrorImpl(r"fullReset", 47110, 80, const prefix0.Reflector(), -1, 14, 14, const <Object>[], false, #fullReset), new r.ParameterMirrorImpl(r"reset", 47110, 112, const prefix0.Reflector(), -1, 14, 14, const <Object>[], false, #reset), new r.ParameterMirrorImpl(r"_baseDirectory", 32870, 82, const prefix0.Reflector(), -1, 19, 19, const [], null, null), new r.ParameterMirrorImpl(r"_cameras", 2130022, 84, const prefix0.Reflector(), -1, 20, 21, const [], null, null), new r.ParameterMirrorImpl(r"_materials", 2130022, 86, const prefix0.Reflector(), -1, 22, 23, const [], null, null), new r.ParameterMirrorImpl(r"_textures", 2130022, 88, const prefix0.Reflector(), -1, 24, 25, const [], null, null), new r.ParameterMirrorImpl(r"_images", 2130022, 90, const prefix0.Reflector(), -1, 26, 27, const [], null, null), new r.ParameterMirrorImpl(r"_meshes", 2130022, 92, const prefix0.Reflector(), -1, 28, 29, const [], null, null), new r.ParameterMirrorImpl(r"_lights", 2130022, 94, const prefix0.Reflector(), -1, 30, 31, const [], null, null), new r.ParameterMirrorImpl(r"_buffers", 2130022, 96, const prefix0.Reflector(), -1, 32, 33, const [], null, null), new r.ParameterMirrorImpl(r"_bufferViews", 2130022, 98, const prefix0.Reflector(), -1, 34, 35, const [], null, null), new r.ParameterMirrorImpl(r"_accessors", 2130022, 100, const prefix0.Reflector(), -1, 36, 37, const [], null, null), new r.ParameterMirrorImpl(r"_samplers", 2130022, 102, const prefix0.Reflector(), -1, 38, 39, const [], null, null), new r.ParameterMirrorImpl(r"_animations", 2130022, 104, const prefix0.Reflector(), -1, 40, 41, const [], null, null), new r.ParameterMirrorImpl(r"_asset", 32870, 106, const prefix0.Reflector(), -1, 42, 42, const [], null, null), new r.ParameterMirrorImpl(r"value", 32774, 110, const prefix0.Reflector(), 2, 2, 2, const <Object>[], null, null), new r.ParameterMirrorImpl(r"node", 32774, 113, const prefix0.Reflector(), 0, 0, 0, const <Object>[], null, null), new r.ParameterMirrorImpl(r"name", 47110, 122, const prefix0.Reflector(), -1, 19, 19, const <Object>[], '', #name), new r.ParameterMirrorImpl(r"_nextId", 32870, 117, const prefix0.Reflector(), -1, 10, 10, const [], null, null), new r.ParameterMirrorImpl(r"_backgroundColor", 32870, 120, const prefix0.Reflector(), -1, 43, 43, const [], null, null), new r.ParameterMirrorImpl(r"memberName", 32774, 130, const prefix0.Reflector(), -1, 19, 19, const <Object>[], null, null), new r.ParameterMirrorImpl(r"positionalArguments", 2129926, 130, const prefix0.Reflector(), -1, 67, 68, const <Object>[], null, null), new r.ParameterMirrorImpl(r"namedArguments", 2129926, 130, const prefix0.Reflector(), -1, 69, 70, const <Object>[], null, null), new r.ParameterMirrorImpl(r"function", 32774, 134, const prefix0.Reflector(), -1, 44, 44, const <Object>[], null, null), new r.ParameterMirrorImpl(r"instancesMirror", 32774, 134, const prefix0.Reflector(), -1, 45, 45, const <Object>[], null, null), new r.ParameterMirrorImpl(r"methodMirror", 32774, 134, const prefix0.Reflector(), -1, 46, 46, const <Object>[], null, null), new r.ParameterMirrorImpl(r"_name", 32870, 140, const prefix0.Reflector(), -1, 19, 19, const [], null, null), new r.ParameterMirrorImpl(r"element", 16390, 144, const prefix0.Reflector(), null, null, null, const <Object>[], null, null), new r.ParameterMirrorImpl(r"x", 32774, 145, const prefix0.Reflector(), -1, 10, 10, const <Object>[], null, null), new r.ParameterMirrorImpl(r"x", 32774, 146, const prefix0.Reflector(), -1, 10, 10, const <Object>[], null, null), new r.ParameterMirrorImpl(r"a", 32774, 150, const prefix0.Reflector(), -1, 10, 10, const <Object>[], null, null), new r.ParameterMirrorImpl(r"value", 32774, 149, const prefix0.Reflector(), -1, 10, 10, const <Object>[], null, null), new r.ParameterMirrorImpl(r"name", 32774, 151, const prefix0.Reflector(), -1, 19, 19, const <Object>[], null, null)], <Type>[prefix1.GLTFNode, prefix2.GLTFProject, prefix3.GLTFScene, prefix0.FunctionModel, prefix0.IEditElement, prefix0.CustomEditElement, prefix4.RefTest, prefix5.GLTFChildOfRootProperty, Object, prefix5.GltfProperty, int, const m.TypeValue<List<double>>().type, List, prefix6.GLTFSkin, bool, const m.TypeValue<List<prefix7.IComponent>>().type, List, const m.TypeValue<Map<String, Object>>().type, Map, String, const m.TypeValue<List<prefix8.Camera>>().type, List, const m.TypeValue<List<prefix9.GLTFPBRMaterial>>().type, List, const m.TypeValue<List<prefix10.GLTFTexture>>().type, List, const m.TypeValue<List<prefix11.GLTFImage>>().type, List, const m.TypeValue<List<prefix12.GLTFMesh>>().type, List, const m.TypeValue<List<prefix13.Light>>().type, List, const m.TypeValue<List<prefix14.GLTFBuffer>>().type, List, const m.TypeValue<List<prefix15.GLTFBufferView>>().type, List, const m.TypeValue<List<prefix16.GLTFAccessor>>().type, List, const m.TypeValue<List<prefix17.GLTFSampler>>().type, List, const m.TypeValue<List<prefix18.GLTFAnimation>>().type, List, prefix19.GLTFAsset, prefix20.Vector4, Function, prefix21.InstanceMirror, prefix21.MethodMirror, prefix20.Vector3, prefix20.Quaternion, prefix20.Matrix4, const m.TypeValue<List<prefix1.GLTFNode>>().type, List, prefix12.GLTFMesh, prefix8.Camera, Type, const m.TypeValue<List<prefix3.GLTFScene>>().type, List, const m.TypeValue<List<String>>().type, List, const m.TypeValue<List<prefix21.ParameterMirror>>().type, List, const m.TypeValue<Map<String, prefix22.EditableProperty<dynamic>>>().type, Map, const m.TypeValue<Map<dynamic, dynamic>>().type, Map, prefix7.IComponent, Invocation, const m.TypeValue<List<dynamic>>().type, List, const m.TypeValue<Map<Symbol, dynamic>>().type, Map], 10, {r"==": (dynamic instance) => (x) => instance == x, r"toString": (dynamic instance) => instance.toString, r"noSuchMethod": (dynamic instance) => instance.noSuchMethod, r"hashCode": (dynamic instance) => instance.hashCode, r"runtimeType": (dynamic instance) => instance.runtimeType, r"extensions": (dynamic instance) => instance.extensions, r"extras": (dynamic instance) => instance.extras, r"name": (dynamic instance) => instance.name, r"translate": (dynamic instance) => instance.translate, r"addChild": (dynamic instance) => instance.addChild, r"addComponent": (dynamic instance) => instance.addComponent, r"update": (dynamic instance) => instance.update, r"nodeId": (dynamic instance) => instance.nodeId, r"weights": (dynamic instance) => instance.weights, r"skin": (dynamic instance) => instance.skin, r"isJoint": (dynamic instance) => instance.isJoint, r"components": (dynamic instance) => instance.components, r"translation": (dynamic instance) => instance.translation, r"rotation": (dynamic instance) => instance.rotation, r"scale": (dynamic instance) => instance.scale, r"matrix": (dynamic instance) => instance.matrix, r"parentMatrix": (dynamic instance) => instance.parentMatrix, r"children": (dynamic instance) => instance.children, r"parent": (dynamic instance) => instance.parent, r"mesh": (dynamic instance) => instance.mesh, r"camera": (dynamic instance) => instance.camera, r"visible": (dynamic instance) => instance.visible, r"addScene": (dynamic instance) => instance.addScene, r"addNode": (dynamic instance) => instance.addNode, r"baseDirectory": (dynamic instance) => instance.baseDirectory, r"cameras": (dynamic instance) => instance.cameras, r"materials": (dynamic instance) => instance.materials, r"textures": (dynamic instance) => instance.textures, r"images": (dynamic instance) => instance.images, r"meshes": (dynamic instance) => instance.meshes, r"lights": (dynamic instance) => instance.lights, r"buffers": (dynamic instance) => instance.buffers, r"bufferViews": (dynamic instance) => instance.bufferViews, r"accessors": (dynamic instance) => instance.accessors, r"samplers": (dynamic instance) => instance.samplers, r"animations": (dynamic instance) => instance.animations, r"asset": (dynamic instance) => instance.asset, r"scenes": (dynamic instance) => instance.scenes, r"scene": (dynamic instance) => instance.scene, r"nodes": (dynamic instance) => instance.nodes, r"makeCurrent": (dynamic instance) => instance.makeCurrent, r"sceneId": (dynamic instance) => instance.sceneId, r"backgroundColor": (dynamic instance) => instance.backgroundColor, r"getName": (dynamic instance) => instance.getName, r"getParameters": (dynamic instance) => instance.getParameters, r"getPositionalArgumentsString": (dynamic instance) => instance.getPositionalArgumentsString, r"getPositionalArguments": (dynamic instance) => instance.getPositionalArguments, r"getNamedArgumentsString": (dynamic instance) => instance.getNamedArgumentsString, r"getNamedArguments": (dynamic instance) => instance.getNamedArguments, r"getReturnType": (dynamic instance) => instance.getReturnType, r"invoke": (dynamic instance) => instance.invoke, r"function": (dynamic instance) => instance.function, r"instancesMirror": (dynamic instance) => instance.instancesMirror, r"methodMirror": (dynamic instance) => instance.methodMirror, r"getPropertiesInfos": (dynamic instance) => instance.getPropertiesInfos, r"edit": (dynamic instance) => instance.edit, r"toJson": (dynamic instance) => instance.toJson, r"properties": (dynamic instance) => instance.properties, r"element": (dynamic instance) => instance.element, r"greater": (dynamic instance) => instance.greater, r"lessEqual": (dynamic instance) => instance.lessEqual, r"a": (dynamic instance) => instance.a, r"b": (dynamic instance) => instance.b}, {r"extensions=": (dynamic instance, value) => instance.extensions = value, r"extras=": (dynamic instance, value) => instance.extras = value, r"name=": (dynamic instance, value) => instance.name = value, r"weights=": (dynamic instance, value) => instance.weights = value, r"skin=": (dynamic instance, value) => instance.skin = value, r"isJoint=": (dynamic instance, value) => instance.isJoint = value, r"components=": (dynamic instance, value) => instance.components = value, r"translation=": (dynamic instance, value) => instance.translation = value, r"rotation=": (dynamic instance, value) => instance.rotation = value, r"scale=": (dynamic instance, value) => instance.scale = value, r"matrix=": (dynamic instance, value) => instance.matrix = value, r"children=": (dynamic instance, value) => instance.children = value, r"parent=": (dynamic instance, value) => instance.parent = value, r"mesh=": (dynamic instance, value) => instance.mesh = value, r"camera=": (dynamic instance, value) => instance.camera = value, r"visible=": (dynamic instance, value) => instance.visible = value, r"baseDirectory=": (dynamic instance, value) => instance.baseDirectory = value, r"cameras=": (dynamic instance, value) => instance.cameras = value, r"materials=": (dynamic instance, value) => instance.materials = value, r"textures=": (dynamic instance, value) => instance.textures = value, r"images=": (dynamic instance, value) => instance.images = value, r"meshes=": (dynamic instance, value) => instance.meshes = value, r"lights=": (dynamic instance, value) => instance.lights = value, r"buffers=": (dynamic instance, value) => instance.buffers = value, r"bufferViews=": (dynamic instance, value) => instance.bufferViews = value, r"accessors=": (dynamic instance, value) => instance.accessors = value, r"samplers=": (dynamic instance, value) => instance.samplers = value, r"animations=": (dynamic instance, value) => instance.animations = value, r"asset=": (dynamic instance, value) => instance.asset = value, r"scene=": (dynamic instance, value) => instance.scene = value, r"backgroundColor=": (dynamic instance, value) => instance.backgroundColor = value, r"b=": (dynamic instance, value) => instance.b = value}, null, [])};


final _memberSymbolMap = null;

initializeReflectable() {
  if (!isTransformed) {
    throw new UnsupportedError(
        "The transformed code is running with the untransformed "
        "reflectable package. Remember to set your package-root to "
        "'build/.../packages'.");
  }
  r.data = _data;
  r.memberSymbolMap = _memberSymbolMap;
}
