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
        Animation animation = new Animation.startEnd(10.0, 0.0, 2.0, ease: Ease.easeOutBounce)
          ..onUpdate.listen((num value){
            nodeCube.translation = new Vector3(0.0, 0.0, 3.0 + value);
            print('  animation : $value');
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
        Animation animation = new Animation.startEnd(5.0, 0.0, 1.0, ease: Ease.easeOutBounce)
          ..onUpdate.listen((num value){
            nodeCube2.translation = new Vector3(0.0, value, 3.0);
            print('  animation : $value');
          });
        animation.play();
      });
    nodeCube.addChild(nodeCube2);
  }

  Future moveCube() async {
    Animation animation1 = new Animation.startEnd(0.0, 5.0, 2.0, ease: Ease.easeInQuadratic)
//    ..onStart.listen((_){
//      nodeCube.translation = new Vector3(0.0,0.0,0.0);
//    })
      ..onUpdate.listen((num value){
        nodeCube.translation = new Vector3(value, 2.0, 0.0);
//      print('animation1 : $value');
      });
    animation1.play();

//    Animation animation2 = new Animation(2.0)
//    ..onStart.listen((_){
//      nodeCube.translate(new Vector3(0.0, 0.0, 0.01));
////      print(nodeCube.translation);
//    })
//    ..onEnd.listen((_){
//      nodeCube.translation = new Vector3(0.0,5.0,0.0);
//    });
//    await animation2.play();

    Animation animation3 = new Animation.startEnd(0.0, 5.0, 2.0, ease: Ease.easeOutBounce)
      ..onUpdate.listen((num value){
        nodeCube2.translation = new Vector3(value, 0.0, 3.0);
        print('  animation3 : $value');
      });
    animation3.play();
  }
}