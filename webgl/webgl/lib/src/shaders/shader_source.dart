/// Un [ShaderSource] contient les codes texte des VertexShader et FragmentShader
class ShaderSource {
  String name;
  String vsCode;
  String fsCode;

  ShaderSource(this.name, this.vsCode, this.fsCode);
}