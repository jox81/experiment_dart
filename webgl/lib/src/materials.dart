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

class MaterialBase extends Material{

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

  final buffersNames = ['vertexPositionBuffer', 'vertexIndiceBuffer'];
  final attributsNames = ['aVertexPosition'];
  final uniformsNames = ["uPMatrix", "uMVMatrix"];

  UniformLocation get _uPMatrix => uniforms["uPMatrix"];
  UniformLocation get _uMVMatrix => uniforms["uMVMatrix"];

  Buffer get _vertexPositionBuffer => buffers['vertexPositionBuffer'];
  int get _aVertexPosition => attributes['aVertexPosition'];

  Buffer get _vertexIndiceBuffer => buffers['vertexIndiceBuffer'];

  MaterialBase():super(_vsSource, _fsSource){
  }

  setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, GL.FLOAT, false, 0, 0);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), GL.STATIC_DRAW);

    //indices
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), GL.STATIC_DRAW);
  }

  setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
  }
}

class MaterialBaseColor extends Material{

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
  final  buffersNames = ['vertexPositionBuffer', 'vertexIndiceBuffer'];
  final attributsNames = ['aVertexPosition'];
  final uniformsNames = ["uPMatrix","uMVMatrix","uColor"];

  UniformLocation get _uPMatrix => uniforms["uPMatrix"];
  UniformLocation get _uMVMatrix => uniforms["uMVMatrix"];
  UniformLocation get _uColor => uniforms["uColor"];

  Buffer get _vertexPositionBuffer => buffers['vertexPositionBuffer'];
  int get _aVertexPosition => attributes['aVertexPosition'];

  Buffer get _vertexIndiceBuffer => buffers['vertexIndiceBuffer'];

  //External Parameters
  final Vector3 color;

  MaterialBaseColor(this.color ):super(_vsSource, _fsSource){
  }

  setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, GL.FLOAT, false, 0, 0);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), GL.STATIC_DRAW);

    //indices
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), GL.STATIC_DRAW);
  }

  setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
    gl.uniform3fv(_uColor, color.storage);
  }
}

class MaterialBaseVertexColor extends Material{

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
  final  buffersNames = ['vertexPositionBuffer', 'vertexIndiceBuffer', 'vertexColorBuffer'];
  final  attributsNames = ['aVertexPosition','aVertexColor'];
  final uniformsNames = ["uPMatrix","uMVMatrix"];

  UniformLocation get _uPMatrix => uniforms["uPMatrix"];
  UniformLocation get _uMVMatrix => uniforms["uMVMatrix"];

  Buffer get _vertexPositionBuffer => buffers['vertexPositionBuffer'];
  int get _aVertexPosition => attributes['aVertexPosition'];

  Buffer get _vertexColorBuffer => buffers['vertexColorBuffer'];
  int get _aVertexColor => attributes['aVertexColor'];

  Buffer get _vertexIndiceBuffer => buffers['vertexIndiceBuffer'];

  MaterialBaseVertexColor():super(_vsSource, _fsSource){
  }

  setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, GL.FLOAT, false, 0, 0);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), GL.STATIC_DRAW);

    //colors
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexColorBuffer);
    gl.enableVertexAttribArray(_aVertexColor);
    gl.vertexAttribPointer(_aVertexColor, mesh.colorDimensions, GL.FLOAT, false, 0, 0);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.colors), GL.STATIC_DRAW);

    //indices
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), GL.STATIC_DRAW);
  }

  setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
  }
}

class MaterialBaseTexture extends Material{

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

  final buffersNames = ['vertexPositionBuffer', 'vertexIndiceBuffer', 'vertexTextureCoordBuffer'];
  final attributsNames = ['aVertexPosition','aTextureCoord'];
  final uniformsNames = ["uPMatrix","uMVMatrix","uSampler"];

  UniformLocation get _uPMatrix => uniforms["uPMatrix"];
  UniformLocation get _uMVMatrix => uniforms["uMVMatrix"];

  Buffer get _vertexPositionBuffer => buffers['vertexPositionBuffer'];
  int get _aVertexPosition => attributes['aVertexPosition'];

  Buffer get _vertexIndiceBuffer => buffers['vertexIndiceBuffer'];

  Buffer get _vertexTextureCoordBuffer => buffers['vertexTextureCoordBuffer'];
  int get _aTextureCoord => attributes['aTextureCoord'];
  UniformLocation get _uSampler => uniforms["uSampler"];

  //External parameters
  TextureMap textureMap;

  MaterialBaseTexture():super(_vsSource, _fsSource){
  }

  setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), GL.STATIC_DRAW);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, GL.FLOAT, false, 0, 0);

    //indices
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), GL.STATIC_DRAW);

    //Texture
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexTextureCoordBuffer);
    gl.enableVertexAttribArray(_aTextureCoord);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.textureCoords), GL.STATIC_DRAW);
    gl.vertexAttribPointer(_aTextureCoord, mesh.textureCoordsDimensions, GL.FLOAT, false, 0, 0);
    gl.activeTexture(GL.TEXTURE0);
    gl.bindTexture(GL.TEXTURE_2D, textureMap.texture);
  }

  setShaderUniforms(Mesh mesh) {
    gl.uniform1i(_uSampler, 0);

    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
  }

  Future addTexture(String fileName) {
    Completer completer = new Completer();
    TextureMap.initTexture(fileName, (textureMapResult){
      textureMap = textureMapResult;
      completer.complete();
    });

    return completer.future;
  }
}

class MaterialBaseTextureNormal extends Material{

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

