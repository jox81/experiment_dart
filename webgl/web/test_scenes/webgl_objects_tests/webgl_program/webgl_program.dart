import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglTest webglTest =
      new WebglTest(querySelector('#glCanvas'));

  webglTest.setup();
}

class WebglTest {

  WebglTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  void setup() {
//    test01();
    test02CubeMap();
  }

  void test01() {
     WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = ShaderSource.sources['material_point'].vsCode
      ..compile();
    vertexShader.logShaderInfos();

    WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = ShaderSource.sources['material_point'].fsCode
      ..compile();

    fragmentShader.logShaderInfos();

    WebGLProgram program = new WebGLProgram()
      ..attachShader(vertexShader)
      ..attachShader(fragmentShader)
      ..link()
      ..validate()
      ..use();

    //Pour setter une valeur à un attribut :
    //
    WebGLActiveInfo attribute = program.getActiveAttribInfo(0);
    WebGLAttributLocation attribLocation = program.getAttribLocation(attribute.name);
    attribLocation.enabled = true;
    attribLocation.vertexAttrib3fv(new Vector3.all(0.5));

    //Pour setter une valeur à un uniform :
    //
    WebGLActiveInfo activeInfo = program.getActiveUniform(1);
    WebGLUniformLocation uniformLocation = program.getUniformLocation(activeInfo.name);
    uniformLocation.uniformMatrix4fv(new Matrix4.identity(), false);

    program.logProgramInfos();
  }

  Future test02CubeMap() async {

//    List<ImageElement> cubeMapImages = await TextureUtils.loadCubeMapImages();
//    WebGLTexture cubeMapTexture = TextureUtils.createCubeMapFromElements(cubeMapImages);
//
//    MaterialSkyBox materialSkyBox = new MaterialSkyBox();
//    materialSkyBox.skyboxTexture = cubeMapTexture;

    WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = ShaderSource.sources['material_skybox'].vsCode
      ..compile();
    vertexShader.logShaderInfos();

    WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = ShaderSource.sources['material_skybox'].fsCode
      ..compile();

    fragmentShader.logShaderInfos();

    WebGLProgram program = new WebGLProgram()
      ..attachShader(vertexShader)
      ..attachShader(fragmentShader)
      ..link()
      ..validate()
      ..use();

    //Pour setter une valeur à un attribut :
    //
    WebGLActiveInfo attribute = program.getActiveAttribInfo(0);
    WebGLAttributLocation attribLocation = program.getAttribLocation(attribute.name);
    attribLocation.enabled = true;
    attribLocation.vertexAttrib3fv(new Vector3.all(0.5));

    //Pour setter une valeur à un uniform :
    //
    WebGLActiveInfo activeInfo = program.getActiveUniform(1);
    WebGLUniformLocation uniformLocation = program.getUniformLocation(activeInfo.name);
    uniformLocation.uniformMatrix4fv(new Matrix4.identity(), false);

    program.logProgramInfos();
  }

}
