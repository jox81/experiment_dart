#version 120

// total number of samples at each fragment,
#extension GL_OES_standard_derivatives : enable

#define NUM_SAMPLES           256
#define NUM_SPIRAL_TURNS      10
#define VARIATION             0

varying vec2 v_UV;

uniform sampler2D tDepth;
// uniform sampler2D tDiffuse;

uniform float intensity;
uniform float sampleRadiusWS;
uniform float bias;
uniform float zNear;
uniform float zFar;
uniform vec4 projInfo;
uniform vec2 viewportResolution;
uniform float projScale;  // how many pixels a 1m size 1m away from the camera is.  Or 500 is a good value.

// RGBA depth
float unpackDepth( const in vec4 rgba_depth ) {
  const vec4 bit_shift = vec4( 1.0 / ( 256.0 * 256.0 * 256.0 ), 1.0 / ( 256.0 * 256.0 ), 1.0 / 256.0, 1.0 );
  float depth = dot( rgba_depth, bit_shift );
  return depth;

}
/*
 Clipping plane constants for use by reconstructZ
 clipInfo = (z_f == -inf()) ? Vector3(z_n, -1.0f, 1.0f) : Vector3(z_n * z_f,  z_n - z_f,  z_f);
*/
float reconstructCSZ(float depth) {
//      return clipInfo[0] / (clipInfo[1] * d + zFar[2]);
    return ( zNear * zFar ) / ( (zNear - zFar) * depth + zFar );
}

/**  vec4(-2.0f / (width*P[0][0]),
          -2.0f / (height*P[1][1]),
          ( 1.0f - P[0][2]) / P[0][0],
          ( 1.0f + P[1][2]) / P[1][1])

    where P is the projection matrix that maps camera space points
    to [-1, 1] x [-1, 1].  That is, GCamera::getProjectUnit(). */

/** Reconstruct camera-space P.xyz from screen-space S = (x, y) in
    pixels and camera-space z < 0.  Assumes that the upper-left pixel center
    is at (0.5, 0.5) [but that need not be the location at which the sample tap
    was placed!]

    Costs 3 MADD.  Error is on the order of 10^3 at the far plane, partly due to z precision.
*/
vec3 reconstructCSPosition(vec2 S, float z) {
    return vec3((S.xy * projInfo.xy + projInfo.zw) * z, z);
}

/** Reconstructs screen-space unit normal from screen-space position */
vec3 reconstructCSFaceNormal(vec3 C) {
    return -normalize(cross(dFdy(C), dFdx(C)));
}

vec3 reconstructNonUnitCSFaceNormal(vec3 C) {
    return -cross(dFdy(C), dFdx(C));
}

//// reconstructs view-space unit normal from view-space position,
// vec3 reconstructNormalVS(vec3 positionVS) {,
//   return normalize(cross(dFdx(positionVS), dFdy(positionVS)));,
//  },

// returns a unit vector and a screen-space radius for the tap on a unit disk
// (the caller should scale by the actual disk radius)
vec2 tapLocation(int sampleNumber, float spinAngle, out float radiusSS) {
  // radius relative to radiusSS
  float alpha = (float(sampleNumber) + 0.5) * (1.0 / float(NUM_SAMPLES));
  float angle = alpha * (float(NUM_SPIRAL_TURNS) * 6.28) + spinAngle;

  radiusSS = alpha;
  return vec2(cos(angle), sin(angle));
}

vec3 getOffsetPositionVS(vec2 uv, vec2 unitOffset, float radiusSS) {
  uv = uv + radiusSS * unitOffset * (1.0 / viewportResolution.x);
  float zDepth = unpackDepth( texture2D( tDepth, uv ) );
  float depthCS = reconstructCSZ( zDepth );
  return  reconstructCSPosition( uv, depthCS );
}

float sampleAO(vec2 uv, vec3 positionVS, vec3 normalVS, float sampleRadiusSS, int tapIndex, float rotationAngle){
  const float epsilon = 0.01;
  float radius2 = sampleRadiusWS * sampleRadiusWS;

  // offset on the unit disk, spun for this pixel,
  float radiusSS;
  vec2 unitOffset = tapLocation(tapIndex, rotationAngle, radiusSS);
  radiusSS *= sampleRadiusSS;

  vec3 Q = getOffsetPositionVS(uv, unitOffset, radiusSS);
  vec3 v = Q - positionVS;

  float vv = dot(v, v);
  float vn = dot(v, normalVS) - bias;

#if VARIATION == 0

   // (from the HPG12 paper)
   // Note large epsilon to avoid overdarkening within cracks
  return float(vv < radius2) * max(vn / (epsilon + vv), 0.0);

#elif VARIATION == 1 // default / recommended

   // Smoother transition to zero (lowers contrast, smoothing out corners). [Recommended]
  float f = max(radius2 - vv, 0.0) / radius2;
  return f * f * f * max(vn / (epsilon + vv), 0.0);

#elif VARIATION == 2

   // Medium contrast (which looks better at high radii), no division.  Note that the
   // contribution still falls off with radius^2, but we've adjusted the rate in a way that is
   // more computationally efficient and happens to be aesthetically pleasing.
  float invRadius2 = 1.0 / radius2;
  return 4.0 * max(1.0 - vv * invRadius2, 0.0) * max(vn, 0.0);

#else

   // Low contrast, no division operation
  return 2.0 * float(vv < radius2) * max(vn, 0.0);

#endif
}

void main() {

  float zDepth = unpackDepth( texture2D( tDepth, v_UV ) );

  float depthCS = reconstructCSZ( zDepth );
  vec3 originVS = reconstructCSPosition( v_UV, depthCS );

  vec3 normalVS = normalize( reconstructNonUnitCSFaceNormal(originVS) );

  float randomPatternRotationAngle = fract( fract( v_UV.x * viewportResolution.x * 894.0 ) * 3.0 + fract( v_UV.y * viewportResolution.y * 999.0 ) * 5.0 + fract( zDepth * 131.0 ) + fract( originVS.x * 3234.0 ) + fract( originVS.y * 99.0 ) );
//      float randomPatternRotationAngle = 2.0 * PI * sampleNoise.x;


// radius of influence in screen space
  float radiusWS = sampleRadiusWS;
  // radius of influence in world space
  float radiusSS = projScale * radiusWS / originVS.y;

  float occlusion = 0.0;
  for (int i = 0; i < NUM_SAMPLES; ++i) {
    occlusion += sampleAO(v_UV, originVS, normalVS, radiusSS, i,
                          randomPatternRotationAngle);
  }

  occlusion = 1.0 - occlusion / float( NUM_SAMPLES );
  occlusion = clamp(pow(occlusion, 1.0 + intensity), 0.0, 1.0);
//    vec4 color = texture2D( tDiffuse, v_UV );
  gl_FragColor = vec4( occlusion, occlusion, occlusion, 1.0 );
//    gl_FragColor = vec4(radiusSS, radiusSS, radiusSS, 1.0);
}