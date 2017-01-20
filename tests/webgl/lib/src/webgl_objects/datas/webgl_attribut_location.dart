import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';

class WebGLAttributLocation{
  int _location;
  int get location => _location;

  WebGLAttributLocation(this._location);

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_ENABLED
  bool get enabled => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_ENABLED);
  set enabled(bool enabled) => _setEnabled(enabled);

  void _setEnabled(bool enabled){
    if(enabled){
      _enable();
    } else {
      _disable();
    }
  }
  void _enable() {
    gl.ctx.enableVertexAttribArray(_location);
  }

  void _disable() {
    gl.ctx.disableVertexAttribArray(_location);
  }

  // >>>
  ///Return the information requested in vertexAttribName about the vertex attribute at
  ///the passed index. The type returned is dependent on the information requested.
  dynamic getVertexAttrib(int vertexAttributeIndex, VertexAttribGlEnum vertexAttribName){
    return gl.ctx.getVertexAttrib(vertexAttributeIndex,vertexAttribName.index);
  }

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_BUFFER_BINDING
  ///Returns the currently bound WebGLBuffer.
  WebGLBuffer get bufferBound => new WebGLBuffer.fromWebGL(getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING));

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_SIZE
  ///Returns an int indicating the size of an element of the vertex array.
  int get elementSize => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_SIZE);

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_STRIDE
  ///Returns a GLint indicating the number of bytes between successive elements
  ///in the array. 0 means that the elements are sequential.
  int get stride => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_STRIDE);

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_TYPE
  ///Returns a VertexAttribArrayType representing the array type.
  VertexAttribArrayType get elementType => VertexAttribArrayType.getByIndex(getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_TYPE));

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_NORMALIZED
  ///Returns a GLboolean that is true if fixed-point data types are normalized
  ///for the vertex attribute array at the given index.
  bool get isNormalized => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_NORMALIZED);

  // > getVertexAttrib CURRENT_VERTEX_ATTRIB [4]
  ///Returns a Vector4 representing the current value of
  ///the vertex attribute at the given index.
  Vector4 get value => new Vector4.fromFloat32List(getVertexAttrib(_location, VertexAttribGlEnum.CURRENT_VERTEX_ATTRIB));

  ///specifies the data formats and locations of vertex attributes in a
  ///vertex attributes array.
  ///[stride] specifying the offset in bytes between the beginning of consecutive vertex attributes.
  ///[offset] specifying an offset in bytes of the first component in the vertex attribute array. Must be a multiple of type.
  void vertexAttribPointer(int size, ShaderVariableType type, bool normalized, int stride, int offset) {
    assert(1 <= size && size <= 4);
    gl.ctx.vertexAttribPointer(_location, size, type.index, normalized, stride, offset);
  }

  // Todo : On ne peut avoir que ces types là ?

  //float
  void vertexAttrib1f(num x) {
    gl.ctx.vertexAttrib1f(_location, x);
  }
  
  void vertexAttrib2f(num x, num y) {
    gl.ctx.vertexAttrib2f(_location, x, y);
  }
  
  void vertexAttrib3f(num x, num y, num z) {
    gl.ctx.vertexAttrib3f(_location, x, y, z);
  }

  void vertexAttrib4f(num x, num y, num z, num w) {
    gl.ctx.vertexAttrib4f(_location, x, y, z, w);
  }
  
  //List float
  void vertexAttrib1fv(Float32List data) {
    gl.ctx.vertexAttrib1fv(_location, data);
  }
  
  void vertexAttrib2fv(Vector2 data) {
    gl.ctx.vertexAttrib2fv(_location, data.storage);
  }
  
  void vertexAttrib3fv(Vector3 data) {
    gl.ctx.vertexAttrib3fv(_location, data.storage);
  }

  void vertexAttrib4fv(Vector4 data) {
    gl.ctx.vertexAttrib4fv(_location, data.storage);
  }

  void logVertexAttributInfos() {
    Utils.log("Vertex Attribut Infos", (){
        print('value : ${value}');
        print('enabled : ${enabled}');
        print('elementSize : ${elementSize}');
        print('stride : ${stride}');
        print('elementType : ${elementType}');
        print('isNormalized : ${isNormalized}');
        print('Buffer bound : ${bufferBound}');
    });
  }
}