  final buffersNames = ['vertexPositionBuffer', 'vertexIndiceBuffer', 'vertexTextureCoordBuffer', 'vertexNormalBuffer'];
  final attributsNames = ['aVertexPosition','aTextureCoord','aVertexNormal'];
  final uniformsNames = ["uPMatrix", "uMVMatrix", "uSampler", "uNMatrix", "uAmbientColor", "uUseLighting", "uLightingDirection", "uDirectionalColor"];

  UniformLocation get _uPMatrix => uniforms["uPMatrix"];
  UniformLocation get _uMVMatrix => uniforms["uMVMatrix"];

  //Vertices Position
  Buffer get _vertexPositionBuffer => buffers['vertexPositionBuffer'];
  int get _aVertexPosition => attributes['aVertexPosition'];

  //Indices
  Buffer get _vertexIndiceBuffer => buffers['vertexIndiceBuffer'];

  //TextureCoords
  Buffer get _vertexTextureCoordBuffer => buffers['vertexTextureCoordBuffer'];
  int get _aTextureCoord => attributes['aTextureCoord'];
  UniformLocation get _uSampler => uniforms["uSampler"];

  //Normals
  UniformLocation get _uNMatrix => uniforms["uNMatrix"];
  Buffer get _vertexNormalBuffer => buffers['vertexNormalBuffer'];
  int get _aVertexNormal => attributes['aVertexNormal'];

  //Lightings
  UniformLocation get _uAmbientColor => uniforms["uAmbientColor"];
  UniformLocation get _uUseLighting => uniforms["uUseLighting"];
  UniformLocation get _uLightDirection => uniforms["uLightingDirection"];
  UniformLocation get _uDirectionalColor => uniforms["uDirectionalColor"];

  //External Parameters
  TextureMap textureMap;
  Vector3 ambientColor;
  DirectionalLight directionalLight;
  bool useLighting;

  MaterialBaseTextureNormal():super(_vsSource, _fsSource){
  }

  setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), GL.STATIC_DRAW);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, GL.FLOAT, false, 0, 0);

    //indices
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), GL.STATIC_DRAW);

    //Texture
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexTextureCoordBuffer);
    gl.enableVertexAttribArray(_aTextureCoord);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.textureCoords), GL.STATIC_DRAW);
    gl.vertexAttribPointer(_aTextureCoord, mesh.textureCoordsDimensions, GL.FLOAT, false, 0, 0);

    gl.activeTexture(GL.TEXTURE0);
    gl.bindTexture(GL.TEXTURE_2D, textureMap.texture);

    //Normals
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexNormalBuffer);
    gl.enableVertexAttribArray(_aVertexNormal);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.vertexNormals), GL.STATIC_DRAW);
    gl.vertexAttribPointer(_aVertexNormal, mesh.vertexNormalsDimensions, GL.FLOAT, false, 0, 0);
  }

  setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);

    Matrix4 mvInverse = new Matrix4.identity();
    mvInverse.copyInverse(mvMatrix);
    Matrix3 normalMatrix = mvInverse.getRotation();

    normalMatrix.transpose();
    gl.uniformMatrix3fv(_uNMatrix, false, normalMatrix.storage);

    //Light

    // draw lighting?
    gl.uniform1i(_uUseLighting, useLighting ? 1 : 0); // must be int, not bool

    if (useLighting) {
      gl.uniform3f(
          _uAmbientColor,
          ambientColor.r,
          ambientColor.g,
          ambientColor.b
      );

      Vector3 adjustedLD = new Vector3.zero();
      directionalLight.direction.normalizeInto(adjustedLD);
      adjustedLD.scale(-1.0);

      //Float32List f32LD = new Float32List(3);
      //adjustedLD.copyIntoArray(f32LD);
      //_gl.uniform3fv(_uLightDirection, f32LD);

      gl.uniform3f(_uLightDirection, adjustedLD.x, adjustedLD.y, adjustedLD.z);

      gl.uniform3f(
          _uDirectionalColor, directionalLight.color.r, directionalLight.color.g, directionalLight.color.b
      );
    }
  }

  Future addTexture(String fileName) {
    Completer completer = new Completer();
    TextureMap.initTexture(fileName, (textureMapResult){
      textureMap = textureMapResult;
      completer.complete();
    });

    return completer.future;
  }
}


///PBR's
///http://marcinignac.com/blog/pragmatic-pbr-setup-and-gamma/
class MaterialPBR extends Material{

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
  final buffersNames = ['vertexPositionBuffer', 'vertexIndiceBuffer'];
  final attributsNames = ['aVertexPosition'];
  final uniformsNames = ["uPMatrix", "uMVMatrix", "uColor"];

  UniformLocation get _uPMatrix => uniforms["uPMatrix"];
  UniformLocation get _uMVMatrix => uniforms["uMVMatrix"];
  UniformLocation get _uColor => uniforms["uColor"];

  Buffer get _vertexPositionBuffer => buffers['vertexPositionBuffer'];
  int get _aVertexPosition => attributes['aVertexPosition'];

  Buffer get _vertexIndiceBuffer => buffers['vertexIndiceBuffer'];

  //External Parameters
  final Vector3 color;

  MaterialPBR(this.color ):super(_vsSource, _fsSource){
  }

  setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(GL.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, GL.FLOAT, false, 0, 0);
    gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), GL.STATIC_DRAW);

    //indices
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), GL.STATIC_DRAW);
  }

  setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
    gl.uniform3fv(_uColor, color.storage);
  }
}
