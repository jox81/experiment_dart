import 'dart:html';
import 'dart:math';
import '../../lib/threejs.dart';
import '../../lib/statsjs.dart';

void main() {

  Element container = document.createElement( 'div' );
  document.body.children.add(container);

  Scene scene = new Scene();
  PerspectiveCamera camera = new PerspectiveCamera(
      75,
      window.innerWidth / window.innerHeight,
      0.1,
      1000);

  WebGLRenderer renderer = new WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight );

  container.children.add(renderer.domElement);

  Random random = new Random();

  List<Mesh> meshes = new List();

  num boxZoneWidth = 20;
  int meshCount = 1000;
  for(int i = 0; i < meshCount; i++) {
    BoxGeometry geometry = new BoxGeometry(1, 1, 1);
    MeshBasicMaterial material =
    new MeshBasicMaterial({'color': 0x00ff00});
    Mesh cube = new Mesh(geometry, material);

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

    for(Mesh mesh in meshes){
      mesh.rotation.x += random.nextDouble() / 10;
      mesh.rotation.y += random.nextDouble() / 10;
    }
    renderer.render(scene, camera);
    stats.update();
  }

  render(0);

  print('end');
}
