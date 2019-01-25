uniform mat4 projection_matrix;

attribute vec3 vertex;
attribute vec2 uv;

varying vec2 fragmentUV;

void main(void) {
    //vec4 position = gl_Vertex + vec4(gl_Normal, 1.0) * 0.125;
    //vec4 position = vec4(0, 0, 0, 1);
    // prevent skewing
    //position.w = 1.0;

    //gl_Position = gl_ModelViewProjectionMatrix * position;
    gl_Position = projection_matrix * vec4(vertex, 1.0);
    fragmentUV = uv;
}