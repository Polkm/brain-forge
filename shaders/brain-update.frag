extern vec2 resolusion;
extern float layerz;
extern float frame;

extern Image above;
extern Image bellow;

highp float rand(vec2 co)
{
  highp float a = 12.9898;
  highp float b = 78.233;
  highp float c = 43758.5453;
  highp float dt= dot(co.xy ,vec2(a,b));
  highp float sn= mod(dt,3.14);
  return fract(sin(sn) * c);
}

bool isAlive(Image layer, vec2 pos)
{
  return texture2D(layer, pos / resolusion).a > 0;
}

bool isCancer(Image layer, vec2 pos)
{
  return texture2D(layer, pos / resolusion).rgba == vec4(0, 0, 0, 1);
}

int neighbors(Image layer, vec2 pos)
{
  int count = 0;

  if (isCancer(layer, pos + vec2(1, 0))) {
    count += 1;
  }
  if (isCancer(layer, pos + vec2(0, 1))) {
    count += 1;
  }
  if (isCancer(layer, pos + vec2(-1, 0))) {
    count += 1;
  }
  if (isCancer(layer, pos + vec2(0, -1))) {
    count += 1;
  }

  if (isCancer(layer, pos + vec2(1, 1))) {
    count += 1;
  }
  if (isCancer(layer, pos + vec2(-1, 1))) {
    count += 1;
  }
  if (isCancer(layer, pos + vec2(-1, -1))) {
    count += 1;
  }
  if (isCancer(layer, pos + vec2(1, -1))) {
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

  if (isCancer(above, pos)) {
    count += 1;
  }
  if (layerz > 1 && isCancer(bellow, pos)) {
    count += 1;
  }

  return count;
}

vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
  vec2 pos = tc * resolusion;

  if (!isCancer(texture, pos)) {
    int nbors = neighbors3d(texture, pos);
    float prob = nbors / 26.0;
    if (rand(tc + layerz * resolusion.x + frame * 0.007) < prob) {
      return vec4(0, 0, 0, 1);
    }
  }

  return texture2D(texture, tc);
}
