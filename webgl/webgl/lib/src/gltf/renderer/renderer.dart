import 'dart:html';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/utils/utils_texture.dart';
import 'package:webgl/src/lights/types/directional_light.dart';
import 'package:webgl/src/renderer/render_state.dart';
import 'package:webgl/src/renderer/renderer.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/webgl.dart';

//@reflector
class GLTFRenderer extends Renderer {
  GLTFProject _gltfProject;

  GLTFRenderer(CanvasElement canvas) : super(canvas);

  @override
  void init(covariant GLTFProject project) {
    _gltfProject = project;

    if (_gltfProject.currentScene == null)
      throw new Exception(
          "currentScene mustn't be null in the project before init call : _gltfProject.currentScene");

    renderState.reservedTextureUnits =
        UtilsTextureGLTF.initTextures(_gltfProject);

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

  set renderingType(RenderingType renderingType) {
    renderState.renderingType = renderingType;
    if (renderState.renderingType == RenderingType.stereo) {
      // turn on scissor test
      gl.enable(ContextParameter.SCISSOR_TEST);
    } else {
      gl.disable(ContextParameter.SCISSOR_TEST);
    }
  }

  @override
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

    Camera camera = Engine.mainCamera;
    Vector3 cameraPosition;
    if (renderState.renderingType == RenderingType.single) {
      cameraPosition = camera.translation;
    } else if (renderState.renderingType == RenderingType.stereo) {
      if (Engine.mainCamera is GLTFCameraPerspective) {
        GLTFCameraPerspective camera =
            Engine.mainCamera as GLTFCameraPerspective;
        Vector3 offsetVector = new Vector3.zero();
        cross3(camera.frontDirection, camera.upDirection, offsetVector);
        offsetVector.normalize();

        cameraPosition = Engine.mainCamera.translation +
            offsetVector *
                renderState.offsetScale *
                (renderState.isLeft ? 1 : -1);

        int halfWidthSize = (gl.canvas.width * .5).toInt();
        int halfHeightSize = (gl.canvas.height * .5).toInt();
        gl.scissor(renderState.isLeft ? 0 : halfWidthSize, 0, halfWidthSize,
            gl.canvas.height);
        gl.viewport(renderState.isLeft ? 0 : halfWidthSize,
            (halfHeightSize * .5).toInt(), halfWidthSize, halfHeightSize);

        //flip renderSide
        renderState.isLeft = !renderState.isLeft;
      }
    }

    primitive.material.pvMatrix = (camera.projectionMatrix *
        camera.viewMatrix) as Matrix4;
    primitive.material.setUniforms(
        program,
        modelMatrix,
        camera.viewMatrix,
        camera.projectionMatrix,
        cameraPosition,
        _gltfProject.defaultLight);

    rawDraws(primitive);

    primitive.material.setupAfterRender();
  }

  void _setupPrimitiveBuffers(
      WebGLProgram program, GLTFMeshPrimitive primitive) {
    this._bindAllVertexArrayData(primitive, program);
    if (primitive.hasIndice) {
      this._bindIndicesArrayData(primitive, program);
    }
  }

  void _bindIndicesArrayData(
      GLTFMeshPrimitive primitive, WebGLProgram program) {
    IndicesArrayDataInfos bindBufferInfos =
        this.getIndicesArrayDataInfos(primitive);
    program.initBindBuffer(bindBufferInfos.attributName, bindBufferInfos.usage,
        bindBufferInfos.indices);
  }

