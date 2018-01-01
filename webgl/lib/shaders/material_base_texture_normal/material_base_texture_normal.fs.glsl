precision mediump float;

varying vec2 v_TextureCoord;
varying vec3 v_LightWeighting;

uniform sampler2D u_Sampler;

void main(void) {
  vec4 textureColor = texture2D(u_Sampler, vec2(v_TextureCoord.s, v_TextureCoord.t));
  gl_FragColor = vec4(textureColor.rgb * v_LightWeighting, textureColor.a);
}