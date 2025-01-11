#version 430

uniform vec2 uResolution;
uniform float uTime;

out vec4 outColor;

const float sqrt2 = 1.41421356237309504880168872420969807856967187537694807317667973799073247846;
const float sqrt3 = 1.73205080756887729352744634150587236694280525381038062805580697945193301690;
const float sqrt5 = 2.23606797749978969640917366873127623544061835961152572427089724541052092563;
const float cbrt2 = 1.25992104989487316476721060727822835057025146470150798008197511215529967651;
const float cbrt3 = 1.44224957030740838232163831078010958839186925349935057754641619454168759682;
const float cbrt5 = 1.70997594667669698935310887254386010986805511054305492438286170744429592050;

const float sqrt2_inv = 0.70710678118654752440084436210484903928483593768847403658833986899536623923;
const float sqrt3_inv = 0.57735026918962576450914878050195745564760175127012687601860232648397767230;
const float sqrt5_inv = 0.44721359549995793928183473374625524708812367192230514485417944908210418512;
const float cbrt2_inv = 0.79370052598409973737585281963615413019574666394992650490414288091260825281;
const float cbrt3_inv = 0.69336127435063470484335227478596179544593511345775403656586369340003543713;
const float cbrt5_inv = 0.58480354764257321310135747202758455570609972702020600828451470201451211171;

const float halfpi  = 1.57079632679489661923132169163975144209858469968755291048747229615390820314;
const float pi      = 3.14159265358979323846264338327950288419716939937510582097494459230781640628;
const float tau     = 6.28318530717958647692528676655900576839433879875021164194988918461563281257;
const float pi_inv  = 0.31830988618379067153776752674502872406891929148091289749533468811779359526;
const float tau_inv = 0.15915494309189533576888376337251436203445964574045644874766734405889679763;

const float e       = 2.71828182845904523536028747135266249775724709369995957496696762772407663035;
const float phi     = 1.61803398874989484820458683436563811772030917980576286213544862270526046281;

float intervalIndicator(float x, float a, float b)
{
    return float(x >= a && x <= b);
}

float centeredIntervalIndicator(float x, float center, float width)
{
    float halfWidth = width * 0.5f;
    return intervalIndicator(x, center - halfWidth, center + halfWidth);
}

float cubicBump(float x)
{
    float ax = abs(x);
    float xx = ax * ax;
    return 2.f * xx * ax - 3.f * xx + 1.f;
}

float cubicHalfPlateau(float x)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    return cubicBump(1.f - x);
}

float cubicHalfPlateau(float x, float slopeStart, float slopeEnd)
{
    return cubicHalfPlateau((x - slopeStart) / (x - slopeEnd));
}

float assymmetricCubicPlateau(
    float x, 
    float leftSupportBound, 
    float rightSupportBound, 
    float leftSlopeDistance, 
    float rightSlopeDitance)
{
    float fromLeftHalfPlateau  = cubicHalfPlateau((x - leftSupportBound)  / leftSlopeDistance);
    float fromRightHalfPlateau = cubicHalfPlateau((rightSupportBound - x) / rightSlopeDitance);

    return min(fromLeftHalfPlateau, fromRightHalfPlateau);
}

const int noEaseFn              = 0;
const int easeInFn              = 1;
const int easeOutFn             = 2;
const int easeInOutFn           = 3;

float _easeIn(float x, float gamma)
{
    return pow(x, gamma);
}

float _easeOut(float x, float gamma)
{
    return 1.f - pow(1.f - x, gamma);
}

// See https://math.stackexchange.com/questions/121720/ease-in-out-function/121755#121755
float _easeInOut(float x, float gamma)
{
    float xGamma = pow(x, gamma);
    return xGamma / (xGamma + pow(1.f - x, gamma));
}

float easeIn(float x, float gamma)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    return _easeIn(x, gamma);
}

float easeOut(float x, float gamma)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    return _easeOut(x, gamma);
}

// See https://math.stackexchange.com/questions/121720/ease-in-out-function/121755#121755
float easeInOut(float x, float gamma)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    return _easeInOut(x, gamma);
}

float ease(float x, int ease, float gamma)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    switch(ease)
    {
        case noEaseFn:    return x;
        case easeInFn:    return _easeIn(x, gamma);
        case easeOutFn:   return _easeOut(x, gamma);
        case easeInOutFn: return _easeInOut(x, gamma);
    }
    return x;
}

// Comput a sine from numbers of turns instead of radians, ranging in [a, b] instead of [-1, 1].
float sineInTurns(float x, float frequency, float phase, float a, float b)
{
    return  ( (a + b) - cos(x * frequency * tau + phase * tau) * (b - a) ) * 0.5f;
}

float pulse(
    float x,
    float time,
    float startTime,
    float endTime,
    float fadeInDistance,
    float fadeOutDistance,
    float startWidth,
    float endWidth,
    float fuzzyness,
    int   speedEaseFn,
    float speedGamma
)
{
    float linearRightPos = (time - startTime) / (endTime - startTime);
    float rightPos       = ease(linearRightPos, speedEaseFn, speedGamma);

    float width         = rightPos * endWidth + (1.f - rightPos) * startWidth;
    float halfWidth     = width * 0.5f;
    float pulseValueAtX = assymmetricCubicPlateau(x, rightPos - width, rightPos, fuzzyness, fuzzyness);

    float intensity = assymmetricCubicPlateau(rightPos, 0.f, 1.f, fadeInDistance, fadeOutDistance);
    return pulseValueAtX * intensity;
}

