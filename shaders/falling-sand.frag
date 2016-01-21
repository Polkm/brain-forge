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

int neighbors(Image layer, vec2 pos)
{
  int count = 0;

  if (isAlive(layer, pos + vec2(1, 0))) {
    count += 1;
  }
  if (isAlive(layer, pos + vec2(0, 1))) {
    count += 1;
  }
  if (isAlive(layer, pos + vec2(-1, 0))) {
    count += 1;
  }
  if (isAlive(layer, pos + vec2(0, -1))) {
    count += 1;
  }

  if (isAlive(layer, pos + vec2(1, 1))) {
    count += 1;
  }
  if (isAlive(layer, pos + vec2(-1, 1))) {
    count += 1;
  }
  if (isAlive(layer, pos + vec2(-1, -1))) {
    count += 1;
  }
  if (isAlive(layer, pos + vec2(1, -1))) {
    count += 1;
  }

  return count;
}

int neighbors3d(Image layer, vec2 pos)
{
  int count = 0;
  count += neighbors(layer, pos);
  count += neighbors(above, pos);
  count += neighbors(bellow, pos);

  if (isAlive(above, pos)) {
    count += 1;
  }
  if (layerz > 1 && isAlive(bellow, pos)) {
    count += 1;
  }

  return count;
}

int eL = 5;
int eU = 7;

int fL = 6;
int fU = 6;

vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
  vec2 pos = tc * resolusion;

  // int nbors = neighbors3d(texture, pos);

  if (!isAlive(texture, pos)) {
    if (isAlive(above, pos)) {
      return vec4(1, 1, 1, 1);
    }
  }
  if (isAlive(texture, pos)) {
    if (!isAlive(bellow, pos) && layerz > 1) {
      return vec4(0, 0, 0, 0);
    }
  }

  return texture2D(texture, tc);
}
