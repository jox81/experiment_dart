import 'package:webgl/src/scene.dart';
import 'dart:async';
@MirrorsUsed(
    targets: const [
      P_1_0_01,
    ],
    override: '*')
import 'dart:mirrors';

//https://github.com/generative-design/Code-Package-Processing-3.x/blob/master/01_P/P_1_0_01/P_1_0_01.pde
class P_1_0_01 extends Scene{

  P_1_0_01();

  @override
  setupUserInput() {
    if(updateUserInputFunction == null) {
      updateUserInputFunction = () {
        interaction.update();
      };
    }
    updateUserInputFunction();
  }

  @override
  Future setupScene() async {

  }
}
