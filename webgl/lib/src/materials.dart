import 'package:webgl/src/material.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/mesh.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/texture.dart';
import 'dart:async';
import 'package:webgl/src/light.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/utils.dart';

class MaterialPoint extends MaterialCustom {
  static const String _vsSource = """
    attribute vec3 aVertexPosition;

    uniform float pointSize;
    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      gl_PointSize = pointSize;
    }
    """;

  static const String _fsSource = """
    void main(void) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
    """;

  final buffersNames = ['aVertexPosition'];
  final num pointSize;

  MaterialPoint(this.pointSize) : super(_vsSource, _fsSource);

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
    setShaderUniformWithName("pointSize", pointSize);
  }
}

class MaterialBase extends MaterialCustom {
  static const String _vsSource = """
    attribute vec3 aVertexPosition;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
        gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    void main(void) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
    """;

  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  MaterialBase() : super(_vsSource, _fsSource);

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
  }
}

class MaterialBaseColor extends MaterialCustom {
  static const String _vsSource = """
    attribute vec3 aVertexPosition;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
        gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    uniform vec3 uColor;

    void main(void) {
        gl_FragColor = vec4(uColor, 1.0);
    }
    """;
  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  //External Parameters
  final Vector3 color;

  MaterialBaseColor(this.color) : super(_vsSource, _fsSource) {}

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
    setShaderUniformWithName("uColor", color.storage);
  }
}

class MaterialBaseVertexColor extends MaterialCustom {
  static const String _vsSource = """
    attribute vec3 aVertexPosition;
    attribute vec4 aVertexColor;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    varying vec4 vColor;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vColor = aVertexColor;
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    varying vec4 vColor;

    void main(void) {
      gl_FragColor = vColor;
    }
    """;
  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aVertexColor'];

  MaterialBaseVertexColor() : super(_vsSource, _fsSource);

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
    setShaderAttributWithName(
        'aVertexColor', mesh.colors, mesh.colorDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
  }
}

class MaterialBaseTexture extends MaterialCustom {
  static const String _vsSource = """
    attribute vec3 aVertexPosition;
    attribute vec2 aTextureCoord;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    varying vec2 vTextureCoord;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vTextureCoord = aTextureCoord;
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    varying vec2 vTextureCoord;

    uniform sampler2D uSampler;

    void main(void) {
      gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
    }
    """;

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aTextureCoord'];

  //External parameters
  TextureMap textureMap;

  MaterialBaseTexture() : super(_vsSource, _fsSource) {}

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);

    gl.activeTexture(GL.TEXTURE0);
    gl.bindTexture(GL.TEXTURE_2D, textureMap.texture);
    setShaderAttributWithName(
        'aTextureCoord', mesh.textureCoords, mesh.textureCoordsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
    setShaderUniformWithName('uSampler', 0);
  }

  Future addTexture(String fileName) {
    Completer completer = new Completer();
    TextureMap.initTexture(fileName, (textureMapResult) {
      textureMap = textureMapResult;
      completer.complete();
    });

    return completer.future;
  }
}

class MaterialBaseTextureNormal extends MaterialCustom {
  static const String _vsSource = """
    attribute vec3 aVertexPosition;
    attribute vec2 aTextureCoord;
    attribute vec3 aVertexNormal;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;
    uniform mat3 uNMatrix;

    uniform vec3 uAmbientColor;

    uniform vec3 uLightingDirection;
    uniform vec3 uDirectionalColor;

    uniform bool uUseLighting;

    varying vec2 vTextureCoord;
    varying vec3 vLightWeighting;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vTextureCoord = aTextureCoord;
      if(!uUseLighting)
      {
         vLightWeighting = vec3(1.0, 1.0, 1.0);
      } else
      {
         vec3 transformedNormal = uNMatrix * aVertexNormal;
         float directionalLightWeighting = max(dot(transformedNormal, uLightingDirection), 0.0);
         vLightWeighting = uAmbientColor + uDirectionalColor*directionalLightWeighting;
      }
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    varying vec2 vTextureCoord;
    varying vec3 vLightWeighting;

    uniform sampler2D uSampler;

    void main(void) {
      vec4 textureColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
      gl_FragColor = vec4(textureColor.rgb * vLightWeighting, textureColor.a);
    }
    """;

  final buffersNames = [
    'aVertexPosition',
    'aVertexIndice',
    'aTextureCoord',
    'aVertexNormal'
  ];

