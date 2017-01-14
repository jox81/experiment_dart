attribute vec3 aVertexPosition;
attribute vec4 aVertexColor;

uniform float pointSize;
uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

varying vec4 vPointColor;

void main(void) {
  gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aVertexPosition, 1.0);
  gl_PointSize = pointSize;
  vPointColor = aVertexColor;
}