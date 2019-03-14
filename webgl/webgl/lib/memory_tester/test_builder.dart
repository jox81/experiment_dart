import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/memory_tester/memory_tester.dart';

MemoryTester buildMemoryTester(ItemType itemType) {
  MemoryTester result;
  switch(itemType){
    case ItemType.webgl_shader:
      result = _webGLShaderMemoryTester();
  }
  return result;
}

enum ItemType{
  webgl_shader
}

MemoryTester _webGLShaderMemoryTester(){
  MemoryTester tester;
  tester = new MemoryTester<WebGL.Shader>()
    ..constructNewItem = (() => gl.createShader(
        ShaderType.VERTEX_SHADER))
    ..disposeItem = ((int i){
      gl.deleteShader(tester.items[i]);
    });
  return tester;
}