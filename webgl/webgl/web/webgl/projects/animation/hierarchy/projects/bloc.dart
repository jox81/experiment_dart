import 'package:vector_math/vector_math.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/animation/animation.dart';
import 'package:webgl/src/gltf/node.dart';

class Bloc extends GLTFNode{

  GLTFNode nodeCube;
  GLTFNode nodeCube2;

  Bloc(){
    nodeCube = new GLTFNode.cube()
      ..material = new MaterialBaseColor(new Vector4(0.0, 0.0, 1.0, 1.0))
      ..name = 'cube'
      ..translation = new Vector3(0.0, 0.0, 3.0)
      ..onClick.listen((e){
        print("node clicked !!!");
        Animation animation = new Animation.startEnd(0.0, 5.0, 1.0, ease: Ease.sine)
          ..onUpdate.listen((num value){
            nodeCube.translation = new Vector3(0.0, 0.0, 3.0 + value);
            print('  animation : $value');
          })
          ..onEnd.listen((_){
            nodeCube2.visible = true;
          });
        animation.play();
      });
    addChild(nodeCube);

    nodeCube2 = new GLTFNode.cube()
      ..material = new MaterialBaseColor(new Vector4(1.0, 1.0, 0.0, 1.0))
      ..name = 'cube2'
      ..translation = new Vector3(0.0, 0.0, 3.0)
      ..onClick.listen((e){
        print("node2 clicked !!!");
        Animation animation = new Animation.startEnd(0.0, 5.0, 0.8, ease: Ease.sine)
          ..onUpdate.listen((num value){
            nodeCube2.translation = new Vector3(0.0, value, 3.0);
            print('  animation : $value');
          })
          ..onEnd.listen((_){
            nodeCube2.visible = false;
            nodeCube2.enable = false;
          });
        animation.play();
      });
    nodeCube.addChild(nodeCube2);
  }
}