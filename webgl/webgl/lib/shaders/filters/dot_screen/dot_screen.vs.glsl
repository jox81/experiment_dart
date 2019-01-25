//position must fit the screen
attribute vec2 position;

varying vec2 v_TextureCoord;

void main() {
    gl_Position = vec4(position, 0, 1);
    v_TextureCoord = gl_Position.xy * 0.5 + 0.5;
}