import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/gltf.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/renderer/render_state.dart';
import 'package:webgl/src/webgl_objects/context.dart';

Future main() async {

  await AssetLibrary.loadDefault();
  assert(AssetLibrary.project.brdfLUT != null);

  new WebglTestViewport(querySelector('#glCanvas') as CanvasElement).render();
}

class WebglTestViewport {

  GLTFEngine engine;
  GLTFRenderer get renderer => engine.renderer;
  GLTFProject project;
  GLTFScene scene;

  WebglTestViewport(CanvasElement canvas) {
    new Context(canvas,enableExtensions:true,logInfos:false);
    GL.viewport = new Rectangle(0, 0, (gl.canvas.width), gl.canvas.height);

    engine = new GLTFEngine(canvas);
    project = new GLTFProject()
        ..addScene(scene = new GLTFScene());
    engine.init(project);

    setup();
  }

  void setup() {
    setupCamera();
    setupMeshes();
  }

  void setupCamera() {
    Engine.mainCamera = new GLTFCameraPerspective(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(10.0, 10.0, 10.0);
  }

  void setupMeshes() {
    GLTFNode node = new GLTFNode.cube()
      ..material = new MaterialBaseColor(new Vector4(0.0, 0.0, 1.0, 1.0))
      ..name = 'cube'
      ..translation = new Vector3(0.0, 0.0, 0.0);
    scene.addNode(node);
//    getInfos();
  }

  void render({num time: 0.0}) {
    renderer.renderingType = RenderingType.stereo;
    engine.render();
  }

//  void getInfos() {
////    Context.webglConstants.logConstants();
////    Context.webglParameters.logValues();
//
//    IntrospectionManager.instance.logTypeInfos(GLTFMesh,
//      showBaseInfo: true,
//      showLibrary: false,
//      showType: false,
//      showTypeVariable: false,
//      showTypeDef: false,
//      showFunctionType: true,
//      showVariable: true,
//      showParameter: false,
//      showMethod: true
//    );
//
//    nodes[0].getPropertiesInfos();
//  }
}