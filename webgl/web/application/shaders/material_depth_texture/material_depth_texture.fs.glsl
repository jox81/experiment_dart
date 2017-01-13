precision mediump float;

uniform sampler2D uSampler;

varying vec2 vTextureCoord;

float near = 2.0;
float far = 1000.0;

//applique une adaptation linéaire sur zoverw
//car les valeurs de depth ne sont pas linéaires
float linearizeDepth(float zoverw)
{
	return  (2.0 * near) / (far + near - zoverw * (far - near));
}

void main(void) {
    // on récupère le z en prenant la valeur r du pixel.
	float zoverw = texture2D(uSampler, vTextureCoord.st).r;

    float grey = linearizeDepth(zoverw);
	gl_FragColor = vec4(grey, grey, grey, 1.0);
}

/*
if you're drawing the depth texture from the FBO and things are either white or black,
your depth texture is working, but your values are too high. OpenGL camera set up so that the Z values get big quickly,
whereas when you're drawing those values directly as colors 0 is black and 1 is white,
so you're getting what you're expecting, which an image rendered with a 0.0 - 1.0 range.
*/