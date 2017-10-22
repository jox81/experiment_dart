import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/animation.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/camera.dart';

// Uint8List = Byte
// Uint16List = SCALAR : int

class GLTFRenderer {
  GLTFProject gltf;
  GLTFScene get activeScene => gltf.scenes[0];
  List<GLTFNode> get nodes => activeScene.nodes;

  webgl.RenderingContext gl;

  String vsSource =
    '''
      attribute vec3 aPosition;

      uniform mat4 uModelMatrix;
      uniform mat4 uViewMatrix;
      uniform mat4 uProjectionMatrix;
      
      void main(void) {
          gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(aPosition, 1.0);
      }
    ''';
  String fsSource =
    '''
      void main() {
        gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
      }
    ''';

  GLTFRenderer(this.gltf) {
    logCurrentFunction();

    try {
      CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) {
        throw "x";
      }
    } catch (err) {
      throw "Your web browser does not support WebGL!";
    }
  }

  Camera activeCameraNode;
  Matrix4 viewMatrix = new Matrix4.identity();
  Matrix4 projectionMatrix = new Matrix4.identity();

  void draw() {
    logCurrentFunction();

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT.index);

    webgl.Program program = buildProgram(vsSource, fsSource);
    gl.useProgram(program);

    if(gltf.cameras.length > 0) {
      activeCameraNode = gltf.cameras[0];
    }else{
      GLTFCameraPerspective camera = new GLTFCameraPerspective(0.7, 1000.0, 0.01);
      viewMatrix = camera.lookAtMatrix;
      projectionMatrix = camera.perspectiveMatrix;
      camera.position = new Vector3(0.5, 0.5, 3.0);
      activeCameraNode = camera;
    }

    //setup
    for (var i = 0; i < nodes.length; i++) {
      GLTFNode node = nodes[i];
      if(node.camera != null){
        if(node.camera.cameraId == activeCameraNode) {
          setupNodeCamera(program, node);
        }
      }
    }

    setUnifrom(program,'uViewMatrix',ShaderVariableType.FLOAT_MAT4,viewMatrix.storage);
    setUnifrom(program,'uProjectionMatrix',ShaderVariableType.FLOAT_MAT4,projectionMatrix.storage);

    //draw
    for (var i = 0; i < nodes.length; i++) {
      GLTFNode node = nodes[i];
      if(node.mesh != null){
        setupNodeMesh(program, node);
        drawNodeMesh(program, node.mesh.primitives[0]);
      }
    }
  }

  void setupNodeCamera(webgl.Program program, GLTFNode node) {
    logCurrentFunction();

    GLTFCameraPerspective camera = node.camera as GLTFCameraPerspective;
    viewMatrix = camera.lookAtMatrix;
    projectionMatrix = camera.perspectiveMatrix;
    camera.position = node.translation;
  }

  void setupNodeMesh(webgl.Program program, GLTFNode node) {
    logCurrentFunction();

    GLTFMeshPrimitive primitive = node.mesh.primitives[0];

    //bind
    for (int i = 0; i < primitive.attributes.keys.length; i++) {
      bindVertices(program, primitive);
    }
    if(primitive.indices != null){
      bindIndices(primitive.indices);
    }

    //uniform
    setUnifrom(program,'uModelMatrix',ShaderVariableType.FLOAT_MAT4,node.matrix.storage);
  }

  void drawNodeMesh(webgl.Program program, GLTFMeshPrimitive primitive) {
    logCurrentFunction();

    String attributName = primitive.attributes.keys.toList()[0];//'POSITION'
    GLTFAccessor accessorVertices = primitive.attributes[attributName];

    if (primitive.indices == null) {
      gl.drawArrays(primitive.mode.index, accessorVertices.byteOffset, accessorVertices.count);
    } else {
      GLTFAccessor accessorIndices = primitive.indices;

      gl.drawElements(primitive.mode.index, accessorIndices.count,
          accessorIndices.componentType.index, accessorIndices.byteOffset);
    }
  }

  void bindVertices(webgl.Program program, GLTFMeshPrimitive primitive) {
    logCurrentFunction();

    String attributName = primitive.attributes.keys.toList()[0];
    GLTFAccessor accessor = primitive.attributes[attributName];

    GLTFBuffer bufferData = accessor.bufferView.buffer;
    Float32List verticesInfos = bufferData.data.buffer.asFloat32List(
        accessor.bufferView.byteOffset,
        accessor.count * accessor.typeLength);

    //>
    initBuffer(accessor.bufferView.usage, verticesInfos);

    //>
    setAttribut(
        program, attributName, accessor.typeLength, accessor.componentType);
  }

  void bindIndices(GLTFAccessor accessorIndices) {
    logCurrentFunction();

    Uint16List indices = accessorIndices.bufferView.buffer.data.buffer
        .asUint16List(accessorIndices.bufferView.byteOffset, accessorIndices.count);

    initBuffer(accessorIndices.bufferView.usage, indices);
  }

  webgl.Program buildProgram(String vsSource, String fsSource) {
    logCurrentFunction();

    webgl.Program program = gl.createProgram();

    addShader(program, ShaderType.VERTEX_SHADER, vsSource);
    addShader(program, ShaderType.FRAGMENT_SHADER, fsSource);
    gl.linkProgram(program);
    if (gl.getProgramParameter(program, ProgramParameterGlEnum.LINK_STATUS.index) ==
        null) {
      throw "Could not link the shader program!";
    }
    return program;
  }

  void addShader(webgl.Program program, ShaderType type, String source) {
    logCurrentFunction();

    webgl.Shader shader = gl.createShader(type.index);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if (gl.getShaderParameter(shader, ShaderParameters.COMPILE_STATUS.index) ==
        null) {
      throw "Could not compile $type shader:\n\n ${gl.getShaderInfoLog(shader)}";
    }
    gl.attachShader(program, shader);
  }

  /// [componentCount] => 3 (x, y, z)
  void setAttribut(webgl.Program program, String attributName, int componentCount,
      ShaderVariableType componentType) {
    logCurrentFunction(attributName);

    int attributLocation = gl.getAttribLocation(program, 'a${capitalize(attributName)}');

    // turn on getting data out of a buffer for this attribute
    gl.enableVertexAttribArray(attributLocation);

    bool normalize = false;
    int offset = 0;         // start at the beginning of the buffer
    int stride = 0;         // how many bytes to move to the next vertex
                            // 0 = use the correct stride for type and numComponents

    gl.vertexAttribPointer(
        attributLocation, componentCount, componentType.index, normalize, stride, offset);
  }

  void setUnifrom(webgl.Program program,String unifromName, ShaderVariableType componentType, TypedData data){
    logCurrentFunction(unifromName);

    webgl.UniformLocation uniformLocation = gl.getUniformLocation(program, unifromName);

    bool transpose = false;

    switch(componentType){
      case ShaderVariableType.FLOAT_MAT4:
        gl.uniformMatrix4fv(uniformLocation, transpose, data);
        break;
      default:
        break;
    }
  }

  void initBuffer(BufferType bufferType, TypedData data) {
    logCurrentFunction();

    webgl.Buffer buffer = gl.createBuffer();
    gl.bindBuffer(bufferType.index, buffer);
    gl.bufferData(bufferType.index, data, BufferUsageType.STATIC_DRAW.index);
  }

  num currentTime = 0;
  num deltaTime = 0;
  num timeFps = 0;
  int fps = 0;
  num speedFactor  = 1.0;
  void render({num time: 0.0}) {
    logCurrentFunction();

    deltaTime = time - currentTime;
    timeFps += deltaTime;
    fps++;
    currentTime = time * speedFactor;

    if(fps >= 1000) {
      timeFps = 0;
      fps = 0;
    }

    try {
      update();
      draw();
    } catch (ex) {
      print("Error: $ex");
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

  //text utils
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1).toLowerCase();

  void update() {
    logCurrentFunction();

    for (int i = 0; i < gltfProject.animations.length; i++) {
      GLTFAnimation animation = gltfProject.animations[i];
      for (int j = 0; i < animation.channels.length; i++) {
        GLTFAnimationChannel channel = animation.channels[j];

        ByteBuffer byteBuffer = getNextInterpolatedValues(channel.sampler);
        channel.target.node.rotation = new Quaternion.fromBuffer(byteBuffer, 0);
      }
    }
  }

  ByteBuffer getNextInterpolatedValues(GLTFAnimationSampler sampler){
    logCurrentFunction();

    Float32List keyTimes = getKeyTimes(sampler.input);
    Float32List keyValues = getKeyValues(sampler.output);

    num playTime = (currentTime / 1000) % keyTimes.last;// Todo (jpu) : find less cost ?

    //> playtime range
    int previousIndex = 0;
    double previousTime = 0.0;
    while (keyTimes[previousIndex] < playTime){
      previousTime = keyTimes[previousIndex];
      previousIndex++;
    }
    previousIndex--;

    int nextIndex = (previousIndex + 1) % keyTimes.length;
    double nextTime = keyTimes[nextIndex];


    //> values
    Float32List previousValues = keyValues.buffer.asFloat32List(sampler.output.byteOffset + previousIndex * sampler.output.typeLength * sampler.output.componentLength, sampler.output.typeLength);
    Float32List nextValues = keyValues.buffer.asFloat32List(sampler.output.byteOffset + nextIndex * sampler.output.typeLength * sampler.output.componentLength, sampler.output.typeLength);

    double interpolationValue = (playTime - previousTime) / (nextTime - previousTime);

    // Todo (jpu) : add easer ratio interpolation

    Quaternion result = getQuaternionInterpolation(previousValues, nextValues, interpolationValue, previousIndex, previousTime, playTime, nextIndex, nextTime);

    return result.storage.buffer;
  }

  Quaternion getQuaternionInterpolation(Float32List previousValues, Float32List nextValues, double interpolationValue, int previousIndex, double previousTime, num playTime, int nextIndex, double nextTime) {

    Quaternion previous = new Quaternion.fromFloat32List(previousValues);
    Quaternion next = new Quaternion.fromFloat32List(nextValues);

    //
    double angle = next.radians - previous.radians;
    if( angle.abs() > PI){
      next[3] *= -1;
    }

    Quaternion result = slerp(previous, next, interpolationValue);

    print('interpolationValue : $interpolationValue');
    print('previous : $previousIndex > ${previousTime.toStringAsFixed(3)} \t: ${degrees(previous.radians).toStringAsFixed(3)} ${previousTime.toStringAsFixed(3)} \t| $previous');
    print('result   : - > ${playTime.toStringAsFixed(3)} \t: ${degrees(result.radians).toStringAsFixed(3)} ${playTime.toStringAsFixed(3)} \t| $result');
    print('next     : $nextIndex > ${nextTime.toStringAsFixed(3)} \t: ${degrees(next.radians).toStringAsFixed(3)} ${nextTime.toStringAsFixed(3)} \t| $next');
    print('');
    return result;
  }

  Float32List getInterpolatedValues(Float32List previousValues, Float32List nextValues, num interpolationValue){
    Float32List result = new Float32List(previousValues.length);

    for (int i = 0; i < previousValues.length; i++) {
      result[i] = previousValues[i] + interpolationValue * (nextValues[i] - previousValues[i]);
    }
    return result;
  }

  Quaternion slerp(Quaternion qa, Quaternion qb, double t) {
    // quaternion to return
    Quaternion qm = new Quaternion.identity();

    // Calculate angle between them.
    double cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;

    // if qa=qb or qa=-qb then theta = 0 and we can return qa
    if (cosHalfTheta.abs() >= 1.0){
      qm.w = qa.w;
      qm.x = qa.x;
      qm.y = qa.y;
      qm.z = qa.z;
      return qm;
    }

    // Calculate temporary values.
    double halfTheta = acos(cosHalfTheta);
    double sinHalfTheta = sqrt(1.0 - cosHalfTheta*cosHalfTheta);

    // if theta = 180 degrees then result is not fully defined
    // we could rotate around any axis normal to qa or qb
    if (sinHalfTheta.abs() < 0.001){
      qm.w = (qa.w * 0.5 + qb.w * 0.5);
      qm.x = (qa.x * 0.5 + qb.x * 0.5);
      qm.y = (qa.y * 0.5 + qb.y * 0.5);
      qm.z = (qa.z * 0.5 + qb.z * 0.5);
      return qm;
    }
    double ratioA = sin((1 - t) * halfTheta) / sinHalfTheta;
    double ratioB = sin(t * halfTheta) / sinHalfTheta;

    //calculate Quaternion.
    qm.w = (qa.w * ratioA + qb.w * ratioB);
    qm.x = (qa.x * ratioA + qb.x * ratioB);
    qm.y = (qa.y * ratioA + qb.y * ratioB);
    qm.z = (qa.z * ratioA + qb.z * ratioB);

    return qm;
  }

  Float32List getKeyTimes(GLTFAccessor accessor){
    logCurrentFunction();

    Float32List keyTimes = accessor.bufferView.buffer.data.buffer.asFloat32List(
        accessor.byteOffset, accessor.count * accessor.typeLength);
    return keyTimes;
  }

  // Todo (jpu) : try to return only buffer
  Float32List getKeyValues(GLTFAccessor accessor) {
    logCurrentFunction();

    Float32List keyValues = accessor.bufferView.buffer.data.buffer.asFloat32List(
        accessor.byteOffset,
        accessor.count * accessor.typeLength);
    return keyValues;
  }


}



