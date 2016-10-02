import 'dart:math' as Math;
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/interaction.dart';

//Scene used for learning https://www.shadertoy.com/view/Md23DV
class SceneViewShaderLearning01 extends Scene {

  final num viewAspectRatio;

  SceneViewShaderLearning01(Application application):this.viewAspectRatio = application.viewAspectRatio,super();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  @override
  setupUserInput() {

    updateUserInputFunction = (){
    };

    updateUserInputFunction();
  }

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.0, 0.0, 0.0, 1.0);

    Mesh mesh = await baseSurface();
    materials.add(mesh.material);
    meshes.add(mesh);

    //Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //... custom animation here
      mesh.updateFunction(time);
      _lastTime = time;
    };
  }

  Mesh baseSurface() {
    num shaderTime = 0.0;

    String vShader = '''
    precision mediump float;

    attribute vec2 a_vertex;

    uniform float u_time;

    void main(void) {
      gl_Position=vec4(a_vertex,0.0,1.0);
    }

  ''';

    String fShader = '''
    precision mediump float;

    uniform float u_time;

    void mainImage( out vec4 fragColor, in vec2 fragCoord )
    {
      vec2 r = vec2( fragCoord.xy / iResolution.xy );
      // shorter version of the same coordinate transformation.
      // For example "aVector.xy" is a new vec2 made of the first two
      // components of "aVector".
      // And, when division operator is applied between vectors,
      // each component of the first vector is divided by the corresponding
      // component of the second vector.
      // So, first line of this tutorial is the same as the first line
      // of the previous tutorial.

      vec3 backgroundColor = vec3(1.0);
      vec3 color1 = vec3(0.216, 0.471, 0.698);
      vec3 color2 = vec3(1.00, 0.329, 0.298);
      vec3 color3 = vec3(0.867, 0.910, 0.247);

      // start by setting the background color. If pixel's value
      // is not overwritten later, this color will be displayed.
      vec3 pixel = backgroundColor;

      // if the current pixel's x coordinate is between these values,
      // then put color 1.
      // The difference between 0.55 and 0.54 determines
      // the with of the line.
      float leftCoord = 0.54;
      float rightCoord = 0.55;
      if( r.x < rightCoord && r.x > leftCoord ) pixel = color1;

      // a different way of expressing a vertical line
        // in terms of its x-coordinate and its thickness:
      float lineCoordinate = 0.4;
      float lineThickness = 0.003;
      if(abs(r.x - lineCoordinate) < lineThickness) pixel = color2;

      // a horizontal line
      if(abs(r.y - 0.6)<0.01) pixel = color3;

      // see how the third line goes over the first two lines.
      // because it is the last one that sets the value of the "pixel".

      fragColor = vec4(pixel, 1.0);
    }

    void main(void) {
      mainImage(gl_FragColor, gl_FragCoord.xy);
    }

  ''';

    List<String> buffersNames = ['a_vertex'];

    MaterialCustom materialCustom = new MaterialCustom(
        vShader, fShader, buffersNames);
    materialCustom
      ..setShaderAttributsVariables = (Mesh mesh) {
        materialCustom.setShaderAttributWithName(
            'a_vertex', mesh.vertices, mesh.vertexDimensions);
      }
      ..setShaderUniformsVariables = (Mesh mesh) {
        materialCustom.setShaderUniformWithName('u_time', shaderTime);
      };
    materials.add(materialCustom);

    Mesh mesh = new Mesh.Rectangle()
      ..material = materialCustom;

    mesh.updateFunction = (num time) {
      shaderTime = time / 10000;
    };

    return mesh;
  }
}
