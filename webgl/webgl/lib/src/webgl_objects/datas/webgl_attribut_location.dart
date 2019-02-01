import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'dart:web_gl' as WebGL;

class WebGLAttributLocation{
  int _location;
  int get location => _location;

  WebGLAttributLocation(this._location);

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_ENABLED
  bool get enabled => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_ENABLED) as bool;
  set enabled(bool enabled) => _setEnabled(enabled);

  void _setEnabled(bool enabled){
    if(enabled){
      _enable();
    } else {
      _disable();
    }
  }
  void _enable() {
    gl.enableVertexAttribArray(_location);
  }

  void _disable() {
    gl.disableVertexAttribArray(_location);
  }

  // >>>
  ///Return the information requested in vertexAttribName about the vertex attribute at
  ///the passed index. The type returned is dependent on the information requested.
  /// int vertexAttributeIndex
  /// VertexAttribGlEnum vertexAttribName
  Object getVertexAttrib(int vertexAttributeIndex, int vertexAttribName){
    return gl.getVertexAttrib(vertexAttributeIndex,vertexAttribName);
  }

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_BUFFER_BINDING
  ///Returns the currently bound WebGLBuffer.
  WebGLBuffer get bufferBound {
    WebGL.Buffer webGLBuffer = getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING) as WebGL.Buffer;
    return new WebGLBuffer.fromWebGL(webGLBuffer);
  }

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_SIZE
  ///Returns an int indicating the size of an element of the vertex array.
  int get elementSize => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_SIZE) as int;

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_STRIDE
  ///Returns a GLint indicating the number of bytes between successive elements
  ///in the array. 0 means that the elements are sequential.
  int get stride => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_STRIDE) as int;

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_TYPE
  ///Returns a VertexAttribArrayType representing the array type.
  int get elementType => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_TYPE) as int;

  // > getVertexAttrib VERTEX_ATTRIB_ARRAY_NORMALIZED
  ///Returns a GLboolean that is true if fixed-point data types are normalized
  ///for the vertex attribute array at the given index.
  bool get isNormalized => getVertexAttrib(_location, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_NORMALIZED) as bool;

  // > getVertexAttrib CURRENT_VERTEX_ATTRIB [4]
  ///Returns a Vector4 representing the current value of
  ///the vertex attribute at the given index.
  Vector4 get value => new Vector4.fromFloat32List(getVertexAttrib(_location, VertexAttribGlEnum.CURRENT_VERTEX_ATTRIB) as Float32List);

  ///specifies the data formats and locations of vertex attributes in a
  ///vertex attributes array.
  ///[stride] specifying the offset in bytes between the beginning of consecutive vertex attributes.
  ///[offset] specifying an offset in bytes of the first component in the vertex attribute array. Must be a multiple of type.
  /// ShaderVariableType type
  void vertexAttribPointer(int size, int type, bool normalized, int stride, int offset) {
    assert(1 <= size && size <= 4);
    gl.vertexAttribPointer(_location, size, type, normalized, stride, offset);
  }

  // Todo : On ne peut avoir que ces types là ?

  //float
  void vertexAttrib1f(num x) {
    gl.vertexAttrib1f(_location, x);
  }
  
  void vertexAttrib2f(num x, num y) {
    gl.vertexAttrib2f(_location, x, y);
  }
  
  void vertexAttrib3f(num x, num y, num z) {
    gl.vertexAttrib3f(_location, x, y, z);
  }

  void vertexAttrib4f(num x, num y, num z, num w) {
    gl.vertexAttrib4f(_location, x, y, z, w);
  }
  
  //List float
  void vertexAttrib1fv(Float32List data) {
    gl.vertexAttrib1fv(_location, data);
  }
  
  void vertexAttrib2fv(Vector2 data) {
    gl.vertexAttrib2fv(_location, data.storage);
  }
  
  void vertexAttrib3fv(Vector3 data) {
    gl.vertexAttrib3fv(_location, data.storage);
  }

  void vertexAttrib4fv(Vector4 data) {
    gl.vertexAttrib4fv(_location, data.storage);
  }

  void logVertexAttributInfos() {
    Debug.log("Vertex Attribut Infos", (){
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