
/// Un [ShaderInfos] est utilisé pour charger des fichiers glsl en indiquant leur chemin
class ShaderInfos {
  String name;
  Uri vertexShaderUri;
  Uri fragmentShaderUri;

  ShaderInfos(this.name, this.vertexShaderUri, this.fragmentShaderUri);
}