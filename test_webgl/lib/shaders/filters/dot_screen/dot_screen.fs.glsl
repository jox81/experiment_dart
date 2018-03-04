precision mediump float;

uniform sampler2D texture;
uniform vec2 center;
uniform float angle;
uniform float scale;
uniform vec2 texSize;

varying vec2 v_TextureCoord;

float pattern() {
    float s = sin(angle), c = cos(angle);
    vec2 tex = v_TextureCoord * texSize - center;
    vec2 point = vec2(
        c * tex.x - s * tex.y,
        s * tex.x + c * tex.y
    ) * scale;
    return (sin(point.x) * sin(point.y)) * 4.0;
}

void main() {
    vec4 color = texture2D(texture, v_TextureCoord);
    float average = (color.r + color.g + color.b) / 3.0;
    gl_FragColor = vec4(vec3(average * 10.0 - 5.0 + pattern()), color.a);
}

