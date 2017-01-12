precision mediump float;

uniform sampler2D uSampler;

varying vec2 vTextureCoord;

float near = 1.0;
float far = 1000.0;

void main(void) {
    // on récupère le z en prenant la valeur r du pixel.
	float z = texture2D(uSampler, vTextureCoord.st).r;
	float grey = (2.0 * near) / (far + near - z * (far - near));
	vec4 color = vec4(grey, grey, grey, 1.0);
	gl_FragColor = color;
}