  //External Parameters
  TextureMap textureMap;
  Vector3 ambientColor;
  DirectionalLight directionalLight;
  bool useLighting;

  MaterialBaseTextureNormal() : super(_vsSource, _fsSource) {}

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);

    gl.activeTexture(GL.TEXTURE0);
    gl.bindTexture(GL.TEXTURE_2D, textureMap.texture);
    setShaderAttributWithName(
        'aTextureCoord', mesh.textureCoords, mesh.textureCoordsDimensions);

    setShaderAttributWithName(
        'aVertexNormal', mesh.vertexNormals, mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);

    Matrix4 mvInverse = new Matrix4.identity();
    mvInverse.copyInverse(Application.instance.mvMatrix);
    Matrix3 normalMatrix = mvInverse.getRotation();

    normalMatrix.transpose();
    setShaderUniformWithName("uNMatrix", normalMatrix.storage);

    //Light

    // draw lighting?
    setShaderUniformWithName(
        "uUseLighting", useLighting ? 1 : 0); // must be int, not bool

    if (useLighting) {
      setShaderUniformWithName(
          "uAmbientColor", ambientColor.r, ambientColor.g, ambientColor.b);

      Vector3 adjustedLD = new Vector3.zero();
      directionalLight.direction.normalizeInto(adjustedLD);
      adjustedLD.scale(-1.0);

      //Float32List f32LD = new Float32List(3);
      //adjustedLD.copyIntoArray(f32LD);
      //_gl.uniform3fv(_uLightDirection, f32LD);

      setShaderUniformWithName(
          "uLightingDirection", adjustedLD.x, adjustedLD.y, adjustedLD.z);

      setShaderUniformWithName("uDirectionalColor", directionalLight.color.r,
          directionalLight.color.g, directionalLight.color.b);
    }
  }

  Future addTexture(String fileName) {
    Completer completer = new Completer();
    TextureMap.initTexture(fileName, (textureMapResult) {
      textureMap = textureMapResult;
      completer.complete();
    });

    return completer.future;
  }
}

///PBR's
///http://marcinignac.com/blog/pragmatic-pbr-setup-and-gamma/
class MaterialPBR extends MaterialCustom {
  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aNormal'];

  //External Parameters
  final PointLight pointLight;

  MaterialPBR._internal(String vsSource, String fsSource, this.pointLight)
      : super(vsSource, fsSource);
  //>>
  static Future<MaterialPBR> create(PointLight pointLight) async {
    String vsCode = await Utils
        .loadGlslShader('../shaders/material_pbr/material_pbr.vs.glsl');
    String fsCode = await Utils
        .loadGlslShader('../shaders/material_pbr/material_pbr.fs.glsl');
    return new MaterialPBR._internal(vsCode, fsCode, pointLight);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
    setShaderAttributWithName(
        'aNormal', mesh.vertexNormals, mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);

    setShaderUniformWithName(
        "uNormalMatrix",
        new Matrix4.inverted(Application.instance.mvMatrix)
            .transposed()
            .getRotation()
            .storage);
    setShaderUniformWithName("uLightPos", pointLight.position.storage);
  }
}

/*
//Loading glsl files....
  //may be used to load code async
  -1-

  MaterialPBR._internal(String vsSource, String fsSource, this.pointLight) : super(vsSource, fsSource);
  //>>
  static Future<MaterialPBR> create(PointLight pointLight)async {
    String vsCode = await Utils.loadGlslShader('../shaders/material_pbr/material_pbr.vs.glsl');
    String fsCode = await Utils.loadGlslShader('../shaders/material_pbr/material_pbr.fs.glsl');
    return new MaterialPBR._internal(vsCode, fsCode, pointLight);
  }

  >> but need to change creation time to :
  MaterialPBR materialPBR = await MaterialPBR.create(pointLight);


  //Or use sync getter
  -2-

  static String get vsCode {
    return Utils.loadGlslShaderSync('../shaders/material_pbr/material_pbr.vs.glsl');
  }

  static String get fsCode {
    return Utils.loadGlslShaderSync('../shaders/material_pbr/material_pbr.fs.glsl');
  }

  MaterialPBR(this.pointLight) : super(vsCode, fsCode);

  >> But have warning message:
  Synchronous XMLHttpRequest on the main thread is deprecated because of its detrimental effects to the end user's experience. For more help, check http://xhr.spec.whatwg.org/.

 */
