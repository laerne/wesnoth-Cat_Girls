#version 330

uniform vec2 uResolution;
uniform float uTime;

const int tileLength = 72;
const vec2 imageResolution = vec2(float(tileLength), float(tileLength));
out vec4 outColor;

const float sqrt2 = 1.41421356237309504880168872420969807856967187537694807317667973799073247846;
const float sqrt3 = 1.73205080756887729352744634150587236694280525381038062805580697945193301690;
const float sqrt5 = 2.23606797749978969640917366873127623544061835961152572427089724541052092563;
const float pi    = 3.14159265358979323846264338327950288419716939937510582097494459230781640628;
const float tau   = 6.28318530717958647692528676655900576839433879875021164194988918461563281257;

struct Rect
{
	vec2 pos;
	vec2 size;
};

bool isInRect(vec2 pos, Rect rect)
{
	return pos.x >= rect.pos.x && pos.x < (rect.pos.x + rect.size.x)
	    && pos.y >= rect.pos.y && pos.y < (rect.pos.y + rect.size.y);
}

//! Signed modulo (keep sign of y)
float smod(float a, float n)
{
    float r = mod(a, n);
    if ((r >= 0) == (n >= 0))
        return r;
    else
        return r + n;
}

vec2 smod(vec2 a, vec2 n)
{
    return vec2(smod(a.x, n.x), smod(a.y, n.y));
}

vec3 smod(vec3 a, vec3 n)
{
    return vec3(smod(a.x, n.x), smod(a.y, n.y), smod(a.z, n.z));
}

vec4 smod(vec4 a, vec4 n)
{
    return vec4(smod(a.x, n.x), smod(a.y, n.y), smod(a.z, n.z), smod(a.w, n.w));
}

vec2 smod(vec2 a, float n)
{
    return vec2(smod(a.x, n), smod(a.y, n));
}

vec3 smod(vec3 a, float n)
{
    return vec3(smod(a.x, n), smod(a.y, n), smod(a.z, n));
}

vec4 smod(vec4 a, float n)
{
    return vec4(smod(a.x, n), smod(a.y, n), smod(a.z, n), smod(a.w, n));
}

vec2 getTileCenter(ivec2 tileCoord, int tileSize)
{
    float i = float(tileCoord.x);
    float j = float(tileCoord.y);
    float l = float(tileSize);

    if (tileCoord.x % 2 == 0)
        return vec2(0.75f * i * l, j * l);
    else
        return vec2(0.75f * i * l, (j + 0.5f) * l);
}

ivec2 getBottomLeftTileCoord(vec2 imagePos, int tileSize)
{
    float l = float(tileSize);
    float rx = imagePos.x / l;
    float ry = imagePos.y / l;
    int i = int(floor((4.f / 3.f) * imagePos.x / l));
    int j = 0;
    if (i % 2 == 0)
        j = int(floor(ry - 0.5f * rx + 0.375f * i));
    else
        j = int(floor(ry - 0.5f * rx + 0.375f * i - 0.5f));
    return ivec2(i, j);
}

float stretchedSquaredLength(vec2 a)
{
    a.y = (sqrt3 * 0.5f) * a.y;
    return dot(a, a);
}

float stretchedLength(vec2 a)
{
    return sqrt(stretchedSquaredLength(a));
}

float stretchedSquaredDistance(vec2 a, vec2 b)
{
    return stretchedSquaredLength(b - a);
}

float stretchedDistance(vec2 a, vec2 b)
{
    return sqrt(stretchedSquaredDistance(a, b));
}


ivec2 getClosestTileCoord(vec2 imagePos, int tileSize)
{
    ivec2 ij = getBottomLeftTileCoord(imagePos, tileSize);

    ivec2 coords[4];
    coords[0] = ij;
    coords[1] = ij + ivec2(0, 1);
    if (ij.x % 2 == 0)
    {
        coords[2] = ij + ivec2(1, 1);
        coords[3] = ij + ivec2(1, 0);
    }
    else
    {
        coords[2] = ij + ivec2(1, 2);
        coords[3] = ij + ivec2(1, 1);
    }

    ivec2 bestCoord = coords[0];
    float bestSqDist = 1.f / 0.f;
    int k = 0;
    do
    {
        vec2 center = getTileCenter(coords[k], tileSize);
        float sqDist = stretchedSquaredDistance(imagePos, center);
        if (sqDist <= bestSqDist)
        {
            bestCoord = coords[k];
            bestSqDist = sqDist;
        }
        ++k;
    } while (k < 4);
    return bestCoord;
}

