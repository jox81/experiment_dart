
/*

//Todo
class MaterialNormalMapping extends Material {

  //External parameters
  WebGLTexture skyboxTexture;

  MaterialNormalMapping._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialNormalMapping() {
    ShaderSource shaderSource = ShaderSource.sources['material_reflection'];
    return new MaterialNormalMapping._internal(
        shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Mesh model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.primitive.vertices, model.primitive.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.primitive.indices);
    setShaderAttributArrayBuffer('aNormal', model.primitive.vertexNormals,
        model.primitive.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh model) {

//    print("###############");

//    print("uModelMatrix: \n${Context.modelMatrix}");
//    print("uViewMatrix: \n${Context.mainCamera.lookAtMatrix}");
//    setShaderUniform("uModelMatrix", Context.modelMatrix);
//    setShaderUniform("uViewMatrix", Context.mainCamera.lookAtMatrix);
//use in common with vertex shader ?

//    print("uModelViewMatrix: \n${Context.mainCamera.lookAtMatrix * Context.modelMatrix}");
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);


    setShaderUniform("uProjectionMatrix", Context.mainCamera.projectionMatrix);

    setShaderUniform("uInverseViewMatrix",
        new Matrix4.inverted(Context.mainCamera.viewMatrix));

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix = (Context.mainCamera.viewMatrix * Context.modelMatrix).getNormalMatrix() as Matrix3;
    setShaderUniform("uNormalMatrix", normalMatrix);

    gl.activeTexture(TextureUnit.TEXTURE0);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, skyboxTexture.webGLTexture);
    setShaderUniform('uEnvMap', 0);
  }
}
 */
