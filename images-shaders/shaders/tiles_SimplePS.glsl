#version 330

// This shader computes all the relevant information about a tiling of wesnoth hexagon tiles.

// Custom types
struct Rect
{
    vec2 pos;
    vec2 size;
};

// Shader-toy-esque uniform inputs.
uniform vec2 uResolution;
uniform float uTime;

// Output variables
out vec4 outColor;

// Global value
const int wesnothTileLength = 72; // Each wesnoth hexagon tile is inscribed inside a square of that side length.
const float sqrt2 = 1.41421356237309504880168872420969807856967187537694807317667973799073247846;
const float sqrt3 = 1.73205080756887729352744634150587236694280525381038062805580697945193301690;
const float sqrt5 = 2.23606797749978969640917366873127623544061835961152572427089724541052092563;
const float pi    = 3.14159265358979323846264338327950288419716939937510582097494459230781640628;
const float tau   = 6.28318530717958647692528676655900576839433879875021164194988918461563281257;

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

// Custom math functions

// Signed modulo : like mod, but the result has the same sign as n instead of the same sign as a.
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

// Return the position at the center of the tile with given index.
//
// Tiles are inscribed in a square of side tileLength.
vec2 tileCenter(ivec2 ij, int tileLength)
{
    float l = float(tileLength);

    if (ij.x % 2 == 0)
        return vec2(0.75f * ij.x * l, ij.y * l);
    else
        return vec2(0.75f * ij.x * l, (ij.y + 0.5f) * l);
}

// For each hexagonal tile, associate a rhombus tile starting at the center of the hexagonal tile until the center
// of the hexagonal tile above and on the hexagonal tile on the right.
// Those tiles form a tiling of the 2D space.
//
// This function return the integer index pair of the hexagon tile associated with the rhombus containing imagePos.
//
// Tiles are inscribed in a square of side tileLength.
ivec2 findBottomLeftTileCoord(vec2 imagePos, int tileLength)
{
    float l = float(tileLength);
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

// Return the squared "squeezed" length of vector a.
//
// The squeezed length is the length of the vector if it's squeezed by sqrt(3) / 2 in the y direction.
//
// @remark: this is because a regular hexagon with a long diameter of 1 has a short diameter of sqrt(3) / 2.
// It turns out that a wesnoth hexagon is a horizontal regular hexagon,
// which is inscribed in a rectangle of ratio sqrt(3) / 2, stretch to fit (be inscribed in) a square.
// Therefore this the length is if we unsqueeze wesnoth tiles into regular hexagons.
float squeezedSquaredLength(vec2 a)
{
    a.y = 0.875 * a.y;
    return dot(a, a);
}

// Return the "squeezed" length of vector a.
//
// The squeezed length is the length of the vector if it's squeezed by sqrt(3) / 2 in the y direction.
// See squeezedSquaredLength for as to why it's relevant.
float squeezedLength(vec2 a)
{
    return sqrt(squeezedSquaredLength(a));
}

// Return the squared "squeezed" distance of vector a.
//
// The squeezed distance is the distance of two points if it's squeezed by sqrt(3) / 2 in the y direction.
// See squeezedSquaredLength for as to why it's relevant.
float squeezedSquaredDistance(vec2 a, vec2 b)
{
    return squeezedSquaredLength(b - a);
}

// Return the "squeezed" distance of vector a.
//
// The squeezed distance is the distance of two points if it's squeezed by sqrt(3) / 2 in the y direction.
// See squeezedSquaredLength for as to why it's relevant.
float squeezedDistance(vec2 a, vec2 b)
{
    return sqrt(squeezedSquaredDistance(a, b));
}

// Return the integer index pair of the closest tile to imagePos.
//
// Tiles are inscribed in a square of side tileLength.
ivec2 findClosestTileCoord(vec2 imagePos, int tileLength)
{
    ivec2 ij = findBottomLeftTileCoord(imagePos, tileLength);

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
        vec2 center = tileCenter(coords[k], tileLength);
        float sqDist = squeezedSquaredDistance(imagePos, center);
        if (sqDist < bestSqDist)
        {
            bestCoord = coords[k];
            bestSqDist = sqDist;
        }
        ++k;
    } while (k < 4);
    return bestCoord;
}

// Euclidean distance from `position` to (0, 0) such that the set of points of distance 1
// is inscribed into the center hexagonal tile (of side tileLength).
float circularTileDistance(vec2 position, int tileLength)
{
    return distance(vec2(0), position) / float(tileLength / 2);
}

// Hexagonal distance from `position` to (0, 0) such that the set of points of distance 1
// is the hexagonal boundary of center hexagonal tile (of side tileLength).
float squeezedHexagonalTileDistance(vec2 position, int tileLength)
{
    float l = float(tileLength);
    float d1 = abs(2 * position.y / l);
    float d2 = abs((2 * position.x - position.y) / l);
    float d3 = abs((2 * position.x + position.y) / l);
    return max(max(d1, d2), d3);
}