// Color gradient using technique described in: https://iquilezles.org/articles/palettes/
// Tweak factors interactively using: http://dev.thi.ng/gradients/
vec3 colorGradient(float interpolant, vec3 offset, vec3 amplitude, vec3 frequency, vec3 phase)
{
    return offset + amplitude * cos((interpolant * frequency + phase) * tau);
}

// Copied from https://github.com/glslify/glsl-easings/blob/master/back-out.glsl
// MIT license.
float easeOutBounce(float t) {
  const float a = 4.0 / 11.0;
  const float b = 8.0 / 11.0;
  const float c = 9.0 / 10.0;

  const float ca = 4356.0 / 361.0;
  const float cb = 35442.0 / 1805.0;
  const float cc = 16061.0 / 1805.0;

  float t2 = t * t;

  return t < a
    ? 7.5625 * t2
    : t < b
      ? 9.075 * t2 - 9.9 * t + 3.4
      : t < c
        ? ca * t2 - cb * t + cc
        : 10.8 * t * t - 20.52 * t + 10.72;
}

float radiusFn(float t)
{
    float bounce = min(easeOutBounce(t * 2.f), 1.f);
    float fadeOut = 1.f - easeIn(t * 3.f - 2.f, 3.f);
    return bounce * fadeOut;
}

float intensityFn(float t)
{
    float fadeOut = 1.f - easeIn(t * 6.f - 5.f, 3.f);
    return fadeOut;
}

vec3 colorFn(float t)
{
    return colorGradient(t, vec3(1.798, 0.500, 0.088), vec3(0.500, 0.500, 0.608), vec3(0.178, 0.358, 0.268), vec3(0.000, 1.588, -0.382));
}

vec4 animation(float x, float t)
{
    const float timeFactor = 1.f / 2.f;
    float flatRadius   = 0.f;
    float fuzzyRadius  = 0.05f;
    float sphereRadius = radiusFn(t * timeFactor) - (flatRadius + fuzzyRadius);
    float intensity    = intensityFn(t * timeFactor);

    float v = 0.f;
    if (x < sphereRadius)
    {
        float x1 = x / sphereRadius;
        v = 1 - sqrt(1 - x1 * x1);
    }
    else
    {
        float x1 = (x - (sphereRadius + flatRadius)) / fuzzyRadius;
        v = easeIn(1 - x1, 3.f);
    }

    v = v * intensity;
    return v * vec4(colorFn(sphereRadius), v);
}

vec4 revealAlphaWithChecker(vec4 color, vec2 pixelPos)
{
    int parity = int(floor(pixelPos.x * 0.125f) + floor(pixelPos.y * 0.125)) % 2;
    vec4 checkerColor = parity == 0 ? vec4(0.3f, 0.3f, 0.3f, 1.f) : vec4(0.2f, 0.2f, 0.2f, 1.f);
    vec4 opaqueColor = vec4(color.xyz, 1.f);
    return mix(checkerColor, opaqueColor, color.a);
}

void main()
{
    // Global display settings
    const float speedFactor = 1.f;
    const float loopDuration = 2.f;
    const int previewBandThickness = 48;

    // Set the domain interval [a, b] and codomain interval [c, d] to observe here
    float a = 0.f;
    float b = 1.f;
    float c = 0.f;
    float d = 1.f;

    float graphHeight = uResolution.y - previewBandThickness;
    float x = a + gl_FragCoord.x / uResolution.x * b - a;
    float t = uTime * speedFactor;
    if (loopDuration > 0.f)
        t = mod(t, loopDuration);

    // Call your function here, using the following pattern, replacing f by you function name.
    //   vec4 fx = vec4(vec3(f(x)), 1.f);                  // Non-temporal function to G
    //   vec4 fx = vec4(0.f, 0.f, f(x)); fx.xy = fx.zz;    // Non-temporal function to GA
    //   vec4 fx = vec4(f(x), 1.f);                        // Non-temporal function to RGB
    //   vec4 fx = f(x);                                   // Non-temporal function to RGBA
    //   vec4 fx = vec4(vec3(f(x, t)), 1.f);               //     temporal function to G
    //   vec4 fx = vec4(0.f, 0.f, f(x, t)); fx.xy = fx.zz; //     temporal function to GA
    //   vec4 fx = vec4(f(x, t), 1.f);                     //     temporal function to RGB
    //   vec4 fx = f(x, t);                                //     temporal function to RGBA
    vec4 fx = animation(x, t);
    
    float pixel_y = gl_FragCoord.y;
    vec4 color;
    if (pixel_y > graphHeight)
    {
        color = revealAlphaWithChecker(fx, gl_FragCoord.xy);
    }
    else
    {
        vec3 pixel_fx = graphHeight * (fx.xyz - c) / (d - c);
        color.xyz = clamp(pixel_fx - pixel_y, vec3(0.f), vec3(1.f));
        float y = c + pixel_y / graphHeight * (d - c);
        if (y < 0)
            color.xyz = 1.f-color.xyz;
        color.a = max(max(color.r, color.g), color.b);
    }

    outColor = color;
}
