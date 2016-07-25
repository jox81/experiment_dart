import 'dart:web_gl';
import 'package:gl_enums/gl_enums.dart' as GL;

class ActiveInfoCustom{
  String typeName;
  ActiveInfo activeInfo;
  ActiveInfoCustom(this.activeInfo) {}
}

class ProgramInfo{
  List<ActiveInfoCustom> attributes = new List();
  List<ActiveInfoCustom> uniforms = new List();
  int attributeCount = 0;
  int uniformCount = 0;
}

class UtilsShader {
  static ProgramInfo getProgramInfo(RenderingContext gl, program) {
    var activeUniforms = gl.getProgramParameter(program, GL.ACTIVE_UNIFORMS);
    var activeAttributes = gl.getProgramParameter(
        program, GL.ACTIVE_ATTRIBUTES);

    // Taken from the WebGl spec:
    // http://www.khronos.org/registry/webgl/specs/latest/1.0/#5.14
    var enums = {
      0x8B50: 'FLOAT_VEC2',
      0x8B51: 'FLOAT_VEC3',
      0x8B52: 'FLOAT_VEC4',
      0x8B53: 'INT_VEC2',
      0x8B54: 'INT_VEC3',
      0x8B55: 'INT_VEC4',
      0x8B56: 'BOOL',
      0x8B57: 'BOOL_VEC2',
      0x8B58: 'BOOL_VEC3',
      0x8B59: 'BOOL_VEC4',
      0x8B5A: 'FLOAT_MAT2',
      0x8B5B: 'FLOAT_MAT3',
      0x8B5C: 'FLOAT_MAT4',
      0x8B5E: 'SAMPLER_2D',
      0x8B60: 'SAMPLER_CUBE',
      0x1400: 'BYTE',
      0x1401: 'UNSIGNED_BYTE',
      0x1402: 'SHORT',
      0x1403: 'UNSIGNED_SHORT',
      0x1404: 'INT',
      0x1405: 'UNSIGNED_INT',
      0x1406: 'FLOAT'
    };

    ProgramInfo result = new ProgramInfo();

    // Loop through active uniforms
    for (var i = 0; i < activeUniforms; i++) {
      ActiveInfoCustom uniform = new ActiveInfoCustom(gl.getActiveUniform(program, i));
      uniform.typeName = enums[uniform.activeInfo.type];
      result.uniforms.add(uniform);
      result.uniformCount += uniform.activeInfo.size;
    }

    // Loop through active attributes
    for (var i = 0; i < activeAttributes; i++) {
      ActiveInfoCustom attribute = new ActiveInfoCustom(gl.getActiveAttrib(program, i));
      attribute.typeName = enums[attribute.activeInfo.type];
      result.attributes.add(attribute);
      result.attributeCount += attribute.activeInfo.size;
    }

    return result;
  }
}