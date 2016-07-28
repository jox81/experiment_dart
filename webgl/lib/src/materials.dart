import 'dart:web_gl';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/application.dart';
import 'dart:typed_data';
import 'package:webgl/src/mesh.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/texture.dart';
import 'dart:async';
import 'package:webgl/src/light.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/utils_shader.dart';

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

  static const String _vsSource = """
    attribute vec4 aVertexPosition;

    //vertex normal in the model space
    attribute vec3 aNormal;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    uniform mat3 uNormalMatrix;

    //user supplied light position
    uniform vec3 uLightPos;

    //vertex position in the eye coordinates (view space)
    varying vec3 ecPosition;
    //normal in the eye coordinates (view space)
    varying vec3 ecNormal;
    //light position in the eye coordinates (view space)
    varying vec3 ecLightPos;

    void main(void) {
      //transform vertex into the eye space
      vec4 pos = uMVMatrix * aVertexPosition;

      ecPosition = pos.xyz;
      ecNormal = uNormalMatrix * aNormal;
      ecLightPos = vec3(uMVMatrix * vec4(uLightPos, 1.0));

      //project the vertex, the rest is handled by WebGL
      gl_Position = uPMatrix * pos;
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    //vertex position, normal and light position in the eye/view space
    varying vec3 ecPosition;
    varying vec3 ecNormal;
    varying vec3 ecLightPos;

    float lambert(vec3 lightDirection, vec3 surfaceNormal);

    float lambert(vec3 lightDirection, vec3 surfaceNormal) {
      return max(0.0, dot(lightDirection, surfaceNormal));
    }


    void main() {
      //normalize the normal, we do it here instead of vertex
      //shader for smoother gradients
      vec3 N = normalize(ecNormal);

      //calculate direction towards the light
      vec3 L = normalize(ecLightPos - ecPosition);

      //diffuse intensity
      float Id = lambert(L, N);

      //surface and light color, full white
      vec4 baseColor = vec4(1.0);
      vec4 lightColor = vec4(1.0);

      vec4 finalColor = vec4(baseColor.rgb * lightColor.rgb * Id, 1.0);
      gl_FragColor = finalColor;
    }

    """;

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aNormal'];

  //External Parameters
  PointLight pointLight;

  MaterialPBR(this.pointLight) : super(_vsSource, _fsSource);

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName('aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
    setShaderAttributWithName('aNormal', mesh.vertexNormals, mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);

    setShaderUniformWithName("uNormalMatrix", new Matrix4.inverted(Application.instance.mvMatrix).transposed().getRotation().storage);
    setShaderUniformWithName("uLightPos", pointLight.position.storage);
  }
}
