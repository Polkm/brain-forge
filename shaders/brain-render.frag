extern vec2 resolusion;
extern float layerz;
extern float seed;

// extern vec4 neuron

highp float rand(vec2 co)
{
  highp float a = 12.9898;
  highp float b = 78.233;
  highp float c = 43758.5453;
  highp float dt= dot(co.xy ,vec2(a,b));
  highp float sn= mod(dt,3.14);
  return fract(sin(sn) * c);
}

vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
  vec4 info = texture2D(texture, tc);

  info.a = floor(info.a * 256);

  // return vec4(info.a, 0, 0, 1);

  vec4 cellColor = vec4(0, 0, 0, 0);

  if (info.a == 0) {
    cellColor = vec4(0, 0, 0, 1);
  } else if (info.a == 1) {
    cellColor = vec4(0.2, 0.5, 0.8, 0.8);
  } else if (info.a == 2) {
    cellColor = vec4(0.95, 0.2, 0.2, 1);
  } else {
    cellColor = vec4(1, 1, 0, 1);
  }

  return cellColor * color;
}
