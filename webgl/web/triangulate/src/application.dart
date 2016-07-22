import '../src/util.dart';
import 'dart:html';
import 'package:logging/logging.dart';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'dart:web_gl';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'mesh.dart';
import 'material.dart';

class Application {
  RenderingContext gl;
  Logger _logger;

  List<Mesh> meshes = new List<Mesh>();

  Application() {
    _logger = _setupLogger('app');
  }

  Logger _setupLogger(String loggerName) {
    Logger logger = new Logger(loggerName);
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    return logger;
  }

  void init() {
    loadModel('susan/Susan.json', 'susan/SusanTexture.png',
        'shaders/shaderModel.vs.glsl', 'shaders/shaderModel.fs.glsl');
  }

  loadModel(String jsonModelFile, String textureImageFile,
      String vsShaderFileUrl, String fsShaderFileUrl) {
    print("loading ${vsShaderFileUrl}");

    util.loadTextResource(vsShaderFileUrl, (String vsErr, String vsText) {
      if (vsErr != null) {
        window.alert('Fatal error getting vertex shader (see console)');
        print(vsErr);
      } else {
        print("loading ${fsShaderFileUrl}");
        util.loadTextResource(fsShaderFileUrl, (String fsErr, String fsText) {
          if (fsErr != null) {
            window.alert('Fatal error getting fragment shader (see console)');
            print(fsErr);
          } else {
            print("loading ${jsonModelFile}");
            util.loadJSONResource(jsonModelFile, (String modelErr, modelObj) {
              if (modelErr != null) {
                window.alert('Fatal error getting Susan model (see console)');
                print(fsErr);
              } else {
                print("loading ${textureImageFile}");
                util.loadImage(textureImageFile, (imgErr, textureImage) {
                  if (imgErr != null) {
                    window.alert(
                        'Fatal error getting Susan texture (see console)');
                    print(imgErr);
                  } else {
                    print("Fill mesh");

                    Mesh modelMesh = new Mesh();
                    modelMesh.vertices = modelObj['meshes'][0]['vertices'];
                    modelMesh.indices = modelObj['meshes'][0]['faces']
                        .expand((i) => i)
                        .toList();
                    modelMesh.texCoords =
                        modelObj['meshes'][0]['texturecoords'][0];
                    modelMesh.normals = modelObj['meshes'][0]['normals'];
                    modelMesh.vsShader = vsText;
                    modelMesh.fsShader = fsText;
                    modelMesh.textureImage = textureImage;
                    meshes.add(modelMesh);

                    print("RunDemo");
                    RunDemo(modelMesh);
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  void initGL() {
    CanvasElement canvas = document.getElementById("glCanvas");
    List<String> names = [
      "webgl",
      "experimental-webgl",
      "webkit-3d",
      "moz-webgl"
    ];
    for (int i = 0; i < names.length; ++i) {
      try {
        gl = canvas.getContext(names[i]);
      } catch (e) {}
      if (gl != null) {
        break;
      }
    }
    if (gl == null) {
      window.alert("Could not initialise WebGL");
      return null;
    }

    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
    gl.enable(GL.DEPTH_TEST);
    gl.enable(GL.CULL_FACE);
    gl.frontFace(GL.CCW);
    gl.cullFace(GL.BACK);
  }

  void createBuffers(Program program, Mesh modelMesh) {
    Buffer modelPosVertexBufferObject = gl.createBuffer();
    gl.bindBuffer(GL.ARRAY_BUFFER, modelPosVertexBufferObject);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List(modelMesh.vertices.length),
        GL.STATIC_DRAW);

    Buffer modelTexCoordVertexBufferObject = gl.createBuffer();
    gl.bindBuffer(GL.ARRAY_BUFFER, modelTexCoordVertexBufferObject);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List(modelMesh.texCoords.length),
        GL.STATIC_DRAW);

    Buffer modelNormalBufferObject = gl.createBuffer();
    gl.bindBuffer(GL.ARRAY_BUFFER, modelNormalBufferObject);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List(modelMesh.normals.length),
        GL.STATIC_DRAW);

    Buffer modelIndexBufferObject = gl.createBuffer();
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, modelIndexBufferObject);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER,
        new Uint16List(modelMesh.indices.length), GL.STATIC_DRAW);

    //with program
    gl.bindBuffer(GL.ARRAY_BUFFER, modelPosVertexBufferObject);
    int positionAttribLocation = gl.getAttribLocation(program, 'vertPosition');
    gl.vertexAttribPointer(
        positionAttribLocation, // Attribute location
        3, // Number of elements per attribute
        GL.FLOAT, // Type of elements
        false,
        3 * Float32List.BYTES_PER_ELEMENT, // Size of an individual vertex
        0 // Offset from the beginning of a single vertex to this attribute
        );
    gl.enableVertexAttribArray(positionAttribLocation);

    gl.bindBuffer(GL.ARRAY_BUFFER, modelTexCoordVertexBufferObject);
    int texCoordAttribLocation = gl.getAttribLocation(program, 'vertTexCoord');
    gl.vertexAttribPointer(
        texCoordAttribLocation, // Attribute location
        2, // Number of elements per attribute
        GL.FLOAT, // Type of elements
        false,
        2 * Float32List.BYTES_PER_ELEMENT, // Size of an individual vertex
        0);
    gl.enableVertexAttribArray(texCoordAttribLocation);

    gl.bindBuffer(GL.ARRAY_BUFFER, modelNormalBufferObject);
    int normalAttribLocation = gl.getAttribLocation(program, 'vertNormal');
    gl.vertexAttribPointer(normalAttribLocation, 3, GL.FLOAT, true,
        3 * Float32List.BYTES_PER_ELEMENT, 0);
    gl.enableVertexAttribArray(normalAttribLocation);
  }

  Texture getTexture(textureImage) {
    //
    // Create texture
    //
    Texture texture = gl.createTexture();
    gl.bindTexture(GL.TEXTURE_2D, texture);
    gl.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 0); //Todo ?? 0
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
    gl.texImage2D(
        GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, textureImage);
    gl.bindTexture(GL.TEXTURE_2D, null);

    return texture;
  }

  Matrix4 worldMatrix = new Matrix4.zero();
  Matrix4 viewMatrix = new Matrix4.zero();
  Matrix4 projMatrix = new Matrix4.zero();

  void RunDemo(Mesh modelMesh) {
    print('This is working');

    initGL();

    MaterialModel material =
        new MaterialModel(gl, modelMesh.vsShader, modelMesh.fsShader);
    if (material.program == null) return;

    createBuffers(material.program, modelMesh);

    modelMesh.texture = getTexture(modelMesh.textureImage);

    //Uniforms
    UniformLocation matWorldUniformLocation;
    matWorldUniformLocation = gl.getUniformLocation(material.program, 'mWorld');

    UniformLocation matViewUniformLocation;
    matViewUniformLocation = gl.getUniformLocation(material.program, 'mView');

    UniformLocation matProjUniformLocation;
    matProjUniformLocation = gl.getUniformLocation(material.program, 'mProj');

    //
    Matrix4 xRotationMatrix = new Matrix4.zero();
    Matrix4 yRotationMatrix = new Matrix4.zero();

    //
    // Lighting information
    //

    //Ambient Light
    Vector3 ambientColor = new Vector3(0.2, 0.2, 0.2);
    material.ambientColor = ambientColor;

    //Sun direction
    Vector3 sunDirection = new Vector3(3.0, 4.0, -2.0);
    UniformLocation sunlightDirUniformLocation;
    sunlightDirUniformLocation =
        gl.getUniformLocation(material.program, 'sun.direction');
    gl.uniform3fv(sunlightDirUniformLocation, sunDirection.storage);

    //Sun intensity
    Vector3 sunColor = new Vector3(0.9, 0.9, 0.9);
    UniformLocation sunlightIntUniformLocation;
    sunlightIntUniformLocation =
        gl.getUniformLocation(material.program, 'sun.color');
    gl.uniform3fv(sunlightIntUniformLocation, sunColor.storage);

    //Camera

    setupCamera();

    //
    // Main render loop
    //
    Matrix4 identityMatrix = new Matrix4.identity();
    num angle = 0;

//    loop (double time) {
//      angle = window.performance.now() / 1000 / 6 * 2 * PI;
//      yRotationMatrix = identityMatrix.rotate(new Vector3(0.0, 1.0, 0.0), angle);
//      xRotationMatrix = identityMatrix.rotate(new Vector3(1.0, 0.0, 0.0), angle / 4);
//      worldMatrix = yRotationMatrix * xRotationMatrix;
//      drawScene(matWorldUniformLocation, worldMatrix, texture, modelMesh.indices);
//
//      window.requestAnimationFrame(loop);
//    };

    //window.requestAnimationFrame(loop);

    //
    gl.uniformMatrix4fv(matWorldUniformLocation, false, worldMatrix.storage);
    gl.uniformMatrix4fv(matViewUniformLocation, false, viewMatrix.storage);
    gl.uniformMatrix4fv(matProjUniformLocation, false, projMatrix.storage);

    drawScene(modelMesh);
  }

  void drawScene(Mesh model) {
    clearScene();

    if (model.texture != null) {
      gl.bindTexture(GL.TEXTURE_2D, model.texture);
      gl.activeTexture(GL.TEXTURE0);
    }

    gl.drawElements(GL.TRIANGLES, model.indices.length, GL.UNSIGNED_SHORT, 0);
  }

  void setupCamera() {
    worldMatrix.setIdentity();
    viewMatrix.setIdentity();
    viewMatrix.translate(0.0, 0.0, -5.0);
    projMatrix = makePerspectiveMatrix(radians(45.0),
        gl.drawingBufferWidth / gl.drawingBufferHeight, 0.1, 1000.0);
    //?? viewMatrix.mat4.lookAt(viewMatrix, [0, 0, -8], [0, 0, 0], [0, 1, 0]);
  }

  void clearScene() {
    gl.clearColor(0.75, 0.85, 0.8, 1.0);
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
  }
}