// Distance from (0, 0)
float ellipticTileDistance(vec2 position, int tileSize)
{
    return stretchedDistance(vec2(0), position) / float(tileSize / 2);
}

// Distance from (0, 0)
float stretchedHexagonalTileDistance(vec2 position, int tileSize)
{
    float l = float(tileSize);
    float d1 = abs(2 * position.y / l);
    float d2 = abs((2 * position.x - position.y) / l);
    float d3 = abs((2 * position.x + position.y) / l);
    return max(max(d1, d2), d3);
}

// Distance from (0, 0)
float diamondHexagonalTileDistance(vec2 position, int tileSize)
{
    float l = float(tileSize);
    float d1 = abs(sqrt5 * position.y / l) - 1.2 + sqrt5 * 0.5f;
    float d2 = abs((2 * position.x - position.y) / l);
    float d3 = abs((2 * position.x + position.y) / l);
    // return d1;
    return max(max(d1, d2), d3);
}

// Amplitude from x half-axis (centered in (0,0)).
float normalizedTileAmplitude(vec2 position)
{
    return atan(position.y, position.x) / tau + 0.5f;
}

int getTileTriColor(ivec2 ij)
{
    if (ij.x % 2 == 0)
    {
        if (ij.y >= 0)
            return ij.y % 3;
        else
            return (3 - abs(ij.y) % 3) % 3;
    }
    else
    {
        if (ij.y >= 0)
            return (2 + ij.y) % 3;
        else
            return (5 - abs(ij.y) % 3) % 3;
    }
    return -1;
}

vec3 tricolorRedOrGreenOrBlue(float value, int tricolor)
{
    switch (tricolor)
    {
        case 0: return vec3(value, 0.f, 0.f);
        case 1: return vec3(0.f, value, 0.f);
        case 2: return vec3(0.f, 0.f, value);
    }
    return vec3(value);
}

// // Return (px, py) coordinate of corresponding tile in (x,y), normalized distance to center in z, and normalized amplitude to x axis in w.
// vec4 getTileInfo(vec2 imagePos, int tileSize)
// {
//     ivec2 ij = getClosestTileCoord(imagePos, tileSize);

//     vec4 result;
//     result.xy = getTileCenter(ij, tileSize);
//     vec2 shift = result.xy - imagePos;
//     result.z = sqrt(deformedSqDist(vec2(0), shift)) / float(tileSize / 2);
//     result.w = atan(shift.y, shift.x) / radians(360.f) + 0.5f;
//     return result;
// }

void main()
{
    vec2 screenCenter = uResolution * 0.5f;
    vec2 imageCenter = imageResolution * 0.5f;
    
    vec2 pos = gl_FragCoord.xy;
    vec2 imagePos = pos - screenCenter + imageCenter;
    Rect imageRect;
    imageRect.pos = -imageCenter;
    imageRect.size = imageResolution;
   
    ivec2 ij = getClosestTileCoord(imagePos, tileLength);
    vec2 tileCenter = getTileCenter(ij, tileLength);
    vec2 tilePos = imagePos - tileCenter;
    float d = diamondHexagonalTileDistance(tilePos, tileLength);
    float a = normalizedTileAmplitude(tilePos);
    float factor = smod(a + uTime, 1.0);
    // float step = d;
    float step = 0.25f * round(d * 4.f);
    // vec4 color = vec4(mix(vec3(0.5 + step * 0.5f, 0, 0), vec3(0.5 + step * 0.5f, step, 0), factor), 1);
    vec4 color = vec4(tricolorRedOrGreenOrBlue(step, getTileTriColor(ij)), 1.0f);

    bool inImage = isInRect(imagePos, imageRect);
    float imageMask = inImage ? 1.f : 0.f;
    if (!inImage)
    {
        float mixFactor = max(0, sin(uTime * 2));
        vec4 warningColor = vec4(0.6, 0, 1, 1);
        color = mix(color, warningColor, mixFactor);
    }

    outColor = color;
}