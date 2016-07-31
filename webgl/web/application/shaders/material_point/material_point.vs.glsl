attribute vec3 aVertexPosition;
attribute vec4 aVertexColor;

uniform float pointSize;
uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;

varying vec4 vPointColor;

void main(void) {
  gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
  gl_PointSize = pointSize;
  vPointColor = aVertexColor;
}