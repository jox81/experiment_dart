precision mediump float;

///> from web/application/shaders/functions/envMap-cube.glsl
/// should be inserted dynamically
//using :
//#pragma tessd: require("/application/shaders/functions/envMap-cube.glsl")
/**
 * Samples cubemap environment map
 * @param  {vec3} wcNormal - normal in the world coordinate space
 * @param  {float} - flipEnvMap    -1.0 for left handed coorinate system oriented texture (usual case)
 *                                  1.0 for right handed coorinate system oriented texture
 * @return {vec4} - cubemap texture coordinate
 */
vec3 envMapCube(vec3 wcNormal, float flipEnvMap) {
    return vec3(flipEnvMap * wcNormal.x, wcNormal.y, wcNormal.z);
}

vec3 envMapCube(vec3 wcNormal) {
    //-1.0 for left handed coorinate system oriented texture (usual case)
    return envMapCube(wcNormal, -1.0);
}
///>

uniform mat4 uInverseViewMatrix;
uniform samplerCube uEnvMap;

varying vec3 ecPosition;
varying vec3 ecNormal;

//http://marcinignac.com/blog/pragmatic-pbr-hdr/
//It's important to remember in which coordinate space we calculate our reflection. Normals are usually in
//the view (eye) space and it's easy to calculate view ray (eyeDir) in view space as the camera position is [0,0,0] so
//we just negate the vertex position. But the cubemap textures are addressed by a vector in the world space so we need
//to move our computation there.
void main() {
    //direction towards they eye (camera) in the view (eye) space
    vec3 ecEyeDir = normalize(-ecPosition);
    //direction towards the camera in the world space
    vec3 wcEyeDir = vec3(uInverseViewMatrix * vec4(ecEyeDir, 0.0));
    //surface normal in the world space
    vec3 wcNormal = vec3(uInverseViewMatrix * vec4(ecNormal, 0.0));

    //reflection vector in the world space. We negate wcEyeDir as the reflect function expect incident vector pointing towards the surface
    vec3 reflectionWorld = reflect(-wcEyeDir, normalize(wcNormal));

    gl_FragColor = textureCube(uEnvMap, envMapCube(reflectionWorld));
}