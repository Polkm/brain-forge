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
  vec2 pos = tc * resolusion;

  float roll = rand(seed + tc + layerz * 0.03543);

  if (roll > 0.9999) {
    return vec4(0, 0, 0, 0);
  } else if (roll > 0.2) {
    return vec4(0.2, 0.5, 0.8, 1.0 / 255.0);
  } else {
    return vec4(0.95, 0.2, 0.2, 2.0 / 255.0);
  }
  return texture2D(texture, tc);
}
