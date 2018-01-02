
import 'dart:async';
@MirrorsUsed(
    targets: const [
      P_1_0_01,
    ],
    override: '*')
import 'dart:mirrors';

import 'package:webgl_application/src/application.dart';

//https://github.com/generative-design/Code-Package-Processing-3.x/blob/master/01_P/P_1_0_01/P_1_0_01.pde
class P_1_0_01 extends SceneJox{

  P_1_0_01();

  @override
  setupUserInput() {
    if(updateUserInputFunction == null) {
      updateUserInputFunction = () {
        Application.instance.interaction.update();
      };
    }
    updateUserInputFunction();
  }

  @override
  Future setupScene() async {

  }
}
