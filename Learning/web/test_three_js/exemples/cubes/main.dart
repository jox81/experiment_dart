import 'dart:html';
import 'dart:math';
import 'package:threejs_facade/three.dart' as THREE;
import '../../lib/statsjs.dart';

void main() {

  Element container = document.createElement( 'div' );
  document.body.children.add(container);

  THREE.Scene scene = new THREE.Scene();
  THREE.PerspectiveCamera camera = new THREE.PerspectiveCamera(
      75,
      window.innerWidth / window.innerHeight,
      0.1,
      1000);

  THREE.WebGLRenderer renderer = new THREE.WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight, null);

  container.children.add(renderer.domElement);

  Random random = new Random();

  List<THREE.Mesh> meshes = new List();

  num boxZoneWidth = 20;
  int meshCount = 1000;
  for(int i = 0; i < meshCount; i++) {
    THREE.BoxGeometry geometry = new THREE.BoxGeometry(1, 1, 1);
    THREE.BufferGeometry bufferGeometry = new THREE.BufferGeometry().fromGeometry(geometry, null);

    THREE.MeshBasicMaterial material =
    new THREE.MeshBasicMaterial();

    THREE.Mesh cube = new THREE.Mesh(bufferGeometry, material);

    cube.position.x = random.nextDouble() * boxZoneWidth;
    cube.position.y = random.nextDouble() * boxZoneWidth;
    cube.position.z = random.nextDouble() * boxZoneWidth;

    scene.add(cube);
    meshes.add(cube);
  }

  camera.position
    ..x = boxZoneWidth * 0.5
    ..y = boxZoneWidth * 0.5
    ..z = 100;

  Stats stats = new Stats();
  container.children.add(stats.dom);

  void render(num delta) {
    window.animationFrame.then(render);

    for(THREE.Mesh mesh in meshes){
      mesh.rotation.x += random.nextDouble() / 10;
      mesh.rotation.y += random.nextDouble() / 10;
    }
    renderer.render(scene, camera, null, null);
    stats.update();
  }

  render(0);

  print('end');
}
