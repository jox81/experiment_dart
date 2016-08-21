import 'dart:html';
import 'package:threejs_facade/three.dart';
import '../../lib/statsjs.dart';
import '../../lib/j3d.dart' as J3D;
import 'package:js/js.dart';
import 'dart:async';

/// using J3D Loader :
/// https://github.com/drojdjou/J3D
///
/// using Three.js facade
/// https://github.com/blockforest/threejs-dart-facade

Future main() async {
  Element container = document.createElement('div');
  document.body.children.add(container);
  Stats stats = new Stats();
  document.body.children.add(stats.dom);

  Scene scene = new Scene();
  WebGLRenderer renderer = new WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight, null);
  container.children.add(renderer.domElement);

  await getJ3D(renderer, scene);

  Mesh cube = scene.getObjectByName('cube');
  Camera camera = scene.getObjectByName('camera');

  List<Mesh> meshes = new List();
  meshes.add(cube);
  scene.add(cube);

  void render(num delta) {
    stats.begin();

    renderer.render(scene, camera, null, null);

    stats.end();

    window.animationFrame.then(render);
  }

  window.animationFrame.then(render);

  print('end');
}

Future getJ3D(renderer, scene) {
  Completer loadCompleter = new Completer();
  J3D.Loader.loadJSON("model/Test01.json", allowInterop((jsmeshes) {
    J3D.Loader.loadJSON("model/Test01Scene.json", allowInterop((jsscene) {
      J3D.Loader.parseJSONScene(renderer, scene, jsscene, jsmeshes);
      loadCompleter.complete();
    }));
  }));

  return loadCompleter.future;
}
