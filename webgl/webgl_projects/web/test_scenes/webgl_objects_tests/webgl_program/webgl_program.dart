import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/shaders/shader_sources.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

Future main() async {
  ShaderSources shaderSources = new ShaderSources();
  await shaderSources.loadShaders();

  WebglTest webglTest =
      new WebglTest(querySelector('#glCanvas') as CanvasElement);

  webglTest.setup();
}

class WebglTest {

  WebglTest(CanvasElement canvas) {
    new Context(canvas, enableExtensions: true, logInfos: false);
  }

  void setup() {
//    test01();
//    test02CubeMap();
    shouldProgramAlwaysSetUniform();
  }

  void test01() {
    WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = ShaderSources.materialPoint.vsCode
      ..compile();
    vertexShader.logShaderInfos();

    WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = ShaderSources.materialPoint.fsCode
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
      ..source = ShaderSources.materialSkybox.vsCode
      ..compile();
    vertexShader.logShaderInfos();

    WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = ShaderSources.materialSkybox.fsCode
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

  //Test pour voir si il est nécessaire de mettre a jour des uniforms une fois settées.
  //visiblement les résultats montre qu'un program garde les unifrom settés même après avoir utilisé un autre program
  // c'est donc inutile de les setter à nouveau si ils n'ont pas changé
  void shouldProgramAlwaysSetUniform() {
    WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = ShaderSources.materialBaseColor.vsCode
      ..compile();
    vertexShader.logShaderInfos();

    WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = ShaderSources.materialBaseColor.fsCode
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
    WebGLUniformLocation uniformLocation = program.getUniformLocation('uColor');
//    uniformLocation.uniform4fv(new Vector4.all(0.5).storage);
    Float32List fl = new Float32List.fromList([.1,.4,.3,.5])..[0] = 0.2;
    gl.uniform4fv(uniformLocation.webGLUniformLocation,fl);
    program.logProgramInfos();

    //>
    void useNewTempProgram(){
      WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
        ..source = ShaderSources.materialSkybox.vsCode
        ..compile();

      WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
        ..source = ShaderSources.materialSkybox.fsCode
        ..compile();

      WebGLProgram program = new WebGLProgram()
        ..attachShader(vertexShader)
        ..attachShader(fragmentShader)
        ..link()
        ..validate()
        ..use();
      program.logProgramInfos();
      print('useNewTempProgram');
    }

    useNewTempProgram();

    print('reset first program');
    program.use();

    program.logProgramInfos();
  }

}