// Hexagonal pseudo-distance from `position` to (0, 0) such that the set of points of distance 1
// is the hexagonal boundary of center hexagonal tile (of side tileLength) and such that thickening that set by ε
// (using the euclidean distance) is the same of the set of points of distance in between [1 - ε, 1 + ε].
float diamondHexagonalTileDistance(vec2 position, int tileLength)
{
    float l = float(tileLength);
    float d1 = abs(sqrt5 * position.y / l) - 1.2 + sqrt5 * 0.5f;
    float d2 = abs((2 * position.x - position.y) / l);
    float d3 = abs((2 * position.x + position.y) / l);
    // return d1;
    return max(max(d1, d2), d3);
}

// Return the amplitude of position to the X half-axis, (starting at (0,0) and going right).
// The value is in number of turns (ranging between 0 and 1) instead of in radians or degrees.
float normalizedTileAmplitude(vec2 position)
{
    return atan(position.y, position.x) / tau + 0.5f;
}

// See https://www.redblobgames.com/grids/hexagons
ivec3 toCubeCoords(ivec2 ij)
{
    int q = ij.x;
    if (ij.x % 2 == 0)
    {
        int r = ij.y - (ij.x + (ij.x & 1)) / 2;
        return ivec3(q, r, -q - r);
    }
    else
    {
        int r = ij.y - (ij.x - (ij.x & 1)) / 2;
        return ivec3(q, r, -q - r);
    }
}

int cubeCoordNorm(ivec3 qrs)
{
    return (abs(qrs.x) + abs(qrs.y) + abs(qrs.z)) / 2;
}

int tileNorm(ivec2 ij)
{
    return cubeCoordNorm(toCubeCoords(ij));
}

// Draw the hexagons of the board.
// imagePos: position, in pixels, relative to the center of the screen.
// imagePos: rectangle, relative, relative to the center of the screen.
vec4 paintTiling(vec2 imagePos, Rect imageRect)
{
    // Get info about tile containing imagePos
    ivec2 ij = findClosestTileCoord(imagePos, wesnothTileLength);
    vec2 ijCenter = tileCenter(ij, wesnothTileLength);
    vec2 tilePos = imagePos - ijCenter;

    // Get info of position within that tile
    float d = diamondHexagonalTileDistance(tilePos, wesnothTileLength);
    float a = normalizedTileAmplitude(tilePos);

    // Make a fun color animation.
    float step = 0.25f * round(d * 4.f);
    float factor = smod(a - uTime * 0.25, 1.0);
    ivec3 qrs = toCubeCoords(ij);
    vec3 baseColor = qrs == ivec3(0)        ? vec3(1.f)
                   : cubeCoordNorm(qrs) > 3 ? vec3(0.f)
                   :                          smod(vec3(qrs) * 0.1, 1.f);
    vec4 color = vec4(step * factor * baseColor, 1.f);

    // Periodically hatch pixels that are outside the image to render
    bool inImage = isInRect(imagePos, imageRect);
    float imageMask = inImage ? 1.f : 0.f;
    if (!inImage)
    {
        float mixFactor = smod(uTime * 0.25f, 1.f) < 0.5 ? 0.f : sin((imagePos.x - imagePos.y) * 0.5) < 0.5f ? 0.f : 1.f;
        vec4 warningColor = vec4(0.6f, 0, 1, 1);
        color = mix(color, warningColor, mixFactor);
    }

    return color;
}

// Main function.
void main()
{
	// Center must be a integer value, otherwise there are weird roundings.
    vec2 screenCenter = floor(uResolution * 0.5f);
    // const vec2 imageResolution = vec2(      wesnothTileLength,      wesnothTileLength); // only the center tile
    // const vec2 imageResolution = vec2(2.5 * wesnothTileLength,  3 * wesnothTileLength); // tile radius of 1
    // const vec2 imageResolution = vec2(4   * wesnothTileLength,  5 * wesnothTileLength); // tile radius of 2
    const vec2 imageResolution = vec2(5.5 * wesnothTileLength,  7 * wesnothTileLength); // tile radius of 3
    // const vec2 imageResolution = vec2(7   * wesnothTileLength,  9 * wesnothTileLength); // tile radius of 4
    // const vec2 imageResolution = vec2(8.5 * wesnothTileLength, 11 * wesnothTileLength); // tile radius of 5

    vec2 pos = gl_FragCoord.xy;
    vec2 imagePos = pos - screenCenter;
    Rect imageRect;
    imageRect.pos = imageResolution * -0.5f;
    imageRect.size = imageResolution;
   
    outColor = paintTiling(imagePos, imageRect);
}