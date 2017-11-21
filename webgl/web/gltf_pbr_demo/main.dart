import 'dart:typed_data';
import 'package:datgui/datgui.dart' as dat;
import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as webgl;
import 'package:gltf/gltf.dart' as glTF;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart' as Context;
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl/src/gltf_pbr_demo/renderer_kronos_scene.dart';
import 'package:webgl/src/gltf_pbr_demo/renderer_kronos_utils.dart';
import 'package:webgl/src/utils/utils_assets.dart';

Future<int> loadCubeMap(
    webgl.RenderingContext gl, String envMap, String type, GlobalState state) async {
  logCurrentFunction();
  webgl.Texture texture = gl.createTexture();
  int textureNumber = -1;
  int activeTextureEnum = webgl.TEXTURE0;
  int mipLevels = 0;
  String uniformName = 'u_EnvSampler';
  if (type == "diffuse") {
    uniformName = 'u_DiffuseEnvSampler';
    activeTextureEnum = webgl.TEXTURE1;
    textureNumber = 1;
    mipLevels = 1;
  } else if (type == "specular") {
    uniformName = 'u_SpecularEnvSampler';
    activeTextureEnum = webgl.TEXTURE2;
    textureNumber = 2;
    mipLevels = 10;
  } else if (type == "environment") {
    uniformName = 'u_EnvSampler';
    activeTextureEnum = webgl.TEXTURE0;
    textureNumber = 0;
    mipLevels = 1;
  } else {
    Element error = document.getElementById('error');
    error.innerHtml += 'Invalid type of cubemap loaded<br>';
    return -1;
  }

  gl.activeTexture(activeTextureEnum);
  gl.bindTexture(webgl.TEXTURE_CUBE_MAP, texture);
  gl.texParameteri(
      webgl.TEXTURE_CUBE_MAP, webgl.TEXTURE_WRAP_S, webgl.CLAMP_TO_EDGE);
  gl.texParameteri(
      webgl.TEXTURE_CUBE_MAP, webgl.TEXTURE_WRAP_T, webgl.CLAMP_TO_EDGE);

  if (mipLevels < 2) {
    gl.texParameteri(
        webgl.TEXTURE_CUBE_MAP, webgl.TEXTURE_MIN_FILTER, webgl.LINEAR);
    gl.texParameteri(
        webgl.TEXTURE_CUBE_MAP, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR);
  } else {
    gl.texParameteri(webgl.TEXTURE_CUBE_MAP, webgl.TEXTURE_MIN_FILTER,
        webgl.LINEAR_MIPMAP_LINEAR);
    gl.texParameteri(
        webgl.TEXTURE_CUBE_MAP, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR);
  }

  String path = "textures/" + envMap + "/" + type + "/" + type;

  void onLoadEnvironmentImage(
      webgl.Texture texture, int face, ImageElement image, int level) {
    logCurrentFunction();
    gl.activeTexture(activeTextureEnum);
    gl.bindTexture(webgl.TEXTURE_CUBE_MAP, texture);
    gl.pixelStorei(webgl.UNPACK_FLIP_Y_WEBGL, 0);
    // todo:  should this be srgb?  or rgba?  what's the HDR scale on this?
    gl.texImage2D(face, level, state.sRGBifAvailable, state.sRGBifAvailable,
        webgl.UNSIGNED_BYTE, image);
  }

  for (int level = 0; level < mipLevels; level++) {
    List<Map<String, int>> faces = [
      {'${path}_right_$level.jpg': webgl.TEXTURE_CUBE_MAP_POSITIVE_X},
      {'${path}_left_$level.jpg': webgl.TEXTURE_CUBE_MAP_NEGATIVE_X},
      {'${path}_top_$level.jpg': webgl.TEXTURE_CUBE_MAP_POSITIVE_Y},
      {'${path}_bottom_$level.jpg': webgl.TEXTURE_CUBE_MAP_NEGATIVE_Y},
      {'${path}_front_$level.jpg': webgl.TEXTURE_CUBE_MAP_POSITIVE_Z},
      {'${path}_back_$level.jpg': webgl.TEXTURE_CUBE_MAP_NEGATIVE_Z}
    ];
    for (var i = 0; i < faces.length; i++) {
      int cubeFace = faces[i].values.toList()[0];
      Completer completer = new Completer<dynamic>();
      ImageElement image = new ImageElement();
      image.onLoad.listen((_) {
        onLoadEnvironmentImage(texture, cubeFace, image, level);
        completer.complete();
      });
      image.src = faces[i].keys.toList()[0];

      await completer.complete;
    }
  }

  state.uniforms[uniformName] = new GLFunctionCall()
    ..function = gl.uniform1i
    ..vals = <dynamic>[textureNumber];
  return 1;
}