  IndicesArrayDataInfos getIndicesArrayDataInfos(GLTFMeshPrimitive primitive) {
    GLTFAccessor accessorIndices = primitive.indicesAccessor;

    String attributName = 'INDICES';
    TypedData indices;
    int usage = accessorIndices.bufferView.usage;

    if (accessorIndices.componentType == 5123 ||
        accessorIndices.componentType == 5121) {
      indices = accessorIndices.bufferView.buffer.data.buffer.asUint16List(
          accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset,
          accessorIndices.count);
    } else if (accessorIndices.componentType == 5125) {
      if (this.renderState.hasIndexUIntExtension == null)
        throw 'hasIndexUIntExtension : extension not supported';
      indices = accessorIndices.bufferView.buffer.data.buffer.asUint32List(
          accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset,
          accessorIndices.count);
    } else {
      throw '_bindIndices : componentType not implemented ${VertexAttribArrayType.getByIndex(
        accessorIndices.componentType,
      )}';
    }

    IndicesArrayDataInfos result = new IndicesArrayDataInfos();
    result.attributName = attributName;
    result.usage = usage;
    result.indices = indices;

    return result;
  }

  void _bindAllVertexArrayData(
      GLTFMeshPrimitive primitive, WebGLProgram program) {
    for (String attributName in primitive.attributes.keys) {
      GLTFAccessor accessor = primitive.attributes[attributName];

      this._checkIfDatasAreCorrects(accessor);

      //>
      VertexArrayDataInfos vertexArrayDataInfos = new VertexArrayDataInfos();
      vertexArrayDataInfos.attributName = attributName;
      vertexArrayDataInfos.components = accessor.components; //vertexCoordLength
      vertexArrayDataInfos.componentType = accessor.componentType;
      vertexArrayDataInfos.normalized = accessor.normalized;
      vertexArrayDataInfos.stride = accessor.byteStride;
      vertexArrayDataInfos.usage = accessor.bufferView.usage;
      vertexArrayDataInfos.verticesInfos = primitive.getVerticesInfos(accessor);

      //>
      this.bindSingleVertexArrayData(program, vertexArrayDataInfos);
    }
  }

  void _checkIfDatasAreCorrects(GLTFAccessor accessor) {
    if (accessor.bufferView == null) throw 'bufferView must be defined';
    if (accessor.bufferView.buffer == null) throw 'buffer must be defined';
    //The offset of an accessor into a bufferView and the offset of an accessor into a buffer must be a multiple of the size of the accessor's component type.
    assert((accessor.bufferView.byteOffset + accessor.byteOffset) %
            accessor.componentLength ==
        0);
    //Each accessor must fit its bufferView, so next expression must be less than or equal to bufferView.length
    if (!(accessor.byteOffset +
            accessor.byteStride * (accessor.count - 1) +
            accessor.components * accessor.componentLength <=
        accessor.bufferView.byteLength)) {
      throw '${accessor.byteOffset + accessor.byteStride * (accessor.count - 1) + accessor.components * accessor.componentLength} <= ${accessor.bufferView.byteLength}';
    }
  }

  void bindSingleVertexArrayData(
      WebGLProgram program, VertexArrayDataInfos vertexArrayDataInfos) {
    program.initBindBuffer(vertexArrayDataInfos.attributName,
        vertexArrayDataInfos.usage, vertexArrayDataInfos.verticesInfos);
    program.setAttribut(
        vertexArrayDataInfos.attributName,
        vertexArrayDataInfos.components,
        vertexArrayDataInfos.componentType,
        vertexArrayDataInfos.normalized,
        vertexArrayDataInfos.stride);
  }

  void rawDraws(GLTFMeshPrimitive primitive) {
    int drawMode = primitive.drawMode;

    if (!primitive.hasIndice || drawMode == DrawMode.POINTS) {
      DrawArraysInfos drawArraysInfos = this.getDrawArraysInfos(primitive);
      GL.drawArrays(drawArraysInfos.drawMode, drawArraysInfos.firstVertexIndex,
          drawArraysInfos.vertexCount);
    } else {
      DrawElementInfos drawElementInfos = this.getDrawElementInfos(primitive);
      GL.drawElements(
        drawElementInfos.drawMode,
        drawElementInfos.count,
        drawElementInfos.type,
        drawElementInfos.offset,
      );
    }

    bool debugLayer = false;
    if (debugLayer) _drawLayer(canvas);
  }

  DrawArraysInfos getDrawArraysInfos(GLTFMeshPrimitive primitive) {
    GLTFAccessor positionAccessor = primitive.positionAccessor;
    if (positionAccessor == null) {
      throw 'Mesh attribut Position accessor must almost have POSITION data defined :)';
    }

    DrawArraysInfos result = new DrawArraysInfos();
    result.drawMode = primitive.drawMode;
    result.firstVertexIndex = positionAccessor.byteOffset;
    result.vertexCount = positionAccessor.count;

    return result;
  }

  DrawElementInfos getDrawElementInfos(GLTFMeshPrimitive primitive) {
    GLTFAccessor indicesAccessor = primitive.indicesAccessor;

    DrawElementInfos result = new DrawElementInfos();
    result.drawMode = primitive.drawMode;
    result.count = indicesAccessor.count;
    result.type = indicesAccessor.componentType;
    result.offset = 0;

    return result;
  }

  ///what is it for ? this show primitives layers drawn
  int _countImage = 0;
  void _drawLayer(CanvasElement canvas) {
    if (_countImage < 10) {
      String dataUrl = canvas.toDataUrl();
      ImageElement image = new ImageElement(src: dataUrl);
      DivElement div = querySelector('#debug') as DivElement;
      div.children.add(image);
      _countImage++;
    }
  }
}

class DrawElementInfos {
  int drawMode;
  int count;
  int type;
  int offset;
}

class DrawArraysInfos {
  int drawMode;
  int firstVertexIndex;
  int vertexCount;
}

class VertexArrayDataInfos {
  String attributName;
  int usage;
  int components;
  int componentType;
  bool normalized;
  int stride;
  Float32List verticesInfos;
}

class IndicesArrayDataInfos {
  String attributName;
  int usage;
  TypedData indices;
}
