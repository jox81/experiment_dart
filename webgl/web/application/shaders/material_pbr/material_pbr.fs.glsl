precision mediump float;

//vertex position, normal and light position in the eye/view space
varying vec3 ecPosition;
varying vec3 ecNormal;
varying vec3 ecLightPos;

float lambert(vec3 lightDirection, vec3 surfaceNormal) {
  return max(0.0, dot(lightDirection, surfaceNormal));
}

const float gamma = 2.2;

//gamma in
vec3 toLinear(vec3 v) {
  return pow(v, vec3(gamma));
}
vec4 toLinear(vec4 v) {
  return vec4(toLinear(v.rgb), v.a);
}

// gamma out
vec3 toGamma(vec3 v) {
  return pow(v, vec3(1.0 / gamma));
}
vec4 toGamma(vec4 v) {
  return vec4(toGamma(v.rgb), v.a);
}

void main() {
  //normalize the normal, we do it here instead of vertex
  //shader for smoother gradients
  vec3 N = normalize(ecNormal);

  //calculate direction towards the light
  vec3 L = normalize(ecLightPos - ecPosition);

  //diffuse intensity
  float Id = lambert(L, N);

  //surface and light color, full white
  vec4 baseColor = toLinear(vec4(1.0));
  vec4 lightColor = toLinear(vec4(1.0));

  vec4 finalColor = vec4(baseColor.rgb * lightColor.rgb * Id, 1.0);
  gl_FragColor = toGamma(finalColor);
}