// Update model from dat.gui change
Future updateModel(
    String value,
    webgl.RenderingContext gl,
    GlobalState glState,
    Matrix4 viewMatrix,
    Matrix4 projectionMatrix,
    dynamic backBuffer,
    dynamic frontBuffer) async {
  logCurrentFunction();
  Element error = document.getElementById('error');
  glState.scene = null;
  gl.clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT);
  CanvasElement canvas2d = document.getElementById('canvas2d') as CanvasElement;
  frontBuffer.clearRect(0, 0, canvas2d.width, canvas2d.height);
  document.getElementById('loadSpinner').style.display = 'block';
  resetCamera();

  String url = 'gltf_pbr_demo/models/$value/glTF/$value.gltf';
  glTF.Gltf gltfSource =
      await GLTFProject.loadGLTFResource(url, useWebPath: false);
  GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

  KronosScene scene =
      new KronosScene(gl, glState, "./models/$value/glTF/", gltf);
  scene.projectionMatrix = projectionMatrix;
  scene.viewMatrix = viewMatrix;
  scene.backBuffer = backBuffer;
  scene.frontBuffer = frontBuffer;
  glState.scene = scene;
}

Future main() async {
  logCurrentFunction();
  Element error = document.getElementById('error');

  String vertSource = await UtilsAssets
      .loadGlslShader('./shaders/kronos_gltf_pbr/kronos_gltf_pbr.vs.glsl')
      .catchError((dynamic errorThrown) => error.innerHtml +=
          'Failed to load the vertex shader: $errorThrown <br>');
  String fragSource = await UtilsAssets
      .loadGlslShader('./shaders/kronos_gltf_pbr/kronos_gltf_pbr.fs.glsl')
      .catchError((dynamic errorThrown) => error.innerHtml +=
          'Failed to load the fragment shader: $errorThrown <br>');

  await init(vertSource, fragSource);
}

