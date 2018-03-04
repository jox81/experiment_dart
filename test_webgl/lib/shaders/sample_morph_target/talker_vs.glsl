attribute vec3 neutral_morph_position;
attribute vec3 angry_morph_position;
attribute vec3 happy_morph_position;
attribute vec3 normal;

uniform mat4 modelMatrix, viewMatrix, projectionMatrix;

// weights for morph targets -- neutral is auto-derived
uniform float angry_morph_weight;
uniform float happy_morph_weight;

varying vec3 normal_eye;
varying vec3 position_eye;

// light position
varying vec3 lightPosition_eye;

void main () {
    // work out neutral weight
    float neutral_morph_weight = 1.0 - angry_morph_weight + happy_morph_weight;
    neutral_morph_weight = clamp (neutral_morph_weight, 0.0, 1.0);
    
    // sum of weights and weighted average
    float sum_weights = neutral_morph_weight + angry_morph_weight + happy_morph_weight;
    float neutral_factor = neutral_morph_weight / sum_weights;
    float happy_factor = happy_morph_weight / sum_weights;
    float angry_factor = angry_morph_weight / sum_weights;
    vec3 position = neutral_factor * neutral_morph_position + angry_factor * angry_morph_position + happy_factor * happy_morph_position;
    
    gl_Position = projectionMatrix * vec4 (position_eye, 1.0);

    position_eye = (viewMatrix * modelMatrix * vec4 (position, 1.0)).xyz;
    lightPosition_eye = (viewMatrix * vec4 (1.0, 1.0, 10.0, 1.0)).xyz;
    normal_eye = (viewMatrix * modelMatrix * vec4 (normal, 0.0)).xyz;
}

