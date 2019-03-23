import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
import 'package:webgl/src/gltf/utils/utils_texture.dart';
import 'package:webgl/src/lights/types/directional_light.dart';
import 'package:webgl/src/renderer/renderer.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart'
as GLEnum;
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/webgl.dart';

@reflector
class GLTFRenderer extends Renderer {
  GLTFProject _gltfProject;

  GLTFRenderer(CanvasElement canvas) : super(canvas);

  void init(covariant GLTFProject project) {
    _gltfProject = project;

    if (_gltfProject.currentScene == null)
      throw new Exception("currentScene must be set before init.");

    renderState.reservedTextureUnits = UtilsTextureGLTF.initTextures(_gltfProject);

    // Todo (jpu) : pourquoi si je ne le fait pas ici, il y a des soucis de rendu ?!!
    _gltfProject.defaultLight = new DirectionalLight()
      ..translation = new Vector3(50.0, 50.0, -50.0)
      ..direction = new Vector3(50.0, 50.0, -50.0).normalized()
      ..color = new Vector3(1.0, 1.0, 1.0);

    // Todo (jpu) : replace this in camera
    Engine.mainCamera = _gltfProject.getCurrentCamera();

    _backgroundColor = project.scene.backgroundColor;
  }

  set _backgroundColor(Vector4 color) {
    gl.clearColor(color.r, color.g, color.g, color.a);
  }

  void render({num currentTime: 0.0}) {
    try {
      GL.resizeCanvas();
      GL.clear(
          ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);
      _drawNodes(_gltfProject.currentScene.nodes);
    } catch (ex) {
      print(
          "GLTFRenderer : Error From renderer _render method: $ex ${StackTrace.current}");
    }
  }

  void _drawNodes(List<GLTFNode> nodes) {
    for (int i = 0; i < nodes.length; i++) {
      GLTFNode node = nodes[i];
      drawNode(node);
      _drawNodes(node.children); //recursive
    }
  }

  void drawNode(GLTFNode node) {
    if (!node.visible) return;
    if (node.mesh == null) return;
    if (node.mesh.primitives == null) return;

    List<GLTFMeshPrimitive> primitives = node.mesh.primitives;
    for (int i = 0; i < primitives.length; i++) {
      GLTFMeshPrimitive primitive = primitives[i];
      Matrix4 modelMatrix = (node.parentMatrix * node.matrix) as Matrix4;

      _drawPrimitive(primitive, modelMatrix);
    }
  }

  void _drawPrimitive(GLTFMeshPrimitive primitive, Matrix4 modelMatrix) {
    primitive.bindMaterial(renderState);

    WebGLProgram program = primitive.program;
    gl.useProgram(program.webGLProgram);

    _setupPrimitiveBuffers(program, primitive);

    primitive.material.setupBeforeRender();
    primitive.material.pvMatrix = (Engine.mainCamera.projectionMatrix *
        Engine.mainCamera.viewMatrix) as Matrix4;
    primitive.material.setUniforms(
        program,
        modelMatrix,
        Engine.mainCamera.viewMatrix,
        Engine.mainCamera.projectionMatrix,
        Engine.mainCamera.translation,
        _gltfProject.defaultLight);
    {
      if (primitive.indicesAccessor == null ||
          primitive.drawMode == DrawMode.POINTS) {
        GLTFAccessor accessorPosition = primitive.positionAccessor;
        if (accessorPosition == null)
          throw 'Mesh attribut Position accessor must almost have POSITION data defined :)';
        GL.drawArrays(primitive.drawMode, accessorPosition.byteOffset,
            accessorPosition.count);
      } else {
        GLTFAccessor accessorIndices = primitive.indicesAccessor;
        GL.drawElements(primitive.drawMode, accessorIndices.count,
            accessorIndices.componentType, 0);
      }

      // _drawLayer(canvas);
    }

    primitive.material.setupAfterRender();
  }

  void _setupPrimitiveBuffers(
      WebGLProgram program, GLTFMeshPrimitive primitive) {
    _bindVertexArrayData(primitive, program);

    if (primitive.indicesAccessor != null) {
      _bindIndicesData(primitive, program);
    }
  }

  void _bindIndicesData(GLTFMeshPrimitive primitive, WebGLProgram program) {
    String attributName = 'INDICES';

    GLTFAccessor accessorIndices = primitive.indicesAccessor;
    TypedData indices;
    if (accessorIndices.componentType == 5123 ||
        accessorIndices.componentType == 5121) {
      indices = accessorIndices.bufferView.buffer.data.buffer.asUint16List(
          accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset,
          accessorIndices.count);
    } else if (accessorIndices.componentType == 5125) {
      if (renderState.hasIndexUIntExtension == null)
        throw "hasIndexUIntExtension : extension not supported";
      indices = accessorIndices.bufferView.buffer.data.buffer.asUint32List(
          accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset,
          accessorIndices.count);
    } else {
      throw "_bindIndices : componentType not implemented ${GLEnum.VertexAttribArrayType.getByIndex(accessorIndices.componentType)}";
    }

    program.initBindBuffer(attributName, accessorIndices.bufferView.usage, indices);

  }

  void _bindVertexArrayData(GLTFMeshPrimitive primitive, WebGLProgram program) {
    for (String attributName in primitive.attributes.keys) {
      GLTFAccessor accessor = primitive.attributes[attributName];

      if (accessor.bufferView == null) throw 'bufferView must be defined';
      if (accessor.bufferView.buffer == null) throw 'buffer must be defined';

      Float32List verticesInfos = accessor.bufferView.buffer.data.buffer
          .asFloat32List(
              accessor.byteOffset + accessor.bufferView.byteOffset,
              accessor.count *
                  (accessor.byteStride ~/ accessor.componentLength));

      //The offset of an accessor into a bufferView and the offset of an accessor into a buffer must be a multiple of the size of the accessor's component type.
      assert((accessor.bufferView.byteOffset + accessor.byteOffset) %
              accessor.componentLength ==
          0);

      //Each accessor must fit its bufferView, so next expression must be less than or equal to bufferView.length
      assert(
          accessor.byteOffset +
                  accessor.byteStride * (accessor.count - 1) +
                  (accessor.components * accessor.componentLength) <=
              accessor.bufferView.byteLength,
          '${accessor.byteOffset + accessor.byteStride * (accessor.count - 1) + (accessor.components * accessor.componentLength)} <= ${accessor.bufferView.byteLength}');

      //>
      program.initBindBuffer(attributName, accessor.bufferView.usage, verticesInfos);

      //>
      program.setAttribut(attributName, accessor.components, accessor.componentType, accessor.normalized, accessor.byteStride);
    }
  }



//  ///what is it for ? this show primitives layers drawn
//  int _countImage = 0;
//  void _drawLayer(CanvasElement canvas) {
//    if (_countImage < 10) {
//      String dataUrl = canvas.toDataUrl();
//      ImageElement image = new ImageElement(src: dataUrl);
//      DivElement div = querySelector('#debug') as DivElement;
//      div.children.add(image);
//      _countImage++;
//    }
//  }
}