Future init(String vertSource, String fragSource) async {
  logCurrentFunction();
  CanvasElement canvas = document.getElementById('canvas') as CanvasElement;
  CanvasElement canvas2d = document.getElementById('canvas2d') as CanvasElement;
  Element error = document.getElementById('error');
  if (canvas == null) {
    error.innerHtml += 'Failed to retrieve the canvas element<br>';
    return;
  }
  var canvasWidth = -1;
  var canvasHeight = -1;
  canvas.hidden = true;

  webgl.RenderingContext gl = canvas.getContext("webgl", <String, dynamic>{})
          as webgl.RenderingContext ??
      canvas.getContext("experimental-webgl", <String, dynamic>{})
          as webgl.RenderingContext;

  Context.glWrapper = new WebGLRenderingContext.fromWebGL(gl);
  if (gl == null) {
    error.innerHtml += 'Failed to get the rendering context for WebGL<br>';
    return;
  }

  CanvasRenderingContext2D ctx2d =
      canvas2d.getContext("2d") as CanvasRenderingContext2D;

  webgl.EXTsRgb hasSRGBExt = gl.getExtension('EXT_SRGB') as webgl.EXTsRgb;

  GlobalState glState = new GlobalState()
    ..uniforms = {}
    ..attributes = {}
    ..vertSource = vertSource
    ..fragSource = fragSource
    ..scene = null
    ..hasLODExtension =
        gl.getExtension('EXT_shader_texture_lod') as webgl.ExtShaderTextureLod
    ..hasDerivativesExtension = gl.getExtension('OES_standard_derivatives')
        as webgl.OesStandardDerivatives
    ..sRGBifAvailable =
        hasSRGBExt != null ? webgl.EXTsRgb.SRGB_EXT : webgl.RGBA;

  Matrix4 projectionMatrix = new Matrix4.identity();
  void resizeCanvasIfNeeded() {
    logCurrentFunction();
    int width = Math.max(1, window.innerWidth);
    var height = Math.max(1, window.innerHeight);
    if (width != canvasWidth || height != canvasHeight) {
      canvas.width = canvas2d.width = canvasWidth = width;
      canvas.height = canvas2d.height = canvasHeight = height;
      gl.viewport(0, 0, width, height);
      setPerspectiveMatrix(projectionMatrix, 45.0 * Math.PI / 180.0,
          width / height, 0.01, 100.0);
    }
  }

  // Create cube maps
  var envMap = "papermill";
//  loadCubeMap(gl, envMap, "environment", glState);
  await loadCubeMap(gl, envMap, "diffuse", glState);
  await loadCubeMap(gl, envMap, "specular", glState);
  // Get location of mvp matrix uniform
  glState.uniforms['u_MVPMatrix'] = new GLFunctionCall()
    ..function = gl.uniformMatrix4fv;
  // Get location of normal matrix uniform
  glState.uniforms['u_ModelMatrix'] = new GLFunctionCall()
    ..function = gl.uniformMatrix4fv;

  // Light
  glState.uniforms['u_LightDirection'] = new GLFunctionCall()
    ..function = gl.uniform3f
    ..vals = <dynamic>[0.0, 0.5, 0.5];
  glState.uniforms['u_LightColor'] = new GLFunctionCall()
    ..function = gl.uniform3f
    ..vals = <dynamic>[1.0, 1.0, 1.0];

  // Camera
  glState.uniforms['u_Camera'] = new GLFunctionCall()
    ..function = gl.uniform3f
    ..vals = <dynamic>[0.0, 0.0, -4.0];

  // Model matrix
  Matrix4 modelMatrix = new Matrix4.identity();

  // View matrix
  Matrix4 viewMatrix = new Matrix4.identity();
  Vector3 eye = new Vector3(0.0, 0.0, 4.0);
  Vector3 at = new Vector3(0.0, 0.0, 0.0);
  Vector3 up = new Vector3(0.0, 1.0, 0.0);
  setViewMatrix(viewMatrix, eye, at, up);

  // get scaling stuff
  glState.uniforms['u_ScaleDiffBaseMR'] = new GLFunctionCall()
    ..function = gl.uniform4f
    ..vals = <dynamic>[0.0, 0.0, 0.0, 0.0];
  glState.uniforms['u_ScaleFGDSpec'] = new GLFunctionCall()
    ..function = gl.uniform4f
    ..vals = <dynamic>[0.0, 0.0, 0.0, 0.0];
  glState.uniforms['u_ScaleIBLAmbient'] = new GLFunctionCall()
    ..function = gl.uniform4f
    ..vals = <dynamic>[1.0, 1.0, 1.0, 1.0];

  // Load scene
  String defaultModelName = 'DamagedHelmet';
  updateModel(defaultModelName, gl, glState, viewMatrix, projectionMatrix,
      canvas, ctx2d);

  // Set clear color
  gl.clearColor(0.2, 0.2, 0.2, 1.0);

  // Enable depth test
  gl.enable(webgl.DEPTH_TEST);

  var redrawQueued = false;
  void redraw() {
    logCurrentFunction();
    if (!redrawQueued) {
      redrawQueued = true;
      window.requestAnimationFrame((num val) {
        redrawQueued = false;
        resizeCanvasIfNeeded();
        var scene = glState.scene;
        if (scene != null) {
          scene.drawScene(gl);
        }
      });
    }
  }

  ;

  // Set control callbacks
  canvas2d.onMouseDown.listen((ev) {
    handleMouseDown(ev);
  });
  document.onMouseUp.listen((ev) {
    handleMouseUp(ev);
  });
  document.onMouseMove.listen((ev) {
    handleMouseMove(ev, redraw);
  });
  document.onMouseWheel.listen((ev) {
    handleWheel(ev, redraw);
  });

  // Initialize GUI
  dat.GUI gui = new dat.GUI();
  dat.GUI folder = gui.addFolder("Metallic-Roughness Material");

  DatModelText text = new DatModelText()..model = defaultModelName;
  folder.add(text, 'Model', [
    'MetalRoughSpheres',
    'AppleTree',
    'Avocado',
    'BarramundiFish',
    'BoomBox',
    'Corset',
    'DamagedHelmet',
    'FarmLandDiorama',
    'NormalTangentTest',
    'Telephone',
    'TextureSettingsTest',
    'Triangle',
    'WaterBottle'
  ]).onChange((String value) {
    updateModel(
        value, gl, glState, viewMatrix, projectionMatrix, canvas, ctx2d);
  });
  folder.open();

  var light = gui.addFolder("Directional Light");
  var lightProps = new DatLight()
    ..lightColor = [255, 255, 255]
    ..lightScale = 1.0
    ..lightRotation = 75
    ..lightPitch = 40;

  void updateLight(dynamic value) {
    logCurrentFunction();
    glState.uniforms['u_LightColor'].vals = <dynamic>[
      [
        lightProps.lightScale * lightProps.lightColor[0] / 255,
        lightProps.lightScale * lightProps.lightColor[1] / 255,
        lightProps.lightScale * lightProps.lightColor[2] / 255
      ]
    ];

    var rot = lightProps.lightRotation * Math.PI / 180;
    var pitch = lightProps.lightPitch * Math.PI / 180;
    glState.uniforms['u_LightDirection'].vals = <dynamic>[
      Math.sin(rot) * Math.cos(pitch),
      Math.sin(pitch),
      Math.cos(rot) * Math.cos(pitch)
    ];

    redraw();
  }

  ;

  light.addColor(lightProps, "lightColor").onChange(updateLight);
  light.add(lightProps, "lightScale", 0, 10).onChange(updateLight);
  light.add(lightProps, "lightRotation", 0, 360).onChange(updateLight);
  light.add(lightProps, "lightPitch", -90, 90).onChange(updateLight);

  light.open();

  updateLight(null);

  //mouseover scaling

  ScaleVal scaleVals = new ScaleVal()..IBL = 1.0;

  void updateMathScales(dynamic v) {
    logCurrentFunction();
    Element el = scaleVals.pinnedElement != null
        ? scaleVals.pinnedElement
        : scaleVals.activeElement;
    String elId = el != null ? el.attributes['id'] : null;

    glState.uniforms['u_ScaleDiffBaseMR'].vals = <dynamic>[
      [
        elId == "mathDiff" ? 1.0 : 0.0,
        elId == "baseColor" ? 1.0 : 0.0,
        elId == "metallic" ? 1.0 : 0.0,
        elId == "roughness" ? 1.0 : 0.0
      ]
    ];
    glState.uniforms['u_ScaleFGDSpec'].vals = <dynamic>[
      [
        elId == "mathF" ? 1.0 : 0.0,
        elId == "mathG" ? 1.0 : 0.0,
        elId == "mathD" ? 1.0 : 0.0,
        elId == "mathSpec" ? 1.0 : 0.0
      ]
    ];
    glState.uniforms['u_ScaleIBLAmbient'].vals = <dynamic>[
      [scaleVals.IBL, scaleVals.IBL, 0.0, 0.0]
    ];

    redraw();
  }

  ;

  gui.add(scaleVals, "IBL", 0, 4).onChange(updateMathScales);

  void setActiveComponent(Element el) {
    logCurrentFunction();
    if (scaleVals.activeElement != null) {
      scaleVals.activeElement.classes.remove("activeComponent");
    }
    if (el != null && scaleVals.pinnedElement == null) {
      el.classes.add("activeComponent");
    }
    scaleVals.activeElement = el;

    if (scaleVals.pinnedElement == null) {
      updateMathScales(null);
    }
  }

  ;

  void setPinnedComponent(Element el) {
    logCurrentFunction();
    if (scaleVals.activeElement != null) {
      if (el != null) {
        scaleVals.activeElement.classes.remove("activeComponent");
      } else {
        scaleVals.activeElement.classes.add("activeComponent");
      }
    }

    if (scaleVals.pinnedElement != null) {
      scaleVals.pinnedElement.classes.remove("pinnedComponent");
    }
    if (el != null) {
      el.classes.add("pinnedComponent");
    }

    scaleVals.pinnedElement = el;

    updateMathScales(null);
  }

  ;

  void createMouseOverScale(String arg0, String arg1) {
    logCurrentFunction();
    Element el = document.querySelector(arg0);

    el.onMouseOver.listen((MouseEvent ev) {
      setActiveComponent(el);
    });

    el.onMouseOut.listen((MouseEvent ev) {
      setActiveComponent(null);
    });

    el.onClick.listen((MouseEvent ev) {
      if (scaleVals.pinnedElement != null) {
        setPinnedComponent(null);
      } else {
        setPinnedComponent(el);
      }
      ev.stopPropagation();
    });
  }

  ;

  createMouseOverScale('#mathDiff', 'diff');
  createMouseOverScale('#mathSpec', 'spec');
  createMouseOverScale('#mathF', 'F');
  createMouseOverScale('#mathG', 'G');
  createMouseOverScale('#mathD', 'D');
  createMouseOverScale("#baseColor", "baseColor");
  createMouseOverScale("#metallic", "metallic");
  createMouseOverScale("#roughness", "roughness");

  document.querySelector("#pbrMath").onClick.listen((MouseEvent ev) {
    if (scaleVals.pinned && scaleVals.pinnedElement != null) {
      scaleVals.pinnedElement.classes.remove("pinnedComponent");
    }
    scaleVals.pinned = false;
  });

  updateMathScales(null);

  String format255(dynamic p) {
    String str = p.toString();
    return ''.padLeft(3, ' ').substring(str.length) + str;
  }

  // picker
  Element pixelPickerText = document.getElementById('pixelPickerText');
  Element pixelPickerColor = document.getElementById('pixelPickerColor');
  Position<int> pixelPickerPos = new Position<int>(x: 0, y: 0);
  bool pixelPickerScheduled = false;
  void sample2D(num val) {
    logCurrentFunction();
    pixelPickerScheduled = false;
    var x = pixelPickerPos.x;
    var y = pixelPickerPos.y;
    Uint8ClampedList p = ctx2d.getImageData(x, y, 1, 1).data;
    pixelPickerText.innerHtml = "r:  " +
        format255(p[0]) +
        " g:  " +
        format255(p[1]) +
        " b:  " +
        format255(p[2]) +
        "<br>r: " +
        (p[0] / 255).toStringAsFixed(2) +
        " g: " +
        (p[1] / 255).toStringAsFixed(2) +
        " b: " +
        (p[2] / 255).toStringAsFixed(2);
    pixelPickerColor.style.backgroundColor = 'rgb(${p[0]},${p[1]},${p[2]})';
  }

  canvas2d.onMouseMove.listen((MouseEvent e) {
    Rectangle pos = canvas2d.client;
    pixelPickerPos.x = (e.page.x - pos.left).toInt();
    pixelPickerPos.y = (e.page.y - pos.top).toInt();
    if (!pixelPickerScheduled) {
      pixelPickerScheduled = true;
      window.requestAnimationFrame(sample2D);
    }
  });

  // Redraw the scene after window size changes.
  window.onResize.listen((e) => redraw());

//  void tick(num time) {
//    animate(MainInfos.roll);
//    redraw();
//    window.requestAnimationFrame(tick);
//  }
//
//  ;
  // Uncomment for turntable
  //tick();
}

