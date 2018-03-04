precision mediump float;

///> from web/shaders/functions/envMap-cube.glsl
/// should be inserted dynamically
//using :
//#pragma tessd: require("/shaders/functions/envMap-cube.glsl")
/**
 * Samples cubemap environment map
 * @param  {vec3} wcNormal - normal in the world coordinate space
 * @param  {float} - flipEnvMap    -1.0 for left handed coorinate system oriented texture (usual case)
 *                                  1.0 for right handed coorinate system oriented texture
 * @return {vec4} - cubemap texture coordinate
 */
//(jpu) j'ai du ajouter un flip sur le y, le résutat est meiux mais pas encore correcte
vec3 envMapCube(vec3 wcNormal, float flipEnvMap) {
    return vec3(flipEnvMap * wcNormal.x, wcNormal.y, wcNormal.z);
}

vec3 envMapCube(vec3 wcNormal) {
    //-1.0 for left handed coorinate system oriented texture (usual case)
    return envMapCube(wcNormal, -1.0);
}
///>

uniform mat4 u_InverseViewMatrix;
uniform samplerCube u_EnvMap;

varying vec3 v_ecPosition;
varying vec3 v_ecNormal;

//http://marcinignac.com/blog/pragmatic-pbr-hdr/
//
//It's important to remember in which coordinate space we calculate our reflection.
//
//Normals are usually in the view (eye) space and it's easy to calculate view ray (eyeDir) in view space as the
//camera position is [0,0,0] so we just negate the vertex position.
//
//But the cubemap textures are addressed by a vector in the world space so we need to move our computation there.
void main() {
    //direction from they eye (camera) in the view (eye) space is = v_ecPosition
    //direction from the camera in the world space
    vec3 wcEyeDir = vec3(u_InverseViewMatrix * vec4(v_ecPosition, 0.0));
    //surface normal in the world space
    vec3 wcNormal = vec3(u_InverseViewMatrix * vec4(v_ecNormal, 0.0));

    //reflection vector in the world space.
    vec3 wcReflection = reflect(normalize(wcEyeDir), normalize(wcNormal));

    gl_FragColor = textureCube(u_EnvMap, envMapCube(wcReflection));
}