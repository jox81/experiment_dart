precision mediump float;

varying vec3 wcNormal;

uniform samplerCube uEnvMap;

void main() {
    gl_FragColor = textureCube(uEnvMap, envMapCube(normalize(wcNormal)));
}