class DatLight {
  int lightRotation;

  List<int> lightColor;

  double lightScale;

  int lightPitch;
}

class DatModelText {
  String model;
}

// ***** Mouse Controls ***** //
bool mouseDown;
num lastMouseX = null;
num lastMouseY = null;

void resetCamera() {
  logCurrentFunction();
  MainInfos.roll = Math.PI;
  MainInfos.pitch = 0.0;
  MainInfos.translate = 4.0;
  mouseDown = false;
}

void handleMouseDown(MouseEvent ev) {
  logCurrentFunction();
  mouseDown = true;
  lastMouseX = ev.client.x;
  lastMouseY = ev.client.y;
}

void handleMouseUp(MouseEvent ev) {
  logCurrentFunction();
  mouseDown = false;
}

void handleMouseMove(MouseEvent ev, Function redraw) {
  logCurrentFunction();
  if (!mouseDown) {
    return;
  }
  num newX = ev.client.x;
  num newY = ev.client.y;

  var deltaX = newX - lastMouseX;
  MainInfos.roll += (deltaX / 100.0);

  var deltaY = newY - lastMouseY;
  MainInfos.pitch += (deltaY / 100.0);

  lastMouseX = newX;
  lastMouseY = newY;

  redraw();
}

num wheelSpeed = 1.04;
void handleWheel(WheelEvent ev, Function redraw) {
  logCurrentFunction();
  ev.preventDefault();
  if (ev.deltaY > 0) {
    MainInfos.translate *= wheelSpeed;
  } else {
    MainInfos.translate /= wheelSpeed;
  }

  redraw();
}

int prev = new DateTime.now().millisecond;
void animate(double angle) {
  logCurrentFunction();
  int curr = new DateTime.now().millisecond;
  int elapsed = curr - prev;
  prev = curr;
  MainInfos.roll = angle + ((Math.PI / 4.0) * elapsed) / 1000.0;
}
