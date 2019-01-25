precision mediump float;

struct DirectionalLight
{
	vec3 direction;
	vec3 color;
};

uniform vec3 u_ambientLightIntensity;
uniform DirectionalLight sun;
uniform u_Sampler2D u_Sampler;

varying vec2 v_fragTexCoord;
varying vec3 v_fragNormal;



void main()
{
	vec3 surfaceNormal = normalize(v_fragNormal);
	vec3 normSunDir = normalize(sun.direction);
	vec4 texel = texture2D(u_Sampler, v_fragTexCoord);

	vec3 lightIntensity = u_ambientLightIntensity +
		sun.color * max(dot(v_fragNormal, normSunDir), 0.0);

	gl_FragColor = vec4(texel.rgb * lightIntensity, texel.a);
}