precision mediump float;

uniform samplerCube skybox;

varying vec3 vTextureCoord;

void main()
{
    gl_FragColor = textureCube(skybox, vTextureCoord);
}