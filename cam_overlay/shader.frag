#ifdef GL_ES
#  ifdef GL_FRAGMENT_PRECISION_HIGH
#    define maxfragp highp
#  else
#    define maxfragp mediump
#  endif
#else
#  define maxfragp
#endif

uniform sampler2D texture;

varying maxfragp vec2 fragmentUV;

void main(void)
{
    gl_FragColor = texture2D(texture, fragmentUV);
    //gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}