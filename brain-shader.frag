extern vec2 resolusion;
extern float layerz;

extern Image above;
extern Image bellow;

float rand(vec3 co)
{
  return fract(sin(dot(co.xy + co.z, vec2(12.9898, 78.233))) * 43758.5453);
}

bool isAlive(Image layer, vec2 pos)
{
  return texture2D(layer, pos / resolusion).a > 0;
}

bool hasLivingNeighbor(Image layer, vec2 pos)
{
  if (isAlive(layer, pos + vec2(1, 0))) {
    return true;
  } else if (isAlive(layer, pos - vec2(1, 0))) {
    return true;
  } else if (isAlive(layer, pos + vec2(0, 1))) {
    return true;
  } else if (isAlive(layer, pos - vec2(0, 1))) {
    return true;
  }
  if (isAlive(above, pos)) {
    return true;
  }
  if (layerz > 1 && isAlive(bellow, pos)) {
    return true;
  }
  return false;
}

bool shouldGrow(Image layer, vec2 pos)
{
  return hasLivingNeighbor(layer, pos); // && rand(vec3(pos, layerz)) > 0.6;
}

vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
  vec2 pos = tc * resolusion;

  if (shouldGrow(texture, pos)) {
    return vec4(1, 1, 1, 1);
  }

  return texture2D(texture, tc);
}
