import 'dart:web_gl';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:logging/logging.dart';

class Material{

  final RenderingContext gl;

  Shader vertexShader;
  Shader fragementShader;

  Program _program;
  Program get program => _program;
  set program(Program value) => _program = value;

  Logger _logger;

  Material(this.gl, vertexShaderSource, fragmentShaderSource) {
    _logger = _setupLogger('Material');
    _initProgram(vertexShaderSource, fragmentShaderSource);
  }

  Logger _setupLogger(String loggerName) {
    Logger logger = new Logger(loggerName);
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    return logger;
  }

  Shader _getShader(int shaderType, String shaderSource){

    if(shaderType != GL.VERTEX_SHADER && shaderType != GL.FRAGMENT_SHADER ) {
      _logger.log(Level.SEVERE, 'ERROR Wrong type shader');
      return null;
    }

    String shaderName;

    switch(shaderType){
      case GL.VERTEX_SHADER:
        shaderName = "x-shader/x-vertex";
        break;
      case GL.FRAGMENT_SHADER:
        shaderName = "x-shader/x-fragment";
        break;
    }
    Shader shader = gl.createShader(shaderType);

    gl.shaderSource(shader, shaderSource);

    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
      _logger.log(Level.SEVERE, 'ERROR compiling ${shaderName}!',
          gl.getShaderInfoLog(shader));
      return null;
    }

    return shader;
  }

  void _initProgram(vertexShaderSource, fragmentShaderSource) {
    Shader vertexShader = _getShader(GL.VERTEX_SHADER, vertexShaderSource);
    Shader fragmentShader = _getShader(GL.FRAGMENT_SHADER, fragmentShaderSource);
    if(vertexShader == null || fragmentShader == null) return null;

    _program = gl.createProgram();
    gl.attachShader(_program, vertexShader);
    gl.attachShader(_program, fragmentShader);
    gl.linkProgram(_program);

    if (!gl.getProgramParameter(_program, GL.LINK_STATUS)) {
      _logger.log(
          Level.SEVERE,
          'ERROR linking program! Could not initialise shaders',
          gl.getProgramInfoLog(_program));
      return null;
    }
    gl.validateProgram(_program);
    if (!gl.getProgramParameter(_program, GL.VALIDATE_STATUS)) {
      _logger.log(Level.SEVERE, 'ERROR validating program!',
          gl.getProgramInfoLog(_program));
      return null;
    }

    // Tell OpenGL state machine which program should be active.
    gl.useProgram(_program);

  }
}

class MaterialModel extends Material{
  Vector3 _ambientColor;

  Vector3 get ambientColor => _ambientColor;
  set ambientColor(Vector3 value) {
    _ambientColor = value;
    setAmbientUniform();
  }

  MaterialModel(RenderingContext gl,String vertexShaderSource, String fragmentShaderSource):super(gl,vertexShaderSource, fragmentShaderSource) {
  }

  void setAmbientUniform() {
    UniformLocation ambientUniformLocation;
    ambientUniformLocation =
        gl.getUniformLocation(program, 'ambientLightIntensity');
    gl.uniform3fv(ambientUniformLocation, ambientColor.storage);
  }
}