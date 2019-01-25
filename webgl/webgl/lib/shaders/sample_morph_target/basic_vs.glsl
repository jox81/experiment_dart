//Sample from webgl exemple for morph target
//http://antongerdelan.net/blog/demos/morphtargets/

attribute vec3 lc_vp;
attribute vec3 mtarget_loc;
attribute vec2 vt;
attribute vec3 lc_vn;


uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

uniform float morphtimefactor;

varying vec2 texCoords;
varying vec3 ec_3d_norm;
varying vec3 ec_3d_pos;
varying vec3 ec_3d_lightPos;

void main (void) {

	// morph anim
	float t = clamp (morphtimefactor, 0.0, 1.0);
	vec3 localPos = mix (lc_vp, mtarget_loc, t);

	vec4 wp_4d_lightPos = vec4 (2, 1, 3, 1);
	vec4 ec_4d_lightPos = viewMatrix * wp_4d_lightPos;
	ec_3d_lightPos = ec_4d_lightPos.xyz;

	texCoords = vt;
	ec_3d_norm = normalize (viewMatrix * vec4 (lc_vn, 0)).xyz; // should be using normalMat (inverse-transpose of 3x3 modelMatrix)
	vec4 ec_4d_pos = viewMatrix * vec4 (localPos, 1);
	ec_3d_pos = ec_4d_pos.xyz;
	
	gl_Position = projectionMatrix * ec_4d_pos;
}
